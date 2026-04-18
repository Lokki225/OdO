---
stepsCompleted: []
inputDocuments:
  - epics.md
  - architecture.md
projectName: TooXTips
userName: Lokki
date: 2026-03-30
status: ready-for-dev
storyId: "2.5"
storyKey: "2-5-agenda-state-management-with-riverpod"
---

# Story 2.5: Agenda State Management with Riverpod

## Story Statement

As a developer,
I want to manage Agenda state with Riverpod providers,
So that UI widgets reactively update when events change.

## Acceptance Criteria

**Given** AgendaRepository from Story 2.4
**When** I create `features/agenda/presentation/agenda_providers.dart`
**Then** `agendaRepositoryProvider` returns AgendaRepository instance
**And** `todayAgendaProvider` returns today's events (async)
**And** `weekAgendaProvider` returns week's events (async)
**And** `nextEventsProvider` returns next 2-3 events for strip (async)
**And** `agendaNotifierProvider` provides StateNotifier for add/update/delete actions
**And** all providers use @riverpod annotation for code generation

## Technical Context

### Architecture Compliance

**Provider Structure:**
```
features/agenda/presentation/
└── _providers.dart
    ├── agendaRepositoryProvider (sync)
    ├── todayAgendaProvider (async)
    ├── weekAgendaProvider (async)
    ├── nextEventsProvider (async)
    ├── selectedDateProvider (state)
    └── agendaNotifierProvider (state notifier)
```

**State Management Pattern:**
- Sync providers for repository injection
- Async providers for data fetching (with auto-caching)
- StateNotifier for CRUD actions
- Riverpod code generation with @riverpod annotation

**Folder Structure:**
```
features/agenda/
├── data/
│   ├── agenda_dao.dart
│   └── agenda_repository.dart
├── domain/
│   └── repositories/
│       └── agenda_repository.dart
└── presentation/
    ├── _providers.dart          # New: All Riverpod providers
    ├── agenda_slide.dart
    └── widgets/
        ├── agenda_strip.dart
        ├── add_event_sheet.dart
        └── event_card.dart
```

### Key Implementation Details

**Provider Definitions:**

1. **agendaRepositoryProvider:**
   - Returns singleton AgendaRepository instance
   - Sync provider (no async/await)
   - Injected into all other providers

2. **todayAgendaProvider:**
   - Async provider: `Future<List<AgendaEvent>>`
   - Calls `repository.getEventsForDate(today)`
   - Auto-refreshes when events change
   - Caches result automatically

3. **weekAgendaProvider:**
   - Async provider: `Future<List<AgendaEvent>>`
   - Calls `repository.getEventsForWeek(weekStart)`
   - Auto-refreshes when events change
   - Caches result automatically

4. **nextEventsProvider:**
   - Async provider: `Future<List<AgendaEvent>>`
   - Calls `repository.getNextEvents(3)`
   - Used by AgendaStrip widget
   - Auto-refreshes when events change

5. **selectedDateProvider:**
   - State provider: `StateProvider<DateTime>`
   - Tracks currently selected date in calendar
   - Used by DayView and WeekView

6. **agendaNotifierProvider:**
   - StateNotifier for CRUD actions
   - Methods: `createEvent()`, `updateEvent()`, `deleteEvent()`
   - Automatically invalidates cached providers after mutations
   - Handles error states

### Dependencies & Imports

**From Story 2.1:**
- `features/agenda/data/agenda_repository.dart` — AgendaRepository

**Riverpod:**
- `flutter_riverpod` — Provider, AsyncProvider, StateNotifier
- `riverpod_annotation` — @riverpod code generation

**Flutter:**
- `material.dart` — DateTime utilities

### Testing Requirements

**Unit Tests:**
- Mock AgendaRepository with Mockito
- Test repository provider returns instance
- Test async providers return correct data
- Test state notifier CRUD methods
- Test provider invalidation after mutations
- Test error handling in async providers

**Test File Location:**
```
test/features/agenda/presentation/agenda_providers_test.dart
```

### Performance Considerations

- Async providers auto-cache results (Riverpod feature)
- Manual invalidation after CRUD operations
- Use `select()` to watch specific fields (avoid unnecessary rebuilds)
- Debounce rapid mutations to prevent excessive database calls

### Previous Story Intelligence

**From Story 2.1 (Event Data Access Layer):**
- AgendaRepository provides all query methods
- Methods return Future<List<AgendaEvent>> or Future<AgendaEvent>

**From Story 2.2 (Persistent Agenda Strip):**
- AgendaStrip watches `nextEventsProvider`
- Needs real-time updates when events change

**From Story 2.3 (Calendar View):**
- DayView and WeekView watch `todayAgendaProvider` and `weekAgendaProvider`
- Need real-time updates when events change

**From Story 2.4 (Event CRUD):**
- AddEventSheet uses `agendaNotifierProvider` to create/update events
- After mutation, providers must be invalidated to refresh UI

### Files to Create/Modify

**New Files:**
1. `lib/features/agenda/presentation/_providers.dart` — All Riverpod providers
2. `test/features/agenda/presentation/agenda_providers_test.dart` — Unit tests

**Existing Files to Reference:**
- `lib/features/agenda/data/agenda_repository.dart` — Repository methods

## Implementation Notes

- Use @riverpod annotation for code generation (requires build_runner)
- All async providers should handle loading and error states
- Invalidate providers after CRUD operations: `ref.invalidate(todayAgendaProvider)`
- Use `select()` to watch specific fields and avoid unnecessary rebuilds
- StateNotifier should not expose internal state, only methods

## Completion Checklist

- [ ] _providers.dart file created
- [ ] agendaRepositoryProvider implemented
- [ ] todayAgendaProvider implemented (async)
- [ ] weekAgendaProvider implemented (async)
- [ ] nextEventsProvider implemented (async)
- [ ] selectedDateProvider implemented (state)
- [ ] agendaNotifierProvider implemented (state notifier)
- [ ] All providers use @riverpod annotation
- [ ] CRUD methods invalidate cached providers
- [ ] Error handling implemented for async providers
- [ ] Unit tests written and passing
- [ ] Code follows CONVENTIONS.md patterns
- [ ] build_runner configured for code generation
