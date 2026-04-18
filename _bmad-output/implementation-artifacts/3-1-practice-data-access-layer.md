# Story 3.1: Practice Data Access Layer

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to create PracticeRepository and PracticeDAO for type-safe skill and session access,
So that all practice queries are centralized and testable.

## Acceptance Criteria

**Given** the Drift database from Epic 1
**When** I create `features/practice/data/practice_dao.dart` with Drift queries
**Then** queries exist for: getAllSkills(), getSkillById(), getSessionsForSkill(), getUnanchoredSessions()
**And** I create `features/practice/data/practice_repository.dart` implementing domain interface
**And** repository methods: createSkill(), logSession(), getSkillWithSessions(), getUnanchoredSessionsLastDays(days)
**And** all queries return properly typed Futures
**And** repository is injected via Riverpod provider

## Tasks / Subtasks

- [ ] Create Practice DAO with Drift queries (AC: 1)
  - [ ] Create `features/practice/data/practice_dao.dart`
  - [ ] Implement getAllSkills() query
  - [ ] Implement getSkillById(id) query
  - [ ] Implement getSessionsForSkill(skillId) query
  - [ ] Implement getUnanchoredSessions() query
- [ ] Create Practice Repository with domain interface (AC: 2)
  - [ ] Create `features/practice/domain/practice_repository.dart` interface
  - [ ] Create `features/practice/data/practice_repository.dart` implementation
  - [ ] Implement createSkill() method
  - [ ] Implement logSession() method
  - [ ] Implement getSkillWithSessions() method
  - [ ] Implement getUnanchoredSessionsLastDays(days) method
- [ ] Setup Riverpod provider injection (AC: 3)
  - [ ] Create practice repository provider
  - [ ] Ensure proper dependency injection

## Dev Notes

### Architecture Patterns and Constraints

- **Database Schema**: Uses Drift ORM for type-safe SQLite access
- **Repository Pattern**: Domain interface with data layer implementation
- **State Management**: Riverpod providers with code-gen syntax (@riverpod)
- **Error Handling**: Result<T> pattern in services, AsyncValue at UI boundaries
- **Naming Convention**: snake_case for database columns, Repository/Notifier/Service suffixes for providers

### Critical Database Tables

From architecture.md, the key tables are:

**Skills Table:**
```sql
id, name, created_at, last_session_at
```

**Sessions Table:**
```sql
id, skill_id, started_at, duration_minutes, 
notes, is_anchored, suggested_time
```

**Critical Session Fields:**
- `is_anchored = false` when session logged without corresponding agenda event
- `suggested_time` populated when session was logged from a suggestion
- Pattern detection relies on these fields for unanchored session analysis

### Source Tree Components to Touch

- `features/practice/data/practice_dao.dart` (NEW)
- `features/practice/data/practice_repository.dart` (NEW) 
- `features/practice/domain/practice_repository.dart` (NEW)
- `core/database/app_database.dart` (existing - reference only)

### Testing Standards Summary

- Unit tests for all repository methods
- Test both success and error cases
- Mock DAO for repository tests
- Verify proper Future<T> return types
- Test Riverpod provider injection

### Project Structure Notes

Following confirmed architecture structure:
```
features/practice/
├── data/
│   ├── practice_dao.dart        # Drift queries
│   └── practice_repository.dart # Repository implementation
├── domain/
│   └── practice_repository.dart # Repository interface
└── presentation/
    └── practice_providers.dart  # Riverpod providers (Story 3.8)
```

**Alignment with Architecture:**
- Strict data → domain → presentation separation
- Domain layer defines interfaces, data layer implements
- Riverpod providers in presentation layer only
- Database access centralized through DAO pattern

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 3: Practice Module]
- [Source: _bmad-output/planning-artifacts/architecture.md#SQLite Schema Decisions]
- [Source: _bmad-output/planning-artifacts/architecture.md#Project Structure]
- [Source: _bmad-output/planning-artifacts/architecture.md#Confirmed Architectural Decisions]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
