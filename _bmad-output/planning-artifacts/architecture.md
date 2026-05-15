# OdO — Architecture Specification

**Project:** OdO — Personal AI Daily Companion
**Author:** Lokki
**Date:** May 13, 2026
**Status:** Locked for V1 MVP Implementation

---

## Input Documents Loaded

- **Project Brief** (`project-brief.md`) — Executive summary, MVP scope, success criteria, roadmap
- **UX Design Specification** (`ux-design-specification.md`) — Visual design system, interaction patterns, emotional design
- **Epics** (`epics.md`) — Six epics with stories and acceptance criteria

---

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
- **Glance Screen** — ambient lock surface with orb, lock state, info cards, voice/text/quick-add bottom bar; slide-up unlock; vocal-password + typed-password + optional biometric auth
- **Home Screen** — persistent Agenda strip, one-slide Practice carousel, persistent AI bottom bar
- **Agenda Module** — event CRUD with three categories (Personal/Work/Practice), day timeline with 30-min grid, monthly calendar within Agenda slide, persistent strip with three states (events today / no more today / nothing scheduled)
- **Practice Module** — user-defined skills, session logging, automatic streak computation, 7-day activity bar, unanchored session silent flagging, pattern detection (3 sessions at similar times across ≥2 weeks)
- **AI Layer** — selective context payload (≤4,000 chars), swappable provider abstraction, chat sheet, voice tap-to-speak, offline graceful degradation
- **Evening Session** — 8pm invitation, 5-min ceiling ritual, headline → 3–4 highlights with tag/expand/dismiss → one cross-domain insight → close summary, "wrap up" jump
- **Proactive Suggestions** — on-device, fully offline; ranked by longest-idle skill → shortest fitting slot → earliest window; one per evening (non-negotiable); throughout-day on data shifts; suppression algorithm
- **Voice (V1)** — tap-to-speak via mic button; one-shot commit when possible; configurable voice output per surface
- **Themes** — seven presets + custom color picker; dark default; light mode optimized for outdoor Abidjan brightness
- **Background Tasks** — 8pm session invitation, 5-min pre-event reminders; best-effort with fallback on app open
- **Offline-Tolerant** — every feature works without connectivity

**Non-Functional Requirements:**
- **Performance:** sub-500ms perceived latency via optimistic UI and local-first rendering
- **Reliability:** 99%+ crash-free sessions; no data loss on restart; session persistence until midnight on interruption
- **Offline Capability:** 100% core features without connectivity; AI degrades silently
- **Privacy:** all user data local; only AI context payload over HTTPS; no analytics, no telemetry, no third-party SDKs, no ad IDs
- **Accessibility:** WCAG AA contrast; 44dp minimum touch targets; voice as equal-priority input; high-contrast outdoor-readable light mode
- **Locale:** XOF currency (no decimals), DD/MM/YYYY, UTC+0, French-primary UI with English support
- **Security:** API keys via `--dart-define` build-time only, never in source control

**Scale & Complexity:**
- **Primary Domain:** Mobile-first Flutter application with local-first architecture
- **Complexity Level:** Medium-High — Glance Screen state machine, voice integration, on-device suggestion engine, evening session orchestration, multi-theme system
- **Estimated Components:** 7 core architectural components, 5 supporting services

### Technical Constraints & Dependencies

- **Solo development** — one person, full responsibility, scope ruthlessly prioritized
- **Flutter cross-platform** — one codebase, iOS + Android from V1
- **Local-first data** — no backend, no user accounts, no sync in V1
- **AI provider abstraction** — Claude default, but Gemini/Groq/OpenAI/offline-stub swappable via single constant
- **Background task reliability** — workmanager and iOS background fetch are best-effort; fallback essential
- **Voice on V1** — platform STT (Apple Speech, Android SpeechRecognizer) via tap-to-speak; ambient wake-word deferred to V2
- **Two-device model** — V1 ships phone-only; watch (V2) reads phone-computed state

### Cross-Cutting Concerns Identified

1. **AI Context Aggregation** — spans Agenda + Practice + suggestion history; real-time state sync; hard 4k char cap
2. **Offline Tolerance** — every feature; ConnectivityService is a dependency for AI layer only
3. **Background Task Scheduling** — 8pm evening session + 5-min event reminders + throughout-day data-shift triggers
4. **Data Persistence** — SQLite schema supports free-slot detection, idle-skill ranking, pattern detection queries
5. **Temporal Reasoning** — UTC+0 throughout; "today" boundary at midnight local; session persistence until midnight
6. **Theme Coherence** — orb + active dot + cards + accents all inherit active theme via semantic tokens
7. **Voice State Machine** — idle → listening → parsing → committed → confirmation; orb animation tightly coupled

---

## Architectural Component Model

### Core Architectural Components (Own Data & State)

1. **GlanceModule** — lock state, orb animation state, auth (vocal/typed/biometric), quick-capture pipeline
2. **AgendaModule** — events, calendar state, strip data, category coloring
3. **PracticeModule** — skills, sessions, streak computation, unanchored flagging, pattern detection
4. **AiService** — provider abstraction, context builder, response parser, chat sheet state
5. **EveningSession** — 8pm orchestration, highlight ranking, tag/expand/dismiss state, close summary, persistence-until-midnight
6. **SuggestionEngine** — on-device proactive logic, slot detection, idle ranking, suppression algorithm
7. **ThemeSystem** — seven presets + custom picker, semantic tokens, runtime swap

### Supporting Services (Stateless, Injected as Dependencies)

1. **NotificationService** — local notification scheduling and delivery
2. **BackgroundTaskService** — workmanager scheduling, 8pm trigger, data-shift trigger, fallback on app open
3. **ConnectivityService** — online/offline state, AI availability flag
4. **VoiceService** — platform STT wrapper, TTS wrapper, voice state machine
5. **LocaleService** — XOF formatting, DD/MM/YYYY, UTC+0 timezone, French/English string lookup

**Architectural Principle:** Components own Riverpod providers and DB access. Supporting services are plain Dart classes injected via providers. This distinction prevents folder-structure debt as the codebase grows.

---

## Critical Technical Risks & Mitigations

### Background Task Reliability (Platform-Specific)

**Risk:** `workmanager` on Android is subject to battery optimization killing background tasks. On iOS, background fetch is throttled by OS based on usage. Neither platform guarantees 8pm task execution.

**Mitigation Strategy:**
- Product decision: 8pm notification is best-effort, not guaranteed
- UI never implies the notification will definitely arrive
- **Fallback trigger:** when the user opens the app, if no evening session has been delivered or completed in the last 18 hours and current local time is between 8pm and midnight, surface the session inline as the first home-screen interaction
- After-midnight policy: today's session is gone — no retroactive surfacing
- This covers background failure without user awareness

### Suggestion Staleness (Time-Sensitive Slots)

**Risk:** A suggestion is generated at 8pm Wednesday for a Thursday 2pm slot. The user does not tap until Thursday 11am. The slot may no longer exist.

**Mitigation:** When the confirmation sheet opens, recheck the Agenda locally before rendering. If the slot is gone, display a single line: *"This slot is no longer available"* with a single button: "Close." No alternative suggestion. The AI will try again tonight.

**Slot validity window:** 30 minutes between suggestion creation and confirmation tap. Beyond that, re-validate.

### Context Payload Overflow (4k Hard Cap)

**Risk:** As the user accumulates skills, agenda density, and suggestion history, the context payload grows beyond what the AI provider can usefully reason over.

**Mitigation:**
- Hard cap enforced in `ContextBuilder`: payload must be ≤4,000 characters before send
- Priority order when truncating: (1) today's agenda + 48h ahead, (2) all skills with current streak only, (3) last 7 days unanchored sessions, (4) last 3 suggestions with outcomes, (5) current datetime + active screen
- Full data (full agenda week, full session history, complete suggestion log) stays on-device for local SuggestionEngine reasoning
- Truncation is silent — the user never sees a "context too large" error

### Voice Failure Modes

**Risk:** Platform STT fails on Ivorian French accent, ambient noise, or short utterances. AI parsing produces ambiguous intent.

**Mitigation:**
- Platform STT (Apple Speech / Google SpeechRecognizer) is already accent-tolerant for standard French
- On STT failure: orb returns to idle, no error banner; user can retap and retry
- On AI parsing ambiguity: follow-up question appears only when intent is genuinely unclear — never for optional enrichments
- Optional enrichments (notes, category) offered after the action is already saved, never blocking commit

### Theme System Performance

**Risk:** Seven theme presets + custom color picker means many possible accent combinations. Hardcoded colors anywhere in the widget tree break this.

**Mitigation:**
- **Two-layer color token system** (see Design System section below) — semantic tokens only used in widgets, raw palette never directly referenced
- `AppColors` is the single source of truth; `AppTheme` builds `ThemeData` from active theme
- Theme switch at runtime via `ProviderScope` rebuild — no app restart
- Custom picker computes only the accent token; surface/text/border tokens stay locked to the active mode (dark or light)

### Evening Session Interruption

**Risk:** User starts the 8:01pm session, gets a phone call at 8:03pm, returns at 11:47pm. Session state must survive.

**Mitigation:**
- Session state persisted to SQLite (`evening_sessions` table) on every tag/expand/dismiss
- On app reopen between 8pm and midnight, if an in-progress session exists, resume from current step
- At midnight, in-progress session is marked `abandoned_at = midnight_timestamp` and is no longer resumable
- Tomorrow's session begins fresh

---

## SQLite Schema (Foundation for All Features)

The complete schema. Drift code generation produces type-safe DAOs from these tables.

### `skills`

```sql
id              INTEGER PRIMARY KEY AUTOINCREMENT
name            TEXT NOT NULL
created_at      INTEGER NOT NULL              -- epoch ms
last_session_at INTEGER                        -- epoch ms, nullable
```

### `sessions`

```sql
id                INTEGER PRIMARY KEY AUTOINCREMENT
skill_id          INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE
started_at        INTEGER NOT NULL              -- epoch ms
duration_minutes  INTEGER NOT NULL
notes             TEXT
is_anchored       INTEGER NOT NULL DEFAULT 0    -- 0/1 bool
suggested_time    INTEGER                        -- epoch ms, nullable
```

**Critical columns:**
- `is_anchored = 0` when session was logged without a corresponding agenda event
- `suggested_time` populated when session was logged from a suggestion
- **Pattern detection query:**
  ```sql
  SELECT started_at FROM sessions
  WHERE skill_id = ? AND is_anchored = 0
  ORDER BY started_at DESC LIMIT 3
  ```
  If all three timestamps fall within a 90-minute window-of-day and span ≥2 distinct calendar weeks, the evening session asks once about anchoring.

### `events`

```sql
id          INTEGER PRIMARY KEY AUTOINCREMENT
title       TEXT NOT NULL
start_time  INTEGER NOT NULL              -- epoch ms
end_time    INTEGER NOT NULL              -- epoch ms
category    TEXT NOT NULL                 -- 'personal' | 'work' | 'practice'
notes       TEXT
```

### `suggestions`

```sql
id                INTEGER PRIMARY KEY AUTOINCREMENT
skill_id          INTEGER REFERENCES skills(id) ON DELETE SET NULL
slot_start        INTEGER NOT NULL              -- epoch ms
slot_duration     INTEGER NOT NULL              -- minutes
suggested_at      INTEGER NOT NULL              -- epoch ms
accepted_at       INTEGER                        -- epoch ms, nullable
dismissed_at      INTEGER                        -- epoch ms, nullable
thumbs_down_at    INTEGER                        -- epoch ms, nullable
suppressed_until  INTEGER                        -- epoch ms, nullable
```

**Critical column:** `suppressed_until` — computed when dismissed (now + 3 days), thumbs-down (now + 7 days), or accepted (now + 1 day). `SuggestionEngine` filters out any skill where `suppressed_until > now()`. This is the entire learning algorithm in one column.

### `evening_sessions`

```sql
id              INTEGER PRIMARY KEY AUTOINCREMENT
session_date    TEXT NOT NULL                  -- 'YYYY-MM-DD' local date
started_at      INTEGER NOT NULL               -- epoch ms
completed_at    INTEGER                         -- epoch ms, nullable
abandoned_at    INTEGER                         -- epoch ms, nullable (set at midnight if not completed)
headline        TEXT NOT NULL
close_summary   TEXT
```

### `evening_highlights`

```sql
id                  INTEGER PRIMARY KEY AUTOINCREMENT
evening_session_id  INTEGER NOT NULL REFERENCES evening_sessions(id) ON DELETE CASCADE
display_order       INTEGER NOT NULL
content             TEXT NOT NULL                -- the highlight text
source_type         TEXT NOT NULL                -- 'session' | 'event' | 'pattern' | 'insight'
source_ref_id       INTEGER                       -- nullable FK depending on source_type
user_tag            TEXT                          -- 'significant' | 'dismiss' | 'expand' | NULL
tagged_at           INTEGER                       -- epoch ms, nullable
```

**Architectural Principle:** Get these six tables right before writing any feature code. Everything else queries them. Schema changes after Epic 1 require a migration and are costly — review the schema in full before Day 1.

---

## Starter Template & Project Initialization

### Primary Technology Domain

Mobile Application (Flutter) — cross-platform requirement with offline-first architecture, local SQLite persistence, and Riverpod state management.

### Selected Starter: Custom Architecture Scaffold

**Rationale:** Architectural decisions are locked (Riverpod, Drift, go_router, workmanager). A generic starter would impose patterns conflicting with the offline-first + AI context aggregation + multi-theme design. Custom scaffold is more efficient.

**Initialization Command:**

```bash
flutter create --org com.odo odo
```

### Production-Ready `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^14.0.0

  # Local persistence
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.22
  path_provider: ^2.1.3
  path: ^1.9.0
  shared_preferences: ^2.2.3

  # Notifications + background
  flutter_local_notifications: ^17.1.2
  workmanager: ^0.5.2
  timezone: ^0.9.4

  # AI + connectivity
  http: ^1.2.1
  connectivity_plus: ^6.0.3

  # Voice (V1: tap-to-speak)
  speech_to_text: ^6.6.0
  flutter_tts: ^4.0.2

  # Auth (optional biometric)
  local_auth: ^2.2.0

  # Calendar + locale
  table_calendar: ^3.1.2
  intl: ^0.19.0

  # Animations + UI
  flutter_animate: ^4.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  drift_dev: ^2.18.0
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.9
  flutter_lints: ^4.0.0
```

### Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── theme.dart                       # seven presets + custom; semantic tokens
│   └── router.dart                      # go_router config, bottom sheets as routes
├── features/
│   ├── glance/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── home/
│   │   └── presentation/                # carousel shell, persistent strip wiring
│   ├── agenda/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── practice/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── ai/
│   │   ├── data/                        # provider clients (Claude, Gemini, etc.)
│   │   ├── domain/                      # AiProvider interface, context builder
│   │   └── presentation/                # chat sheet, persistent bottom bar
│   ├── evening_session/
│   │   ├── data/
│   │   ├── domain/                      # highlight ranking, persistence-until-midnight
│   │   └── presentation/                # session screen, tag UI, wrap-up
│   └── settings/
│       ├── data/
│       └── presentation/                # theme picker, voice toggles, lock options
├── core/
│   ├── database/
│   │   ├── app_database.dart
│   │   └── app_database.g.dart          # generated
│   ├── services/
│   │   ├── connectivity_service.dart
│   │   ├── notification_service.dart
│   │   ├── background_task_service.dart
│   │   ├── voice_service.dart
│   │   └── locale_service.dart
│   ├── widgets/
│   │   ├── orb.dart                     # the AI orb, idle + active states
│   │   └── ...
│   ├── constants/
│   │   ├── app_colors.dart              # raw palette + semantic tokens + 7 themes
│   │   ├── app_spacing.dart
│   │   └── app_typography.dart
│   ├── domain/
│   │   ├── result.dart                  # Result<T, AppError> sealed type
│   │   └── app_error.dart
│   └── utils/
│       ├── date_utils.dart
│       └── currency_utils.dart
test/
└── (parallel structure mirroring lib/)
```

**Architectural Principle:** `core/` (not `shared/`) signals foundational, not feature-specific. This convention matters for codebase navigation as it grows.

### Critical `main.dart` Setup

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Timezone DB initialization (required by flutter_local_notifications)
  tz.initializeTimeZones();

  // Background task registration must happen before runApp
  await BackgroundTaskService.initialize();

  // Notification service initialization
  await NotificationService.initialize();

  runApp(
    const ProviderScope(
      child: OdoApp(),
    ),
  );
}
```

**Critical Sequencing:**
- `WidgetsFlutterBinding.ensureInitialized()` first — workmanager and flutter_local_notifications fail silently otherwise
- `tz.initializeTimeZones()` before notification service — scheduled notifications need the timezone DB
- `BackgroundTaskService.initialize()` before `runApp` — workmanager dispatcher must be registered
- `ProviderScope` wraps entire app

### Foundation Files (Write in This Order)

1. **`core/constants/app_colors.dart`** — raw palette + semantic tokens + seven theme maps. Nothing renders without this.
2. **`app/theme.dart`** — `ThemeData` for dark, light, and five accent variants. Include `FontFeature.tabularFigures()` for clock display.
3. **`core/database/app_database.dart`** — Drift schema with all six tables. Run `dart run build_runner build` immediately after.
4. **`features/ai/domain/ai_provider.dart`** — abstract `AiProvider` interface + `OfflineStubAiProvider` concrete fallback.

Do not write any feature widgets until these four files compile cleanly.

### Android Platform Configuration

Add to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

Inside `<application>`:

```xml
<receiver
  android:name="androidx.work.impl.background.systemalarm.RescheduleReceiver"
  android:exported="false" />
```

### iOS Platform Configuration

Add to `Info.plist`:

- `NSMicrophoneUsageDescription` — voice input
- `NSSpeechRecognitionUsageDescription` — STT
- `NSFaceIDUsageDescription` — biometric unlock (optional)
- `UIBackgroundModes` → include `fetch` and `processing`

`flutter_local_notifications` setup in `AppDelegate.swift` per package docs.

---

## Core Architectural Decisions

### 1. Language & Runtime

**Decision:** Dart 3.x with null safety, Flutter 3.x stable channel.

**Pattern:** Sealed classes for state, records for value bundles, pattern matching for state destructuring. No conflict, no mapping layer.

---

### 2. Riverpod Provider Naming → Suffix Convention

**Decision:** Suffix encodes what the provider returns.

**Pattern:**

```dart
// Repositories — read-only data access
final agendaRepositoryProvider           // returns AgendaRepository
final practiceRepositoryProvider         // returns PracticeRepository

// Notifiers — read + write
final agendaNotifierProvider             // returns AgendaNotifier
final eveningSessionNotifierProvider     // returns EveningSessionNotifier

// Services — stateless, single responsibility
final aiProviderServiceProvider          // returns AiProvider (the abstraction)
final connectivityServiceProvider        // returns ConnectivityService
final voiceServiceProvider               // returns VoiceService

// Computed values — derived state, no actions
final todayAgendaProvider                // returns List<AgendaEvent>
final idleSkillsProvider                 // returns List<Skill>
final nextSuggestionProvider             // returns Suggestion?
final activeThemeProvider                // returns OdoTheme
```

**Rule:** `RepositoryProvider` = read. `NotifierProvider` = read + write. `ServiceProvider` = methods to call. Computed providers carry descriptive names with no suffix.

---

### 3. Error Handling → Three Patterns by Context

**Decision:** `AsyncValue<T>` at UI boundary, `Result<T, AppError>` internally, plain `try/catch` only for third-party calls.

**At the widget:**

```dart
ref.watch(todayAgendaProvider).when(
  data: (events) => AgendaTimeline(events: events),
  loading: () => const AgendaShimmer(),
  error: (e, _) => const AgendaErrorState(),
);
```

**Inside services:**

```dart
sealed class Result<T> {
  const Result();
}
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}
class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}

enum AppError {
  aiUnavailable,
  databaseWriteFailed,
  suggestionSuppressed,
  contextPayloadTooLarge,
  voiceCaptureFailed,
  voiceParseAmbiguous,
  slotNoLongerAvailable,
  authFailed,
}
```

**Rule of Thumb:** `Result` inside services and repositories, `AsyncValue` at the provider boundary, `try/catch` only around external library calls.

---

### 4. File Organization → Strict Separation with Provider Convention

**Decision:** `data/domain/presentation/` structure with enforced imports and a single `_providers.dart` per feature.

**Pattern:**

```
features/agenda/
├── data/
│   ├── agenda_repository.dart           # implements domain interface
│   └── agenda_dao.dart                  # Drift DAO, only file that touches DB
├── domain/
│   ├── agenda_event.dart                # entity (plain Dart, no Flutter imports)
│   ├── agenda_repository.dart           # abstract interface
│   └── agenda_notifier.dart             # StateNotifier, business logic
└── presentation/
    ├── agenda_slide.dart
    ├── widgets/
    │   ├── agenda_strip.dart
    │   ├── event_card.dart
    │   ├── monthly_calendar.dart
    │   └── add_event_sheet.dart
    └── agenda_providers.dart            # all Riverpod providers for this feature
```

**Hard import rules:**
- `domain/` imports nothing from `data/` or `presentation/`
- `data/` imports only `domain/` interfaces
- `presentation/` imports only `domain/` entities and providers

**Provider Convention:** Every feature has one `_providers.dart` in `presentation/`. All Riverpod definitions live there. When you need to find a provider, you know exactly where to look.

---

### 5. Test Organization → Separate Tree Mirroring `lib/`

**Decision:** Separate `test/` tree, not co-located.

```
test/
├── features/
│   ├── agenda/
│   │   ├── data/
│   │   │   └── agenda_repository_test.dart
│   │   └── domain/
│   │       └── agenda_notifier_test.dart
│   ├── practice/
│   │   └── domain/
│   │       ├── streak_calculator_test.dart
│   │       └── pattern_detector_test.dart
│   ├── ai/
│   │   └── domain/
│   │       └── context_builder_test.dart
│   └── evening_session/
│       └── domain/
│           └── highlight_ranker_test.dart
└── core/
    └── services/
        └── connectivity_service_test.dart
```

**Priority targets for unit tests** (pure logic, fast to write, most likely place for bugs):
1. `SuggestionEngine` — ranking algorithm, suppression logic
2. `StreakCalculator` — date math edge cases
3. `PatternDetector` — 90-minute window-of-day, ≥2-week span
4. `ContextBuilder` — 4k char cap, truncation priority order
5. `HighlightRanker` — evening session relevance ranking

---

### 6. AI Provider Abstraction → Single Constant Swap

**Decision:** Abstract `AiProvider` interface with concrete implementations. Active provider selected by one constant.

**Interface:**

```dart
abstract class AiProvider {
  String get name;
  Future<Result<AiResponse>> sendContext(AiContextPayload payload);
  Future<Result<Stream<String>>> streamResponse(AiContextPayload payload);
}

class ClaudeAiProvider implements AiProvider { ... }
class GeminiAiProvider implements AiProvider { ... }
class GroqAiProvider implements AiProvider { ... }
class OpenAiAiProvider implements AiProvider { ... }
class OfflineStubAiProvider implements AiProvider { ... }
```

**Selection:** A single constant in `core/constants/ai_config.dart`:

```dart
const kActiveAiProvider = AiProviderType.claude;
```

**Key delivery:** `--dart-define=AI_API_KEY=xxx` at build time. Never in source control. `.env.example` documents required keys. Real `.env` is git-ignored.

**Architectural rule:** Feature code imports the `AiProvider` interface from `domain/`, never a concrete implementation. The Riverpod `aiProviderServiceProvider` injects the active implementation. Swapping providers touches one file.

---

### 7. AI Context Payload → Hard Cap, Priority-Ordered

**Decision:** `ContextBuilder` produces a payload of strictly ≤4,000 characters, with truncation priority defined.

**Priority order (build until cap is reached):**

1. Current datetime + active screen (fixed cost, ~80 chars)
2. Today's agenda + next 48h (target: ~1,200 chars)
3. All skills with current streak only (target: ~600 chars, scales with skill count)
4. Last 7 days unanchored sessions (target: ~500 chars)
5. Last 3 suggestions with outcomes (target: ~400 chars)
6. Compact representation of trailing data if budget remains

**Hard cap enforced in `ContextBuilder.build()`** — returns `Failure(AppError.contextPayloadTooLarge)` only as a defensive check. The truncation logic should make this unreachable in normal use.

**Where AI context is built:** Only in `AiService`. Never in widgets. UI calls `aiService.send(intent)` and the service composes the payload.

---

### 8. Suggestion Engine → On-Device, Fully Offline

**Decision:** `SuggestionEngine` runs entirely on-device. No AI provider call. Pure Dart logic over local SQLite.

**Algorithm:**

1. Query all skills with `last_session_at` older than 24h, ordered by idleness DESC
2. Query agenda for next 48h, compute free slots (gaps ≥30 min)
3. Filter out skills where `suppressed_until > now()`
4. Match longest-idle skill to shortest fitting slot to earliest available window
5. First match wins; algorithm stops
6. Persist as a row in `suggestions` table

**Trigger points:**
- 8pm evening session preparation (one suggestion at most, surfaced inside session as the cross-domain insight if relevant)
- Throughout-day on meaningful data shift (event canceled, streak at risk, pattern threshold crossed)
- Fallback on app open if no recent suggestion delivered

**Non-negotiable:** **One AI voice per day.** If a throughout-day suggestion has fired, the evening session's cross-domain insight is suppressed or downgraded.

---

### 9. Theme System → Seven Presets + Custom Picker

**Decision:** `ThemeSystem` holds seven theme maps, each defining a complete set of semantic tokens. Custom picker overrides the accent token only.

**Two-layer token system:**

**Layer 1 — Raw palette** (never used directly in widgets):

```
violetPrimary    = #7C4DFF
cyanPrimary      = #00C2D4
greenPrimary     = #1D9E75
emberOrange      = #FF6B35
cosmicMagenta    = #C770FF
auroraTeal       = #2DD4BF
darkBg           = #0D0D0F
darkSurface      = #1A1A1F
lightBg          = #FDFBF7
lightSurface     = #FFFFFF
mutedTextDark    = #6B6B80
mutedTextLight   = #6B6B6B
primaryTextDark  = #E8E8F0
primaryTextLight = #1A1A1A
```

**Layer 2 — Semantic tokens** (used in all widgets):

```
colorAccent              // active theme accent
colorAccentAgenda        // Personal category
colorAccentWork          // Work category
colorAccentPractice      // Practice category
colorSurface
colorBackground
colorTextPrimary
colorTextMuted
colorBorder
colorOrbIdle
colorOrbActive
```

**Seven theme maps:**

| Theme | Mode | Accent |
|---|---|---|
| Violet Dark (default) | dark | violetPrimary |
| Cyan Dark | dark | cyanPrimary |
| Green Dark | dark | greenPrimary |
| Light Mode | light | violetPrimary |
| Cosmic | dark | cosmicMagenta |
| Ember | dark | emberOrange |
| Aurora | dark | auroraTeal |

**Custom picker:** overrides `colorAccent` only; all other semantic tokens inherit from the active mode (dark or light).

**Persistence:** Active theme name + custom accent hex (if any) stored in `SharedPreferences`.

---

### 10. Navigation → go_router with Bottom Sheets as Routes

**Decision:** `go_router` handles all navigation. Bottom sheets are routes, not imperative `showModalBottomSheet` calls.

**Top-level routes:**

```
/glance                              # ambient lock screen
/home                                # home with persistent strip + carousel
/home/agenda                         # full agenda slide
/home/agenda/event/:id               # event detail
/home/agenda/calendar                # monthly calendar
/home/practice                       # full practice slide
/home/practice/skill/:id             # skill detail
/evening                             # evening session screen
/settings                            # all settings
/settings/themes                     # theme picker
```

**Bottom sheets as routes:**

```
/home/agenda/add-event               # bottom sheet
/home/practice/add-skill             # bottom sheet
/home/practice/log-session/:id       # bottom sheet
/confirm-suggestion/:id              # bottom sheet
```

**Rationale:** Deep linking works. Back button behavior is consistent. State restoration is centralized. No imperative navigation scattered across widgets.

---

### 11. Background Tasks → Best-Effort with Fallback

**Decision:** `workmanager` schedules the 8pm trigger. `flutter_local_notifications` handles scheduled pre-event reminders. Fallback trigger runs on app open.

**Scheduled work:**

| Task | When | Mechanism |
|---|---|---|
| Evening session invitation | Daily 8pm local | workmanager periodic + flutter_local_notifications scheduled |
| 5-min pre-event reminder | 5 min before each event | flutter_local_notifications scheduled at event create/update |
| Throughout-day suggestion | On data shift (event canceled, streak risk) | Triggered synchronously when data changes; debounced |
| Fallback evening check | On app open | If now ≥ 8pm and no session in last 18h, surface inline |

**No long-running background AI calls.** The on-device `SuggestionEngine` runs in milliseconds. Any AI provider call is gated by user interaction in the foreground.

---

### 12. Voice → Tap-to-Speak in V1

**Decision:** V1 uses platform STT via `speech_to_text` package, triggered by mic tap. Ambient wake-word ("Hey OdO") deferred to V2.

**State machine:**

```
idle → (mic tap) → listening
listening → (silence timeout 1.5s) → parsing
listening → (mic tap again) → cancelled → idle
parsing → (intent clear) → committing → committed → idle
parsing → (intent ambiguous) → follow-up → listening
parsing → (STT failure) → idle (silent)
```

**Orb animation tightly coupled:**
- idle = breathing animation
- listening = waveform
- parsing = quick pulse
- committing = single bright pulse
- committed = brief checkmark overlay

**Voice output (TTS):**
- Phone V1: silent banners default, TTS toggleable in settings
- Watch (V2): voice on by default, TTS reads notifications aloud
- Never speaks first on a device the user isn't wearing or holding

---

### 13. Persistence Until Midnight (Evening Session)

**Decision:** Evening session state persists across app lifecycle until local midnight, then is finalized.

**Implementation:**
- Every tag/expand/dismiss writes to `evening_highlights` table immediately
- On app reopen between 8pm and midnight, if `evening_sessions` row exists with `session_date = today` and `completed_at IS NULL` and `abandoned_at IS NULL`, resume
- A background job (or app-open check) at local midnight marks any incomplete session as `abandoned_at = midnight_timestamp`
- Tomorrow's session creates a fresh row

---

## Confirmed Architectural Decisions (Non-Negotiable)

- **State Management:** Riverpod with code-gen — no alternatives
- **Database:** Drift (type-safe SQLite ORM) — no raw SQLite
- **Background Tasks:** workmanager with fallback on app open
- **Navigation:** go_router with bottom sheets as routes
- **Theme:** seven presets via two-layer token system; dark default; light optimized for outdoor Abidjan
- **Notifications:** flutter_local_notifications
- **AI Context:** all payload construction in `AiService`, never in widgets
- **AI Provider:** abstract interface, swappable via single constant
- **AI Keys:** `--dart-define` at build time, never in source control
- **Privacy:** local-first, no analytics, no telemetry, no third-party SDKs, no ad IDs
- **Locale:** XOF (no decimals), DD/MM/YYYY, UTC+0, French-primary UI

---

## Component Interaction Map

```
                    ┌─────────────────────────┐
                    │  GlanceModule (V1)      │
                    │  + Watch Surface (V2)   │
                    └────────────┬────────────┘
                                 │
                                 ▼
        ┌───────────────────────────────────────────────────┐
        │                    HomeScreen                      │
        │  ┌─────────────────────────────────────────────┐  │
        │  │       Persistent Agenda Strip               │  │
        │  ├─────────────────────────────────────────────┤  │
        │  │   AgendaModule  │   PracticeModule          │  │
        │  │   (slide)       │   (slide)                 │  │
        │  ├─────────────────────────────────────────────┤  │
        │  │       AI Component (persistent bar)          │  │
        │  └─────────────────────────────────────────────┘  │
        └────────────────────┬─────────────────────────────┘
                             │
                  ┌──────────┴──────────┐
                  ▼                     ▼
        ┌──────────────────┐   ┌─────────────────────┐
        │   AiService      │   │ SuggestionEngine    │
        │ (online, ext.)   │   │ (on-device, offline)│
        └────────┬─────────┘   └──────────┬──────────┘
                 │                        │
                 ▼                        ▼
        ┌─────────────────────────────────────────────┐
        │           PersistenceLayer (Drift)          │
        │   skills · sessions · events · suggestions  │
        │   evening_sessions · evening_highlights     │
        └─────────────────────────────────────────────┘
                             ▲
                             │
        ┌────────────────────┴────────────────────────┐
        │           EveningSession (8pm orchestrator)  │
        └─────────────────────────────────────────────┘

Supporting services injected everywhere:
  NotificationService · BackgroundTaskService
  ConnectivityService · VoiceService · LocaleService
  ThemeSystem (active theme via Riverpod)
```

---

## Data Flow: A Day in the Life

**Morning (8:42am):** Phone wakes → Glance Screen renders → orb breathing → tile shows next event (10:00 standup).

**Morning (9:55am):** `flutter_local_notifications` fires the 5-min pre-event reminder scheduled when the standup was created.

**Midday (12:30pm):** User says "Hey OdO" mic-tap → "rendez-vous client at 4pm jeudi" → `VoiceService` returns transcript → `AiService.parseCommand()` returns intent {create_event, title: "Rendez-vous client", start: Thursday 16:00, category: work} → `AgendaModule` commits → banner confirmation, optional note enrichment offered.

**Afternoon (3:00pm):** Wednesday 4pm standup is canceled. `AgendaNotifier` writes the delete → `SuggestionEngine` detects the new free slot → idle-skill ranking returns Japanese (5 days idle) → throughout-day notification: "45 minutes just opened up. Japanese is 5 days idle. Block it?"

**Evening (7:12pm):** User opens Practice → logs 25 min Japanese session → no calendar event → `sessions` row written with `is_anchored = 0`. Streak updated. Silent flag.

**Evening (8:00pm):** `workmanager` fires the evening session task → notification: "Your evening with OdO is ready."

**Evening (8:03pm):** User taps. `EveningSession.start()` creates `evening_sessions` row, runs the headline generator over today's data, queries `HighlightRanker` for top 3–4 items, prepends the cross-domain insight if `PatternDetector` returns a match. Session renders. User tags. Each tag writes immediately to `evening_highlights`.

**Evening (8:06pm):** Phone call interrupts. User returns at 9:14pm. App opens → `EveningSession.resume()` finds the in-progress row → renders from current step.

**Evening (9:18pm):** User taps "wrap up" → close summary written, `completed_at` set. Session closes.

**Midnight (00:00):** No background work fires. Tomorrow's session row will be created at 8pm tomorrow. If user had abandoned today's session mid-stream, an app-open check at any time after midnight marks `abandoned_at = midnight` for cleanup.

---

## Open Architectural Questions (V1 Pre-Build)

These need answers before Day 1 of Epic 1:

1. **Glance auth fallback:** if vocal password fails three times, does the typed password become required, or does the user remain on the Glance Screen indefinitely? **Recommendation:** three failures → typed password becomes the only path for the next 5 minutes.
2. **Custom theme picker — color space:** HSL, RGB hex, or palette swatches? **Recommendation:** swatches first (24 curated), full picker behind "advanced" toggle.
3. **Pattern detection sensitivity:** the spec says "3 sessions at similar times across ≥2 weeks". Is "similar times" ±45 min or ±60 min? **Recommendation:** ±45 min (tight enough to be meaningful, loose enough to catch real patterns).
4. **AI provider default for V1 launch:** Claude (highest quality, simplest billing) — confirm.
5. **Locale string source:** ARB files via `intl_utils` or simple Dart maps? **Recommendation:** simple Dart maps for V1, migrate to ARB in V1.5 when French AI responses ship.

---

**Document Status:** Locked for V1 MVP Implementation
**Last Updated:** May 13, 2026
**Owner:** Lokki (Solo Developer, Abidjan)
