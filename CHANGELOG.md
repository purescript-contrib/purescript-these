# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes:

New features:

Bugfixes:

Other improvements:
- Added `purs-tidy` formatter (#40 by @thomashoneyman)

## [v5.0.0](https://github.com/purescript-contrib/purescript-these/releases/tag/v5.0.0) - 2021-02-26

Breaking changes:
- Added support for PureScript 0.14 and dropped support for all previous versions (#31)

New features:
- Added three new classes: `Align`, `Alignable`, and `Crosswalk` (#29 by @vladciobanu)
- Added `both`, `isThat`, `isThis`, and `isBoth` (#25 by @thomashoneyman)

Bugfixes:

Other improvements:
- Changed default branch to `main` from `master`
- Add documentation for the `These` data type and `these` and `fromThese` functions (#28 by @JordanMartinez)
- Updated to comply with Contributors library guidelines by adding new issue and pull request templates, updating documentation, and migrating to Spago for local development and CI (#26, #30)

## [v4.0.0](https://github.com/purescript-contrib/purescript-these/releases/tag/v4.0.0) - 2018-05-26

- Updated for PureScript 0.12

## [v3.1.0](https://github.com/purescript-contrib/purescript-these/releases/tag/v3.1.0) - 2018-03-15

- Added `maybeThese`, `this`, `that`, and a `MonadGen`-based generator

## [v3.0.0](https://github.com/purescript-contrib/purescript-these/releases/tag/v3.0.0) - 2017-04-07

- Update dependencies for 0.11 compiler
- Remove `generics` dependency

## [v2.0.0](https://github.com/purescript-contrib/purescript-these/releases/tag/v2.0.0) - 2016-10-17

- Updated dependencies

## [v1.0.0](https://github.com/purescript-contrib/purescript-these/releases/tag/v1.0.0) - 2016-06-06

- Updated for 1.0 core libraries.

## [v0.3.4](https://github.com/purescript-contrib/purescript-these/releases/tag/v0.3.4) - 2016-05-16

- Added `Show` instance (@paluh)

## [v0.3.3](https://github.com/purescript-contrib/purescript-these/releases/tag/v0.3.3) - 2015-11-20

- Removed unused imports (@tfausak)

## [v0.3.2](https://github.com/purescript-contrib/purescript-these/releases/tag/v0.3.2) - 2015-11-14

- Updated to allow publishing on http://pursuit.purescript.org/

## [v0.3.1](https://github.com/purescript-contrib/purescript-these/releases/tag/v0.3.1) - 2015-10-23

- Fixed unicode issue with `bower.json` (@tfausak)

## [v0.3.0](https://github.com/purescript-contrib/purescript-these/releases/tag/v0.3.0) - 2015-07-07

This release works with versions 0.7.\* of the PureScript compiler. It will not work with older versions. If you are using an older version, you should require an older, compatible version of this library.

## [v0.2.1](https://github.com/purescript-contrib/purescript-these/releases/tag/v0.2.1) - 2015-05-20

- Initial versioned release. Added `thisOrBoth` and `thatOrBoth`.
