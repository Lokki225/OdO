---
storyId: 1.1
storyKey: 1-1-project-setup-and-dependency-configuration
epicId: 1
projectName: TooXTips
date: 2026-03-29
status: ready-for-dev
---

# Story 1.1: Project Setup and Dependency Configuration

## Story Statement

As a developer,
I want to initialize the Flutter project with all required dependencies configured,
So that the project compiles and is ready for feature development.

## Acceptance Criteria

**Given** a fresh Flutter project created with `flutter create --org com.tooxips tooxips`
**When** I add all dependencies from the architecture specification (Riverpod, Drift, go_router, etc.)
**Then** the project compiles without errors
**And** `flutter pub get` succeeds
**And** all platform-specific configurations (Android permissions, iOS setup) are in place

## Technical Requirements

### Dependencies to Add

**State Management & Dependency Injection:**
- `riverpod: ^2.4.0` - State management with code-gen support
- `riverpod_generator: ^2.3.0` - Code generation for @riverpod
- `flutter_riverpod: ^2.4.0` - Flutter integration for Riverpod

**Database & Persistence:**
- `drift: ^2.14.0` - Type-safe SQLite ORM
- `drift_flutter: ^2.1.0` - Flutter integration for Drift
- `sqlite3_flutter_libs: ^0.5.0` - SQLite native libraries
- `shared_preferences: ^2.2.0` - Local key-value storage

**Navigation:**
- `go_router: ^13.0.0` - Modern routing with bottom sheets support

**Notifications & Background Tasks:**
- `flutter_local_notifications: ^16.0.0` - Local notification delivery
- `workmanager: ^0.5.0` - Background task scheduling
- `timezone: ^0.9.0` - Timezone support for scheduling

**Connectivity:**
- `connectivity_plus: ^5.0.0` - Network connectivity detection

**UI & Calendar:**
- `table_calendar: ^3.0.0` - Calendar widget
- `intl: ^0.19.0` - Internationalization and date formatting

**Build & Code Generation:**
- `build_runner: ^2.4.0` - Code generation runner (dev dependency)
- `drift_dev: ^2.14.0` - Drift code generation (dev dependency)

### Platform-Specific Configuration

**Android (android/app/build.gradle):**
- Set `minSdkVersion` to 21 (for Drift and background tasks)
- Add permissions in `AndroidManifest.xml`:
  - `android.permission.SCHEDULE_EXACT_ALARM` (for workmanager)
  - `android.permission.POST_NOTIFICATIONS` (for notifications)
  - `android.permission.INTERNET` (for AI API calls)

**iOS (ios/Podfile):**
- Set minimum deployment target to 12.0
- Ensure background modes enabled for notifications

### Project Structure

```
tooxips/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   └── theme.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   └── ai_constants.dart
│   │   ├── database/
│   │   │   └── app_database.dart
│   │   └── services/
│   │       ├── ai_provider.dart
│   │       ├── background_task_service.dart
│   │       └── notification_service.dart
│   └── features/
│       ├── agenda/
│       ├── practice/
│       └── ai/
├── test/
├── pubspec.yaml
├── analysis_options.yaml
└── CONVENTIONS.md
```

### Verification Steps

1. Run `flutter create --org com.tooxips tooxips` to initialize project
2. Add all dependencies to `pubspec.yaml`
3. Run `flutter pub get` and verify no errors
4. Run `flutter pub upgrade` to resolve any version conflicts
5. Run `flutter analyze` to check for analysis issues
6. Run `flutter doctor` to verify platform setup
7. Verify Android and iOS configurations are in place
8. Run `dart run build_runner build` to generate initial code (should succeed even with empty files)

## Success Criteria

- ✓ Flutter project initializes without errors
- ✓ All dependencies resolve successfully
- ✓ `flutter pub get` completes without conflicts
- ✓ `flutter analyze` shows no errors or warnings
- ✓ Android minSdkVersion set to 21
- ✓ iOS minimum deployment target set to 12.0
- ✓ Platform permissions configured
- ✓ Project structure created as specified
- ✓ `dart run build_runner build` succeeds (generates empty code)

## Notes

- This story is foundational - all other stories depend on successful completion
- Do not skip platform configuration steps; they are required for later stories
- The project should compile even before adding feature code
- Keep pubspec.yaml organized with clear dependency grouping
