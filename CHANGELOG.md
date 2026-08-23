# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2026-08-23
### Fixed
- Native work (Android `MediaMetadataRetriever`, iOS `AVAssetImageGenerator`) now runs on a
  background thread/queue instead of the platform thread, so thumbnail generation no longer
  blocks the UI.
- Android no longer force-unwraps a possibly-null decoded frame; a failed extraction now
  returns a proper `THUMBNAIL_ERROR` instead of crashing.
- Thumbnails are written to the OS-managed cache directory (`cacheDir` / `.cachesDirectory`)
  instead of a raw temp file, so they get cleaned up automatically under storage pressure.
### Added
- `generateMultipleThumbnails` is now actually implemented on Android and iOS (previously
  unimplemented on both platforms and would return `notImplemented`). Frames are spread evenly
  across the video duration, reusing a single retriever/generator instance per call.
### Changed
- Android decodes frames at the target size via `getScaledFrameAtTime` (API 27+, falls back to
  decode-then-scale on older devices) instead of always decoding at full resolution.
- Android plugin package changed from the placeholder `com.example.v_thumbnail` to
  `com.performance2024.vthumbnail`.

## [0.0.1] - 2024-12-19
### Added
- Plugin to generate a thumbnail from a video file.
- Methods to generate single and multiple thumbnails.
- Example app to demonstrate video picking and thumbnail generation.
- Cross-platform support for Android and iOS.

## [0.0.0] - 2024-12-18
### Initial Release
- Basic setup of the `v_thumbnail` Flutter plugin.
- Created platform interfaces and setup for Android and iOS support.
