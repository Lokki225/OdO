# Practice Module — Acceptance Criteria

## Functional Requirements (FR)

### FR1 — SkillType enum (Story 3.1)
`SkillType` enum has exactly 6 values: `language`, `strategy`, `physical`, `technical`, `creative`, `personal`. Each has a `.value` string getter matching the snake_case database storage value.

### FR2 — Skill entity (Story 3.1)
`Skill` entity is `@immutable` with fields: `int? id`, `String name`, `SkillType type`, `String? metricConfig`, `String? levelLabel`, `DateTime? levelUpdatedAt`, `int sessionssSinceLevelUpdate`, `DateTime createdAt`, `DateTime? lastSessionAt`, `bool isArchived`, `DateTime? suppressedUntil`. Has `validate()` returning `Result<Skill>` and `copyWith(...)`.

### FR3 — Session entity (Story 3.1)
`Session` entity is `@immutable` with fields: `int? id`, `int skillId`, `DateTime startedAt`, `int durationMinutes`, `List<String> modeTags`, `double? performanceMetric`, `int? feelScore`, `String? notes`, `bool isAnchored`, `DateTime? suggestedTime`, `bool isMilestone`, `String? milestoneLabel`. Has `copyWith(...)`.

### FR4 — Skills table schema (Story 3.1)
`Skills` Drift table has columns: `id`, `name`, `type` (text, non-null), `metric_config` (text, nullable), `level_label` (text, nullable), `level_updated_at` (int/epoch ms, nullable), `sessions_since_level_update` (int, default 0), `created_at` (int/epoch ms), `last_session_at` (int/epoch ms, nullable), `is_archived` (bool, default false), `suppressed_until` (int/epoch ms, nullable).

### FR5 — Sessions table schema (Story 3.1)
`Sessions` Drift table has columns: `id`, `skill_id` (FK → skills, cascade delete), `started_at`, `duration_minutes`, `mode_tags` (text, nullable — JSON array), `performance_metric` (real, nullable), `feel_score` (int, nullable), `notes` (text, nullable), `is_anchored` (bool, default false), `suggested_time` (int/epoch ms, nullable), `is_milestone` (bool, default false), `milestone_label` (text, nullable).

### FR6 — Suggestions table schema (Story 3.1)
`Suggestions` Drift table gains `category` column (text, nullable — progressStall|temporalPattern|crossSkill|crossDimension|levelCheckIn).

### FR7 — PracticeDao methods (Story 3.1)
`PracticeDao` has: `insertSkill(SkillsCompanion)`, `updateSkill(SkillsCompanion)`, `deleteSkill(int id)`, `watchAllSkills()` → `Stream<List<SkillRow>>`, `getSkillById(int id)` → `Future<SkillRow?>`, `insertSession(SessionsCompanion)` → returns inserted id, `getSessionsForSkill(int skillId, {int? sinceMs})`, `getLastSession(int skillId)` → `Future<SessionRow?>`, `getUnanchoredSessions(int skillId, {int? sinceMs})` → max 3 results, `updateSessionsCountAndLastSessionAt(int skillId, DateTime lastAt)`.

### FR8 — PracticeRepository interface (Story 3.1)
Abstract `PracticeRepository` with: `addSkill(Skill)` → `Future<Result<int>>`, `updateSkill(Skill)` → `Future<Result<void>>`, `deleteSkill(int id)` → `Future<Result<void>>`, `watchAllSkills()` → `Stream<List<Skill>>`, `addSession(Session)` → `Future<Result<int>>`, `getSessionsForSkill(int skillId, {DateTime? since})` → `Future<Result<List<Session>>>`, `getLastSession(int skillId)` → `Future<Result<Session?>>`, `getUnanchoredSessions(int skillId, {DateTime? since})` → `Future<Result<List<Session>>>`.

### FR9 — PracticeRepositoryImpl (Story 3.1)
Implements `PracticeRepository`, injects `PracticeDao`. All write methods wrapped in `try/catch` → `Failure(AppError.databaseWriteFailed)`. `watchAllSkills` returns DAO stream mapped through `SkillMapper`. `addSession` calls `updateSessionsCountAndLastSessionAt` in same transaction after insert.

### FR10 — Mappers (Story 3.1)
`SkillMapper.fromRow(SkillRow)` → `Skill`, throws `ArgumentError` on unknown `type` string. `SkillMapper.toCompanion(Skill)` → `SkillsCompanion`. `SessionMapper.fromRow(SessionRow)` → `Session` (deserializes `mode_tags` JSON to `List<String>`). `SessionMapper.toCompanion(Session)` → `SessionsCompanion` (serializes `mode_tags` to JSON).

### FR11 — Schema migration (Story 3.1)
`schemaVersion` increments from 1 to 2. `MigrationStrategy.onUpgrade` runs `m.addColumn` for every new column in Skills, Sessions, and Suggestions with correct default values.

### FR12 — Skill validation (Story 3.1)
`Skill.validate()` returns `Failure(AppError.validationFailed)` if `name.trim().isEmpty`. Returns `Success(this)` otherwise.

### FR13 — Mode tags JSON round-trip (Story 3.1)
`SessionMapper` correctly serializes `["Speaking", "Listening"]` to `'["Speaking","Listening"]'` and deserializes back. Empty list serializes to `'[]'`. Null `mode_tags` column deserializes to empty `List<String>`.

## Integration Requirements (IR)

### IR1 — Reactive skill list (Story 3.1)
Inserting a skill via `PracticeDao.insertSkill()` causes `watchAllSkills()` to emit within 50ms.

### IR2 — Cascade delete (Story 3.1)
Deleting a skill via `deleteSkill(id)` removes all associated sessions via SQLite cascade.

### IR3 — lastSessionAt update on session insert (Story 3.1)
After `addSession`, the parent skill's `last_session_at` column reflects the new session's `started_at`. Happens atomically in a `db.transaction`.

### IR4 — getUnanchoredSessions limit (Story 3.1)
`getUnanchoredSessions` returns at most 3 results, ordered by `started_at DESC`, filtered by `is_anchored = false`.

## Edge Cases (EC)

### EC1 — Session without modeTags (Story 3.1)
Session inserted with empty `modeTags` list stores `'[]'` in DB. Reads back as empty list.

### EC2 — Skill with no sessions yet (Story 3.1)
`getLastSession` returns `Success(null)` for a skill with zero sessions.

### EC3 — Unknown SkillType in DB (Story 3.1)
`SkillMapper.fromRow` with an unrecognized `type` value throws `ArgumentError` with the unknown value in the message.

### EC4 — performanceMetric precision (Story 3.1)
`performanceMetric` stored as SQLite REAL (64-bit IEEE 754 double). A value of `1234.56` round-trips without loss.

### EC5 — Archived skill still queryable (Story 3.1)
`watchAllSkills` returns ALL skills including archived ones. Filtering by `isArchived` is a presentation-layer concern.

## Error Handling (EH)

### EH1 — Insert throws (Story 3.1)
If `PracticeDao.insertSkill` throws (e.g. constraint violation), `PracticeRepositoryImpl.addSkill` returns `Failure(AppError.databaseWriteFailed)`.

### EH2 — Session insert with invalid skillId (Story 3.1)
If `skillId` FK is violated (skill doesn't exist), `addSession` returns `Failure(AppError.databaseWriteFailed)`.

### EH3 — Null-safe mapper (Story 3.1)
`SessionMapper.fromRow` handles null `mode_tags`, `performance_metric`, `feel_score`, `milestone_label` without throwing.

## Quality Requirements (QR)

### QR1 — Zero lint (Story 3.1)
`flutter analyze` shows "No issues found!" across all new files.

### QR2 — Test coverage (Story 3.1)
≥ 12 unit/integration tests covering FR7–FR10, IR1–IR4, EC1–EC5, EH1–EH2.

### QR3 — Domain purity (Story 3.1)
`domain/` files contain no imports from `drift`, `flutter`, `data/`, or any external package except `flutter/foundation.dart` (for `@immutable`).
