# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Use full CRD name when upgrading clusters to avoid naming clash.

## [1.46.0] - 2024-02-21

### Changed

- Change the tekton-triggers hostname.

## [1.45.0] - 2024-02-08

### Fixed

- Add missing file to kustomization.

## [1.44.0] - 2024-02-08

### Changed

- Use custom service account for tekton tasks and setup IRSA to give s3 access.

## [1.43.0] - 2024-02-07

### Changed

- Remove references to `rfjh2` from ingresses.

## [1.42.1] - 2024-02-07

### Fixed

- Change storageClass to gp3.

## [1.42.0] - 2024-02-07

### Changed

- Add secrets needed by tekton to helm chart.

## [1.41.5] - 2024-02-06

### Fixed

- Add helm hook to policy exceptions.

## [1.41.4] - 2024-02-06

### Fixed

- Yet another attempt to fix helm chart (yes, another one).

## [1.41.3] - 2024-02-06

### Fixed

- Yet another attempt to fix helm chart.

## [1.41.2] - 2024-02-06

### Fixed

- Fix prowjob CRD.

## [1.41.1] - 2024-02-06

### Fixed

- Fix apiVersion for CRDs.

## [1.41.0] - 2024-02-06

### Changed

- Add CRDs to the helm chart.

## [1.40.0] - 2024-02-06

### Changed

- Move to giantswarm-operations-platform catalog.

## [1.39.8] - 2024-01-29

### Fixed

- Move pss values under the global property

## [1.39.7] - 2024-01-24

### Fixed

- Added missing volume mount in cncf test task.

## [1.39.6] - 2024-01-24

### Fixed

- Make kyverno ignore cncf pods.

## [1.39.5] - 2024-01-19

### Fixed

- Yet another attempt to fix policy exceptions for sonobuoy test pods.

## [1.39.4] - 2024-01-18

### Fixed

- Yet another attempt to fix policy exceptions for sonobuoy test pods.

## [1.39.3] - 2024-01-18

### Fixed

- Fix policy exceptions for sonobuoy test pods.

## [1.39.2] - 2024-01-18

### Fixed

- Add policy exceptions sonobuoy test pods as well.

## [1.39.1] - 2024-01-18

### Fixed

- Use dedicated step for PSS exception creation.

## [1.39.0] - 2024-01-18

### Changed

- Move policy exception for sonobuoy to workload cluster.

## [1.38.0] - 2024-01-17

### Changed

- Add policy exception for sonobuoy.

## [1.37.1] - 2024-01-17

### Changed

- Run cncf test as root user - this time for real.

## [1.37.0] - 2024-01-17

### Changed

- Run cncf test as root user.

## [1.36.2] - 2023-12-18

### Changed

- Run 'upgrade-cluster' task as root.

## [1.36.1] - 2023-12-14

### Fixed

- Set root user for `wait-for-ready` task.

## [1.36.0] - 2023-12-14

### Changed

- Add PSS exceptions.

## [1.35.0] - 2023-12-04

### Changed

- Fix PSS for tekton-triggers.

## [1.34.1] - 2023-12-04

### Fixed

- Fix security context in tekton-dashboard.

## [1.34.0] - 2023-12-04

### Changed

- Remove PSPs and add PolicyException.
- Fix PSS for prow.
- Fix PSS for tekton.

## [1.33.1] - 2023-12-01

## [1.33.0] - 2023-11-29

## [1.32.0] - 2023-11-27

### Added

- Add `OPSCTL_GITHUB_TOKEN` to e2e task to avoid github rate limiting.

## [1.31.0] - 2023-10-12

### Fixed

- Use `cluster flavour` setting during upgrade test.
- Don't get sonobuoy results in upgrade test.

## [1.30.0] - 2023-10-11

### Changed

- Run sonobuoy plugin directly, not using sonobuoy runner.

## [1.29.0] - 2023-10-05

### Added

- Add `cluster.k8s.io` to `release-manager` ClusterRole.

### Changed

- Bump kubectl-gs image to 2.41.1
- Use kubectl-gs to get kubeconfig

## [1.28.0] - 2023-09-14

### Changed

- Added explicit trigger params `region` and `flavour` for all triggers.

## [1.27.0] - 2023-09-13

### Changed

- Make triggering via github comment a bit smarter.

## [1.26.1] - 2023-08-31

### Fixed

- Fixed trigger for `cncf` and `cncf-eni` tests.

## [1.26.0] - 2023-08-30

### Changed

- Raise `wait-for-ready` timeout to 2h to leave broken apps enough time to install.

## [1.25.0] - 2023-08-29

### Added

- Allow testing clusters in `eni` mode on AWS.

## [1.24.0] - 2023-08-28

### Removed

- Remove prow configuration for CAPI repositories, as they will use the new tekton infra.
- Remove 'create-cluster-capi-pure' and 'upgrade-cluster-capi-pure' pipelines and unused tasks.

## [1.23.0] - 2023-07-11

### Changed

- Use one single tekton pipeline and customize behaviour using params for `aws-upgrade`, `azure-upgrade` and `aws-china-upgrade` tests.

## [1.22.0] - 2023-07-05

### Changed

- Use one single tekton pipeline and customize behaviour using params for `aws`, `azure` and `aws-china` tests.

### Removed

- Remove `capz` test.

## [1.21.0] - 2023-06-29

### Changed

- Unified `azure`, `aws` and `aws-china` tests. They all use `sonobuoy-plugin` to run the tests.

### Added

- Add `aws-upgrade` test to test upgrade using `sonobuoy-plugin`.
- Add `aws-china-upgrade` test to test upgrade using `sonobuoy-plugin`.

### Removed

- Delete `upgrade-to-this-azure-operator` unused test.

## [1.20.0] - 2023-06-27

### Changed

- Bump sonobuoy image to `quay.io/giantswarm/sonobuoy:v0.56.17-alpine-giantswarm`.

### Fixed

- Ignore wip releases in `get-latest-release`.

## [1.19.1] - 2023-05-24

### Fixed

- Detect provider from git diff in `create release`.

## [1.19.0] - 2023-05-23

### Changed

- Use bash script to create releases to avoid using old Release CR in `standup` and support `dependsOn` feature.

## [1.18.0] - 2023-05-17

### Changed

- Bump `kubectl-gs` to `v2.37.0`.

## [1.17.0] - 2023-05-16

### Changed

- Bump `kubectl-gs` to `v2.34.0`.
- Make `create-cluster-capi-hybrid` work with vintage release v20.

### Fixed

- Fix kubeconfig generation script.

## [1.16.0] - 2023-03-15

### Changed

- Bump standup to 3.4.2.

## [1.15.0] - 2023-03-15

### Changed

- Bump standup to 3.4.1.

## [1.14.0] - 2023-03-15

### Changed

- Bump standup to 3.4.0.

## [1.13.0] - 2023-02-02

### Changed

- Update kubectl-gs to v2.32.0 which uses objects for `CAPA` machine pools instead of arrays

## [1.12.0] - 2023-01-12

### Changed

- Use 'alpine' to download suonobuoy plugin.

## [1.11.0] - 2023-01-12

### Changed

- Retry 5 times downloading sonobuoy plugin.

## [1.10.0] - 2023-01-11

### Changed

- Updated kubectl-gs to v2.29.5.

## [1.9.0] - 2022-11-24

### Changed

- Updated kubectl-gs to v2.29.0 which changes the format of the volumes for CAPG

## [1.8.1] - 2022-11-10

### Fixed

- Fix capi upgrade test to actually upgrade default-apps app when running it from default-apps repo.

## [1.8.0] - 2022-11-07

### Changed

- Bump `quay.io/giantswarm/kubectl-gs` to `2.27.0`.

## [1.7.1] - 2022-11-03

### Fixed

- e2e upgrade test actually upgrades from latest release to current version being tested.

## [1.7.0] - 2022-10-19

### Fixed

- Fixed parameters for CAPA e2e pipelines.

## [1.6.2] - 2022-10-18

### Fixed

- Remove unnecessary parameters from `upgrade-cluster-capi-pure` pipeline.

## [1.6.1] - 2022-10-18

### Fixed

- Add missing pipelines and tasks to `kustomize`.

### Changed

- Restore GitHub `eventlistener` config that was released in `v1.4.1`.

## [1.6.0] - 2022-09-20

### Changed

- Revert tekton version bumps happened on release 1.4.0.

## [1.5.0] - 2022-09-20

### Added

- Add `upgrade` pipeline for CAPI clusters.

## [1.4.2] - 2022-09-15

### Fixed

- Fixed interceptors after upgrading to 0.21.0.

## [1.4.1] - 2022-09-15

### Fixed

- Fixed github eventlistener syntax after tekton triggers upgrade.

## [1.4.0] - 2022-09-15

### Changed

- Bump tekton pipelines to release 0.39.0.
- Bump tekton dsahboard to release 0.29.2.
- Bump tekton triggers to release 0.21.0.

## [1.3.1] - 2022-09-15

### Fixed

- Wait for cluster creation before we allow connectivity from MC to WC on GCP.

## [1.3.0] - 2022-09-15

### Changed

- Allow connectivity from the MC where tekton runs its tasks to the workload cluster created on GCP.

## [1.2.1] - 2022-08-19

### Fixed

- Escape backslash to fix prow config.

## [1.2.0] - 2022-08-12

### Changed

- Trigger `create-cluster-capi-pure` pipeline even if `/test create` has spaces after the command.

## [1.1.0] - 2022-08-10

### Changed

- Only run cleanup of `create-cluster-capi-pure` runs if they were successful

## [1.0.2] - 2022-07-20

### Changed

- Bump Tekton Triggers to v0.20.1

## [1.0.1] - 2022-07-20

### Fixed

- Included missing `interceptors.yaml` in Kustomization resources list

## [1.0.0] - 2022-06-22

### Changed

- Bump `sonobuoy` to v0.56.7-alpine-giantswarm.
- Bump `kubectl-gs` to 2.14.0.

### Added

- Initial release.

[Unreleased]: https://github.com/giantswarm/test-infra/compare/v1.46.0...HEAD
[1.46.0]: https://github.com/giantswarm/test-infra/compare/v1.45.0...v1.46.0
[1.45.0]: https://github.com/giantswarm/test-infra/compare/v1.44.0...v1.45.0
[1.44.0]: https://github.com/giantswarm/test-infra/compare/v1.44.0...v1.43.0
[1.43.0]: https://github.com/giantswarm/test-infra/compare/v1.42.1...v1.43.0
[1.42.1]: https://github.com/giantswarm/test-infra/compare/v1.42.0...v1.42.1
[1.42.0]: https://github.com/giantswarm/test-infra/compare/v1.41.5...v1.42.0
[1.41.5]: https://github.com/giantswarm/test-infra/compare/v1.41.4...v1.41.5
[1.41.4]: https://github.com/giantswarm/test-infra/compare/v1.41.3...v1.41.4
[1.41.3]: https://github.com/giantswarm/test-infra/compare/v1.41.2...v1.41.3
[1.41.2]: https://github.com/giantswarm/test-infra/compare/v1.41.1...v1.41.2
[1.41.1]: https://github.com/giantswarm/test-infra/compare/v1.41.0...v1.41.1
[1.41.0]: https://github.com/giantswarm/test-infra/compare/v1.40.0...v1.41.0
[1.40.0]: https://github.com/giantswarm/test-infra/compare/v1.39.8...v1.40.0
[1.39.8]: https://github.com/giantswarm/test-infra/compare/v1.39.7...v1.39.8
[1.39.7]: https://github.com/giantswarm/test-infra/compare/v1.39.6...v1.39.7
[1.39.6]: https://github.com/giantswarm/test-infra/compare/v1.39.5...v1.39.6
[1.39.5]: https://github.com/giantswarm/test-infra/compare/v1.39.4...v1.39.5
[1.39.4]: https://github.com/giantswarm/test-infra/compare/v1.39.3...v1.39.4
[1.39.3]: https://github.com/giantswarm/test-infra/compare/v1.39.2...v1.39.3
[1.39.2]: https://github.com/giantswarm/test-infra/compare/v1.39.1...v1.39.2
[1.39.1]: https://github.com/giantswarm/test-infra/compare/v1.39.0...v1.39.1
[1.39.0]: https://github.com/giantswarm/test-infra/compare/v1.38.0...v1.39.0
[1.38.0]: https://github.com/giantswarm/test-infra/compare/v1.37.1...v1.38.0
[1.37.1]: https://github.com/giantswarm/test-infra/compare/v1.37.0...v1.37.1
[1.37.0]: https://github.com/giantswarm/test-infra/compare/v1.36.2...v1.37.0
[1.36.2]: https://github.com/giantswarm/test-infra/compare/v1.36.0...v1.36.2
[1.36.0]: https://github.com/giantswarm/test-infra/compare/v1.35.0...v1.36.0
[1.35.0]: https://github.com/giantswarm/test-infra/compare/v1.34.1...v1.35.0
[1.34.1]: https://github.com/giantswarm/test-infra/compare/v1.34.0...v1.34.1
[1.34.0]: https://github.com/giantswarm/test-infra/compare/v1.33.1...v1.34.0
[1.33.1]: https://github.com/giantswarm/test-infra/compare/v1.33.0...v1.33.1
[1.33.0]: https://github.com/giantswarm/test-infra/compare/v1.32.0...v1.33.0
[1.32.0]: https://github.com/giantswarm/test-infra/compare/v1.31.0...v1.32.0
[1.31.0]: https://github.com/giantswarm/test-infra/compare/v1.30.0...v1.31.0
[1.30.0]: https://github.com/giantswarm/test-infra/compare/v1.29.0...v1.30.0
[1.29.0]: https://github.com/giantswarm/test-infra/compare/v1.28.0...v1.29.0
[1.28.0]: https://github.com/giantswarm/test-infra/compare/v1.27.0...v1.28.0
[1.27.0]: https://github.com/giantswarm/test-infra/compare/v1.26.1...v1.27.0
[1.26.1]: https://github.com/giantswarm/test-infra/compare/v1.26.0...v1.26.1
[1.26.0]: https://github.com/giantswarm/test-infra/compare/v1.25.0...v1.26.0
[1.25.0]: https://github.com/giantswarm/test-infra/compare/v1.24.0...v1.25.0
[1.24.0]: https://github.com/giantswarm/test-infra/compare/v1.23.0...v1.24.0
[1.23.0]: https://github.com/giantswarm/test-infra/compare/v1.22.0...v1.23.0
[1.22.0]: https://github.com/giantswarm/test-infra/compare/v1.21.0...v1.22.0
[1.21.0]: https://github.com/giantswarm/test-infra/compare/v1.20.0...v1.21.0
[1.20.0]: https://github.com/giantswarm/test-infra/compare/v1.19.1...v1.20.0
[1.19.1]: https://github.com/giantswarm/test-infra/compare/v1.19.0...v1.19.1
[1.19.0]: https://github.com/giantswarm/test-infra/compare/v1.18.0...v1.19.0
[1.18.0]: https://github.com/giantswarm/test-infra/compare/v1.17.0...v1.18.0
[1.17.0]: https://github.com/giantswarm/test-infra/compare/v1.16.0...v1.17.0
[1.16.0]: https://github.com/giantswarm/test-infra/compare/v1.15.0...v1.16.0
[1.15.0]: https://github.com/giantswarm/test-infra/compare/v1.14.0...v1.15.0
[1.14.0]: https://github.com/giantswarm/test-infra/compare/v1.13.0...v1.14.0
[1.13.0]: https://github.com/giantswarm/test-infra/compare/v1.12.0...v1.13.0
[1.12.0]: https://github.com/giantswarm/test-infra/compare/v1.11.0...v1.12.0
[1.11.0]: https://github.com/giantswarm/test-infra/compare/v1.10.0...v1.11.0
[1.10.0]: https://github.com/giantswarm/test-infra/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/giantswarm/test-infra/compare/v1.8.1...v1.9.0
[1.8.1]: https://github.com/giantswarm/test-infra/compare/v1.8.0...v1.8.1
[1.8.0]: https://github.com/giantswarm/test-infra/compare/v1.7.1...v1.8.0
[1.7.1]: https://github.com/giantswarm/test-infra/compare/v1.7.0...v1.7.1
[1.7.0]: https://github.com/giantswarm/test-infra/compare/v1.6.2...v1.7.0
[1.6.2]: https://github.com/giantswarm/test-infra/compare/v1.6.1...v1.6.2
[1.6.1]: https://github.com/giantswarm/test-infra/compare/v1.6.0...v1.6.1
[1.6.0]: https://github.com/giantswarm/test-infra/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/giantswarm/test-infra/compare/v1.4.2...v1.5.0
[1.4.2]: https://github.com/giantswarm/test-infra/compare/v1.4.1...v1.4.2
[1.4.1]: https://github.com/giantswarm/test-infra/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/giantswarm/test-infra/compare/v1.3.1...v1.4.0
[1.3.1]: https://github.com/giantswarm/test-infra/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/giantswarm/test-infra/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/giantswarm/test-infra/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/giantswarm/test-infra/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/giantswarm/test-infra/compare/v1.0.2...v1.1.0
[1.0.2]: https://github.com/giantswarm/test-infra/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/giantswarm/test-infra/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/giantswarm/test-infra/compare/v0.0.0...v1.0.0
