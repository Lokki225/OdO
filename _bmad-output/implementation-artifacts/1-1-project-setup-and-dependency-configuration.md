# Story 1.1: Project Setup and Dependency Configuration

Status: ready-for-dev

## Story

As a developer,
I want to initialize the Flutter project with all required dependencies configured,
so that the project compiles and is ready for feature development.

## Acceptance Criteria

1. A fresh Flutter project exists created with `flutter create --org com.odo odo`
2. All dependencies from `architecture.md` are in `pubspec.yaml`: flutter_riverpod ^2.5.1, riverpod_annotation ^2.3.5, go_router ^14.0.0, drift ^2.18.0, sqlite3_flutter_libs ^0.5.22, path_provider ^2.1.3, path ^1.9.0, shared_preferences ^2.2.3, flutter_local_notifications ^17.1.2, workmanager ^0.5.2, timezone ^0.9.4, http ^1.2.1, connectivity_plus ^6.0.3, speech_to_text ^6.6.0, flutter_tts ^4.0.2, local_auth ^2.2.0, table_calendar ^3.1.2, intl ^0.19.0, flutter_animate ^4.5.0
3. Dev dependencies include: drift_dev ^2.18.0, riverpod_generator ^2.4.0, build_runner ^2.4.9, flutter_lints ^4.0.0
4. `flutter pub get` succeeds with no resolution errors
5. The project compiles without errors on iOS and Android (`flutter build apk --debug` and `flutter build ios --debug --no-codesign`)
6. Android `AndroidManifest.xml` includes permissions: RECORD_AUDIO, USE_BIOMETRIC, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, WAKE_LOCK, VIBRATE, INTERNET
7. iOS `Info.plist` includes: `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`, `NSFaceIDUsageDescription`, `UIBackgroundModes` (fetch, background-processing)
8. `CONVENTIONS.md` exists at the repo root documenting locked architectural decisions (Clean Architecture layers, import rules, Riverpod patterns)
9. `.env.example` documents required env vars (`AI_API_KEY`); real `.env` is in `.gitignore`
10. Project folder structure matches the spec in `architecture.md`: `lib/{app,features,core}/`

## Tasks / Subtasks

- [ ] Task 1: Initialize Flutter project (AC: 1)
  - [ ] Run `flutter create --org com.odo odo` in the workspace root
  - [ ] Verify default project compiles
- [ ] Task 2: Configure pubspec.yaml with all dependencies (AC: 2, 3, 4)
  - [ ] Add all runtime dependencies with pinned minor versions
  - [ ] Add all dev dependencies
  - [ ] Run `flutter pub get` and confirm success
- [ ] Task 3: Configure Android permissions (AC: 6)
  - [ ] Edit `android/app/src/main/AndroidManifest.xml` to add all required permissions
  - [ ] Add `workmanager` initialization in `AndroidManifest.xml`
- [ ] Task 4: Configure iOS Info.plist (AC: 7)
  - [ ] Edit `ios/Runner/Info.plist` with all usage descriptions
  - [ ] Add `UIBackgroundModes` array with required modes
- [ ] Task 5: Create CONVENTIONS.md (AC: 8)
  - [ ] Document Clean Architecture import rules
  - [ ] Document Riverpod patterns (AsyncNotifier, StreamProvider, providers in feature folder)
  - [ ] Document naming conventions (files: snake_case, classes: PascalCase)
  - [ ] Document zero-lint policy
- [ ] Task 6: Configure environment files (AC: 9)
  - [ ] Create `.env.example` with `AI_API_KEY=your_key_here`
  - [ ] Verify `.env` is in `.gitignore`
- [ ] Task 7: Scaffold project folder structure (AC: 10)
  - [ ] Create `lib/app/`, `lib/features/`, `lib/core/` directories
  - [ ] Create feature subdirs: `glance/`, `home/`, `agenda/`, `practice/`, `ai/`, `evening_session/`, `settings/`
  - [ ] Each feature gets `data/`, `domain/`, `presentation/` subdirs

## Dev Notes

- **Flutter SDK:** Use the version installed; minimum Flutter 3.22+ required for Dart 3 sealed classes
- **Drift init:** `drift_dev` and `build_runner` are dev deps only; never import `drift_dev` in `lib/`
- **workmanager Android init:** The `<application>` tag in `AndroidManifest.xml` must declare the workmanager `BroadcastReceiver` and the `CallbackDispatcher`; follow the workmanager README exactly
- **google_fonts NOT in scope for this story** — fonts are added in Story 1.2/1.3 when theme is created
- **`flutter_animate`** is preferred over raw `AnimationController` for all animations in the project
- **Build verification:** Run `flutter analyze` after setup — must show "No issues found!" before marking done
- **`.env` pattern:** API keys pass to the app via `--dart-define=AI_API_KEY=xxx` at build time, not via dotenv packages at runtime

### Project Structure Notes

```
lib/
├── main.dart                   # minimal, delegates to app/app.dart
├── app/
│   ├── app.dart               # MaterialApp + ProviderScope
│   ├── theme.dart             # placeholder — Story 1.3
│   └── router.dart            # placeholder — Story 1.8
├── core/
│   ├── constants/             # app_colors.dart, app_spacing.dart, ai_constants.dart
│   ├── database/              # app_database.dart, database_providers.dart
│   ├── services/              # ai_provider.dart, background_task_service.dart, etc.
│   ├── types/                 # result.dart
│   └── widgets/               # shared widgets
└── features/
    ├── glance/{data,domain,presentation}/
    ├── home/presentation/
    ├── agenda/{data,domain,presentation}/
    ├── practice/{data,domain,presentation}/
    ├── ai/{data,domain,presentation}/
    ├── evening_session/{data,domain,presentation}/
    └── settings/{data,domain,presentation}/
```

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Starter-Template] — pubspec.yaml versions locked here
- [Source: _bmad-output/planning-artifacts/architecture.md#Project-Structure] — folder layout
- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.1] — acceptance criteria source

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
