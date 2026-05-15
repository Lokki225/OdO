# Story 1.4: SQLite Database Schema with Drift (Six Tables)

Status: ready-for-dev

## Story

As a developer,
I want to define the complete V1 SQLite schema using Drift,
so that all data is persisted locally with type-safe access.

## Acceptance Criteria

1. `lib/core/database/app_database.dart` defines the Drift `AppDatabase` with all six tables
2. `skills` table: `id` (PK AUTOINCREMENT), `name` (TEXT NOT NULL), `createdAt` (INTEGER NOT NULL, epoch ms), `lastSessionAt` (INTEGER nullable, epoch ms)
3. `sessions` table: `id` (PK), `skillId` (FK → skills, CASCADE DELETE), `startedAt` (INTEGER NOT NULL), `durationMinutes` (INTEGER NOT NULL), `notes` (TEXT nullable), `isAnchored` (INTEGER NOT NULL DEFAULT 0), `suggestedTime` (INTEGER nullable)
4. `events` table: `id` (PK), `title` (TEXT NOT NULL), `startTime` (INTEGER NOT NULL), `endTime` (INTEGER NOT NULL), `category` (TEXT NOT NULL — `'personal'|'work'|'practice'`), `notes` (TEXT nullable)
5. `suggestions` table: `id` (PK), `skillId` (FK → skills SET NULL), `slotStart` (INTEGER NOT NULL), `slotDuration` (INTEGER NOT NULL), `suggestedAt` (INTEGER NOT NULL), `acceptedAt` (INTEGER nullable), `dismissedAt` (INTEGER nullable), `thumbsDownAt` (INTEGER nullable), `suppressedUntil` (INTEGER nullable)
6. `eveningSessions` table: `id` (PK), `sessionDate` (TEXT NOT NULL, 'YYYY-MM-DD'), `startedAt` (INTEGER NOT NULL), `completedAt` (INTEGER nullable), `abandonedAt` (INTEGER nullable), `headline` (TEXT NOT NULL), `closeSummary` (TEXT nullable)
7. `eveningHighlights` table: `id` (PK), `eveningSessionId` (FK → eveningSessions CASCADE DELETE), `displayOrder` (INTEGER NOT NULL), `content` (TEXT NOT NULL), `sourceType` (TEXT NOT NULL — `'session'|'event'|'pattern'|'insight'`), `sourceRefId` (INTEGER nullable), `userTag` (TEXT nullable — `'significant'|'dismiss'|'expand'`), `taggedAt` (INTEGER nullable)
8. `dart run build_runner build --delete-conflicting-outputs` generates Drift code without errors
9. The database opens on a fresh install (migration from scratch works)
10. `lib/core/database/database_providers.dart` exposes a Riverpod `appDatabaseProvider` (singleton, lazy init via `path_provider`)
11. `flutter analyze` reports no issues on all database files

## Tasks / Subtasks

- [ ] Task 1: Create Drift table definitions (AC: 2–7)
  - [ ] `lib/core/database/tables/skills_table.dart` — `Skills` Drift table class
  - [ ] `lib/core/database/tables/sessions_table.dart` — `Sessions` with FK to Skills
  - [ ] `lib/core/database/tables/events_table.dart` — `Events`
  - [ ] `lib/core/database/tables/suggestions_table.dart` — `Suggestions` with FK to Skills
  - [ ] `lib/core/database/tables/evening_sessions_table.dart` — `EveningSessions`
  - [ ] `lib/core/database/tables/evening_highlights_table.dart` — `EveningHighlights` with FK to EveningSessions
- [ ] Task 2: Create `AppDatabase` (AC: 1, 8, 9)
  - [ ] `lib/core/database/app_database.dart`: `@DriftDatabase(tables: [...])` annotation with all 6 tables
  - [ ] `schemaVersion = 1`
  - [ ] `migration` returns `MigrationStrategy(onCreate: (m) => m.createAll())`
- [ ] Task 3: Run code generation (AC: 8)
  - [ ] `dart run build_runner build --delete-conflicting-outputs`
  - [ ] Verify `app_database.g.dart` is generated without errors
- [ ] Task 4: Create `database_providers.dart` (AC: 10)
  - [ ] `appDatabaseProvider`: `Provider<AppDatabase>` — lazy singleton
  - [ ] Uses `path_provider` to get the documents directory
  - [ ] Opens `NativeDatabase.createInBackground(file)`
- [ ] Task 5: Smoke test (AC: 9)
  - [ ] Write a simple unit test that opens the DB in memory: `NativeDatabase.memory()`
  - [ ] Insert one skill, query it back — verifies schema works
- [ ] Task 6: Lint check (AC: 11)
  - [ ] `flutter analyze lib/core/database/` — zero issues

## Dev Notes

- **Drift table naming:** Dart class `Skills` → Drift table name `skills` (auto-lowercased). Column `createdAt` → `created_at` in SQL (auto-snake-cased).
- **FK in Drift:** Use `IntColumn` with `.references(Skills, #id)` for foreign key constraint. For CASCADE, add `customConstraint('REFERENCES skills(id) ON DELETE CASCADE')` on the column definition.
- **SET NULL FK:** For `suggestions.skillId`, use `.nullable().customConstraint('REFERENCES skills(id) ON DELETE SET NULL')`.
- **Integer booleans:** Drift maps `bool` columns to `INTEGER` (0/1) automatically with `BoolColumn`. Use `BoolColumn get isAnchored => boolean().withDefault(const Constant(false))()`.
- **Epoch ms integers:** All timestamps are stored as `int` (epoch milliseconds). Use `IntColumn` with `.nullable()` where applicable.
- **`sessionDate` TEXT:** Stored as `'YYYY-MM-DD'` string to avoid timezone issues in grouping. Use `TextColumn`.
- **`sourceType` and `category` TEXT enums:** Drift doesn't enforce TEXT enum constraints natively — validation must happen in the repository layer.
- **Background open:** `NativeDatabase.createInBackground` runs DB on an isolate — prevents main thread jank.
- **Test with `NativeDatabase.memory()`** to avoid file system dependency in unit tests.

### Project Structure Notes

```
lib/core/database/
├── app_database.dart           # @DriftDatabase, AppDatabase class
├── app_database.g.dart         # generated — do not edit
├── database_providers.dart     # appDatabaseProvider (Riverpod)
└── tables/
    ├── skills_table.dart
    ├── sessions_table.dart
    ├── events_table.dart
    ├── suggestions_table.dart
    ├── evening_sessions_table.dart
    └── evening_highlights_table.dart
```

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#SQLite-Schema] — definitive schema with column names and constraints
- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.4] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#Critical-Technical-Risks] — evening session interruption mitigation

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
