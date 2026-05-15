# Foundation Epic — Acceptance Criteria

## Functional Requirements (FR)

**FR1** — Flutter project initialized
- `flutter create --org com.odo odo` was run; `pubspec.yaml` has `name: odo`
- Default counter app replaced; `main.dart` contains `OdoApp`
- Independently testable: `grep "name: odo" pubspec.yaml` returns a match

**FR2** — All runtime dependencies present with correct versions
- pubspec.yaml contains all 19 packages: `flutter_riverpod: ^2.5.1`, `riverpod_annotation: ^2.3.5`, `go_router: ^14.0.0`, `drift: ^2.18.0`, `sqlite3_flutter_libs: ^0.5.22`, `path_provider: ^2.1.3`, `path: ^1.9.0`, `shared_preferences: ^2.2.3`, `flutter_local_notifications: ^17.1.2`, `workmanager: ^0.5.2`, `timezone: ^0.9.4`, `http: ^1.2.1`, `connectivity_plus: ^6.0.3`, `speech_to_text: ^6.6.0`, `flutter_tts: ^4.0.2`, `local_auth: ^2.2.0`, `table_calendar: ^3.1.2`, `intl: ^0.19.0`, `flutter_animate: ^4.5.0`
- Dev deps: `drift_dev: ^2.18.0`, `riverpod_generator: ^2.4.0`, `build_runner: ^2.4.9`, `flutter_lints: ^4.0.0`

**FR3** — `flutter pub get` succeeds
- Exit code 0; no "version solving failed" errors; `pubspec.lock` generated

**FR4** — Android permissions configured
- `AndroidManifest.xml` contains all 7 `<uses-permission>` elements: `RECORD_AUDIO`, `USE_BIOMETRIC`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `WAKE_LOCK`, `VIBRATE`, `INTERNET`

**FR5** — iOS Info.plist configured
- `NSMicrophoneUsageDescription` present with non-empty description string
- `NSSpeechRecognitionUsageDescription` present
- `NSFaceIDUsageDescription` present
- `UIBackgroundModes` array contains `fetch` and `processing`

**FR6** — CONVENTIONS.md exists at repo root
- Contains section: Clean Architecture import rules (domain → no imports, data → domain only, presentation → domain only)
- Contains section: Riverpod patterns (provider naming suffix convention, AsyncNotifier, StreamProvider)
- Contains section: naming conventions (files snake_case, classes PascalCase, providers suffix rule)
- Contains section: zero-lint policy and API key management via `--dart-define`

**FR7** — Environment file configuration
- `.env.example` contains `AI_API_KEY=your_key_here`
- `.gitignore` includes `.env` entry (not `.env.example`)
- No API key present in any committed file

**FR8** — Folder structure matches architecture spec
- `lib/app/` with `app.dart`, `theme.dart`, `router.dart`
- `lib/core/constants/`, `lib/core/database/`, `lib/core/services/`, `lib/core/types/`, `lib/core/widgets/`, `lib/core/domain/`, `lib/core/utils/`
- `lib/features/glance/`, `lib/features/home/`, `lib/features/agenda/`, `lib/features/practice/`, `lib/features/ai/`, `lib/features/evening_session/`, `lib/features/settings/`
- Each feature (except home) has `data/`, `domain/`, `presentation/` subdirs

**FR9** — `main.dart` initialization order
- `WidgetsFlutterBinding.ensureInitialized()` is first call
- `tz.initializeTimeZones()` called before any notification setup
- `BackgroundTaskService.initialize()` called with `await` before `runApp`
- `NotificationService.initialize()` called with `await` before `runApp`
- `runApp(const ProviderScope(child: OdoApp()))` is the final call

---

## Integration Requirements (IR)

**IR1** — Code generation works
- `dart run build_runner build` exits 0
- No "conflicting outputs" errors
- After Story 1.4, `.g.dart` files are generated for Drift tables and Riverpod providers

**IR2** — App compiles and runs
- `flutter run` on connected Android device/emulator: app launches without crash
- Dark background (`#0D0D0F`) visible on first frame
- 5-tab bottom nav renders

---

## Edge Cases (EC)

**EC1** — Runtime font fetching disabled
- `GoogleFonts.config.allowRuntimeFetching = false` is set in `main()` before `runApp`
- This prevents startup latency on first run from network font download

**EC2** — `minSdkVersion` ≥ 21 on Android
- `android/app/build.gradle` has `minSdkVersion 21` (required by `sqlite3_flutter_libs`)
- Default Flutter creates `minSdkVersion 16` or `19`; must be updated

**EC3** — workmanager receiver in `<application>` tag (not `<manifest>` root)
- BroadcastReceiver element is inside `<application>`, not a sibling of it

---

## Error Handling Requirements (EH)

**EH1** — workmanager `BroadcastReceiver` declared correctly
- `<receiver android:name="androidx.work.impl.background.systemalarm.RescheduleReceiver" android:exported="false" />` inside `<application>` tag

**EH2** — Dart SDK constraint
- `pubspec.yaml` `environment.sdk` set to `">=3.0.0 <4.0.0"`
- Prevents running on Dart 2.x which lacks sealed classes

---

## Quality Requirements (QR)

**QR1** — Zero lint warnings
- `flutter analyze` returns "No issues found!" on all files in `lib/`
- Run after EVERY new file is written — never deferred

**QR2** — Android debug build succeeds
- `flutter build apk --debug` exits 0 with no errors

**QR3** — No unused imports or dead code
- All `import` statements in created files are used
- All stubs have minimal no-op implementations, not empty files

---

## Security Requirements (SR)

**SR1** — API keys never in source
- No `AI_API_KEY` value in any `.dart`, `.yaml`, `.json`, `.xml`, or `.plist` file in the repo
- `--dart-define=AI_API_KEY=` pattern documented in `CONVENTIONS.md`
- `.env` in `.gitignore` and never committed

**SR2** — No sensitive data in CONVENTIONS.md or .env.example
- `.env.example` contains only `AI_API_KEY=your_key_here` (placeholder, not a real key)
