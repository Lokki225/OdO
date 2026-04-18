# Story 3.5: Streak Computation and Display

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see my streak for each skill (consecutive days practiced),
So that I'm motivated to maintain the streak.

## Acceptance Criteria

**Given** session data in SQLite
**When** I create `features/practice/domain/streak_calculator.dart`
**Then** it calculates consecutive days from most recent session backwards
**And** it handles timezone correctly (UTC+0)
**And** it returns current streak count and last session date
**And** the streak bar on skill cards updates reactively
**And** the bar fills proportionally (7-day max for MVP)

## Tasks / Subtasks

- [ ] Create StreakCalculator domain service (AC: 1-3)
  - [ ] Create `features/practice/domain/streak_calculator.dart`
  - [ ] Implement calculateCurrentStreak(sessions) method
  - [ ] Calculate consecutive days from most recent session backwards
  - [ ] Handle UTC+0 timezone correctly for date comparison
  - [ ] Return StreakData object with count and last session date
- [ ] Integrate with skill card display (AC: 4-5)
  - [ ] Update SkillCard widget to use StreakCalculator
  - [ ] Implement reactive updates when sessions change
  - [ ] Show streak bar with proportional fill (7-day maximum)
  - [ ] Display current streak count and last session date
- [ ] Handle edge cases
  - [ ] No sessions (streak = 0)
  - [ ] Single session (streak = 1)
  - [ ] Gap in sessions (streak resets)
  - [ ] Sessions on same day (count as single day)

## Dev Notes

### Architecture Patterns and Constraints

- **Domain Logic**: Pure calculation logic in domain layer
- **Timezone Handling**: UTC+0 as specified in architecture
- **State Management**: Reactive updates via Riverpod providers
- **Data Source**: Session data from SQLite via PracticeRepository
- **Performance**: Efficient calculation for real-time UI updates

### Streak Calculation Algorithm

**Core Logic:**
1. Sort sessions by `started_at` timestamp (most recent first)
2. Extract date component from each session (ignore time)
3. Count consecutive days backwards from most recent
4. Handle same-day sessions (multiple sessions = 1 day)
5. Stop counting at first gap in consecutive days

**Example Calculation:**
```dart
Sessions: [Day 5, Day 4, Day 3, Day 1] // Day 2 missing
Result: Streak = 3 (Days 5, 4, 3), Gap at Day 2
```

### Timezone Requirements

From architecture specifications:
- **NFR11**: UTC+0 timezone handling
- Date comparison must be consistent across device timezone changes
- Session timestamps stored in UTC, converted to local date for streak calculation

### StreakData Model

```dart
class StreakData {
  final int currentStreak;
  final DateTime? lastSessionDate;
  final List<bool> last7Days; // For visual bar display
  
  const StreakData({
    required this.currentStreak,
    this.lastSessionDate,
    required this.last7Days,
  });
}
```

### Visual Requirements

From UX specifications:
- **UX-DR14**: Streak indicator should feel emotionally significant and worth protecting
- **UX-DR22**: Use colorAccentPractice for streak bar
- **7-day maximum**: Bar shows last 7 days with proportional fill
- **Animation**: Smooth updates when streak changes

### Source Tree Components to Touch

- `features/practice/domain/streak_calculator.dart` (NEW)
- `features/practice/domain/models/streak_data.dart` (NEW)
- `features/practice/presentation/widgets/skill_card.dart` (modify for streak display)
- `features/practice/presentation/practice_providers.dart` (add streak provider)

### Testing Standards Summary

- Unit tests for StreakCalculator with various session patterns
- Test timezone edge cases (midnight boundaries)
- Test consecutive vs non-consecutive sessions
- Test empty sessions list and single session
- Widget test for streak bar visual display

### Project Structure Notes

Domain logic separation:
```
features/practice/domain/
├── streak_calculator.dart  # NEW: Core calculation logic
├── models/
│   └── streak_data.dart   # NEW: Streak data model
└── practice_repository.dart # Existing interface
```

**Integration with UI:**
- SkillCard widget calls streak calculation
- Provider watches session changes and recalculates
- Reactive updates ensure UI stays current
- Performance optimization for frequent calculations

### Performance Considerations

**Optimization Strategies:**
- Cache streak calculations per skill
- Only recalculate when sessions change for that skill
- Efficient date comparison algorithms
- Limit calculation window (e.g., last 30 days max)

### Edge Cases to Handle

**Session Patterns:**
- Multiple sessions on same day → count as 1 day
- Sessions at midnight boundary → correct date assignment
- Long gaps between sessions → streak resets to recent consecutive days
- Deleted sessions → recalculate affected streaks

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.5: Streak Computation and Display]
- [Source: _bmad-output/planning-artifacts/epics.md#UX-DR14: Streak significance]
- [Source: _bmad-output/planning-artifacts/architecture.md#NFR11: UTC+0 timezone]
- [Source: _bmad-output/planning-artifacts/architecture.md#Sessions table schema]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
