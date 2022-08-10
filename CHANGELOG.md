# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/giantswarm/test-infra/compare/v1.0.2...HEAD
[1.0.2]: https://github.com/giantswarm/test-infra/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/giantswarm/test-infra/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/giantswarm/test-infra/compare/v0.0.0...v1.0.0
