# Story 3.7: Pattern Detection for Unanchored Sessions

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to detect when a user practices at similar times without calendar events,
So that the AI can suggest making it a recurring event.

## Acceptance Criteria

**Given** unanchored sessions from Story 3.6
**When** I create `features/practice/domain/pattern_detector.dart`
**Then** it detects pattern: 3+ unanchored sessions within 90-minute time window across 2+ different calendar weeks
**And** it returns skill_id and suggested_time if pattern detected
**And** it handles timezone correctly (UTC+0)
**And** the detector is called by SuggestionEngine (Epic 5)

## Tasks / Subtasks

- [ ] Create PatternDetector domain service (AC: 1-2)
  - [ ] Create `features/practice/domain/pattern_detector.dart`
  - [ ] Implement detectPracticePatterns() method
  - [ ] Define pattern criteria: 3+ sessions, 90-minute window, 2+ calendar weeks
  - [ ] Return PatternData with skill_id and suggested_time
- [ ] Implement time window analysis (AC: 2-3)
  - [ ] Group unanchored sessions by skill and time-of-day
  - [ ] Calculate 90-minute time windows for pattern matching
  - [ ] Handle UTC+0 timezone conversions correctly
  - [ ] Account for calendar week boundaries
- [ ] Integrate with future SuggestionEngine (AC: 4)
  - [ ] Design interface for Epic 5 integration
  - [ ] Ensure data format compatible with AI suggestion system
  - [ ] Prepare for cross-module pattern reporting

## Dev Notes

### Architecture Patterns and Constraints

- **Domain Logic**: Pure pattern analysis logic in domain layer
- **Data Source**: Unanchored sessions from PracticeRepository
- **Timezone Handling**: UTC+0 timezone as specified in architecture
- **Pattern Threshold**: Configurable criteria for pattern detection
- **Future Integration**: Prepared for SuggestionEngine in Epic 5

### Pattern Detection Algorithm

**Core Algorithm:**
1. Query unanchored sessions for specific skill
2. Extract time-of-day from each session (ignoring date)
3. Group sessions within 90-minute time windows
4. Count sessions in each time window
5. Check if sessions span 2+ different calendar weeks
6. Return pattern if threshold met (3+ sessions, 2+ weeks)

**Time Window Logic:**
```dart
// Example: Sessions at 19:15, 19:45, 20:30
// Window: 19:00-20:30 (90 minutes)
// Result: Pattern detected (3 sessions in window)
```

### Pattern Criteria (from UX-DR9)

From epics.md UX requirements:
- **Minimum Sessions**: 3 unanchored sessions
- **Time Window**: 90-minute time-of-day window
- **Calendar Spread**: At least 2 different calendar weeks
- **Skill Specific**: Pattern detection per skill (not across skills)

### PatternData Model

```dart
class PatternData {
  final String skillId;
  final DateTime suggestedTime;  // Median time of detected pattern
  final int sessionCount;        // Number of sessions in pattern
  final List<DateTime> sessionTimes; // All session times in pattern
  
  const PatternData({
    required this.skillId,
    required this.suggestedTime,
    required this.sessionCount,
    required this.sessionTimes,
  });
}
```

### Timezone Requirements

From architecture specifications:
- **NFR11**: UTC+0 timezone handling
- Session timestamps stored in UTC
- Time-of-day extraction must account for local timezone
- Calendar week calculation consistent with locale

### Source Tree Components to Touch

- `features/practice/domain/pattern_detector.dart` (NEW)
- `features/practice/domain/models/pattern_data.dart` (NEW)
- `features/practice/data/practice_repository.dart` (add unanchored session queries)
- `features/practice/data/practice_dao.dart` (add time-based queries)

### Testing Standards Summary

- Unit tests for pattern detection with various session distributions
- Test edge cases: exactly 3 sessions, sessions spanning multiple weeks
- Test timezone boundary conditions (midnight, week boundaries)
- Test pattern detection with insufficient data (should return empty)
- Performance test with large session datasets

### Project Structure Notes

Domain logic expansion:
```
features/practice/domain/
├── pattern_detector.dart    # NEW: Core pattern detection
├── models/
│   ├── pattern_data.dart   # NEW: Pattern result model
│   └── streak_data.dart    # Existing from Story 3.5
├── streak_calculator.dart   # Existing from Story 3.5
└── practice_repository.dart # Interface
```

**Integration with Epic 5:**
- SuggestionEngine will call PatternDetector
- Detected patterns become suggestion candidates
- AI contextualizes patterns for proactive notifications

### Database Query Requirements

**Unanchored Session Query:**
```sql
SELECT skill_id, started_at, duration_minutes 
FROM sessions 
WHERE skill_id = ? AND is_anchored = false 
ORDER BY started_at DESC
```

**Time Window Analysis:**
- Extract hour/minute from started_at timestamps
- Group by time ranges (90-minute windows)
- Count sessions per window per skill
- Calculate calendar week numbers for span analysis

### Performance Considerations

**Optimization Strategies:**
- Limit query to recent sessions (e.g., last 90 days)
- Cache pattern detection results per skill
- Only recalculate when new unanchored sessions added
- Efficient time window grouping algorithms

### Future Epic 5 Integration Points

**SuggestionEngine Interface:**
- Method: `List<PatternData> detectAllSkillPatterns()`
- Called during proactive suggestion generation
- Pattern data feeds into AI context for suggestion text
- One-time AI prompt per detected pattern (per UX-DR9)

**AI Suggestion Flow:**
1. SuggestionEngine detects free calendar slots
2. PatternDetector identifies unanchored practice patterns
3. AI matches patterns to available slots
4. Generates suggestion: "Block recurring practice time?"

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.7: Pattern Detection for Unanchored Sessions]
- [Source: _bmad-output/planning-artifacts/epics.md#UX-DR9: Pattern detection criteria]
- [Source: _bmad-output/planning-artifacts/architecture.md#NFR11: UTC+0 timezone]
- [Source: _bmad-output/planning-artifacts/prd.md#Journey 2: Spontaneous Practitioner pattern detection]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
