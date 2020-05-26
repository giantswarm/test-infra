# Giant Swarm Release Workflow & Testing Infrastructure

## Prow

[Prow](https://github.com/kubernetes/test-infra/tree/master/prow) is a CI/CD system running on Kubernetes.

This directory contains the resources composing the GS release workflow & testing.

### Components

Listing the deployments we are currently using.

#### Deck

> UI for prow jobs.

#### Sinker

> Clean up stale prow jobs.

#### Hook

> Handle GitHub events dispatching them to plugins.

#### Horologium

> Start periodic jobs.

#### Plank

> Start prow jobs.

#### ghProxy

> Designed to reduce API token usage by allowing many components to share a single ghCache.

#### Tide

> Automatically retest PRs that meet the criteria ("tide comes in") and automatically merge them when they have up-to-date passing test results.

#### Crier

> Rports your prowjobs on their status changes.

### Setup

This assumes that you are in the `prow` directory and that you can reach your working Kubernetes cluster.

1. Create a bot account (we have our own [tityos](https://github.com/tityosbot)).

    1.1. Grant it **owner** level access to the GitHub organisations on which prow will operate on.

    1.2. Generate a [personal access token](https://github.com/settings/tokens) for the bot with full `repo` scope and `admin:org`, `admin:repo_hook`, and `admin:org_hook` too (in case you want prow to operate at organisation level).

    1.3 Save such OAuth token to `prow/oauth` file.

2. Create a token for GitHub webhooks.

    ```bash
    openssl rand -hex 20 > prow/hmac
    ```

3. Deploy prow

    ```bash
    make prow
    ```

4. Setup the hook

    4.1. Install the `add-hook` tool

    ```bash
    go get -u k8s.io/test-infra/experiment/add-hook
    ```

    4.2. Attach it to the organisation using `--repo` flag (or to a precise repo using `MY_ORG/MY_REPO` convention)

    ```bash
    add-hook --hmac-path=path/to/hmac/secret --github-token-path=path/to/oauth/secret --hook-url http://an.ip.addr.ess/hook --repo MY_ORG --confirm=true
    ```

5. Setup or update your plugins and configs with

```bash
make plugins
make configs
```

## Reference

* How to write [`ProwJobs`](https://github.com/kubernetes/test-infra/blob/master/prow/jobs.md)
