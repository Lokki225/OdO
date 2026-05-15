# OdO — Dev Journal

Running record of implemented stories: what was built, why it was built that way, and what breaks if it's undone. Each entry is self-contained — you can read any section cold.

---

## Story 1-8 — Router and Project Structure
**Date:** 2026-05-15 | **Epic:** 1 — Foundation | **Confidence:** 95/100

### Purpose
Implement navigation so the 5-tab shell exists as a working skeleton, unblocking all feature-screen stories in Epics 2–5.

### What was implemented

- `lib/app/router.dart` — `GoRouter` with `initialLocation: '/glance'`, `ShellRoute` wrapping `/home`, 10 top-level routes + 4 slide-up bottom-sheet routes via `CustomTransitionPage` + `SlideTransition`. `routerProvider` exposes the router to Riverpod for programmatic navigation (voice commands, background task callbacks).
- `lib/features/home/presentation/scaffold_with_nav_bar.dart` — 5-tab `NavigationBar` with French labels (Accueil / Agenda / Pratique / Insights / Profil). Tab selection derived from `GoRouterState.of(context).uri` — iterates tabs last-to-first so sub-routes like `/home/agenda/event/1` correctly highlight the Agenda tab.
- `lib/features/home/presentation/placeholder_screen.dart` — reusable scaffold for unimplemented screens; shows title + current route path.
- `lib/app/app.dart` — migrated from `MaterialApp(home: ...)` to `MaterialApp.router(routerConfig: router)`.
- `CONVENTIONS.md` — added Import Rules table and Navigation section.

### File-by-file breakdown

| File | Responsibility | Connects to |
|------|---------------|-------------|
| `lib/app/router.dart` | All route definitions, slide-up helper, `routerProvider` | `app.dart` (routerConfig), all feature screens |
| `scaffold_with_nav_bar.dart` | 5-tab nav bar + active-tab logic | Consumed by ShellRoute; wraps all `/home/*` screens |
| `placeholder_screen.dart` | Empty screen stub | All 9 unimplemented tab screens |
| `lib/app/app.dart` | `MaterialApp.router` root | `main.dart`, `router.dart`, theme |
| `CONVENTIONS.md` | Navigation + import layer rules | Dev reference |

### Key decisions
- Tab index iteration runs from last to first — a sub-route like `/home/agenda/event/1` must match Agenda, not Home, and last-to-first `startsWith` achieves this with zero branching logic.
- Router defined as a module-level constant (not a class) so `routerProvider = Provider((ref) => router)` is a one-liner.
- `CustomTransitionPage` with `SlideTransition(begin: Offset(0, 1))` gives the native bottom-sheet feel without adding a dependency.

### What breaks if this is undone
- Every feature screen in Epics 2–5 has no navigation entry point.
- Programmatic navigation from `VoiceService` command callbacks (Story 4.4) requires `routerProvider` — removing it breaks the entire voice-nav pipeline.

---

## Story 1-7 — Result Type and Error Handling
**Date:** 2026-05-15 | **Epic:** 1 — Foundation | **Confidence:** 97/100

### Purpose
Introduce a typed, sealed error vocabulary so all service and repository calls return explicit success/failure rather than throwing. Prevents silent nulls and makes failure handling visible at every call site.

### What was implemented

- `lib/core/domain/app_error.dart` — `AppError` enum with 8 variants: `aiUnavailable`, `databaseWriteFailed`, `suggestionSuppressed`, `contextPayloadTooLarge`, `voiceCaptureFailed`, `voiceParseAmbiguous`, `slotNoLongerAvailable`, `authFailed`. Each variant has a `.message` getter.
- `lib/core/types/result.dart` — `sealed class Result<T>` with `Success<T>` (`.value`) and `Failure<T>` (`.error`). Methods: `.when(success:, failure:)`, `.getOrNull()`, `.isSuccess`, `.isFailure`. Re-exports `app_error.dart` so callers need one import.
- All AI provider files and tests migrated from `AppFailure` → `AppError`, `.failure` → `.error`.

### File-by-file breakdown

| File | Responsibility | Connects to |
|------|---------------|-------------|
| `lib/core/domain/app_error.dart` | Exhaustive error enum | Every service and repository return type |
| `lib/core/types/result.dart` | Sealed Result type + helpers | Every `Future<Result<T>>` call site across all features |

### Key gotcha
`Failure<T>` field is named `.error`, not `.failure`. Any pre-migration code using `.failure` fails at compile time — which is intentional. The compile error is the enforcement.

### What breaks if this is undone
- All service method signatures must change from `Result<T>` back to raw `T?` or throw-based — this unravels error handling across every future story.
- The `.when()` pattern in the UI (via `AsyncValue`) mirrors this contract; removing it breaks the UI error handling convention.

---

## Story 1-6 — Core Services
**Date:** 2026-05-15 | **Epic:** 1 — Foundation | **Confidence:** 93/100

### Purpose
Implement the five background services that support notifications, connectivity awareness, background task scheduling, voice state management, and locale formatting. These are depended on by the AI layer, evening session, and suggestion engine.

### What was implemented

- `ConnectivityService` — wraps `connectivity_plus` and exposes `Stream<bool>` (true = online). Hides plugin-specific `ConnectivityResult` from all feature code.
- `NotificationService` — flutter_local_notifications with Africa/Abidjan timezone. Schedules event reminders at -5 min before start. Shows evening session notification at 8pm. Handles Android 13+ `POST_NOTIFICATIONS` permission.
- `BackgroundTaskService` — top-level `callbackDispatcher()` registered with workmanager (must be top-level; cannot be a closure or instance method). Registers periodic `odo.evening_check` task. Computes next 8pm delay on `scheduleEveningCheck()`.
- `VoiceService` — 5-state machine: `idle → listening → parsing → committing → committed`. `StreamController.broadcast(sync: true)` ensures state transitions are delivered synchronously so tests can assert state immediately after `simulateTransition()`. `@visibleForTesting simulateTransition(VoiceState)` bypasses the STT plugin for pure unit tests.
- `LocaleService` — `formatXof(int amount)` uses `NumberFormat('#,##0').format()` then replaces `,` with thin-space for French-style thousands separator. `formatDate` → `DD/MM/YYYY`. `formatTime` → `HH:mm`.
- `service_providers.dart` — 5 Riverpod providers; VoiceService disposes via `ref.onDispose`.

### File-by-file breakdown

| File | Responsibility | Connects to |
|------|---------------|-------------|
| `connectivity_service.dart` | Online/offline stream | AI provider (Story 4.5), suggestion engine (Story 5.6) |
| `notification_service.dart` | Local notifications + TZ scheduling | Evening session (Story 5.4), event reminders (Story 2.4) |
| `background_task_service.dart` | workmanager periodic tasks | Evening check (Story 5.8) |
| `voice_service.dart` | STT state machine | Voice pipeline (Story 4.4), nav commands |
| `locale_service.dart` | XOF + date/time formatting | All UI showing money or timestamps |
| `service_providers.dart` | Riverpod wiring | All feature providers that need these services |

### Critical gotcha
`StreamController.broadcast()` delivers events asynchronously by default. Use `sync: true` for any state machine where tests assert state immediately after a transition. Without it, the `states` list is always empty when the assertion runs.

### What breaks if this is undone
- Removing `PRAGMA foreign_keys = ON` from `NativeDatabase` setup causes CASCADE DELETE to silently do nothing — cascade tests pass but production data leaks orphaned rows.
- Removing `callbackDispatcher` top-level declaration breaks workmanager — it must be a top-level function for the isolate entry point to resolve.

---

## Story 1-5 — AiProvider Abstraction
**Date:** 2026-05-15 | **Epic:** 1 — Foundation | **Confidence:** 95/100

### Purpose
Decouple all AI call sites from any specific provider implementation so Claude can be swapped for Gemini/Groq/OpenAI/Offline without touching feature code. Required before any AI feature story can be written.

### What was implemented

- `lib/features/ai/domain/ai_provider.dart` — `abstract class AiProvider` with `sendContext(AiContextPayload)` and `streamResponse(AiContextPayload)`. Value types: `ChatMessage` (role, content, timestamp), `AiContextPayload` (contextText, userMessage, history), `AiResponse` (text, timestamp). All `@immutable`.
- `lib/features/ai/data/claude_ai_provider.dart` — injects `http.Client` (enables `MockClient` in tests with no mockito). POST to `https://api.anthropic.com/v1/messages`. Model: `claude-sonnet-4-6`, `max_tokens: 1024`. API key via `String.fromEnvironment('AI_API_KEY')`.
- Stubs: `GeminiAiProvider`, `GroqAiProvider`, `OpenAiAiProvider` — all return `Failure(AppError.aiUnavailable)`. `OfflineStubAiProvider` — returns canned text, no network required.
- `lib/core/constants/ai_config.dart` — `const kActiveAiProvider = 'claude'` controls which implementation is injected.
- `lib/features/ai/presentation/ai_providers.dart` — `aiProviderServiceProvider` uses a `switch` on `kActiveAiProvider` to return the correct implementation.

### Key gotcha
`http.MockClient` from `package:http/testing.dart` is the right tool for testing `ClaudeAiProvider` — inject a mock client in the constructor. No need for mockito or generated mocks.

### What breaks if this is undone
- All AI feature stories (4.1–4.5) call `aiProviderServiceProvider` — removing the abstraction forces a concrete provider into feature code and makes swapping or testing impossible.

---

## Story 1-4 — SQLite Database Schema with Drift
**Date:** 2026-05-15 | **Epic:** 1 — Foundation | **Confidence:** 96/100

### Purpose
Define the complete database schema that all feature DAOs will build on. Every Agenda, Practice, and Evening Session story depends on these tables being present with correct FK constraints.

### What was implemented

- 6 Drift table files in `lib/core/database/tables/`:
  - `Skills` — `@DataClassName('SkillRow')`, 4 columns, autoincrement PK
  - `Sessions` — FK → Skills with `CASCADE DELETE`; includes `isAnchored` bool + nullable `suggestedTime`
  - `Events` — category enum (personal/agenda/will), start/end datetimes, nullable recurrence fields
  - `Suggestions` — nullable FK → Skills (`SET NULL` on delete) + `status` enum
  - `EveningSessions` — date, summary, duration
  - `EveningHighlights` — FK → EveningSessions with `CASCADE DELETE`
- `lib/core/database/app_database.dart` — `@DriftDatabase`, `schemaVersion = 1`, `MigrationStrategy(onCreate: createAll + 5 performance indexes)`. `AppDatabase.forTesting(super.executor)` uses `super.parameter` syntax.
- `lib/core/database/database_providers.dart` — `appDatabaseProvider` as a Riverpod `Provider<AppDatabase>` singleton with `ref.onDispose(db.close)`.

### Critical gotcha
SQLite disables FK constraints by default. `PRAGMA foreign_keys = ON` must be passed to `setup:` in **both** `NativeDatabase.createInBackground` (production) and `NativeDatabase.memory()` (tests). Without it, CASCADE DELETE silently does nothing and the cascade tests give false positives.

### What breaks if this is undone
- All DAO files in Epics 2 and 3 extend `DatabaseAccessor<AppDatabase>` and reference these table types — removing any table definition is a compile error across ~10 future files.
- Removing the cascade setup means orphaned `sessions` rows accumulate when a `skill` is deleted.

---

## Story 1-3 — Theme System with Runtime Swap
**Date:** 2026-05-15 | **Epic:** 1 — Foundation | **Confidence:** 96/100

### Purpose
Bridge the `OdoTheme` data tokens (Story 1-2) into a live Flutter `ThemeData`, wire SharedPreferences persistence, and expose a Riverpod notifier so any widget can trigger a runtime theme swap without rebuilding the full app.

### What was implemented

- `lib/core/constants/app_spacing.dart` — spacing scale `sp2`–`sp32` + radius scale (sm/md/lg/xl/full). Used by every UI story.
- `lib/core/constants/app_durations.dart` — `durationFast` (150ms), `durationDefault` (250ms), `durationSlow` (400ms).
- `lib/core/constants/app_typography.dart` — 7 named getters: `textDisplay` / `textTitle` use Fraunces (serif); `textHeadline` through `textLabel` use DM Sans. `tabularFigures` feature enabled on `textDisplay` and `clockStyle`.
- `lib/app/theme.dart` — `AppTheme.fromOdoTheme(OdoTheme, {TextTheme? textThemeOverride})`. `textThemeOverride` allows tests to skip `google_fonts` entirely. Uses `ColorScheme.fromSeed().copyWith()` to avoid deprecated `background` parameter.
- `lib/core/services/shared_preferences_provider.dart` — `@Riverpod(keepAlive: true)`. Throws `UnimplementedError` by design if not overridden before `ProviderScope` mounts — prevents silent null fallbacks.
- `lib/features/settings/presentation/theme_provider.dart` — `ActiveTheme` Notifier. Reads saved theme name from SharedPreferences on `build()`; calls `setTheme(String name)` to persist + switch.
- `lib/app/app.dart` — extended to `ConsumerWidget`; watches `activeThemeProvider` and passes resolved `ThemeData` to `MaterialApp`.
- `lib/main.dart` — initializes SharedPreferences and provides the value via `ProviderScope` overrides before `runApp`.

### Key gotchas
- `CardThemeData` (not `CardTheme`) — Flutter renamed the data class in 3.x; the analyzer catches the old name.
- `BorderRadius.vertical()` returns `BorderRadius`, not `BorderRadiusDirectional` — cast accordingly in tests.
- google_fonts fires an async font-loading error after sync test assertions complete. Fix: wrap each typography test call in `runZonedGuarded<Future<void>>` with a 30ms `Future.delayed` to absorb the trailing async error without failing the assertion.

### What breaks if this is undone
- All 41 UI stories reference `AppSpacing`, `AppTypography`, and `AppTheme` — removing them is a compile error across the entire presentation layer.
- SharedPreferences provider must be overridden in `main()` exactly once; moving it breaks the theme persistence chain.

---

## Story 1-2 — Design Tokens and Color System
**Date:** 2026-05-15 | **Epic:** 1 — Foundation | **Confidence:** 95/100

### Purpose
Define the canonical color token layer so all theme presets and UI stories draw from a single source of truth rather than hardcoding hex values. Establishes the `OdoTheme` data type that Story 1-3 bridges into Flutter's `ThemeData`.

### What was implemented

- `lib/core/constants/odo_theme.dart` — `OdoTheme` immutable data class with 10 semantic token fields (`background`, `surface`, `surfaceVariant`, `accent`, `accentLight`, `onAccent`, `textPrimary`, `textSecondary`, `aiSurface`, `orbIdle`). `withCustomAccent(String hex)` returns a copy with a new accent while recomputing `orbIdle` at 30% alpha. `_parseHex` handles strings with or without `#`.
- `lib/core/constants/app_colors.dart` — 8 raw palette constants annotated `@visibleForTesting` (enforces the two-layer rule at analysis time); 3 fixed category tokens; 3 `colorAccent*` semantic aliases; 7 const `OdoTheme` presets (`violetDark` is the default); `allThemes` list.

### Key decisions
- Two-file split keeps `OdoTheme` as pure Dart (`dart:ui` only) and `AppColors` as the preset registry.
- `orbIdle` is baked into each const instance as `0x4D` alpha (30% of 255). The runtime `withCustomAccent` path uses `withValues(alpha: 0.30)` instead of deprecated `withOpacity`.
- `@visibleForTesting` on raw palette constants means any feature file importing them directly fails `flutter analyze`.

### What breaks if this is undone
- `AppTheme.fromOdoTheme` (Story 1-3) takes an `OdoTheme` parameter — the entire theme system unravels.
- All 7 preset names are referenced by string in `ActiveTheme` notifier — renaming any preset is a runtime theme-switch failure.

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
