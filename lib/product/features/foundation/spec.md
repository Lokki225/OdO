# Foundation Epic — Spec

## Problem Statement

OdO is a greenfield Flutter project. Before any user-facing feature can be built, the technical substrate must exist: a compilable project with all locked dependencies, a design system (tokens + 7 themes), a type-safe SQLite schema (6 tables), a swappable AI provider abstraction, core services (locale, notifications, background tasks, connectivity, voice), a typed `Result<T, F>` error type, and a go_router shell. Without this foundation, every subsequent epic is blocked.

## Goals

- Initialize a Flutter project (`com.odo odo`) that compiles cleanly on Android and iOS
- Lock all dependency versions in `pubspec.yaml` per `architecture.md` so all 41 stories can proceed without version conflicts
- Establish the two-layer color token system (raw palette + semantic tokens) with all 7 OdoTheme presets
- Implement `ThemeData` for dark mode (default/OLED) and light mode with runtime swap via Riverpod
- Define the 6-table SQLite schema in Drift with type-safe DAOs and code-gen working
- Create an `AiProvider` abstract interface with `ClaudeAiProvider` as the V1 implementation and 4 stub providers (Gemini, Groq, OpenAI, OfflineStub)
- Provide `LocaleService`, `NotificationService`, `BackgroundTaskService`, `ConnectivityService`, `VoiceService` as plain-Dart injectable classes
- Define `Result<S, F>` sealed class and `AppFailure` type for all error handling
- Configure go_router shell route with 5-tab bottom nav and all feature routes as stubs
- Create `CONVENTIONS.md` documenting locked architectural decisions

## Non-Goals

- No user-facing UI beyond the bare shell needed to render tabs (tab content is stubs)
- No actual AI API calls (AiProvider is wired but AI features are in Epics 2–4)
- No actual database reads/writes (schema exists but DAOs are wired in per-feature epics)
- No biometric/vocal authentication logic (Story 5.2)
- No real background task scheduling logic (Story 5.8)
- No Google Fonts download at runtime (must be pre-bundled or disabled)

## User Flow

Not applicable — Foundation is a technical epic. The observable outcome is:
1. `flutter run` launches the app with a dark OLED background (`#0D0D0F`)
2. A 5-tab bottom nav renders with Home, Agenda, Practice, Insights, Profile tab labels
3. Each tab shows an empty scaffold (no content — that's Epics 2–5)
4. The app does not crash on Android or iOS

## Technical Constraints

- Flutter 3.22+ / Dart 3.x required (sealed classes, records, pattern matching)
- All 19 runtime dependencies pinned to minor versions from `architecture.md`
- Drift code generation (`dart run build_runner build`) must succeed before any feature code
- API keys passed via `--dart-define=AI_API_KEY=xxx` at build time — no `.env` packages
- `flutter analyze` must show "No issues found!" after each file is written
- `main.dart` initialization order is locked: `ensureInitialized → tz.initializeTimeZones → BackgroundTaskService.initialize → NotificationService.initialize → runApp`

## Dependencies

- **Blocks:** All 33 remaining stories (Epics 2–6)
- **Blocked by:** Nothing (prerequisite epic)
- **Internal story order:** 1.1 → 1.2 → 1.3 → 1.4 → 1.5 → 1.6 → 1.7 → 1.8

## Success Metrics

- `flutter pub get` succeeds with no resolution errors
- `flutter analyze`: "No issues found!"
- `dart run build_runner build`: completes without errors; `.g.dart` files generated
- `flutter build apk --debug`: success
- `flutter build ios --debug --no-codesign`: success
- All 7 OdoTheme presets render correct background/accent colors in widget tests
- `LocaleService.formatXof(15000)` returns `'15 000 F'`
- All 6 Drift tables exist in schema with correct columns