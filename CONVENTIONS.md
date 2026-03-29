# TooXTips Development Conventions

**Reference card for consistent implementation across all development.**

When building at midnight six weeks from now and you can't remember where something goes, this file answers it.

---

## Database

**DATABASE:** snake_case columns, Drift generates camelCase Dart

All database columns use snake_case. Drift automatically handles translation to Dart via `@JsonKey` and column overrides. Write SQL like SQL, let Drift generate Dart like Dart.

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

Drift generates `SessionsCompanion` and `Session` data classes with camelCase Dart fields automatically.

---

## Riverpod Providers

**PROVIDERS:** `{feature}{Layer}Provider` — Repository/Notifier/Service suffix

The suffix encodes what the provider returns. This information matters when scanning a file.

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

**Rules:**
- `RepositoryProvider` = read-only data access
- `NotifierProvider` = read and write
- `ServiceProvider` = call methods on
- Computed providers have descriptive names with no suffix

Anyone reading the code knows the contract from the name alone.

---

## Error Handling

**ERROR HANDLING:** AsyncValue at UI boundary, Result<T> in services, try/catch for externals

Three different error handling patterns for different contexts:

### AsyncValue (UI State)

Use for widgets that need to show loading or error states. Riverpod provides it for free on any `asyncProvider`.

```dart
// In widget
ref.watch(todayAgendaProvider).when(
  data: (events) => AgendaTimeline(events: events),
  loading: () => const AgendaShimmer(),
  error: (e, _) => const AgendaErrorState(),
);
```

### Result Type (Service/Repository Internals)

Use for operations that can fail for known reasons where you want to handle the failure explicitly.

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

### Try/Catch (External Libraries)

Use only for unexpected exceptions from third-party library calls that can throw unpredictably. Never use as primary error handling pattern.

---

## File Organization

**FEATURES:** data/ domain/ presentation/ with _providers.dart in presentation/

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

### Hard Rules on Imports

- `domain/` files import nothing from `data/` or `presentation/`
- `data/` imports `domain/` interfaces only
- `presentation/` imports `domain/` entities and providers only

Violations get caught in code review.

### Provider Convention

Every feature has a single `_providers.dart` file in `presentation/`. All Riverpod provider definitions for that feature live there, nowhere else. When you need to find a provider, you know exactly where to look.

---

## Tests

**TESTS:** Separate test/ tree mirroring lib/ structure

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

Co-located tests create noise in the file tree. Separate tree is lower friction for solo development — `test/` is the one place you look for all tests.

**Priority:** `SuggestionEngine` and `StreakCalculator` get unit tests first — they're pure logic with no Flutter dependency, fast to write, and the most likely place for subtle bugs.

---

## AI & Context

**AI PAYLOAD:** Selective context, 4000 char cap, 48hr agenda window

- Agenda: today + next 48 hours (not a full week)
- Skills: all skills with name, streak, last_session_at (not full session history)
- Sessions: last 7 days, unanchored sessions only
- Suggestions: last 3 suggestions with accepted/dismissed status
- Meta: current_datetime, timezone (UTC+0), active_screen

Hard cap: if payload exceeds 4000 characters, truncate session history first, then extend agenda window.

---

## Imports & Dependencies

**IMPORTS:** domain → nothing, data → domain, presentation → domain only

Enforce strict dependency direction:
- `domain/` is independent — no imports from other layers
- `data/` depends on `domain/` only
- `presentation/` depends on `domain/` only

---

## Models & Providers

**MODELS:** claude-sonnet-4-6 default, AiProvider abstraction for swapping

- Default model: `claude-sonnet-4-6`
- Pinned version, revisit at v1.1
- AiProvider abstraction allows swapping providers without touching feature code
- Pre-built stubs: Claude, Gemini, Groq, OpenAI, Offline

---

## Configuration

**API KEYS:** --dart-define at build time, never in source

API keys are passed at build time via `--dart-define`:

```bash
flutter run --dart-define=CLAUDE_API_KEY=sk-...
```

Never hardcode API keys in source code.

---

## Theme

**THEME:** ThemeMode.dark hardcoded default, SharedPreferences toggle

- Dark mode is the default theme
- User can toggle to light mode via settings
- Toggle state persisted in SharedPreferences
- Both themes render correctly across all screens

---

## Summary

| Area | Convention |
|------|-----------|
| Database | snake_case columns, Drift generates camelCase |
| Providers | `{feature}{Layer}Provider` with suffix |
| Errors | AsyncValue (UI), Result<T> (services), try/catch (external) |
| Features | data/ domain/ presentation/ + _providers.dart |
| Tests | Separate test/ tree mirroring lib/ |
| AI | Selective context, 4000 char cap |
| Imports | domain → nothing, data → domain, presentation → domain |
| Models | claude-sonnet-4-6, AiProvider abstraction |
| API Keys | --dart-define at build time |
| Theme | Dark mode default, SharedPreferences toggle |

---

**Last Updated:** March 29, 2026  
**Status:** Complete — Ready for Implementation
