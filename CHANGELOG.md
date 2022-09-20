# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/giantswarm/test-infra/compare/v1.4.2...HEAD
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
