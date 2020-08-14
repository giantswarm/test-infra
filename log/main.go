package main

import (
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/tektoncd/cli/pkg/cli"
	tektonlog "github.com/tektoncd/cli/pkg/log"
	"github.com/tektoncd/cli/pkg/options"
)

type logHandler struct {
	params *cli.TektonParams
}

func (h logHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	path := strings.TrimPrefix(r.URL.Path, "/")
	reader, err := tektonlog.NewReader(tektonlog.LogTypePipeline, &options.LogOptions{
		AllSteps: true,
		Params:          h.params,
		PipelineRunName: path,
		Stream: &cli.Stream{
			Out: w,
			Err: w,
		},
	})
	if err != nil {
		log.Fatal(err)
	}

	logC, errC, err := reader.Read()
	if err != nil {
		w.WriteHeader(500)
		_, _ = fmt.Fprintf(w, "error: %s", err)
	}

	for logC != nil || errC != nil {
		select {
		case l, ok := <-logC:
			if !ok {
				logC = nil
				continue
			}

			if l.Log == "EOFLOG" {
				_, _ = fmt.Fprintf(w, "\n")
				continue
			}

			_, _ = fmt.Fprintf(w, "[%s : %s] ", l.Task, l.Step)
			_, _ = fmt.Fprintf(w, "%s\n", l.Log)
		case e, ok := <-errC:
			if !ok {
				errC = nil
				continue
			}
			_, _ = fmt.Fprintf(w, "%s\n", e)
		}
	}
}

func main() {
	params := cli.TektonParams{}
	params.SetKubeContext("giantswarm-gaia")
	// ensure that the config is valid by creating a client
	if _, err := params.Clients(); err != nil {
		log.Fatal(err)
	}
	params.SetNamespace("nightly")

	http.Handle("/", logHandler{params: &params})
	s := &http.Server{Addr: ":8080"}
	log.Fatal(s.ListenAndServe())
}
