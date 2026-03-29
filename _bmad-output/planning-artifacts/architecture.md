---
stepsCompleted: ["step-01-init", "step-02-context", "step-03-starter", "step-04-decisions", "step-05-patterns"]
inputDocuments: ["prd.md", "project-brief.md", "TooXTips_MVP_Spec_v2.0_REVISED.md", "ux-design-specification.md"]
workflowType: 'architecture'
project_name: 'TooXTips'
user_name: 'Lokki'
date: '2026-03-29'
status: 'Architecture Complete - Ready for Implementation'
---

# Architecture Decision Document — TooXTips

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

**Project:** TooXTips — Personal AI Productivity Hub  
**Author:** Lokki  
**Date:** March 29, 2026  
**Status:** Architecture Discovery in Progress

---

## Input Documents Loaded

✅ **PRD** (`prd.md`) — Complete product requirements with MVP scope, user journeys, success criteria, and technical architecture overview  
✅ **Project Brief** (`project-brief.md`) — Executive summary, problem statement, core value proposition, and implementation roadmap  
✅ **MVP Spec v2.0 Revised** (`TooXTips_MVP_Spec_v2.0_REVISED.md`) — Detailed UX architecture, feature specifications, design system, and technical stack  
✅ **UX Design Specification** (`ux-design-specification.md`) — Visual design patterns and component specifications

---

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
- Agenda Module: calendar view (day/week), event CRUD, persistent strip showing next 2-3 events
- Practice Module: skill cards, session logging, streak tracking, unanchored session flagging
- AI Component: chat interface, quick-command dropdown, cross-module context aggregation, proactive notifications (8pm daily)
- Offline-First Architecture: all data stored locally (SQLite), app functions completely without connectivity
- Dark/Light Mode: both themes fully supported with OLED optimization

**Non-Functional Requirements:**
- Performance: sub-500ms perceived latency via optimistic UI and local-first rendering
- Reliability: 99%+ crash-free sessions, no data loss on restart
- Offline Capability: 100% core feature functionality without connectivity
- Accessibility: WCAG AA compliance, 44dp minimum touch targets
- Locale Awareness: XOF currency, DD/MM/YYYY dates, French support planned (v1.1)

**Scale & Complexity:**
- Primary Domain: Mobile-first Flutter application with local-first architecture
- Complexity Level: Medium-High (cross-module AI reasoning, offline-first design, background task scheduling)
- Estimated Architectural Components: 6 true architectural components with 4 supporting services

### Technical Constraints & Dependencies

- Solo Development: one person, full responsibility — feature scope must be ruthlessly prioritized
- Flutter Framework: cross-platform requirement (iOS/Android from single codebase)
- Local-First Data: all user data stays on-device; only AI context payload transmitted to Claude API
- Claude API Integration: context-aware reasoning with token limit constraints
- Background Task Scheduling: 8pm proactive check-in via workmanager with platform-specific reliability constraints
- Intermittent Connectivity: users in Abidjan may have inconsistent connectivity — graceful degradation essential

### Cross-Cutting Concerns Identified

1. **AI Context Aggregation** — spans Agenda + Practice modules; requires real-time state synchronization
2. **Offline-First Design** — affects all modules; requires local-first rendering and graceful AI degradation
3. **Background Task Scheduling** — proactive notifications require reliable scheduling with fallback triggers
4. **Data Persistence** — SQLite schema must support efficient querying for free-slot detection and idle-skill matching
5. **Temporal Reasoning** — all AI interactions require accurate datetime context and timezone handling (UTC+0)

---

## Architectural Component Model

### Core Architectural Components (Own Data & State)

1. **AgendaModule** — events, calendar state, strip data
2. **PracticeModule** — skills, sessions, streak computation
3. **AiService** — Claude API client, context builder, response parser
4. **SuggestionEngine** — on-device proactive logic, slot detection, idle ranking
5. **PersistenceLayer** — SQLite via Drift, all DB access centralized
6. **ThemeSystem** — tokens, both themes, locale formatting

### Supporting Services (Stateless, Injected as Dependencies)

1. **NotificationService** — local notification scheduling and delivery
2. **BackgroundTaskService** — workmanager scheduling, 8pm trigger
3. **ConnectivityService** — online/offline state, AI availability flag
4. **LocaleService** — XOF formatting, DD/MM/YYYY, timezone (UTC+0)

**Architectural Principle:** Components own Riverpod providers and DB access. Supporting services are plain Dart classes. This distinction prevents maintenance debt in folder structure and dependency injection.

---

## Critical Technical Risks & Mitigations

### Background Task Reliability (Platform-Specific)

**Risk:** `workmanager` on Android is subject to battery optimization killing background tasks. On iOS, background fetch is throttled by OS based on usage patterns. Neither platform guarantees 8pm task execution.

**Mitigation Strategy:**
- Product decision: 8pm notification is best-effort, not guaranteed
- UI never implies notification will definitely arrive
- Fallback trigger: when user opens app in morning, if no suggestion delivered in last 18 hours, run suggestion engine synchronously and surface result as inline AI component message
- This covers background task failure without user awareness

### Suggestion Staleness (Time-Sensitive Slots)

**Risk:** Background task may arrive at 9:47pm instead of 8:00pm; calendar slot may have changed by then.

**Mitigation:** Add staleness check when user confirms suggestion — verify slot still exists before creating event. Slot validity window: 30 minutes from suggestion time.

---

## SQLite Schema Decisions (Foundation for All Features)

### `suggestions` Table

```sql
id, skill_id, slot_start, slot_duration,
suggested_at, accepted_at, dismissed_at, thumbs_down_at,
suppressed_until
```

**Critical Column:** `suppressed_until` — computed when dismissed or thumbed-down (current timestamp + 7 days). SuggestionEngine filters out any skill where `suppressed_until > now()`. This is the entire learning algorithm in one column.

### `sessions` Table

```sql
id, skill_id, started_at, duration_minutes,
notes, is_anchored, suggested_time
```

**Critical Columns:**
- `is_anchored = false` when session logged without corresponding agenda event
- `suggested_time` populated when session was logged from a suggestion
- Pattern detection query: `SELECT suggested_time FROM sessions WHERE skill_id = ? AND is_anchored = 0 ORDER BY started_at DESC LIMIT 2`
- If both timestamps within 90 minutes of each other, AI asks once about anchoring

**Architectural Principle:** Get these two tables right before writing any feature code. Everything else queries them.

---

## Confirmed Architectural Decisions (Non-Negotiable)

- **State Management:** Riverpod — no alternatives
- **Database:** Drift (type-safe SQLite ORM) — no raw SQLite
- **Background Tasks:** workmanager with fallback trigger on app open
- **Navigation:** go_router for navigation (bottom sheets as routes, not imperative pushes)
- **Theme Default:** ThemeMode.dark hardcoded, user toggle persisted via SharedPreferences
- **Notifications:** flutter_local_notifications for delivery
- **Colour System:** Two-layer system (raw palette → semantic tokens)
- **AI Context:** All context payload construction in AiService, never in UI widgets

---

---

## Starter Template Evaluation

### Primary Technology Domain

Mobile Application (Flutter) — cross-platform requirement with offline-first architecture, local SQLite persistence, and Riverpod state management.

### Starter Options Considered

1. **Flutter Official `flutter create` Command** — Basic starter, minimal setup, requires manual architecture scaffolding
2. **Very Good CLI (Very Good Core Template)** — Production-ready but optimized for web/API, not offline-first mobile with AI reasoning
3. **Custom Architecture Starter (Recommended)** — Leverage confirmed architectural decisions with Flutter official template as foundation

### Selected Starter: Custom Architecture Scaffold

**Rationale for Selection:**
Architectural decisions are already locked in (Riverpod, Drift, go_router, workmanager). A generic starter would impose patterns conflicting with offline-first + AI context aggregation design. Custom scaffold is more efficient for this specific architecture.

**Initialization Command:**

```bash
flutter create --org com.tooxips tooxips
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
  go_router: ^13.2.0

  # Local persistence
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.22
  path_provider: ^2.1.3
  path: ^1.9.0

  # Notifications + background
  flutter_local_notifications: ^17.1.2
  workmanager: ^0.5.2

  # AI + connectivity
  http: ^1.2.1
  connectivity_plus: ^6.0.3

  # Calendar + locale
  table_calendar: ^3.1.2
  intl: ^0.19.0

  # Shared preferences (theme toggle)
  shared_preferences: ^2.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  drift_dev: ^2.18.0
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.9
  flutter_lints: ^4.0.0
```

**Critical Dependencies:**
- `connectivity_plus` required for ConnectivityService (offline state detection)
- `riverpod_annotation` + `riverpod_generator` required for code-gen Riverpod (`@riverpod` syntax) — strongly preferred for solo maintainability

### Project Structure (Corrected)

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── theme.dart
├── features/
│   ├── agenda/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── practice/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── ai/
│       ├── data/           # Claude API client
│       ├── domain/         # context builder, suggestion engine
│       └── presentation/   # AI component widget, chat sheet
├── core/                   # foundational, not feature-specific
│   ├── database/
│   │   ├── app_database.dart
│   │   └── app_database.g.dart
│   ├── services/
│   │   ├── connectivity_service.dart
│   │   ├── notification_service.dart
│   │   ├── background_task_service.dart
│   │   └── locale_service.dart
│   ├── widgets/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   └── app_typography.dart
│   └── utils/
│       ├── date_utils.dart
│       └── currency_utils.dart
```

**Architectural Principle:** `core/` (not `shared/`) signals foundational, not feature-specific. This convention matters for codebase navigation as it grows.

### Critical `main.dart` Setup

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Background task registration must happen before runApp
  await BackgroundTaskService.initialize();

  // Notification service initialization
  await NotificationService.initialize();

  runApp(
    const ProviderScope(
      child: TooXTipsApp(),
    ),
  );
}
```

**Critical Sequencing:**
- `WidgetsFlutterBinding.ensureInitialized()` must be first — workmanager and flutter_local_notifications fail silently without it
- `BackgroundTaskService.initialize()` before `runApp` — workmanager requires this sequencing or dispatcher isn't registered
- `ProviderScope` wraps entire app — all code needs Riverpod provider access

### Foundation Files (Write in This Order)

1. **`core/constants/app_colors.dart`** — raw palette + semantic tokens. Nothing renders without this.
2. **`app/theme.dart`** — ThemeData for dark/light modes, semantic tokens only. Include `FontFeature.tabularFigures()` for clock display.
3. **`core/database/app_database.dart`** — Drift schema with `suggestions` and `sessions` tables. Run `dart run build_runner build` immediately after.

Do not write any feature widgets until these three files compile cleanly.

### Android Platform Configuration

Add to `AndroidManifest.xml` for workmanager + notifications:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

Inside `<application>`:
```xml
<receiver
    android:name="androidx.work.impl.background.systemalarm.RescheduleReceiver"
    android:exported="false" />
```

**iOS:** flutter_local_notifications requires setup in `AppDelegate.swift` — package documentation covers this.

### Architectural Decisions Provided by This Approach

**Language & Runtime:** Dart 3.x with null safety, Flutter 3.x stable channel

**Styling Solution:** Flutter Material Design 3, custom ThemeData with two-layer colour system, dark mode default with light mode toggle via SharedPreferences

**Build Tooling:** Flutter build system (Gradle/Xcode), code generation via Drift and Riverpod, no additional build tools

**Testing Framework:** Flutter test framework (built-in), Riverpod testing utilities, unit tests for services, widget tests for UI

**Code Organization:** Feature-based structure (agenda, practice, ai), clear data → domain → presentation separation, supporting services as plain Dart classes, Riverpod providers as glue layer

**Development Experience:** Hot reload for rapid iteration, Dart DevTools for debugging, type-safe database access via Drift, reactive state management via Riverpod

---

## Core Architectural Decisions

### 1. AI Context Payload Strategy → Selective Context

**Decision:** Selective context with defined boundaries, not full context or tiered approach.

**Rationale:** Full context becomes a trap at month three when session history grows and API calls timeout. Tiered context is architecturally correct long-term but doubles implementation surface for solo MVP.

**Context Payload Composition:**

```dart
// What always goes in the payload
- Agenda: today + next 48 hours (tomorrow is actionable, day-after-tomorrow is noise)
- Skills: all skills with name, streak, last_session_at (not full session history)
- Sessions: last 7 days, unanchored sessions only (anchored sessions are resolved, irrelevant)
- Suggestions: last 3 suggestions with accepted/dismissed status (behavioural context)
- Meta: current_datetime, timezone (UTC+0), active_screen
```

**Key Constraint:** 48-hour agenda window is deliberate tightening from week view. Week of events = 7x tokens for marginal reasoning improvement. AI suggesting something for next Thursday from today's context is lower-value than it sounds.

**Hard Cap:** `contextMaxChars = 4000` — if selective context payload exceeds 4000 characters, `AiService` truncates session history first, then extends agenda window, and logs warning locally. AI never receives malformed or oversized request.

---

### 2. Suggestion Suppression Algorithm → Adaptive Suppression

**Decision:** Three-tier suppression based on user feedback type, not flat 7-day suppression.

**Rationale:** Dismissal ("not now") and thumbs-down ("wrong skill") are different signals requiring different windows. Accepted suggestions need suppression to prevent redundancy.

**Suppression Windows:**

```dart
const suppressionDismissed   = Duration(days: 3);  // "not now" — try again in 3 days
const suppressionThumbsDown  = Duration(days: 7);  // "wrong skill" — avoid for a week
const suppressionAccepted    = Duration(days: 1);  // just scheduled — don't suggest again tomorrow
```

**Implementation:** `SuggestionEngine` filters out any skill where `suppressed_until > now()`. This is the entire learning algorithm in one column.

**Critical Addition to Schema:** `suppressed_until` column in `suggestions` table must be computed when dismissed or thumbed-down. Accepted suppression prevents AI redundancy immediately after being helpful.

---

### 3. Offline Fallback Behavior → Inline Message + Single Pulse

**Decision:** When background task fails and no suggestion delivered in 18 hours, surface suggestion as inline message with single pulse animation on app open.

**Rationale:**
- Silent wait (Option C) wastes a day of value; user never knows
- Toast/snackbar (Option B) introduces inconsistent UI pattern
- Inline message (Option A) is consistent but needs visibility signal

**Implementation Detail:** When fallback trigger fires on app open:
- AI component's pulse dot animates once — single slow pulse, never continuous
- No badge count, no persistent indicator, no second pulse
- If user taps AI bar, suggestion appears as first message in chat thread
- If user doesn't tap, suggestion stays queued for next 8pm check

**Principle:** Signal presence without forcing interaction. One pulse, once, on app open.

---

### 4. Unanchored Session Pattern Detection → Three Sessions, Two Weeks

**Decision:** Suggest anchoring after detecting 3 unanchored sessions at similar times across 2+ different calendar weeks.

**Rationale:** Two sessions is a Tuesday-Thursday coincidence. Three sessions is a pattern. Confidence gain from three over two is worth one-session delay — false positive here makes AI look dumb.

**Pattern Detection Algorithm:**

```dart
bool isPattern(List<DateTime> sessionTimes) {
  if (sessionTimes.length < 3) return false;
  final times = sessionTimes.map((t) => t.hour * 60 + t.minute).toList();
  final spread = times.reduce(max) - times.reduce(min);
  final weeks = sessionTimes.map((t) => weekNumber(t)).toSet();
  return spread <= 90 && weeks.length >= 2;
}
```

**Constraints:**
- 90-minute similarity window (time-of-day tolerance)
- Must span 2+ different calendar weeks (prevents one productive week from triggering)
- 20 lines of Dart, no ML required

---

### 5. Claude Model Version → Pinned to `claude-sonnet-4-6`

**Decision:** Lock to specific model version, not "latest available". Revisit at v1.1.

**Rationale:** "Latest available" is a debugging nightmare when model behaviour changes between sessions. Pin the version, update intentionally when you have usage data to evaluate upgrade value.

**Constants:**

```dart
// core/constants/ai_constants.dart
const claudeModel      = 'claude-sonnet-4-6';
const maxTokens        = 1024;    // sufficient for structured responses
const contextMaxChars  = 4000;    // self-imposed payload limit before truncation
```

**Cost Justification:** Right balance of capability and cost for personal-use app where every interaction comes from your own API key.

---

## AI Provider Abstraction (Swappable Without Feature Code Changes)

**Core Interface:**

```dart
// core/services/ai_provider.dart
abstract class AiProvider {
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1024,
  });
}
```

**Principle:** `AiService` depends only on `AiProvider`, never on concrete implementation. Switching providers is one line in Riverpod provider registration.

**Pre-Built Provider Stubs:**

```dart
// Anthropic Claude — current default
class ClaudeProvider implements AiProvider { ... }

// Google Gemini — free tier is genuinely useful for MVP testing
class GeminiProvider implements AiProvider { ... }

// Groq — fastest inference available, Llama 3 models, very cheap
class GroqProvider implements AiProvider { ... }

// OpenAI — fallback everyone knows
class OpenAiProvider implements AiProvider { ... }

// Local/offline stub — returns null-safe empty responses, never throws
class OfflineProvider implements AiProvider {
  @override
  Future<String> complete({required String systemPrompt,
      required String userMessage, int maxTokens = 1024}) async {
    return '';
  }
}
```

**Critical:** `OfflineProvider` is what `ConnectivityService` swaps in when offline. No try/catch scattered across codebase, no null checks. Offline state is just a different provider.

**Configuration:**

```dart
// core/constants/ai_constants.dart
enum AiProviderType { claude, gemini, groq, openai, offline }

class AiConfig {
  final AiProviderType provider;
  final String apiKey;
  final String model;
  final int maxTokens;
  final int contextMaxChars;

  const AiConfig({
    required this.provider,
    required this.apiKey,
    required this.model,
    this.maxTokens = 1024,
    this.contextMaxChars = 4000,
  });
}

// Presets — swap by changing activeConfig
const claudeConfig = AiConfig(
  provider: AiProviderType.claude,
  apiKey: String.fromEnvironment('CLAUDE_API_KEY'),
  model: 'claude-sonnet-4-6',
);

const geminiConfig = AiConfig(
  provider: AiProviderType.gemini,
  apiKey: String.fromEnvironment('GEMINI_API_KEY'),
  model: 'gemini-1.5-flash',   // free tier, generous limits
);

const groqConfig = AiConfig(
  provider: AiProviderType.groq,
  apiKey: String.fromEnvironment('GROQ_API_KEY'),
  model: 'llama-3.1-8b-instant', // fastest, cheapest
);
```

**API Key Security:** Via `String.fromEnvironment` — keys never touch source code, passed at build time via `--dart-define=CLAUDE_API_KEY=sk-...`

**Riverpod Provider Wiring:**

```dart
// core/providers/ai_provider_provider.dart
@riverpod
AiProvider aiProvider(AiProviderRef ref) {
  final isOnline = ref.watch(connectivityProvider);
  if (!isOnline) return OfflineProvider();

  // Change this one line to switch providers
  const config = geminiConfig; // ← swap here during testing

  return switch (config.provider) {
    AiProviderType.claude  => ClaudeProvider(config),
    AiProviderType.gemini  => GeminiProvider(config),
    AiProviderType.groq    => GroqProvider(config),
    AiProviderType.openai  => OpenAiProvider(config),
    AiProviderType.offline => OfflineProvider(),
  };
}
```

---

## AI Provider Cost Analysis & MVP Recommendation

**Cost per ~1K Tokens (Current Pricing):**

| Provider | Model | Cost | Notes |
|----------|-------|------|-------|
| Claude | Sonnet 4.6 | ~$0.003 | Best reasoning, most expensive |
| Gemini | 1.5 Flash | Free tier | 1M tokens/day free, sufficient |
| Groq | Llama 3.1 8B | ~$0.00005 | Fastest, near-free, weaker reasoning |
| OpenAI | GPT-4o mini | ~$0.00015 | Good balance |

**MVP Recommendation:** Start with Gemini 1.5 Flash on free tier. Reasoning quality is sufficient for structured context payloads — you're reading JSON-like context and returning suggestions, not writing poetry. When sharing with beta testers and volume increases, evaluate staying on Gemini or moving to Groq for cost, Claude for quality.

**Abstraction Benefit:** One afternoon to build correctly, saves you from ever being locked in to a single provider.

---

## Decision Summary

| Decision | Choice | Key Constraint |
|----------|--------|----------------|
| Context payload | Selective (48hr agenda, 7-day unanchored sessions) | `contextMaxChars = 4000` hard cap |
| Suppression | Adaptive (dismissed: 3d, thumbs-down: 7d, accepted: 1d) | Accepted suppression is new — add to schema |
| Offline fallback | Inline message + single pulse animation | One pulse only, never persistent |
| Pattern threshold | 3 sessions, 90-min window, 2+ different weeks | Week-spread condition prevents false positives |
| Claude model | `claude-sonnet-4-6`, pinned | Single constant in `ai_constants.dart` |
| AI provider | Swappable abstraction with 5 implementations | Offline state is just a different provider |

---

---

## Implementation Patterns & Consistency Rules

### 1. Database Naming Convention → snake_case

**Decision:** Write SQL like SQL, let Drift generate Dart like Dart.

**Pattern:** All database columns use snake_case. Drift handles translation to Dart automatically via `@JsonKey` and column overrides.

**Example:**

```dart
// In Drift table definition — snake_case
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get skillId => integer().references(Skills, #id)();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationMinutes => integer()();
  BoolColumn get isAnchored => boolean().withDefault(const Constant(false))();
  DateTimeColumn get suggestedTime => dateTime().nullable()();
}
```

Drift generates `SessionsCompanion` and `Session` data classes with camelCase Dart fields automatically. No conflict, no mapping layer needed.

---

### 2. Riverpod Provider Naming → Descriptive Pattern with Suffix Convention

**Decision:** Suffix encodes what the provider returns — this information matters when scanning a file.

**Pattern:**

```dart
// Repositories — expose data access
final agendaRepositoryProvider       // returns AgendaRepository
final practiceRepositoryProvider     // returns PracticeRepository

// Notifiers — expose mutable state + actions
final agendaNotifierProvider         // returns AgendaNotifier (StateNotifier)
final practiceNotifierProvider       // returns PracticeNotifier

// Services — stateless, single responsibility
final aiProviderServiceProvider      // returns AiProvider (the abstraction)
final connectivityServiceProvider    // returns ConnectivityService

// Computed values — derived state, no actions
final todayAgendaProvider            // returns List<AgendaEvent>
final idleSkillsProvider             // returns List<Skill>
final nextSuggestionProvider         // returns Suggestion?
```

**Rule:** `RepositoryProvider` = read-only data access. `NotifierProvider` = read and write. `ServiceProvider` = call methods on. Computed providers have descriptive names with no suffix. Anyone reading the code knows the contract from the name alone.

---

### 3. Error Handling → AsyncValue at Boundaries, Result Type Internally

**Decision:** Use three different error handling patterns for different contexts.

**Pattern:**

`AsyncValue<T>` for UI state — loading, data, error. Riverpod provides it for free on any `asyncProvider`:

```dart
// In widget
ref.watch(todayAgendaProvider).when(
  data: (events) => AgendaTimeline(events: events),
  loading: () => const AgendaShimmer(),
  error: (e, _) => const AgendaErrorState(),
);
```

`Result<T, AppError>` for service and repository internals — operations that can fail for known reasons:

```dart
// Sealed Result type — define once in core/
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

// AppError — known failure cases
enum AppError {
  aiUnavailable,
  databaseWriteFailed,
  suggestionSuppressed,
  contextPayloadTooLarge,
}
```

Plain `try/catch` for unexpected exceptions only — wrap third-party library calls that can throw unpredictably.

**Rule of Thumb:** `Result` inside services and repositories, `AsyncValue` at the provider boundary, `try/catch` only around external library calls.

---

### 4. File Organization → Strict Separation with Provider Convention

**Decision:** `data/domain/presentation/` structure with enforced internal organization and single `_providers.dart` file per feature.

**Pattern:**

```
features/agenda/
├── data/
│   ├── agenda_repository.dart       # implements domain interface
│   └── agenda_dao.dart              # Drift DAO, only file that touches DB
├── domain/
│   ├── agenda_event.dart            # entity (plain Dart class, no Flutter imports)
│   ├── agenda_repository.dart       # abstract interface
│   └── agenda_notifier.dart         # StateNotifier, business logic lives here
└── presentation/
    ├── agenda_slide.dart            # top-level screen widget
    ├── widgets/
    │   ├── agenda_strip.dart
    │   ├── event_card.dart
    │   └── add_event_sheet.dart
    └── agenda_providers.dart        # all Riverpod providers for this feature
```

**Hard Rules on Imports:**
- `domain/` files import nothing from `data/` or `presentation/`
- `data/` imports `domain/` interfaces only
- `presentation/` imports `domain/` entities and providers only

**Provider Convention:** Every feature has a single `_providers.dart` file in `presentation/`. All Riverpod provider definitions for that feature live there, nowhere else. When you need to find a provider, you know exactly where to look.

---

### 5. Test Organization → Separate Tree Mirroring lib/

**Decision:** Separate `test/` tree mirroring `lib/` structure, not co-located tests.

**Pattern:**

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
│   │       └── suggestion_engine_test.dart
│   └── ai/
│       └── domain/
│           └── context_builder_test.dart
└── core/
    └── services/
        └── connectivity_service_test.dart
```

**Rationale:** Co-located tests create noise in the file tree. Separate tree is lower friction for solo development — `test/` is the one place you look for all tests.

**Priority:** `SuggestionEngine` and `StreakCalculator` get unit tests first — they're pure logic with no Flutter dependency, fast to write, and the most likely place for subtle bugs.

---

## Conventions Reference Card

**Pin this as `CONVENTIONS.md` in project root:**

```
DATABASE         snake_case columns, Drift generates camelCase Dart
PROVIDERS        {feature}{Layer}Provider — Repository/Notifier/Service suffix
ERROR HANDLING   AsyncValue at UI boundary, Result<T> in services, try/catch for externals
FEATURES         data/ domain/ presentation/ with _providers.dart in presentation/
TESTS            Separate test/ tree mirroring lib/ structure
AI PAYLOAD       Selective context, 4000 char cap, 48hr agenda window
IMPORTS          domain → nothing, data → domain, presentation → domain only
MODELS           claude-sonnet-4-6 default, AiProvider abstraction for swapping
API KEYS         --dart-define at build time, never in source
THEME            ThemeMode.dark hardcoded default, SharedPreferences toggle
```

---

## Next Steps

Ready to generate actual implementation files and project structure.

