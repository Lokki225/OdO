# Foundation Epic — Data Implementation Plan

## Scope

Story 1.1 establishes the project scaffold and dependencies. Story 1.4 implements the full Drift schema. This file covers the full data layer for the Foundation epic, which is implemented primarily in Story 1.4.

---

## Database Schema — 6 Tables

### Table: `skills`

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| id | INTEGER | No | AUTOINCREMENT | Primary key |
| name | TEXT | No | — | Skill display name |
| created_at | INTEGER | No | — | Epoch ms (UTC) |
| last_session_at | INTEGER | Yes | NULL | Epoch ms of most recent session |

**Story:** 1.4  
**Index:** None required (small table, always full scan)

### Table: `sessions`

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| id | INTEGER | No | AUTOINCREMENT | Primary key |
| skill_id | INTEGER | No | — | FK → skills.id ON DELETE CASCADE |
| started_at | INTEGER | No | — | Epoch ms (UTC) |
| duration_minutes | INTEGER | No | — | Session length in minutes |
| notes | TEXT | Yes | NULL | Optional free-text notes |
| is_anchored | INTEGER | No | 0 | 0=unanchored, 1=anchored to agenda event |
| suggested_time | INTEGER | Yes | NULL | Epoch ms if from a suggestion |

**Story:** 1.4  
**Indexes:** `(skill_id, started_at)` for streak queries; `(is_anchored)` for pattern detection

### Table: `events`

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| id | INTEGER | No | AUTOINCREMENT | Primary key |
| title | TEXT | No | — | Event title |
| start_time | INTEGER | No | — | Epoch ms (UTC) |
| end_time | INTEGER | No | — | Epoch ms (UTC) |
| category | TEXT | No | — | 'personal' \| 'work' \| 'practice' |
| notes | TEXT | Yes | NULL | Optional notes |

**Story:** 1.4  
**Index:** `(start_time)` — queried on every agenda strip update

### Table: `suggestions`

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| id | INTEGER | No | AUTOINCREMENT | Primary key |
| skill_id | INTEGER | Yes | NULL | FK → skills.id ON DELETE SET NULL |
| slot_start | INTEGER | No | — | Epoch ms of suggested slot start |
| slot_duration | INTEGER | No | — | Duration in minutes |
| suggested_at | INTEGER | No | — | Epoch ms when suggestion was created |
| accepted_at | INTEGER | Yes | NULL | Epoch ms if accepted |
| dismissed_at | INTEGER | Yes | NULL | Epoch ms if dismissed |
| thumbs_down_at | INTEGER | Yes | NULL | Epoch ms if thumbs-down |
| suppressed_until | INTEGER | Yes | NULL | Epoch ms; SuggestionEngine filters `suppressed_until > now()` |

**Story:** 1.4  
**Index:** `(suppressed_until)` for fast SuggestionEngine filter; `(skill_id)` for per-skill suppression check

### Table: `evening_sessions`

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| id | INTEGER | No | AUTOINCREMENT | Primary key |
| session_date | TEXT | No | — | 'YYYY-MM-DD' local date string |
| started_at | INTEGER | No | — | Epoch ms when session started |
| completed_at | INTEGER | Yes | NULL | Epoch ms when completed |
| abandoned_at | INTEGER | Yes | NULL | Epoch ms when abandoned (set at midnight) |
| headline | TEXT | No | — | AI-generated headline for the session |
| close_summary | TEXT | Yes | NULL | AI-generated closing summary |

**Story:** 1.4  
**Index:** `(session_date)` — queried on every app open (resume check)

### Table: `evening_highlights`

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| id | INTEGER | No | AUTOINCREMENT | Primary key |
| evening_session_id | INTEGER | No | — | FK → evening_sessions.id ON DELETE CASCADE |
| display_order | INTEGER | No | — | Sort order within session |
| content | TEXT | No | — | Highlight text displayed to user |
| source_type | TEXT | No | — | 'session' \| 'event' \| 'pattern' \| 'insight' |
| source_ref_id | INTEGER | Yes | NULL | Nullable FK depending on source_type |
| user_tag | TEXT | Yes | NULL | 'significant' \| 'dismiss' \| 'expand' \| NULL |
| tagged_at | INTEGER | Yes | NULL | Epoch ms when tagged |

**Story:** 1.4  
**Index:** `(evening_session_id, display_order)` for ordered highlight fetch

---

## DAO Method Table

DAOs are implemented in Story 1.4. This table defines the contract for each DAO.

### `SkillsDao`

| Method | SQL Operation | Return Type | Story |
|--------|--------------|-------------|-------|
| `watchAllSkills()` | SELECT * FROM skills ORDER BY created_at | Stream<List<SkillRow>> | 1.4 |
| `insertSkill(SkillRow)` | INSERT INTO skills | Future<void> | 1.4 |
| `updateLastSession(int id, int epochMs)` | UPDATE skills SET last_session_at = ? WHERE id = ? | Future<void> | 1.4 |
| `deleteSkill(int id)` | DELETE FROM skills WHERE id = ? | Future<void> | 1.4 |

### `SessionsDao`

| Method | SQL Operation | Return Type | Story |
|--------|--------------|-------------|-------|
| `watchSessionsForSkill(int skillId)` | SELECT * WHERE skill_id = ? ORDER BY started_at DESC | Stream<List<SessionRow>> | 1.4 |
| `getRecentUnanchored(int skillId, int limit)` | SELECT started_at WHERE skill_id=? AND is_anchored=0 ORDER BY started_at DESC LIMIT ? | Future<List<int>> | 1.4 |
| `insertSession(SessionRow)` | INSERT INTO sessions | Future<void> | 1.4 |
| `deleteSession(int id)` | DELETE FROM sessions WHERE id = ? | Future<void> | 1.4 |

### `EventsDao`

| Method | SQL Operation | Return Type | Story |
|--------|--------------|-------------|-------|
| `watchEventsInRange(int start, int end)` | SELECT * WHERE start_time BETWEEN ? AND ? ORDER BY start_time | Stream<List<EventRow>> | 1.4 |
| `insertEvent(EventRow)` | INSERT INTO events | Future<void> | 1.4 |
| `updateEvent(EventRow)` | UPDATE events SET ... WHERE id = ? | Future<void> | 1.4 |
| `deleteEvent(int id)` | DELETE FROM events WHERE id = ? | Future<void> | 1.4 |

### `SuggestionsDao`

| Method | SQL Operation | Return Type | Story |
|--------|--------------|-------------|-------|
| `getActiveSuggestions(int nowMs)` | SELECT * WHERE suppressed_until IS NULL OR suppressed_until < ? | Future<List<SuggestionRow>> | 1.4 |
| `insertSuggestion(SuggestionRow)` | INSERT INTO suggestions | Future<void> | 1.4 |
| `updateOutcome(int id, int? accepted, int? dismissed, int? thumbsDown, int? suppressedUntil)` | UPDATE suggestions SET ... WHERE id = ? | Future<void> | 1.4 |

### `EveningSessionsDao`

| Method | SQL Operation | Return Type | Story |
|--------|--------------|-------------|-------|
| `getSessionForDate(String date)` | SELECT * WHERE session_date = ? LIMIT 1 | Future<EveningSessionRow?> | 1.4 |
| `insertSession(EveningSessionRow)` | INSERT INTO evening_sessions | Future<int> (new id) | 1.4 |
| `markCompleted(int id, int completedAt, String closeSummary)` | UPDATE evening_sessions SET ... WHERE id = ? | Future<void> | 1.4 |
| `markAbandoned(int id, int abandonedAt)` | UPDATE evening_sessions SET abandoned_at = ? WHERE id = ? | Future<void> | 1.4 |

### `EveningHighlightsDao`

| Method | SQL Operation | Return Type | Story |
|--------|--------------|-------------|-------|
| `watchHighlightsForSession(int sessionId)` | SELECT * WHERE evening_session_id = ? ORDER BY display_order | Stream<List<HighlightRow>> | 1.4 |
| `insertHighlight(HighlightRow)` | INSERT INTO evening_highlights | Future<void> | 1.4 |
| `updateTag(int id, String tag, int taggedAt)` | UPDATE evening_highlights SET user_tag=?, tagged_at=? WHERE id=? | Future<void> | 1.4 |

---

## Repository Implementation Delegation

Each domain repository interface is implemented in the data layer by delegating to the corresponding DAO:

| Domain Interface | Data Impl | DAO Used | Story |
|-----------------|-----------|----------|-------|
| `SkillRepository` | `SkillRepositoryImpl` | `SkillsDao` | 1.4 / 3.1 |
| `SessionRepository` | `SessionRepositoryImpl` | `SessionsDao` | 1.4 / 3.1 |
| `EventRepository` | `EventRepositoryImpl` | `EventsDao` | 1.4 / 2.1 |
| `SuggestionRepository` | `SuggestionRepositoryImpl` | `SuggestionsDao` | 1.4 / 5.6 |
| `EveningSessionRepository` | `EveningSessionRepositoryImpl` | `EveningSessionsDao` + `EveningHighlightsDao` | 1.4 / 5.4 |

---

## `app_database.dart` Structure (Story 1.4)

```dart
@DriftDatabase(tables: [SkillsTable, SessionsTable, EventsTable, SuggestionsTable, EveningSessionsTable, EveningHighlightsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Add indexes
      await customStatement('CREATE INDEX idx_events_start ON events(start_time)');
      await customStatement('CREATE INDEX idx_sessions_skill ON sessions(skill_id, started_at)');
      await customStatement('CREATE INDEX idx_sessions_anchored ON sessions(is_anchored)');
      await customStatement('CREATE INDEX idx_suggestions_suppressed ON suggestions(suppressed_until)');
      await customStatement('CREATE INDEX idx_evening_sessions_date ON evening_sessions(session_date)');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'odo.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```
