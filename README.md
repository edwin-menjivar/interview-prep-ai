# HireDeck AI

Interview prep app with sign-in, role-based groups, and structured interview cards.

## Included in this version
- Sign-in gate with local session persistence
- Groups screen with field filters, create/edit/delete
- Cards screen per group with create/edit/delete
- Card detail view with previous/next navigation
- Local persistence for groups/cards and seeded starter content
- Security hardening notes and CI checks

## Run locally
1. `cd /Users/edwin/Documents/development/flashy-tech-solutions/interview-prep-ai`
2. `flutter pub get`
3. `flutter run -d <device_id>`

No environment variables are required for this version.

## Test and quality
- `flutter analyze`
- `flutter test`

## Test coverage
- `test/auth_controller_test.dart`: sign-in validation and session behavior
- `test/study_controller_test.dart`: groups/cards load and CRUD behavior
- `test/widget_test.dart`: auth-gated app boot flow

## Security
See `SECURITY.md` for hardening details and release checklist.
