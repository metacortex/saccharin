# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

<!-- ### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security -->


## [0.4.7] - 2017-5-9

### Fixed
- use request.headers `host` for cors


## [0.4.3] - 2017-5-1

### Changed
- `options_cors` allow referer host instead of *


## [0.4.0] - 2017-5-1

### Changed
- Change resource data callback name to `serialize` from `to_json`

### Added
- Add CORS header to rest api macro
- Add OPTIONS CORS macro `options_cors`


## [0.3.0] - 2017-4-28

### Added
- Add hash invariant helpers `invariant_hash_key`, `invariant_hash_key_any`, `invariant_hash_key_all`
- Add json invariant helpers `invariant_json_as_h`
- Add json parser helpers `json_value_to_i32`, `json_value_to_i64`
- Add kemal REST API macro `rest_api_read_only`
- Add json compact format parser


## [0.2.0] - 2017-4-27

### Added
- Add `_LOG`, `_LOG_PROPS` helpers
- Add kemal REST API macro `rest_api`

### Changed
- Support crystal 0.22.0


## 0.1.0 - 2017-03-31

### Added
- Add `present?`, `empty?` methods
- Add `dig`, `dig?` to `JSON::Any`, `YAML::Any`

[Unreleased]: https://github.com/metacortex/saccharin/compare/v0.4.3...HEAD
[0.4.3]: https://github.com/metacortex/saccharin/compare/v0.4.0...v0.4.3
[0.4.0]: https://github.com/metacortex/saccharin/compare/v0.3.6...v0.4.0
[0.3.0]: https://github.com/metacortex/saccharin/compare/v0.2.0...v0.3.6
[0.2.0]: https://github.com/metacortex/saccharin/compare/v0.1.0...v0.2.0
