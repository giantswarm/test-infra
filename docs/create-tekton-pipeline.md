# Creating a Tekton pipeline

A Tekton pipeline structures the sequence of tasks which will be run.
This is mainly important to us to make tasks reusable and to make
the flow of task executions uniform across different pipelines.
Pipelines should reuse tasks for cluster creation and cleanup and
follow conventions for workspaces and naming.

All pipelines have to be in the `tekton/pipelines` folder.

You can discover the upstream docs on Tekton pipelines here:
https://tekton.dev/docs/pipelines/pipelines/

And example pipeline can look like this:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: cis # Should match the naming scheme of the Prow command.
  namespace: nightly # Should not change,
spec:
  resources:
  - name: releases # Ensures we get the git repo of releases.
    type: git
  workspaces:
  - name: cluster # Should always be called cluster by convention.
  tasks:
  - name: create-cluster # Should always stay here unless there is a good reason.
    taskRef:
      name: create-cluster
    workspaces:
    - name: cluster
      workspace: cluster
    resources:
      inputs:
      - name: releases
        resource: releases

  - name: wait-for-ready # Provided by team-ludacris - this will wait until coreDNS is up and available.
    runAfter: [create-cluster]
    taskRef:
      name: wait-for-ready
    workspaces:
      - name: cluster
        workspace: cluster

  - name: run-tests # Here the individual test suites can be listed.
    runAfter: [wait-for-ready]
    taskRef:
      name: cis # The cis task is run here as a test suite.
    workspaces:
    - name: cluster
      workspace: cluster

  finally:
  - name: cleanup # Should always stay here to ensure the cluster is cleaned up afterwards.
    taskRef:
      name: cleanup
    workspaces:
    - name: cluster
      workspace: cluster
```
