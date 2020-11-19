[![CircleCI](https://circleci.com/gh/giantswarm/test-infra.svg?style=shield)](https://circleci.com/gh/giantswarm/test-infra)

# Giant Swarm Testing Infrastructure

## Getting started

Interacting with our test-infra setup is currently done exclusively through the [releases](https://github.com/giantswarm/releases) repository.
On this repository you can trigger new test runs through comments on Pull Requests.

Please be aware that all interactions with test-infra are designed with the idea in mind that a pull request will either modify or add a single release in the releases repository!
Commands which are currently available are as follows:
- `/test cncf` runs the `cncf` suite against the release.
- `/test cis` runs the `cis` suite against the release.
- `/test aws` runs `awscnfm` against the release - this only works for AWS.

There are multiple dashboards which can be useful to track the progress of tests:
- [prow](https://prow.rfjh2.k8s.gorilla.eu-central-1.aws.gigantic.io/) gives a rough overview of the running tests.
- [tekton](https://tekton.rfjh2.k8s.gorilla.eu-central-1.aws.gigantic.io/#/pipelineruns) gives a more in depth overview of the test progress,
- [kibana](https://kibana.rfjh2.k8s.gorilla.eu-central-1.aws.gigantic.io/app/kibana#/dashboard/a0274d90-151c-11eb-a856-f95f4e179788?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_a=(description:'',filters:!(('$state':(store:appState),meta:(alias:!n,controlledBy:'1603451084569',disabled:!f,index:'83f5e030-146a-11eb-a856-f95f4e179788',key:kubernetes.labels.prow_k8s_io%2Frefs_repo.keyword,negate:!f,params:(query:releases),type:phrase),query:(match_phrase:(kubernetes.labels.prow_k8s_io%2Frefs_repo.keyword:releases)))),fullScreenMode:!f,options:(hidePanelTitles:!f,useMargins:!t),query:(language:kuery,query:''),timeRestore:!f,title:'Prow%20Dashboard',viewMode:view)) gives full insight of the logs emitted during your test.

Each test will generally perform the same flow currently which can be summarized as this:
1. Determine release CR from PR diff.
2. Create release CR on provider CP (`gaia`,`godsmack`,`gorgoth`).
3. Create tenant cluster with created release on target CP.
4. Run tests against created tenant cluster.
5. Report test results.
6. Delete tenant cluster.
7. Delete release on CP.

Feel free to reach out to team ludacris if you have further questions.

## Developing test-infra

You can find guides for the creation of new tests in the `docs` subfolder.

Deploying `test-infra` is currently a bit cumbersome as it is running as an app inside a tenant cluster.
The tenant cluster is `rfjh2` on `gorilla`.
To update `test-infra` you will need to manually edit the `app` CR on the `gorilla` CP in the namespace `rfjh2`.
**There is currently no automatic rollout by merging to master!**

The `roles` and `serviceaccounts` on the target CPs are currently created manually.
You can find the resources [here](control-plane/README.md).

Kubeconfigs to the target CPs are currently generated with a script using `opsctl` and then manually updated to `rfjh2`.
You can find the necessary scripts [here](secrets/generate-standup-kubeconfig-secret.sh).

## Included components

This repository contains manifests for our individual test pipelines as well as the components
we run to build up our testing infrastructure. The two main open source projects used are
[Prow][Prow] and [Tekton][Tekton]

### Prow

[Prow][Prow] is a CI/CD system running on Kubernetes.
We utilize prow to trigger tests and have a nice Github integration to run high cost conformance tests.

#### Components

This is a list of components which we run:
- `Deck` - UI for prow jobs.
- `Sinker` - Clean up stale prow jobs.
- `Hook` - Handle GitHub events dispatching them to plugins.
- `Horologium` - Start periodic jobs.
- `Plank` - Start prow jobs.
- `ghProxy` - Designed to reduce Github API token usage.
- `Tide` - Automatically retest PRs & merge them if tests go green.
- `Crier` - Reports your prowjob status changes.
- `Pipelines` - Automatically creates Tekton pipelines for each Prow job.

### Tekton

[Tekton][Tekton] is a CI/CD system which is highly integrated with Kubernetes.
We utilize it to actually run tests and to structure our test stages.

#### Components

This is a list of components which we run:
- `Pipelines` - This enables the meat of functionalities by Tekton.
- `Dashboard` - Gives and overview of active Tekton tasks and pipelines.
- `prow-log-aggregator` - Collects logs from Tekton tasks and makes them available to Deck.

## Reference

* How to write [`ProwJobs`](https://github.com/kubernetes/test-infra/blob/master/prow/jobs.md)

[Prow]: https://github.com/kubernetes/test-infra/tree/master/prow
[Tekton]: https://tekton.dev/
