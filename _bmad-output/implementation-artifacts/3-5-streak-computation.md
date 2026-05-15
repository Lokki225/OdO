# Story 3.5: Streak Computation

Status: ready-for-dev

## Story

As a developer,
I want a `StreakCalculator` that computes the current streak for a skill,
so that the card always shows correct numbers.

## Acceptance Criteria

1. `lib/features/practice/domain/usecases/streak_calculator.dart` defines `StreakCalculator` pure Dart class
2. `StreakCalculator.compute(List<Session> sessions, DateTime todayLocal) → int` is the only public method
3. The streak equals the number of consecutive days ending today (or yesterday with grace period until end-of-day) with at least one session
4. **Grace period:** Until end-of-day today, if yesterday has a session and today does not, streak is still counted (streak is not broken until midnight)
5. Algorithm handles UTC+0 storage with local-day boundaries: use `DateTime.fromMillisecondsSinceEpoch(...).toLocal()` for day comparisons
6. Unit tests cover all scenarios:
   - No sessions → streak = 0
   - Single session today → streak = 1
   - Sessions 3 consecutive days ending today → streak = 3
   - Session yesterday, none today (before midnight) → streak still counts yesterday
   - Gap in sessions (broke 4 days ago, session today) → streak = 1
   - Multiple sessions same day count as one day
7. `StreakCalculator` has no Flutter imports, no database imports — pure Dart only
8. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: Implement `StreakCalculator` (AC: 1–5, 7)
  - [ ] `lib/features/practice/domain/usecases/streak_calculator.dart`
  - [ ] Algorithm:
    1. Convert all `session.startedAt` to local calendar dates (strip time)
    2. Deduplicate to a `Set<DateTime>` of local dates only (year/month/day)
    3. Start from `todayLocal`; if today has a session, begin counting from today
    4. If today has no session but yesterday has one (grace period), begin from yesterday
    5. Walk backward day by day; stop when a day has no session
    6. Return count
- [ ] Task 2: Unit tests (AC: 6)
  - [ ] `test/features/practice/domain/usecases/streak_calculator_test.dart`
  - [ ] All 6 test scenarios
- [ ] Task 3: Wire into `PracticeNotifier` (replace stub from Story 3.3)
  - [ ] `PracticeNotifier` calls `StreakCalculator().compute(sessions, DateTime.now())` per skill
- [ ] Task 4: Lint check (AC: 8)

## Dev Notes

- **Pure Dart:** No `import 'package:flutter/...` — this allows testing without Flutter test framework.
- **Local day boundary:** `DateTime.fromMillisecondsSinceEpoch(ms, isUtc: false)` gives local time. Strip to date with `DateTime(dt.year, dt.month, dt.day)`.
- **Grace period logic:** If today has no session, try starting from yesterday. If yesterday has a session, count starts from yesterday's streak.
- **Sessions input:** Pass only sessions for the relevant skill — caller filters by `skillId` before calling `compute`.
- **Set comparison:** When building the date set, compare using `DateTime(y,m,d)` — not raw `DateTime` objects (which include time).

### Project Structure Notes

```
lib/features/practice/domain/usecases/
└── streak_calculator.dart

test/features/practice/domain/usecases/
└── streak_calculator_test.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-3.5] — acceptance criteria with timezone note

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
