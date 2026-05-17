# Practice Module — Domain Implementation Plan (Story 3.1)

## 1. SkillType Enum

**File:** `lib/features/practice/domain/entities/skill_type.dart`

| Value | `.value` string | AC ref |
|---|---|---|
| `language` | `'language'` | FR1 |
| `strategy` | `'strategy'` | FR1 |
| `physical` | `'physical'` | FR1 |
| `technical` | `'technical'` | FR1 |
| `creative` | `'creative'` | FR1 |
| `personal` | `'personal'` | FR1 |

**Implementation:**
```dart
enum SkillType {
  language, strategy, physical, technical, creative, personal;

  String get value => name; // enum name matches DB value exactly
}
```

**Imports allowed:** none (pure Dart)

---

## 2. Skill Entity

**File:** `lib/features/practice/domain/entities/skill.dart`

| Property | Type | Nullable | Validation | AC ref |
|---|---|---|---|---|
| `id` | `int?` | Yes | — | FR2 |
| `name` | `String` | No | `name.trim().isEmpty` → Failure | FR2, FR12 |
| `type` | `SkillType` | No | — | FR2 |
| `metricConfig` | `String?` | Yes | — | FR2 |
| `levelLabel` | `String?` | Yes | — | FR2 |
| `levelUpdatedAt` | `DateTime?` | Yes | — | FR2 |
| `sessionssSinceLevelUpdate` | `int` | No | — | FR2 |
| `createdAt` | `DateTime` | No | — | FR2 |
| `lastSessionAt` | `DateTime?` | Yes | — | FR2 |
| `isArchived` | `bool` | No | default false | FR2 |
| `suppressedUntil` | `DateTime?` | Yes | — | FR2 |

**Methods:**
- `validate()` → `Result<Skill>`: returns `Failure(AppError.validationFailed)` if `name.trim().isEmpty`, else `Success(this)` (FR12)
- `copyWith({...})` → `Skill`: all fields optional, returns new instance

**Imports allowed:** `package:flutter/foundation.dart` (`@immutable`), `core/types/result.dart`, `core/domain/app_error.dart`, `skill_type.dart`

---

## 3. Session Entity

**File:** `lib/features/practice/domain/entities/session.dart`

| Property | Type | Nullable | AC ref |
|---|---|---|---|
| `id` | `int?` | Yes | FR3 |
| `skillId` | `int` | No | FR3 |
| `startedAt` | `DateTime` | No | FR3 |
| `durationMinutes` | `int` | No | FR3 |
| `modeTags` | `List<String>` | No (empty list) | FR3 |
| `performanceMetric` | `double?` | Yes | FR3 |
| `feelScore` | `int?` | Yes | FR3 |
| `notes` | `String?` | Yes | FR3 |
| `isAnchored` | `bool` | No | FR3 |
| `suggestedTime` | `DateTime?` | Yes | FR3 |
| `isMilestone` | `bool` | No | FR3 |
| `milestoneLabel` | `String?` | Yes | FR3 |

**Methods:**
- `copyWith({...})` → `Session`

**Imports allowed:** `package:flutter/foundation.dart`, none else

---

## 4. PracticeRepository Interface

**File:** `lib/features/practice/domain/repositories/practice_repository.dart`

Abstract class only — no implementation. All methods documented in `1-data-implementation-plan.md §5`.

**Business rules expressed in interface:**
- `watchAllSkills()` returns ALL skills (including archived) — filtering is presentation concern (EC5)
- `addSession` contract implies atomic update of parent skill counters (IR3) — implementation detail of `PracticeRepositoryImpl`
- `getLastSession` returns `Success(null)` for a skill with zero sessions — not a Failure (EC2)
- `getUnanchoredSessions` implicitly limits to 3 (enforced in DAO, not interface)

**Imports allowed:** `skill.dart`, `session.dart`, `core/types/result.dart`

---

## 5. No Usecases in Story 3.1

Story 3.1 is the data/domain foundation layer. No business-logic usecases are required at this stage — the repository interface IS the domain contract. Usecases (streak computation, auto-detection, unanchored detection) belong to Stories 3.5, 3.6, 3.9 respectively.

---

## 6. Failure Types

All failures in Story 3.1 use existing `AppError` variants:

| Scenario | AppError | AC ref |
|---|---|---|
| DB write exception (insert, update, delete) | `AppError.databaseWriteFailed` | EH1, EH2 |
| Skill name is blank | `AppError.validationFailed` | FR12 |
| Unknown SkillType in DB | `ArgumentError` (not AppError — intentional crash) | EC3 |
