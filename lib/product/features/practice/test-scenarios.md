# Practice Module — Test Scenarios (Story 3.1)

## TS-037 — SkillType enum values and string getters
**ID:** TS-037
**Title:** SkillType has 6 values and correct `.value` strings
**Preconditions:** None
**Input:** `SkillType.language`, `SkillType.strategy`, `SkillType.physical`, `SkillType.technical`, `SkillType.creative`, `SkillType.personal`
**Expected Output:** `.value` returns `'language'`, `'strategy'`, `'physical'`, `'technical'`, `'creative'`, `'personal'` respectively
**Validation Rule:** FR1
**Test Type:** Unit

---

## TS-038 — Skill entity immutable construction
**ID:** TS-038
**Title:** Skill entity constructs with all required fields
**Preconditions:** None
**Input:** All required fields provided (name, type, sessionssSinceLevelUpdate, createdAt, isArchived)
**Expected Output:** Instance created; nullable fields default to null; `isArchived` defaults to false
**Validation Rule:** FR2
**Test Type:** Unit

---

## TS-039 — Skill.validate() empty name
**ID:** TS-039
**Title:** Skill.validate() returns Failure on blank name
**Preconditions:** None
**Input:** `Skill(name: '   ', type: SkillType.language, ...)`
**Expected Output:** `Failure(AppError.validationFailed)`
**Validation Rule:** FR12
**Test Type:** Unit

---

## TS-040 — Skill.validate() valid name
**ID:** TS-040
**Title:** Skill.validate() returns Success on non-empty name
**Preconditions:** None
**Input:** `Skill(name: 'Japanese', type: SkillType.language, ...)`
**Expected Output:** `Success(skill)` where skill equals the input instance
**Validation Rule:** FR12
**Test Type:** Unit

---

## TS-041 — Session entity construction
**ID:** TS-041
**Title:** Session entity constructs with required and optional fields
**Preconditions:** None
**Input:** Required fields (skillId, startedAt, durationMinutes, modeTags, isAnchored, isMilestone); nullable fields omitted
**Expected Output:** Instance created; performanceMetric=null; feelScore=null; notes=null; suggestedTime=null; milestoneLabel=null
**Validation Rule:** FR3
**Test Type:** Unit

---

## TS-042 — PracticeDao.insertSkill and watchAllSkills reactivity
**ID:** TS-042
**Title:** Inserting a skill causes watchAllSkills to emit within 50ms
**Preconditions:** In-memory Drift DB initialized with PRAGMA foreign_keys=ON
**Input:** `dao.insertSkill(SkillsCompanion(name: Value('Chess'), type: Value('strategy'), ...))`
**Expected Output:** `watchAllSkills()` stream emits a list containing the inserted row within 50ms
**Validation Rule:** IR1, FR7
**Test Type:** Integration

---

## TS-043 — PracticeDao.deleteSkill cascades to sessions
**ID:** TS-043
**Title:** Deleting a skill removes all child sessions
**Preconditions:** DB has skill with id=1 and 3 associated sessions
**Input:** `dao.deleteSkill(1)`
**Expected Output:** `getSessionsForSkill(1)` returns empty list; sessions table has zero rows for skillId=1
**Validation Rule:** IR2
**Test Type:** Integration

---

## TS-044 — PracticeRepositoryImpl.addSession updates lastSessionAt atomically
**ID:** TS-044
**Title:** addSession updates parent skill's last_session_at in same transaction
**Preconditions:** Skill exists with id=1, lastSessionAt=null
**Input:** `repo.addSession(Session(skillId: 1, startedAt: t, durationMinutes: 30, ...))`
**Expected Output:** After call, `getSkillById(1).lastSessionAt == t` (epoch ms within tolerance)
**Validation Rule:** IR3
**Test Type:** Integration

---

## TS-045 — PracticeDao.getUnanchoredSessions limit and ordering
**ID:** TS-045
**Title:** getUnanchoredSessions returns at most 3 results ordered DESC
**Preconditions:** DB has 5 unanchored sessions for skillId=1 at different times t1..t5 (t5 most recent)
**Input:** `dao.getUnanchoredSessions(1)`
**Expected Output:** Returns exactly 3 rows ordered [t5, t4, t3]; t1 and t2 excluded
**Validation Rule:** IR4, FR7
**Test Type:** Integration

---

## TS-046 — SessionMapper mode_tags JSON round-trip
**ID:** TS-046
**Title:** mode_tags serializes and deserializes correctly
**Preconditions:** None
**Input:** `Session(modeTags: ['Speaking', 'Listening'], ...)`
**Expected Output:** `SessionMapper.toCompanion(s).modeTags.value == '["Speaking","Listening"]'`; `SessionMapper.fromRow(row).modeTags == ['Speaking', 'Listening']`
**Validation Rule:** FR13
**Test Type:** Unit

---

## TS-047 — SessionMapper empty modeTags
**ID:** TS-047
**Title:** Empty modeTags serializes to '[]' and deserializes to empty list
**Preconditions:** None
**Input:** `Session(modeTags: [], ...)`
**Expected Output:** `toCompanion().modeTags.value == '[]'`; `fromRow(row with modeTags='[]').modeTags == []`
**Validation Rule:** EC1, FR13
**Test Type:** Unit

---

## TS-048 — SessionMapper null mode_tags column
**ID:** TS-048
**Title:** Null mode_tags column deserializes to empty list
**Preconditions:** None
**Input:** DB row with `mode_tags = null`
**Expected Output:** `SessionMapper.fromRow(row).modeTags == []`
**Validation Rule:** EC1, EH3
**Test Type:** Unit

---

## TS-049 — PracticeDao.getLastSession returns null for skill with no sessions
**ID:** TS-049
**Title:** getLastSession returns Success(null) for skill with zero sessions
**Preconditions:** Skill id=1 exists; no sessions for that skill
**Input:** `repo.getLastSession(1)`
**Expected Output:** `Success(null)` (not Failure, not exception)
**Validation Rule:** EC2, FR7
**Test Type:** Integration

---

## TS-050 — SkillMapper.fromRow throws on unknown type
**ID:** TS-050
**Title:** SkillMapper.fromRow throws ArgumentError for unrecognized type string
**Preconditions:** None
**Input:** DB row with `type = 'unknown_type'`
**Expected Output:** `ArgumentError` thrown with message containing `'unknown_type'`
**Validation Rule:** EC3
**Test Type:** Unit

---

## TS-051 — performanceMetric float precision round-trip
**ID:** TS-051
**Title:** performanceMetric 1234.56 round-trips without loss
**Preconditions:** In-memory DB
**Input:** Insert session with `performanceMetric = 1234.56`
**Expected Output:** Retrieved row has `performance_metric == 1234.56`
**Validation Rule:** EC4
**Test Type:** Integration

---

## TS-052 — watchAllSkills includes archived skills
**ID:** TS-052
**Title:** watchAllSkills returns archived and non-archived skills together
**Preconditions:** DB has skill A (isArchived=false) and skill B (isArchived=true)
**Input:** `dao.watchAllSkills()`
**Expected Output:** Stream emits list containing both A and B
**Validation Rule:** EC5
**Test Type:** Integration

---

## TS-053 — PracticeRepositoryImpl.addSkill returns Failure on DAO exception
**ID:** TS-053
**Title:** addSkill returns Failure(databaseWriteFailed) when DAO throws
**Preconditions:** DAO configured to throw on insert (e.g., constraint violation)
**Input:** `repo.addSkill(duplicateSkill)`
**Expected Output:** `Failure(AppError.databaseWriteFailed)` returned; no exception propagates
**Validation Rule:** EH1
**Test Type:** Unit

---

## TS-054 — addSession returns Failure on invalid skillId
**ID:** TS-054
**Title:** addSession returns Failure when skillId FK is violated
**Preconditions:** Skill id=999 does not exist in DB
**Input:** `repo.addSession(Session(skillId: 999, ...))`
**Expected Output:** `Failure(AppError.databaseWriteFailed)`
**Validation Rule:** EH2
**Test Type:** Integration

---

## TS-055 — Domain purity: no drift/flutter imports in domain files
**ID:** TS-055
**Title:** Domain layer files contain no drift or flutter (non-foundation) imports
**Preconditions:** Story 3.1 implementation complete
**Input:** Static analysis of `lib/features/practice/domain/**`
**Expected Output:** `flutter analyze` reports no issues; no import contains `drift` or `flutter` (except `flutter/foundation.dart`)
**Validation Rule:** QR3
**Test Type:** Static / Lint

---

## TS-056 — Schema migration v1 to v2
**ID:** TS-056
**Title:** DB migrates from schemaVersion 1 to 2 without error
**Preconditions:** In-memory DB opened at schemaVersion 1 with existing skills/sessions rows
**Input:** Open DB with schemaVersion=2 and `onUpgrade` migration
**Expected Output:** No exception thrown; new columns present with correct defaults; existing rows preserved
**Validation Rule:** FR11
**Test Type:** Integration

---

## TS-057 — SkillMapper.toCompanion round-trip
**ID:** TS-057
**Title:** SkillMapper.toCompanion produces correct companion values
**Preconditions:** None
**Input:** `Skill(name: 'Chess', type: SkillType.strategy, isArchived: false, ...)`
**Expected Output:** `companion.name.value == 'Chess'`, `companion.type.value == 'strategy'`, `companion.isArchived.value == false`
**Validation Rule:** FR10
**Test Type:** Unit
