package main

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"

	"github.com/tektoncd/cli/pkg/cli"
	"github.com/tektoncd/cli/pkg/pipeline"
	"github.com/tektoncd/cli/pkg/pipelinerun"
	"github.com/tektoncd/cli/pkg/pods"
	trh "github.com/tektoncd/cli/pkg/taskrun"
	"github.com/tektoncd/pipeline/pkg/apis/pipeline/v1beta1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

type logHandler struct {
	clients *cli.Clients
	namespace string
}

func (l logHandler) getOrderedTasks(pr *v1beta1.PipelineRun) ([]trh.Run, error) {
	var tasks []v1beta1.PipelineTask

	switch {
	case pr.Spec.PipelineRef != nil:
		pl, err := pipeline.GetV1beta1(l.clients, pr.Spec.PipelineRef.Name, metav1.GetOptions{}, l.namespace)
		if err != nil {
			return nil, err
		}
		tasks = pl.Spec.Tasks
		tasks = append(tasks, pl.Spec.Finally...)
	case pr.Spec.PipelineSpec != nil:
		tasks = pr.Spec.PipelineSpec.Tasks
		tasks = append(tasks, pr.Spec.PipelineSpec.Finally...)
	default:
		return nil, fmt.Errorf("pipelinerun %s did not provide PipelineRef or PipelineSpec", pr.Name)
	}

	return trh.SortTasksBySpecOrder(tasks, pr.Status.TaskRuns), nil
}

type step struct {
	name      string
	container string
	state     corev1.ContainerState
}

func (s *step) hasStarted() bool {
	return s.state.Waiting == nil
}

func getSteps(pod *corev1.Pod) []*step {
	status := map[string]corev1.ContainerState{}
	for _, cs := range pod.Status.ContainerStatuses {
		status[cs.Name] = cs.State
	}

	var steps []*step
	for _, c := range pod.Spec.Containers {
		steps = append(steps, &step{
			name:      strings.TrimPrefix(c.Name, "step-"),
			container: c.Name,
			state:     status[c.Name],
		})
	}

	return steps
}

func getInitSteps(pod *corev1.Pod) []*step {
	status := map[string]corev1.ContainerState{}
	for _, ics := range pod.Status.InitContainerStatuses {
		status[ics.Name] = ics.State
	}

	var steps []*step
	for _, ic := range pod.Spec.InitContainers {
		steps = append(steps, &step{
			name:      strings.TrimPrefix(ic.Name, "step-"),
			container: ic.Name,
			state:     status[ic.Name],
		})
	}

	return steps
}

var previous time.Time

func next(loc string) {
	if previous.Equal(time.Time{}) {
		fmt.Println("initializing time", loc)
		previous = time.Now()
		return
	}
	fmt.Println("elapsed", time.Now().Sub(previous), loc)
	previous = time.Now()
}

func (l logHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	next("request started")
	runName := strings.TrimPrefix(r.URL.Path, "/")
	pipelineRun, err := pipelinerun.GetV1beta1(l.clients, runName, metav1.GetOptions{}, l.namespace)
	if err != nil {
		log.Fatal(err)
	}
	next("get PR")

	tasks, err := l.getOrderedTasks(pipelineRun)
	next("get tasks")

	for _, task := range tasks {
		taskRun, err := trh.GetV1beta1(l.clients, task.Name, metav1.GetOptions{}, l.namespace)
		if err != nil {
			log.Fatal(err)
		}
		if taskRun.Status.PodName == "" {
			log.Fatal(fmt.Errorf("pod for taskrun %s not available yet", taskRun.Name))
		}
		next("get TR")

		tektonPod := pods.New(taskRun.Status.PodName, l.namespace, l.clients.Kube, pods.NewStream)
		next("get TP")
		pod, err := tektonPod.Get()
		next("get P")
		if err != nil {
			log.Fatal(errors.New(fmt.Sprintf("retrieving task logs %s failed: %s", taskRun.Name, strings.TrimSpace(err.Error()))))
		}

		var steps []*step
		stepsInPod := getSteps(pod)
		steps = append(steps, getInitSteps(pod)...)
		steps = append(steps, stepsInPod...)
		next("get steps")

		for _, step := range steps {
			if !step.hasStarted() {
				continue
			}

			container := tektonPod.Container(step.container)
			podC, perrC, err := container.LogReader(false).Read()
			if err != nil {
				_, _ = fmt.Fprintf(w, "error in getting logs for step %s: %s", step.name, err)
			}
			next("get logs")

			for podC != nil || perrC != nil {
				select {
				case l, ok := <-podC:
					if !ok {
						podC = nil
						continue
					}
					_, _ = fmt.Fprintf(w, "%s\n", l.Log)

				case e, ok := <-perrC:
					if !ok {
						perrC = nil
						continue
					}

					_, _ = fmt.Fprintf(w, "failed to get logs for %s: %s\n", step.name, e)
				}
			}

			if err := container.Status(); err != nil {
				_, _ = fmt.Fprintf(w, "failed to get logs for %s: %s", step.name, err)
				return
			}
		}
	}
}

func main() {
	params := cli.TektonParams{}
	params.SetKubeContext("giantswarm-gaia")
	clients, err := params.Clients()
	if err != nil {
		log.Fatal(err)
	}

	http.Handle("/", logHandler{
		clients:   clients,
		namespace: "nightly",
	})
	s := &http.Server{Addr: ":8080"}
	log.Fatal(s.ListenAndServe())
}
