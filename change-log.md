# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [~ Calendar Versioning](https://calver.org/) with the format YYYY.MM.BUILD.


## [Unreleased]


## [2026.06.71] - 2026-06-19

### Fixed
- Fixed bug in `hugopublish` shell alias for static site deployment
- Corrected the oh-my-zsh install command in the example server setup (was pointing at the Homebrew installer; now uses `ohmyzsh/ohmyzsh` on `raw.githubusercontent.com`)
- Corrected the systemd service example output for NGINX (`web-servers`) which incorrectly read `Enabling & starting core-app`; also aligned both core-app and web-servers blocks with the script's actual `Creating systemd service at ...` wording


## [2025.12.03] - 2025-12-03

### Added
- Added testimonials to documentation assets
### Fixed
- Error preventing the sample Video Collector app from running on Python 3.14
- Updated granian CLI syntax from deprecated `--threads` to `--runtime-threads` (cause run errors in Docker)
- Fixed incorrect shortcode expansions in multiple chapters
- Fixed Docker Compose build configuration for base images
- Fixed shortcode expansion issues in Kindle generation

### Changed
- Removed platform x86 dependency (doesn't seem to be required any longer)


## [2025.10.23] - 2025-10-10

### Added
- Added comprehensive glossary with key industry terms
- Added Amazon ASIN identifiers and 
- Implemented alphabetical ordering for glossary entries

### Changed
- Updated `ruff.toml` to enforce import ordering for improved code readability
- Removed pre-release cover image and set final PDF cover as official book cover

### Fixed
- Corrected NIH definition in book version 2025.10.23
- Fixed spelling of "Hertzner" (now "Hetzner")
- Updated "CertBox" to correct name "CertBot"
- Files: various source files

## [2025.10.12] - 2025-10-03

### Added
- Added `--no-version-change` CLI flag to `combiner.py` to skip version bump step
- Added HTML build support for generating web-ready book format
- Re-enabled automatic version bumping with optional skip flag

### Changed
- Improved version update logic with safer file writing to prevent data loss

### Fixed
- Fixed spelling errors in Kindle validation output
- Fixed version bump reliability issues that could corrupt version numbers
- Files: various source files

## [2025.10.11] - 2025-10-02

### Added
- First official release of the DevOps book
- Complete book content including all chapters, galleries, and supporting materials



---

## Template for Future Entries

<!--
## [YYYY.MM.DD]

### Added
- New features or capabilities
- Files: `path/to/new/file.ext`, `another/file.ext`

### Changed
- Modifications to existing functionality
- Files: `path/to/modified/file.ext` (summary if many files)

### Deprecated
- Features that will be removed in future versions
- Files affected: `path/to/deprecated/file.ext`

### Removed
- Features or files that were deleted
- Files: `path/to/removed/file.ext`

### Fixed
- Bug fixes and corrections
- Files: `path/to/fixed/file.ext`

### Security
- Security patches or vulnerability fixes
- Files: `path/to/security/file.ext`

### Notes
- Additional context or important information
- Major dependencies updated
- Breaking changes explanation
-->
