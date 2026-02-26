# Interview Cards Pro

A modern Flutter app for job interview prep cards with structured answers.

## Focus
- Software Engineering interviews
- Product Management interviews

## What is included
- Search and filter interview cards by field and tags
- Bookmark cards with local persistence
- Detail screen with strong answer framework and red flags
- Test coverage for controller logic and app boot smoke test

## Prerequisites
1. Flutter stable (validated on Flutter 3.41.0)
2. Dart 3.11+
3. Xcode (for iOS simulator) or Android Studio (for Android emulator)

## Setup
1. Open terminal in this repo:
   - cd /Users/edwin/Documents/development/flashy-tech-solutions/interview_cards_pro
2. Install dependencies:
   - flutter pub get

## Run the app
1. List available devices:
   - flutter devices
2. Run on a selected device:
   - flutter run -d <device_id>
3. Optional desktop run (if enabled):
   - flutter run -d macos

## Tests and quality checks
- Run static analysis:
  - flutter analyze
- Run all tests:
  - flutter test
- Run one test file:
  - flutter test test/interview_cards_controller_test.dart

## Current test coverage
- test/interview_cards_controller_test.dart
  - Seed data includes at least two career fields
  - Field + query filtering behavior
  - Bookmark persistence behavior
- test/widget_test.dart
  - App boot smoke test

## Project structure
- lib/src/core: shared theme/utilities
- lib/src/features/interview_cards/domain: entities/enums
- lib/src/features/interview_cards/data: repository implementations
- lib/src/features/interview_cards/application: state/controller
- lib/src/features/interview_cards/presentation: screens/widgets

## Security notes
- No hardcoded credentials or signing secrets
- Keep API keys and signing configs in local files or CI secret stores
- Never commit env files, keystores, or service config secrets
- Add remote backend auth/rules before enabling multi-user cloud sync
