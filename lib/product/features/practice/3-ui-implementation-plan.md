# Practice Module — UI Implementation Plan (Story 3.1)

## Story 3.1 Scope

Story 3.1 is **data and domain only** — no UI screens, widgets, or pages are created in this story. The presentation layer for Practice starts in Story 3.2 (First-Launch Skill Prompt) and Story 3.3 (Skill Card).

---

## Providers Created in Story 3.1

These providers are minimal "plumbing" providers created now so that Stories 3.2+ can consume them without modification.

**File:** `lib/features/practice/presentation/practice_providers.dart`

| Provider | Type | Riverpod Pattern | Depends On |
|---|---|---|---|
| `practiceDaoProvider` | `Provider<PracticeDao>` | `Provider` | `appDatabaseProvider` |
| `practiceRepositoryProvider` | `Provider<PracticeRepository>` | `Provider` | `practiceDaoProvider` |
| `allSkillsProvider` | `StreamProvider<List<Skill>>` | `StreamProvider` | `practiceRepositoryProvider` |

**Note:** `allSkillsProvider` wraps `practiceRepository.watchAllSkills()` which returns `Stream<List<Skill>>`. The stream never emits errors (errors are caught inside the repository stream map). Any `ArgumentError` from an unknown SkillType will be caught and the stream will emit an empty list to protect the UI.

---

## UI Stories That Depend on This Foundation

| Story | File(s) | Consumes |
|---|---|---|
| 3.2 — First-Launch Skill Prompt | `lib/features/practice/presentation/pages/first_launch_sheet.dart` | `practiceRepositoryProvider`, `allSkillsProvider` |
| 3.3 — Skill Card | `lib/features/practice/presentation/widgets/skill_card.dart` | `allSkillsProvider`, `Skill` entity |
| 3.4 — Session Logging | `lib/features/practice/presentation/pages/session_logging_page.dart` | `practiceRepositoryProvider`, `Session` entity, `SkillType` |
| 3.5 — Streak Computation | `lib/features/practice/domain/usecases/compute_streak.dart` | `Session` list from `practiceRepositoryProvider` |
| 3.6 — Auto-Detection | `lib/features/practice/domain/usecases/detect_skill_type.dart` | `SkillType` enum |
| 3.7 — Evolution View | `lib/features/practice/presentation/pages/evolution_page.dart` | `practiceRepositoryProvider`, `Skill`, `Session` |
| 3.8 — Level Check-In | Extends `practice_providers.dart` | `Skill.sessionssSinceLevelUpdate`, `Skill.levelLabel` |
| 3.9 — Unanchored Detection | `lib/features/practice/domain/usecases/detect_unanchored.dart` | `Session.isAnchored`, `Session.suggestedTime` |

---

## Navigation (Reference for Story 3.3+)

The Practice tab is already registered in `lib/app/router.dart`:
- `/home/practice` → `PracticePage` (placeholder, to be replaced in Story 3.3)
- `/home/practice/skill/:id` → skill detail / evolution view (Story 3.7)
- `/home/practice/log/:skillId` → session logging sheet (Story 3.4)

No router changes are required for Story 3.1.
