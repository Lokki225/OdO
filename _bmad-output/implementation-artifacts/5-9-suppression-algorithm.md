# Story 5.9: Suppression Algorithm

Status: ready-for-dev

## Story

As a developer,
I want `SuggestionEngine` to respect suppression windows,
so that the user is never re-suggested something they just dismissed.

## Acceptance Criteria

1. When a suggestion outcome is recorded, `suppressed_until` is set:
   - Accepted: `now + 1 day`
   - Dismissed: `now + 3 days`
   - Thumbs-down: `now + 7 days`
2. `SuggestionEngine.generate()` filters out any skill where `suppressed_until > now()`
3. Suppression is per-skill — suppressing one skill does not suppress others
4. `suppressed_until` is stored in the `suggestions` table (already defined in Story 1.4)
5. If a skill has multiple suggestion rows, the most recent `suppressed_until` value is used for filtering
6. Unit tests verify each window:
   - After accept: skill suppressed for exactly 1 day
   - After dismiss: skill suppressed for exactly 3 days
   - After thumbs-down: skill suppressed for exactly 7 days
   - After suppression expires: skill appears again in generate()

## Tasks / Subtasks

- [ ] Task 1: Verify outcome recording in `ConfirmationSheetNotifier` (AC: 1)
  - [ ] `confirmSuggestion`: `acceptedAt = now.ms`, `suppressedUntil = now.ms + 86400000` (1 day)
  - [ ] `dismissSuggestion`: `dismissedAt = now.ms`, `suppressedUntil = now.ms + 259200000` (3 days)
  - [ ] `thumbsDownSuggestion`: `thumbsDownAt = now.ms`, `suppressedUntil = now.ms + 604800000` (7 days)
  - [ ] These durations in ms: 1 day = 86,400,000; 3 days = 259,200,000; 7 days = 604,800,000
- [ ] Task 2: `SuggestionEngine` suppression filter (AC: 2, 5)
  - [ ] `_isSuppressed(int skillId, List<Suggestion> existingSuggestions, DateTime now) → bool`
  - [ ] Find most recent `suppressedUntil` for the skill; return `suppressedUntil > now.ms`
  - [ ] `generate()` calls this filter before including a skill as idle candidate
- [ ] Task 3: `SuggestionDao` suppression query (AC: 5)
  - [ ] `getLatestSuppressedUntil(int skillId) → Future<int?>` — `SELECT MAX(suppressed_until) FROM suggestions WHERE skill_id = ?`
- [ ] Task 4: Unit tests (AC: 6)
  - [ ] `test/features/proactive/domain/usecases/suggestion_engine_suppression_test.dart`
  - [ ] Test all 4 scenarios: accept, dismiss, thumbs-down, expiry
- [ ] Task 5: Lint check

## Dev Notes

- **Epoch ms durations:** Hard-coded as constants: `const kSuppressAccepted = 86400000`, `kSuppressDismissed = 259200000`, `kSuppressThumbsDown = 604800000`. Define in `lib/core/constants/ai_constants.dart`.
- **Most recent suppression:** A skill may have multiple past suggestions (each with their own `suppressed_until`). Take the MAX — if even the most recent suppression has expired, the skill is available.
- **`SuggestionEngine.generate()` is pure:** It receives `existingSuggestions` as input (pre-fetched). The suppression filter runs entirely on that in-memory list — no additional DB calls inside `generate()`.
- **Consistency with Story 5.7:** `ConfirmationSheetNotifier` sets these values (Story 5.7, Task 1). This story just adds the filter in `SuggestionEngine` and the unit tests to verify correctness.

### Project Structure Notes

```
lib/features/proactive/
├── data/suggestion_dao.dart         # getLatestSuppressedUntil added
└── domain/usecases/suggestion_engine.dart  # _isSuppressed filter added

lib/core/constants/ai_constants.dart # suppression duration constants
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.9] — suppression durations
- [Source: _bmad-output/planning-artifacts/architecture.md#SQLite-Schema] — suppressed_until column note

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List