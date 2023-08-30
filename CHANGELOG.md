# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/giantswarm/test-infra/compare/v1.25.0...HEAD
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
