# Story 2.1: Agenda Repository and DAO

Status: ready-for-dev

## Story

As a developer,
I want a repository and Drift DAO for the `events` table,
so that event CRUD is type-safe and centralized.

## Acceptance Criteria

1. `lib/features/agenda/data/agenda_dao.dart` defines `AgendaDao` extending `DatabaseAccessor<AppDatabase>` with methods: `insertEvent`, `updateEvent`, `deleteEvent`, `getEventById`, `getEventsBetween(int startMs, int endMs)`, `watchEventsForDay(DateTime date)`
2. `watchEventsForDay(date)` returns `Stream<List<Event>>` (reactive Drift query)
3. `getEventsBetween` returns `Future<List<Event>>` for a time range in epoch ms
4. `lib/features/agenda/domain/repositories/agenda_repository.dart` defines `abstract class AgendaRepository` with the same method signatures returning `Result<T>` or `Stream<List<Event>>`
5. `lib/features/agenda/data/repositories/agenda_repository_impl.dart` implements `AgendaRepository`, injects `AgendaDao`, wraps all DAO calls in try/catch → `Result<T>`
6. `lib/features/agenda/domain/entities/event.dart` defines `Event` entity (pure Dart): `int? id`, `String title`, `DateTime startTime`, `DateTime endTime`, `EventCategory category`, `String? notes`
7. `EventCategory` enum defined in domain: `personal`, `work`, `practice`
8. `lib/features/agenda/data/mappers/event_mapper.dart` maps between `EventsCompanion`/`EventData` (Drift row) and `Event` entity
9. Unit tests cover: insert event, update event, delete event, range query returns correct events, watchEventsForDay emits on insert
10. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: Domain entity + repository interface (AC: 4, 6, 7)
  - [ ] `lib/features/agenda/domain/entities/event.dart` — `Event` immutable class + `EventCategory` enum
  - [ ] `lib/features/agenda/domain/repositories/agenda_repository.dart` — abstract interface
- [ ] Task 2: Drift DAO (AC: 1–3)
  - [ ] `lib/features/agenda/data/agenda_dao.dart`
  - [ ] `@DaoAccessor()` annotation; list `AgendaDao` in `AppDatabase.daos`
  - [ ] `watchEventsForDay`: filter `startTime >= dayStart && startTime < dayEnd`
  - [ ] `getEventsBetween`: filter `startTime >= startMs && startTime < endMs`
- [ ] Task 3: Mapper (AC: 8)
  - [ ] `lib/features/agenda/data/mappers/event_mapper.dart`
  - [ ] `Event fromRow(EventData row)` and `EventsCompanion toCompanion(Event entity)`
  - [ ] Store `startTime`/`endTime` as epoch milliseconds; convert via `DateTime.fromMillisecondsSinceEpoch` / `.millisecondsSinceEpoch`
- [ ] Task 4: Repository implementation (AC: 5)
  - [ ] Inject `AgendaDao` via constructor
  - [ ] Each write method: `try { await dao.insert(...); return Success(()) } catch (e) { return Failure(AppError.databaseWriteFailed); }`
  - [ ] `watchEventsForDay` passes through the Drift stream (no try/catch on streams — handle in presentation)
- [ ] Task 5: Unit tests (AC: 9)
  - [ ] Use in-memory Drift DB: `NativeDatabase.memory()`
  - [ ] `test/features/agenda/data/agenda_dao_test.dart`
- [ ] Task 6: Lint check (AC: 10)
  - [ ] `flutter analyze lib/features/agenda/` — zero issues

## Dev Notes

- **Drift DAO declaration:** `AgendaDao` must be added to `@DriftDatabase(daos: [AgendaDao, ...])` in `app_database.dart` — run `build_runner` after adding.
- **`watchEventsForDay` day boundaries:** Compute `dayStart` = start of day in UTC (since all times are stored as UTC epoch ms). Use `DateTime(date.year, date.month, date.day).toUtc().millisecondsSinceEpoch`.
- **`category` column validation:** The `category` column stores `'personal'|'work'|'practice'`. Mapper must throw `ArgumentError` if unknown string encountered — never silently discard.
- **Riverpod provider for repo:** Add `agendaRepositoryProvider` in `lib/features/agenda/presentation/agenda_providers.dart` (created in Story 2.5). For now, the repo can be created locally in tests.
- **Stream error handling:** Drift streams emit database errors as stream errors. In presentation, handle via `AsyncValue.error` state — do not try/catch the stream in the repository.

### Project Structure Notes

```
lib/features/agenda/
├── domain/
│   ├── entities/
│   │   └── event.dart             # Event + EventCategory
│   └── repositories/
│       └── agenda_repository.dart # abstract interface
├── data/
│   ├── agenda_dao.dart
│   ├── mappers/
│   │   └── event_mapper.dart
│   └── repositories/
│       └── agenda_repository_impl.dart
└── presentation/                  # Story 2.2+
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-2.1] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#SQLite-Schema] — events table definition
- [Source: CLAUDE.md#Clean-Architecture] — layer dependency rules

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
