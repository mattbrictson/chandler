# chandler Change Log

All notable changes to this project will be documented in this file.

chandler is in a pre-1.0 state. This means that its APIs and behavior are subject to breaking changes without deprecation notices. Until 1.0, version numbers will follow a [Semver][]-ish `0.y.z` format, where `y` is incremented when new features or breaking changes are introduced, and `z` is incremented for lesser changes or bug fixes.

## [Unreleased][]

* Your contribution here! 
* [#36](https://github.com/mattbrictson/chandler/issues/36): Releaxed Version Handling - [@PatrikSteuer](https://github.com/PatrikSteuer)

## [0.9.0][] (2019-02-10)

* [#45](https://github.com/mattbrictson/chandler/pull/45): Submit link references together with the release notes for each version so that links are always properly rendered - [@deivid-rodriguez](https://github.com/deivid-rodriguez)

## [0.8.0][] (2019-01-26)

* **Drop support for EOL Rubies.** Chandler now requires Ruby >= 2.3.

## [0.7.0][] (2016-12-23)

* [#23](https://github.com/mattbrictson/chandler/pull/23): Fix warnings reported when using Rake 12.0 - [@mattbrictson](https://github.com/mattbrictson)
* [#21](https://github.com/mattbrictson/chandler/pull/21): Remove --debug flag since it is not used anywhere - [@mattbrictson](https://github.com/mattbrictson)

## [0.6.0][] (2016-11-09)

* [#19](https://github.com/mattbrictson/chandler/pull/19): Add GitHub Enterprise support - [@mattbrictson](https://github.com/mattbrictson)

## [0.5.0][] (2016-10-07)

* Adds support for using `CHANDLER_GITHUB_API_TOKEN` to authenticate your API requests - Orta

## [0.4.0][] (2016-09-23)

* Support for reStructuredText `definition-list` style CHANGELOG layouts.

## [0.3.1][] (2016-05-13)

* Fix a bug where the formatting of certain Markdown release notes were
  inadvertently altered due to stripping indentation off the first line of the
  text.

## [0.3.0][] (2016-03-22)

* Support Markdown "setext" style h1-level headings [#11](https://github.com/mattbrictson/chandler/pull/11)

## [0.2.0][] (2016-02-19)

* Chandler now understands versions at Markdown/Rdoc h1-level headings (previously only h2 and h3 were searched).
* If Chandler can't find any version tags, print an error message rather than exiting silently.
* If Chandler can't find a version in your CHANGELOG, it will log a warning rather than exiting with an uncaught exception.
* Add `--tag-prefix` option to allow for other Git version tag formats (e.g. `myapp-v1.0.0`; see [#3](https://github.com/mattbrictson/chandler/issues/3))

## [0.1.2][] (2015-10-26)

* Fix Windows test failures introduced in 0.1.1

## [0.1.1][] (2015-10-26)

* Work around parsing issues caused by non-breaking spaces in change logs (e.g. SSHKit)

## 0.1.0 (2015-06-19)

* Initial release

[Semver]: http://semver.org
[Unreleased]: https://github.com/mattbrictson/chandler/compare/v0.9.0...HEAD
[0.9.0]: https://github.com/mattbrictson/chandler/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/mattbrictson/chandler/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/mattbrictson/chandler/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/mattbrictson/chandler/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/mattbrictson/chandler/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mattbrictson/chandler/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/mattbrictson/chandler/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/mattbrictson/chandler/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mattbrictson/chandler/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/mattbrictson/chandler/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/mattbrictson/chandler/compare/v0.1.0...v0.1.1
