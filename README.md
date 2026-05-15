# OdO — Personal AI Daily Companion

OdO is a mobile app (Android + iOS) that acts as a personal AI daily companion for a single user. It manages schedule, practice habits, and expenses, then ties all three together with a proactive AI layer that learns what matters to you over time.

**Not a productivity app. A daily ritual.**

---

## What it does

OdO operates across three time horizons:

| Horizon | Description |
|---------|-------------|
| **Moments** | Timely notifications throughout the day — 5 min before a meeting, a practice session starting, a proactive suggestion when the AI detects something worth surfacing |
| **Evening Session** | A structured 5-minute reflective conversation at 8pm. This is where OdO learns what you value |
| **Cumulative Understanding** | Over weeks, OdO builds a local model of your patterns. Stays on-device. Grows in value every day |

### Core modules

- **Agenda** — events, schedule, calendar. The anchor that gives the AI temporal awareness
- **Practice (Wills)** — long-term skill tracking with session logging, streaks, and pattern detection
- **AI Layer** — Claude API integration with persistent chat bar, voice tap-to-speak, context builder, and offline fallback
- **Evening Session** — orchestrated nightly conversation with on-device suggestion engine
- **Glance Screen** — app-lock-style screen as the primary ambient surface

---

## Tech stack

| Layer | Technology |
|-------|-----------|
| UI framework | Flutter + Dart |
| State management | Riverpod 3.x (`@riverpod` annotation + code generation) |
| Local database | Drift (SQLite ORM) — 6 tables |
| Navigation | go_router — shell route with 5-tab bottom nav |
| AI | Claude API (`claude-sonnet-4-6`) via `http` package |
| Background tasks | workmanager |
| Notifications | flutter_local_notifications |
| Persistence | shared_preferences |
| Fonts | google_fonts (Fraunces + DM Sans) |
| Code generation | build_runner, drift_dev, riverpod_generator |

**Architecture:** Clean Architecture, strictly enforced — `domain/` → `data/` → `presentation/`. No layer skipping.

---

## Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0
- Android SDK with NDK 28.2.13676358 (required by `speech_to_text`)
- Xcode (iOS builds, macOS only)
- A Claude API key (`sk-ant-...`)

---

## Setup

```bash
# Clone
git clone https://github.com/Lokki225/OdO.git
cd OdO

# Install dependencies
flutter pub get

# Run code generation (Drift + Riverpod)
dart run build_runner build --delete-conflicting-outputs
```

### API key

OdO never stores API keys in source. Pass it at run time via `--dart-define`:

```bash
flutter run --dart-define=AI_API_KEY=sk-ant-your-key-here
```

Copy `.env.example` to `.env` for reference (`.env` is gitignored and never committed).

---

## Running

```bash
# Debug on connected device
flutter run --dart-define=AI_API_KEY=sk-ant-your-key-here

# Release APK
flutter build apk --release --dart-define=AI_API_KEY=sk-ant-your-key-here

# Run tests
flutter test

# Analyze
flutter analyze
```

**Quality gate:** `flutter analyze` must report "No issues found!" and `flutter test` must pass ≥ 90% before any story is considered done.

---

## Project structure

```
lib/
  app/
    app.dart           # MaterialApp.router root (ConsumerWidget)
    router.dart        # GoRouter — initialLocation=/glance, ShellRoute, 14 routes
    theme.dart         # AppTheme.fromOdoTheme → Material3 ThemeData
  core/
    constants/         # OdoTheme, AppColors (7 presets), AppSpacing, AppTypography, AppDurations
    database/          # Drift AppDatabase, 6 table definitions, database_providers.dart
    domain/            # AppError enum (8 variants)
    services/          # ConnectivityService, NotificationService, BackgroundTaskService,
                       # VoiceService (5-state machine), LocaleService (XOF/French)
    types/             # sealed Result<T> with Success/Failure
    widgets/           # shared widgets
  features/
    agenda/            # Agenda module — data / domain / presentation
    ai/                # AiProvider abstraction + Claude/Gemini/Groq/OpenAI/Offline impls
    evening_session/   # Evening session orchestration
    glance/            # Glance screen (ambient lock-style surface)
    home/              # ScaffoldWithNavBar, PlaceholderScreen
    practice/          # Practice / Wills module
    settings/          # Theme provider + settings screen
  main.dart            # Init chain: ensureInitialized → GoogleFonts → tz → workmanager → notifications → ProviderScope

test/                  # Mirrors lib/ structure exactly
  app/
  core/
  features/

lib/product/           # Product layer — spec, AC, risks, test scenarios, impl plans per epic
docs/                  # Design reference, implementation plan, contracts, dev journal
_bmad-output/          # Story artifacts and planning artifacts
```

---

## Database schema

Six Drift tables with FK constraints enforced via `PRAGMA foreign_keys = ON`:

| Table | Purpose |
|-------|---------|
| `skills` | Practice skills tracked by the user |
| `sessions` | Practice session logs (FK → skills, CASCADE DELETE) |
| `events` | Agenda events |
| `suggestions` | AI-generated proactive suggestions |
| `evening_sessions` | Evening conversation records |
| `evening_highlights` | User-highlighted moments from evening sessions (FK → evening_sessions, CASCADE DELETE) |

---

## Themes

Seven `OdoTheme` presets — dark mode default (OLED-optimized):

| Theme | Accent | Notes |
|-------|--------|-------|
| Violet Dark | `#7C4DFF` | **Default** — OLED `#0D0D0F` background |
| Cyan Dark | `#00BCD4` | |
| Green Dark | `#1D9E75` | |
| Ember | `#FF6B35` | |
| Aurora | `#00E5FF` | |
| Cosmic | `#E040FB` | |
| Light Mode | `#8B6C4F` | `#FDF8F2` base |

Active theme is persisted in SharedPreferences and swappable at runtime.

---

## Epic status

| Epic | Stories | Status |
|------|---------|--------|
| 1 — Foundation | 8/8 | **COMPLETE** |
| 2 — Agenda Module | 0/5 | Not started |
| 3 — Practice Module | 0/6 | Not started |
| 4 — AI Layer | 0/5 | Not started |
| 5 — Glance + Evening + Proactive | 0/9 | Not started |
| 6 — Polish & Resilience | 0/8 | Not started |

**Current test count:** 129/129 passing | `flutter analyze`: No issues found

---

## Key conventions

See [`CONVENTIONS.md`](CONVENTIONS.md) for the full reference. Quick summary:

- **Layer imports:** `domain/` imports nothing; `data/` imports `domain/` only; `presentation/` imports `domain/` only — never `data/`
- **Providers:** `{feature}{Layer}Provider` suffix encodes the type (`*RepositoryProvider`, `*NotifierProvider`, `*ServiceProvider`)
- **Error handling:** `AsyncValue` at UI boundary, `Result<T>` in services, `try/catch` for external libraries only
- **Navigation:** always `context.go()` / `context.push()` — never `Navigator.push`
- **API keys:** `--dart-define` at build time, never in source
- **Lint:** zero-tolerance — `flutter analyze` must be clean before moving to the next file

---

## Locale

French UI (`fr`) with English fallback. Ivorian context:
- Currency: XOF with thin-space thousands separator (`1 500 F`)
- Dates: `DD/MM/YYYY`
- Times: `HH:mm` (24-hour)
- Timezone: `Africa/Abidjan` (UTC+0)

---

## Offline-first

All Agenda and Practice features work without internet. The AI layer degrades gracefully — `OfflineStubAiProvider` returns canned text when connectivity is unavailable. Connectivity state is streamed via `ConnectivityService`.

---

**Solo project by Franklin Ouattara.**  
Test device: Samsung SM-N960F.
