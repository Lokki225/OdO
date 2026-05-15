# Story 3.1: Practice Repository and DAO

Status: ready-for-dev

## Story

As a developer,
I want a repository and DAO for `skills` and `sessions`,
so that practice data is type-safe and centralized.

## Acceptance Criteria

1. `lib/features/practice/data/practice_dao.dart` defines `PracticeDao` extending `DatabaseAccessor<AppDatabase>` with methods: `insertSkill`, `deleteSkill`, `watchAllSkills`, `insertSession`, `getSessionsForSkill(int skillId, int sinceMs)`, `getLastSession(int skillId)`, `getUnanchoredSessions(int skillId, int sinceMs)`
2. `watchAllSkills` returns `Stream<List<SkillData>>` — reactive
3. `getUnanchoredSessions` returns sessions where `is_anchored = 0`, ordered by `started_at DESC`, limit 3
4. `lib/features/practice/domain/repositories/practice_repository.dart` defines abstract `PracticeRepository` with the same signatures returning `Result<T>` or streams
5. `lib/features/practice/data/repositories/practice_repository_impl.dart` implements `PracticeRepository`, injects `PracticeDao`, wraps writes in try/catch
6. `lib/features/practice/domain/entities/skill.dart` defines `Skill` entity: `int? id`, `String name`, `DateTime createdAt`, `DateTime? lastSessionAt`
7. `lib/features/practice/domain/entities/session.dart` defines `Session` entity: `int? id`, `int skillId`, `DateTime startedAt`, `int durationMinutes`, `String? notes`, `bool isAnchored`, `DateTime? suggestedTime`
8. Mappers exist for `Skill` ↔ Drift row and `Session` ↔ Drift row
9. Unit tests cover: insertSkill, deleteSkill stream emission, insertSession, getUnanchoredSessions returns max 3 unanchored
10. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: Domain entities (AC: 6, 7)
  - [ ] `lib/features/practice/domain/entities/skill.dart` — `Skill` with `@immutable`
  - [ ] `lib/features/practice/domain/entities/session.dart` — `Session` with `@immutable`
- [ ] Task 2: Domain repository interface (AC: 4)
  - [ ] `lib/features/practice/domain/repositories/practice_repository.dart`
- [ ] Task 3: Drift DAO (AC: 1–3)
  - [ ] `lib/features/practice/data/practice_dao.dart`
  - [ ] `getUnanchoredSessions`: `SELECT * FROM sessions WHERE skill_id = ? AND is_anchored = 0 ORDER BY started_at DESC LIMIT 3`
  - [ ] `getLastSession`: `SELECT * FROM sessions WHERE skill_id = ? ORDER BY started_at DESC LIMIT 1`
  - [ ] Register `PracticeDao` in `AppDatabase.daos`; re-run build_runner
- [ ] Task 4: Mappers (AC: 8)
  - [ ] `lib/features/practice/data/mappers/skill_mapper.dart`
  - [ ] `lib/features/practice/data/mappers/session_mapper.dart`
- [ ] Task 5: Repository impl (AC: 5)
  - [ ] Injects `PracticeDao`; wraps all writes in `Result<T>` try/catch
  - [ ] `watchAllSkills`: passes through Drift stream
- [ ] Task 6: Unit tests (AC: 9)
  - [ ] In-memory DB: `NativeDatabase.memory()`
  - [ ] `test/features/practice/data/practice_dao_test.dart`
- [ ] Task 7: Lint check (AC: 10)

## Dev Notes

- **`last_session_at` update:** When `insertSession` is called, also update the parent skill's `last_session_at = session.startedAt` via a second DAO call or a single SQL transaction. Do this inside a `db.transaction(...)`.
- **Pattern detection query:** The `getUnanchoredSessions` method with `LIMIT 3` is the exact query used by `PatternDetector` (Story 3.6). The `sinceMs` parameter allows filtering by recency.
- **Stream for all skills:** `watchAllSkills` uses `select(skills).watch()` — no filter, returns all skills ordered by `created_at ASC`.

### Project Structure Notes

```
lib/features/practice/
├── domain/
│   ├── entities/{skill.dart,session.dart}
│   └── repositories/practice_repository.dart
├── data/
│   ├── practice_dao.dart
│   ├── mappers/{skill_mapper.dart,session_mapper.dart}
│   └── repositories/practice_repository_impl.dart
└── presentation/              # Stories 3.2+
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-3.1] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#SQLite-Schema] — skills + sessions tables
- [Source: _bmad-output/planning-artifacts/architecture.md#Critical-Technical-Risks] — pattern detection query

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
