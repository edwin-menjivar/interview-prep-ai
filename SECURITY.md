# Security Hardening Notes

## Fixed from prior codebase
- Removed all hardcoded signing credentials and secret material from source.
- Added explicit secret ignore rules for env files, keystores, and Firebase service config files.
- Removed risky startup dependency on a bundled env asset.
- Kept a single top-level MaterialApp to avoid routing and auth flow confusion.
- Added explicit error states for load and bookmark failures.
- Added safe route argument validation to prevent runtime type crashes.
- Replaced swipe-delete patterns with explicit user actions only.

## Operational checklist before release
- Use CI secret store for signing and backend keys.
- Add SAST and dependency scanning in CI.
- Enable runtime crash reporting and analytics.
- For cloud sync, enforce least-privilege backend rules.
