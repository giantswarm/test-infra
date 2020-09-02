[![CircleCI](https://circleci.com/gh/giantswarm/test-infra.svg?style=shield)](https://circleci.com/gh/giantswarm/test-infra)

# Giant Swarm Testing Infrastructure

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

## Setup

There are some steps to be taken outside of Kubernetes to set up Prow.

### Outside of Kubernetes

This assumes that you are in the `prow` directory and that you can reach your working Kubernetes cluster.

1. Create a bot account (we have our own [tityos](https://github.com/tityosbot)).
  - Grant it **owner** level access to the GitHub organisations on which prow will operate on.

  - Generate a [personal access token](https://github.com/settings/tokens) for the bot with full `repo` scope and `admin:org`, `admin:repo_hook`, and `admin:org_hook` too (in case you want prow to operate at organisation level).

  - Save such OAuth token to `prow/oauth` file.

2. Create a token for GitHub webhooks.

  ```bash
  openssl rand -hex 20 > prow/hmac
  ```

3. Setup the hook
  > This should be done after Prow is installed in the cluster!

  - Install the `add-hook` tool
    ```bash
    go get -u k8s.io/test-infra/experiment/add-hook
    ```

  - Attach it to the organisation using `--repo` flag (or to a precise repo using `MY_ORG/MY_REPO` convention)
    ```bash
    add-hook --hmac-path=path/to/hmac/secret --github-token-path=path/to/oauth/secret --hook-url http://an.ip.addr.ess/hook --repo MY_ORG --confirm=true
    ```

### Kubernetes Deployment

*For Giant Swarm users:*

1. Deploy the helm chart using `opsctl`.

  ```
  opsctl deploy test-infra -i INSTALLATION
  ```

*For non Giant Swarm users:*

1. Build the helm chart.

  ```
  for i in prow tekton; do mkdir -p helm/test-infra/templates; ./kustomize build ./$i > helm/test-infra/templates/$i.yaml; done
  ```

2. Deploy the helm chart.

  ```
  helm install ./helm
  ```

*Independent of user:*

3. Apply CRDs.

  ```
  kubectl apply -f crds
  ```

4. Template Secrets.

  This is mostly manual templating of the files in `secrets`

5. Apply Secrets.

  ```
  kubectl apply -f secrets
  ```

## Secrets

Generated secrets are stored in the LastPass of our organization.
Templates for these secrets can be found in the `secrets` folder.

- Access credentials for [Tityos Bot](https://github.com/tityosbot)
- Access credentials for a S3 bucket where to upload test results
- Github OAuth Secret
- Github webhooks token for Tekton to access Github

## S3 bucket credentials

If you don't have an existing S3 bucket to store the test results, switch your [role](https://intranet.giantswarm.io/docs/support-and-ops/ops-recipes/aws-role-switching/#aws-cli) if needed and run [this](scripts/s3-bucket-access.sh) script. It will create a bucket and also IAM role and
policy to enable access to it. Don't forget to update the `s3-bucket-credentials` secret with the generated credentials.

## Reference

* How to write [`ProwJobs`](https://github.com/kubernetes/test-infra/blob/master/prow/jobs.md)

[Prow]: https://github.com/kubernetes/test-infra/tree/master/prow
[Tekton]: https://tekton.dev/
