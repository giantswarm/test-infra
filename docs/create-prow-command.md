# Creating a Prow command

A Prow command is the interface which allows us to trigger a job
from Github with a command ( e.g. a Github comment with `/test cis`).

Currently the configuration for these commands lives in `prow/configs.yaml`.
We should always use presubmit hooks on the `giantswarm/releases` repository
for now. This can be specified differently but there is currently no reason
to.

And example of a configuration:
```yaml
  - name: cis # Name of the prow command.
    agent: tekton-pipeline # Should always be tekton-pipeline-
    max_concurrency: 3 # Number of jobs running concurrently at max.
    always_run: false # If this should run on every commit.
    skip_report: false # If the bot should report in the PR.
    pipeline_run_spec:
      pipelineRef:
        name: cis # Name of the Tekton pipeline. In this case the pipeline is in tekton/pipelines/cis.yaml
      serviceAccountName: releases # Should always be releases.
      resources:
      - name: releases # Should always be releases.
        resourceRef:
          name: PROW_IMPLICIT_GIT_REF # Should always be PROW_IMPLICIT_GIT_REF.
      workspaces:
      - name: cluster # This is the workspace where persistent data in the pipeline is handled. We use cluster as convention.
        volumeClaimTemplate:
          spec:
            accessModes:
            - ReadWriteOnce # This needs to stay ReadWriteOnce - other settings did not work well.
            resources:
              requests:
                storage: 10Mi # Storage size of the workspace.
    trigger: "/test cis" # The command you can use in Github comments.
    rerun_command: "/test cis" # The command to rerun tests from Github comments.
```
