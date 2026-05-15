# OdO — Dev Journal

Running record of implemented stories: what was built, why it was built that way, and what breaks if it's undone. Each entry is self-contained — you can read any section cold.

---

## Story 1-1 — Project Setup and Dependency Configuration
**Date:** 2026-05-15 | **Epic:** 1 — Foundation | **Confidence:** 91/100

### Purpose
Establish the technical substrate that unblocks all 40 remaining stories: pinned dependencies, platform permissions, canonical folder structure, `main.dart` initialization order, and environment hygiene. Nothing in Epics 2–6 can be written until this story is done.

### What was implemented

- `pubspec.yaml` updated: package name set to `odo`, Dart SDK constraint locked to `>=3.0.0 <4.0.0`, all 19 required runtime deps added with pinned minor versions, `google_fonts` added (required by EC1), dev deps aligned to spec.
- `main.dart` rewritten with the locked initialization order: `ensureInitialized → GoogleFonts.config → tz.initializeTimeZones → BackgroundTaskService.initialize → NotificationService.initialize → ProviderScope(OdoApp)`.
- `OdoApp` ConsumerWidget created in `lib/app/app.dart` with OLED dark background (`#0D0D0F`). `theme.dart` and `router.dart` are stubs — real implementations land in Stories 1.3 and 1.8.
- Stub services `BackgroundTaskService` and `NotificationService` created in `lib/core/services/` with no-op static `initialize()` methods. They will be fleshed out in Story 1.6 without changing the call sites in `main.dart`.
- `Result<S>` sealed class + initial `AppFailure` enum created in `lib/core/types/result.dart`. Expanded in Story 1.7.
- Core constants stubs created: `AppColors` (OLED bg + three accent colors), `AppSpacing` (spacing + radius tokens), `AiConstants` (model name, context cap, window sizes). Full design tokens land in Story 1.2.
- Android manifest: 7 `<uses-permission>` elements (RECORD_AUDIO, USE_BIOMETRIC, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, WAKE_LOCK, VIBRATE, INTERNET) and the WorkManager `RescheduleReceiver` declared explicitly inside `<application>`.
- iOS `Info.plist`: `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`, `NSFaceIDUsageDescription`, `UIBackgroundModes` (fetch + processing).
- `CONVENTIONS.md` expanded with explicit Naming Conventions and Zero-Lint Policy sections.
- `.env.example` created (`AI_API_KEY=your_key_here`); `.env` added to `.gitignore`.
- All feature and core subdirectories created (`lib/features/{glance,home,agenda,practice,ai,evening_session,settings}/{data,domain,presentation}/`).

### File-by-file breakdown

| File | Responsibility | Connects to |
|------|---------------|-------------|
| `pubspec.yaml` | All dep versions + package name `odo` | Every dart file via `package:odo/` imports |
| `lib/main.dart` | Locked init chain, ProviderScope root | `app/app.dart`, `core/services/` |
| `lib/app/app.dart` | `OdoApp` widget, OLED dark theme stub | Consumed by `main.dart`; replaced by Story 1.3 theme |
| `lib/app/theme.dart` | Placeholder — Story 1.3 | Story 1.3 |
| `lib/app/router.dart` | Placeholder — Story 1.8 | Story 1.8 |
| `lib/core/services/background_task_service.dart` | Static `initialize()` stub | `main.dart`; expanded in Story 1.6 |
| `lib/core/services/notification_service.dart` | Static `initialize()` stub | `main.dart`; expanded in Story 1.6 |
| `lib/core/types/result.dart` | `sealed class Result<S>`, `AppFailure` enum | Domain usecases and repository impls across all features |
| `lib/core/constants/app_colors.dart` | OLED bg + accent color stubs | Story 1.2 expands; Story 1.3 consumes |
| `lib/core/constants/app_spacing.dart` | Spacing + radius token stubs | Story 1.2 expands; all UI stories consume |
| `lib/core/constants/ai_constants.dart` | Model name, context cap, window sizes | AI layer (Stories 4.x) |
| `android/.../AndroidManifest.xml` | Permissions + WorkManager receiver | Runtime permissions + Story 1.6 workmanager init |
| `ios/Runner/Info.plist` | Privacy strings + background modes | Speech (Story 4.4), biometric (Story 5.2), notifications (Story 1.6) |
| `CONVENTIONS.md` | Naming + zero-lint rules | Dev reference for all 41 stories |
| `.env.example` / `.gitignore` | API key hygiene | Story 1.5 AI provider, all build invocations |

### Architectural alignment
No domain or data layers exist in this story — it is infrastructure only. `main.dart` depends on `core/services/` and `app/`; `app/app.dart` depends only on Flutter and Riverpod. No layer boundary violations.

### Acceptance criteria → code mapping

| AC | Code | Test |
|----|------|------|
| FR1 — `name: odo` in pubspec | `pubspec.yaml` line 1 | N/A — static file check |
| FR2 — 19 runtime deps with correct versions | `pubspec.yaml` dependencies block | `flutter pub get` exit 0 |
| FR3 — `flutter pub get` succeeds | Resolved by correct dep constraints | CI: `flutter pub get` |
| FR4 — Android 7 permissions | `AndroidManifest.xml` uses-permission elements | N/A — static file check |
| FR5 — iOS 4 Info.plist keys | `ios/Runner/Info.plist` | N/A — static file check |
| FR6 — CONVENTIONS.md all sections | `CONVENTIONS.md` (naming + zero-lint added) | N/A — static file check |
| FR7 — .env.example + .gitignore | `.env.example`, `.gitignore` | N/A — static file check |
| FR8 — Full folder structure | All dirs created with stubs | `flutter analyze` (no missing-file errors) |
| FR9 — `main.dart` init order | `lib/main.dart` lines 11–16 | `widget_test.dart` — OdoApp renders |
| EC1 — GoogleFonts.config.allowRuntimeFetching=false | `lib/main.dart` line 12 | `widget_test.dart` setUpAll |
| EC2 — minSdkVersion ≥ 21 | `android/app/build.gradle.kts` — `minSdk = 21` | N/A — static file check |
| EC3 / EH1 — WorkManager receiver in `<application>` | `AndroidManifest.xml` `<receiver>` element | N/A — static file check |
| EH2 — SDK `>=3.0.0 <4.0.0` | `pubspec.yaml` environment.sdk | `flutter pub get` (Dart 2 would fail) |
| QR1 — Zero lint | All files | `flutter analyze` → "No issues found!" |
| SR1 — No API keys in source | `.env` in `.gitignore`, no keys in any .dart/.yaml | Manual + CI grep |

### What was deliberately NOT simplified
- The WorkManager `RescheduleReceiver` was declared explicitly in the manifest even though the plugin can auto-merge it — the AC requires it and explicit declaration prevents it being stripped by a future manifest merger configuration.
- `google_fonts` was added in this story despite the dev notes saying "not in scope for 1.1" because AC EC1 (`GoogleFonts.config.allowRuntimeFetching = false`) is an acceptance criterion, which takes precedence over dev notes per project rules.

### What breaks if this is undone
- Removing the `main.dart` init chain order (specifically `tz.initializeTimeZones` before notification setup) causes timezone-aware notifications to fire at UTC+0 regardless of device locale.
- Removing `GoogleFonts.config.allowRuntimeFetching = false` causes a network request on first launch — fails offline and adds ~200ms startup latency.
- Changing the pubspec `name` away from `odo` breaks all `package:odo/` imports across every future story.
- Removing the WorkManager `RescheduleReceiver` silently breaks background task re-scheduling after device reboot in some Android OEM ROMs that do not trigger the plugin's auto-merge path.

### What could increase confidence
- Running `flutter build apk --debug` on a connected Android device or emulator to verify native compilation (blocked by environment — no device attached).
- Running `flutter build ios --debug --no-codesign` to verify iOS compilation (blocked by environment — requires macOS).

---
