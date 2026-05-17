# Practice Module — Data Implementation Plan (Story 3.1)

## 1. Table Schema Changes

### 1a. `skills` table — new columns (added to existing `skills_table.dart`)

| Column | Dart field | Type | Nullable | Default | AC ref |
|---|---|---|---|---|---|
| `type` | `type` | `TextColumn` | No | — | FR4 |
| `metric_config` | `metricConfig` | `TextColumn` | Yes | null | FR4 |
| `level_label` | `levelLabel` | `TextColumn` | Yes | null | FR4 |
| `level_updated_at` | `levelUpdatedAt` | `IntColumn` (epoch ms) | Yes | null | FR4 |
| `sessions_since_level_update` | `sessionsSinceLevelUpdate` | `IntColumn` | No | `0` | FR4 |
| `is_archived` | `isArchived` | `BoolColumn` | No | `false` | FR4 |
| `suppressed_until` | `suppressedUntil` | `IntColumn` (epoch ms) | Yes | null | FR4 |

**Drift DSL example:**
```dart
TextColumn get type => text()();
TextColumn get metricConfig => text().nullable()();
TextColumn get levelLabel => text().nullable()();
IntColumn get levelUpdatedAt => integer().nullable()();
IntColumn get sessionsSinceLevelUpdate => integer().withDefault(const Constant(0))();
BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
IntColumn get suppressedUntil => integer().nullable()();
```

---

### 1b. `sessions` table — new columns (added to existing `sessions_table.dart`)

| Column | Dart field | Type | Nullable | Default | AC ref |
|---|---|---|---|---|---|
| `mode_tags` | `modeTags` | `TextColumn` (JSON) | Yes | null | FR5 |
| `performance_metric` | `performanceMetric` | `RealColumn` | Yes | null | FR5 |
| `feel_score` | `feelScore` | `IntColumn` | Yes | null | FR5 |
| `is_milestone` | `isMilestone` | `BoolColumn` | No | `false` | FR5 |
| `milestone_label` | `milestoneLabel` | `TextColumn` | Yes | null | FR5 |

**Drift DSL example:**
```dart
TextColumn get modeTags => text().nullable()();
RealColumn get performanceMetric => real().nullable()();
IntColumn get feelScore => integer().nullable()();
BoolColumn get isMilestone => boolean().withDefault(const Constant(false))();
TextColumn get milestoneLabel => text().nullable()();
```

---

### 1c. `suggestions` table — new column (added to existing `suggestions_table.dart`)

| Column | Dart field | Type | Nullable | Default | AC ref |
|---|---|---|---|---|---|
| `category` | `category` | `TextColumn` | Yes | null | FR6 |

**Drift DSL example:**
```dart
TextColumn get category => text().nullable()();
```

---

## 2. Schema Migration

**File:** `lib/core/database/app_database.dart`

| Change | Detail | AC ref |
|---|---|---|
| `schemaVersion` | `1` → `2` | FR11 |
| `MigrationStrategy.onUpgrade` | Guard: `if (from < 2)` → call `m.addColumn` for every new column listed above | FR11 |
| `PracticeDao` | Add to `@DriftDatabase(daos: [AgendaDao, PracticeDao])` and class body getter | FR7 |

**Migration skeleton:**
```dart
MigrationStrategy(
  onCreate: (m) async {
    await m.createAll();
    await customStatement('CREATE INDEX ...');
  },
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      await m.addColumn(skills, skills.type);
      await m.addColumn(skills, skills.metricConfig);
      await m.addColumn(skills, skills.levelLabel);
      await m.addColumn(skills, skills.levelUpdatedAt);
      await m.addColumn(skills, skills.sessionsSinceLevelUpdate);
      await m.addColumn(skills, skills.isArchived);
      await m.addColumn(skills, skills.suppressedUntil);
      await m.addColumn(sessions, sessions.modeTags);
      await m.addColumn(sessions, sessions.performanceMetric);
      await m.addColumn(sessions, sessions.feelScore);
      await m.addColumn(sessions, sessions.isMilestone);
      await m.addColumn(sessions, sessions.milestoneLabel);
      await m.addColumn(suggestions, suggestions.category);
    }
  },
)
```

---

## 3. PracticeDao

**File:** `lib/features/practice/data/practice_dao.dart`
**Annotation:** `@DriftAccessor(tables: [Skills, Sessions])`
**Extends:** `DatabaseAccessor<AppDatabase>`

| Method | SQL Operation | Return Type | AC ref |
|---|---|---|---|
| `insertSkill(SkillsCompanion c)` | `INSERT OR REPLACE INTO skills` | `Future<int>` (generated id) | FR7 |
| `updateSkill(SkillsCompanion c)` | `UPDATE skills SET ... WHERE id=?` | `Future<bool>` | FR7 |
| `deleteSkill(int id)` | `DELETE FROM skills WHERE id=?` | `Future<int>` | FR7 |
| `watchAllSkills()` | `SELECT * FROM skills` | `Stream<List<SkillRow>>` | FR7, IR1 |
| `getSkillById(int id)` | `SELECT * FROM skills WHERE id=? LIMIT 1` | `Future<SkillRow?>` | FR7 |
| `insertSession(SessionsCompanion c)` | `INSERT INTO sessions` | `Future<int>` | FR7 |
| `getSessionsForSkill(int skillId, {int? sinceMs})` | `SELECT * FROM sessions WHERE skill_id=? [AND started_at>=?] ORDER BY started_at DESC` | `Future<List<SessionRow>>` | FR7 |
| `getLastSession(int skillId)` | `SELECT * FROM sessions WHERE skill_id=? ORDER BY started_at DESC LIMIT 1` | `Future<SessionRow?>` | FR7 |
| `getUnanchoredSessions(int skillId, {int? sinceMs})` | `SELECT * FROM sessions WHERE skill_id=? AND is_anchored=0 [AND started_at>=?] ORDER BY started_at DESC LIMIT 3` | `Future<List<SessionRow>>` | FR7, IR4 |
| `updateSessionsCountAndLastSessionAt(int skillId, DateTime lastAt)` | `UPDATE skills SET sessions_since_level_update=sessions_since_level_update+1, last_session_at=? WHERE id=?` | `Future<void>` | FR7, IR3 |

---

## 4. Mappers

### 4a. SkillMapper

**File:** `lib/features/practice/data/mappers/skill_mapper.dart`
**Pattern:** `abstract final class SkillMapper` (static methods only)

| Method | Input | Output | Logic | AC ref |
|---|---|---|---|---|
| `fromRow(SkillRow row)` | `SkillRow` | `Skill` | Map each column; `type` → `SkillType.values.firstWhere(v.value == row.type)` (throws `ArgumentError` on unknown) | FR10, EC3 |
| `toCompanion(Skill skill)` | `Skill` | `SkillsCompanion` | `Value(skill.field)` for each field; nullable fields use `Value(null)` when null | FR10 |

**DateTime↔epoch:** `DateTime.fromMillisecondsSinceEpoch(ms)` / `.millisecondsSinceEpoch`

---

### 4b. SessionMapper

**File:** `lib/features/practice/data/mappers/session_mapper.dart`
**Pattern:** `abstract final class SessionMapper`

| Method | Input | Output | Logic | AC ref |
|---|---|---|---|---|
| `fromRow(SessionRow row)` | `SessionRow` | `Session` | `modeTags`: `row.modeTags == null ? [] : (jsonDecode(row.modeTags!) as List).cast<String>()`; all other nullable fields mapped with null propagation | FR10, EC1, EH3 |
| `toCompanion(Session s)` | `Session` | `SessionsCompanion` | `modeTags`: `Value(jsonEncode(s.modeTags))` (always writes JSON even for empty list) | FR10, FR13 |

---

## 5. PracticeRepository Interface

**File:** `lib/features/practice/domain/repositories/practice_repository.dart`
**Pattern:** `abstract class PracticeRepository`

| Method | Return Type | AC ref |
|---|---|---|
| `addSkill(Skill)` | `Future<Result<int>>` | FR8 |
| `updateSkill(Skill)` | `Future<Result<void>>` | FR8 |
| `deleteSkill(int id)` | `Future<Result<void>>` | FR8 |
| `watchAllSkills()` | `Stream<List<Skill>>` | FR8 |
| `addSession(Session)` | `Future<Result<int>>` | FR8 |
| `getSessionsForSkill(int skillId, {DateTime? since})` | `Future<Result<List<Session>>>` | FR8 |
| `getLastSession(int skillId)` | `Future<Result<Session?>>` | FR8 |
| `getUnanchoredSessions(int skillId, {DateTime? since})` | `Future<Result<List<Session>>>` | FR8 |

---

## 6. PracticeRepositoryImpl

**File:** `lib/features/practice/data/repositories/practice_repository_impl.dart`
**Implements:** `PracticeRepository`
**Injects:** `PracticeDao _dao`

| Method | Delegation | Error Handling | AC ref |
|---|---|---|---|
| `addSkill(Skill)` | `SkillMapper.toCompanion` → `_dao.insertSkill` → return `Success(id)` | try/catch → `Failure(AppError.databaseWriteFailed)` | FR9, EH1 |
| `updateSkill(Skill)` | `SkillMapper.toCompanion` → `_dao.updateSkill` | try/catch → `Failure(...)` | FR9 |
| `deleteSkill(int id)` | `_dao.deleteSkill(id)` | try/catch → `Failure(...)` | FR9 |
| `watchAllSkills()` | `_dao.watchAllSkills().map(rows => rows.map(SkillMapper.fromRow).toList())` | raw stream (errors propagate) | FR9, EC5 |
| `addSession(Session)` | `database.transaction(() async { id = await _dao.insertSession(...); await _dao.updateSessionsCountAndLastSessionAt(...); return id; })` | try/catch → `Failure(...)` | FR9, IR3, EH2 |
| `getSessionsForSkill` | `_dao.getSessionsForSkill` → `SessionMapper.fromRow` | try/catch → `Failure(...)` | FR9 |
| `getLastSession` | `_dao.getLastSession` → `SessionMapper.fromRow` or null | try/catch → `Failure(...)` | FR9, EC2 |
| `getUnanchoredSessions` | `_dao.getUnanchoredSessions` → map rows | try/catch → `Failure(...)` | FR9, IR4 |

---

## 7. Riverpod Providers

**File:** `lib/features/practice/presentation/practice_providers.dart`

| Provider | Type | Depends on | AC ref |
|---|---|---|---|
| `practiceDaoProvider` | `Provider<PracticeDao>` | `appDatabaseProvider` | FR7 |
| `practiceRepositoryProvider` | `Provider<PracticeRepository>` | `practiceDaoProvider` | FR8, FR9 |
| `allSkillsProvider` | `StreamProvider<List<Skill>>` | `practiceRepositoryProvider` | FR8 |
