# Creating a Tekton task

Tasks are the smallest piece of our test infra puzzle.
They are meant for individual conformance test suite executions
which are supplied either from upstream or internal teams.
This is where you can check the created cluster for conformity
and get the different `kubeconfig` for example as inputs.

All tasks have to be in the `tekton/tasks` folder and should be
registered in `tekton/tasks/kustomization.yaml`.

You can discover the upstream docs on Tekton tasks here:
https://tekton.dev/docs/pipelines/tasks/

An example task might look like this:
```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: cis # Task name which can be chosen freely.
  namespace: test-workloads # This namespace should stay unchanged.
spec:
  workspaces:
  - name: cluster # Workspace supplied by the pipeline. Must use the same name.
    description: Cluster information is stored here.
  steps:
  - name: run-tests # One or many steps can be listed here.
    image: quay.io/giantswarm/conformance-tests # Image used for running your tests.
    env:
      - name: "KUBECONFIG_PATH"
        value: $(workspaces.cluster.path)/kubeconfig # Path to tenant cluster kubeconfig.
    script: |
      #! /bin/sh
      run-sonobuoy-tests cis
```
