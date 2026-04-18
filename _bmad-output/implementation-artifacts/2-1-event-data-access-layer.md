---
stepsCompleted: []
inputDocuments:
  - epics.md
  - architecture.md
  - prd.md
projectName: TooXTips
userName: Lokki
date: 2026-03-30
status: ready-for-dev
storyId: "2.1"
storyKey: "2-1-event-data-access-layer"
---

# Story 2.1: Event Data Access Layer

## Story Statement

As a developer,
I want to create AgendaRepository and AgendaDAO for type-safe event access,
So that all event queries are centralized and testable.

## Acceptance Criteria

**Given** the Drift database from Epic 1
**When** I create `features/agenda/data/agenda_dao.dart` with Drift queries
**Then** queries exist for: getAllEvents(), getEventsForDate(), getEventsForWeek(), getNextEvents(count)
**And** I create `features/agenda/data/agenda_repository.dart` implementing domain interface
**And** repository methods: createEvent(), updateEvent(), deleteEvent(), getUpcomingEvents()
**And** all queries return Future<List<AgendaEvent>> or Future<AgendaEvent>
**And** repository is injected via Riverpod provider

## Technical Context

### Architecture Compliance

**Database Foundation:**
- Uses Drift ORM (type-safe SQLite) from Epic 1 (`core/database/app_database.dart`)
- Events table already defined in Drift schema with columns: id, title, startTime, endTime, category
- All database access must be centralized in repository layer
- No direct database queries in UI widgets

**Folder Structure:**
```
features/agenda/
├── data/
│   ├── agenda_dao.dart          # Drift queries (new)
│   └── agenda_repository.dart   # Repository interface implementation (new)
├── domain/
│   └── models/
│       └── agenda_event.dart    # Domain model (may already exist)
└── presentation/
```

**Riverpod Integration:**
- Create `features/agenda/presentation/_providers.dart` with:
  - `agendaRepositoryProvider` — returns AgendaRepository singleton
  - All repository methods exposed via providers for UI consumption

### Key Implementation Details

**AgendaDAO (Drift Queries):**
- Extend `AppDatabase` with Drift query methods
- Methods must return `Future<List<AgendaEvent>>` or `Future<AgendaEvent>`
- Use Drift's `@Query` annotation for custom queries
- Handle timezone correctly (all times stored as UTC, displayed in UTC+0)

**AgendaRepository:**
- Implement domain interface (create if doesn't exist: `features/agenda/domain/repositories/agenda_repository.dart`)
- Wrap DAO queries with error handling
- Use Result<T> pattern for error handling (from architecture)
- Methods:
  - `Future<List<AgendaEvent>> getAllEvents()` — all events, ordered by startTime
  - `Future<List<AgendaEvent>> getEventsForDate(DateTime date)` — events on specific date
  - `Future<List<AgendaEvent>> getEventsForWeek(DateTime weekStart)` — 7-day window
  - `Future<List<AgendaEvent>> getNextEvents(int count)` — next N upcoming events
  - `Future<AgendaEvent> createEvent(AgendaEvent event)` — insert and return
  - `Future<AgendaEvent> updateEvent(AgendaEvent event)` — update and return
  - `Future<void> deleteEvent(String eventId)` — delete by id
  - `Future<List<AgendaEvent>> getUpcomingEvents()` — next 2-3 events for strip

**Error Handling:**
- Catch database exceptions and convert to domain errors
- Never throw raw SQLite exceptions to UI
- Log errors locally for debugging

### Dependencies & Imports

**From Epic 1 (Foundation):**
- `core/database/app_database.dart` — Drift database instance
- `core/constants/app_colors.dart` — color tokens (if needed for event categories)

**Riverpod:**
- `flutter_riverpod` — for provider injection
- `riverpod_annotation` — for @riverpod code generation

**Drift:**
- Already configured in pubspec.yaml from Epic 1
- Use generated code from `app_database.g.dart`

### Testing Requirements

**Unit Tests:**
- Mock AppDatabase with Mockito
- Test each DAO query with sample data
- Test repository error handling
- Test date range queries (boundary conditions)

**Test File Location:**
```
test/features/agenda/data/agenda_repository_test.dart
test/features/agenda/data/agenda_dao_test.dart
```

### Performance Considerations

- Index events by startTime for efficient range queries
- Limit getNextEvents() to reasonable count (2-3 for strip, 7 for week view)
- Cache upcoming events in Riverpod provider (async provider with auto-refresh)

### Previous Story Intelligence

**From Story 1.4 (SQLite Database Schema):**
- Events table structure: `id, title, startTime, endTime, category`
- Drift code generation already completed
- Database instance available as singleton

**From Story 1.7 (Main.dart Initialization):**
- Database initialized before app runs
- ProviderScope wraps entire app

### Files to Create/Modify

**New Files:**
1. `lib/features/agenda/data/agenda_dao.dart` — Drift query methods
2. `lib/features/agenda/data/agenda_repository.dart` — Repository implementation
3. `lib/features/agenda/domain/repositories/agenda_repository.dart` — Domain interface (if needed)
4. `lib/features/agenda/presentation/_providers.dart` — Riverpod providers
5. `test/features/agenda/data/agenda_repository_test.dart` — Unit tests

**Existing Files to Reference:**
- `lib/core/database/app_database.dart` — Drift database
- `lib/main.dart` — Database initialization

## Implementation Notes

- Keep DAO methods simple and focused on single queries
- Repository layer handles composition and error handling
- All date/time operations must be timezone-aware (UTC+0)
- Use Riverpod's async provider for automatic caching and refresh
- Document any custom SQL queries with comments explaining the logic

## Completion Checklist

- [ ] AgendaDAO created with all required query methods
- [ ] AgendaRepository created with all required methods
- [ ] Riverpod providers configured for dependency injection
- [ ] All methods return properly typed Futures
- [ ] Error handling implemented (no raw exceptions to UI)
- [ ] Unit tests written and passing
- [ ] Code follows CONVENTIONS.md patterns
- [ ] No direct database access in UI widgets
