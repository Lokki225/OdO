# Story 3.6: Unanchored Session Flagging

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to flag sessions that don't have corresponding calendar events,
So that the system can detect patterns later.

## Acceptance Criteria

**Given** session logging from Story 3.4
**When** a session is logged without a calendar event
**Then** `isAnchored` is set to false in the sessions table
**And** no UI prompt appears (silent flagging) (UX-DR9)
**And** the flag is stored for pattern detection
**And** the user never sees the flag until pattern is detected

## Tasks / Subtasks

- [ ] Implement unanchored flagging logic (AC: 1)
  - [ ] Modify session logging to set `isAnchored = false` by default
  - [ ] Add logic to check for corresponding calendar events
  - [ ] Set `isAnchored = true` only when session has matching agenda event
- [ ] Ensure silent operation (AC: 2)
  - [ ] No UI indication of anchored/unanchored status
  - [ ] No prompts or notifications about unanchored sessions
  - [ ] Flagging is completely transparent to user experience
- [ ] Store data for pattern detection (AC: 3-4)
  - [ ] Ensure `isAnchored` field is properly stored in SQLite
  - [ ] Add `suggested_time` field population when applicable
  - [ ] Verify data is available for future pattern detection queries

## Dev Notes

### Architecture Patterns and Constraints

- **Database Schema**: Uses existing `sessions.is_anchored` boolean field
- **Silent Operation**: No user-facing indication of anchored/unanchored status
- **Future Integration**: Data prepared for pattern detection in Story 3.7
- **Performance**: Efficient calendar event lookup for anchoring check

### Session Schema Integration

From architecture.md sessions table:
```sql
id, skill_id, started_at, duration_minutes,
notes, is_anchored, suggested_time
```

**Critical Fields:**
- `is_anchored`: Boolean flag (false for manual sessions, true when linked to calendar event)
- `suggested_time`: Timestamp when session was suggested by AI (null for manual sessions)
- `started_at`: Used for pattern detection timing analysis

### Anchoring Logic

**Default Behavior (Story 3.4):**
- Manual session logging always sets `isAnchored = false`
- No calendar event creation or prompting
- User logs session and it's automatically unanchored

**Future AI Suggestion Flow (Epic 5):**
- AI suggests practice session for specific time slot
- User accepts suggestion → creates calendar event + session with `isAnchored = true`
- `suggested_time` field populated with original suggestion timestamp

### UX Requirements

From epics.md UX specifications:
- **UX-DR9**: Unanchored sessions flagged silently until pattern detected — 3 sessions within 90-minute time-of-day window across at least 2 different calendar weeks. AI asks once. If dismissed, never asks again for that skill.

**Silent Operation Requirements:**
- No visual indicators on skill cards or session history
- No badges, icons, or status messages about anchored/unanchored
- User experience identical regardless of anchoring status
- Pattern detection triggers only after sufficient data collected

### Calendar Event Lookup Logic

**Anchoring Check Algorithm:**
1. Session logged with start time and duration
2. Query agenda for events in time window (±15 minutes tolerance)
3. If matching event found → set `isAnchored = true`
4. If no matching event → keep `isAnchored = false` (default)
5. Store session with appropriate anchoring flag

**Performance Considerations:**
- Efficient agenda event queries by time range
- Cache recent agenda data to avoid repeated database hits
- Minimal impact on session logging flow

### Source Tree Components to Touch

- `features/practice/data/practice_repository.dart` (modify logSession method)
- `features/practice/domain/models/session.dart` (ensure isAnchored field)
- `features/agenda/data/agenda_repository.dart` (query for event matching)
- Database schema (verify sessions.is_anchored column exists)

### Testing Standards Summary

- Unit tests for anchoring logic with various scenarios
- Test calendar event matching within tolerance windows
- Test default behavior (isAnchored = false for manual sessions)
- Verify no UI changes or user-visible indicators
- Integration test with session logging flow

### Project Structure Notes

Integration points with existing stories:
```
features/practice/data/
├── practice_repository.dart  # Modified: anchoring logic in logSession
└── practice_dao.dart        # Query unanchored sessions for pattern detection

features/agenda/data/
└── agenda_repository.dart   # Query events for anchoring check
```

**Data Flow:**
1. User logs session (Story 3.4)
2. System checks for matching calendar event (this story)
3. Sets `isAnchored` flag appropriately
4. Stores session in SQLite
5. Pattern detection runs on unanchored sessions (Story 3.7)

### Edge Cases to Handle

**Calendar Event Matching:**
- Multiple events in time window → match closest event
- Partial overlap with calendar events → match if significant overlap
- Events created after session logged → remain unanchored
- Session duration longer than calendar event → still considered anchored

**Time Window Tolerance:**
- ±15 minutes tolerance for matching
- Handle timezone edge cases consistently
- Session start time vs event start time comparison

### Future Pattern Detection Preparation

**Data Requirements for Story 3.7:**
- Query: `SELECT * FROM sessions WHERE skill_id = ? AND is_anchored = false`
- Time analysis: group by time-of-day window (90-minute tolerance)
- Pattern threshold: 3+ sessions across 2+ calendar weeks
- Enable AI suggestion for anchoring detected patterns

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.6: Unanchored Session Flagging]
- [Source: _bmad-output/planning-artifacts/epics.md#UX-DR9: Silent flagging requirements]
- [Source: _bmad-output/planning-artifacts/architecture.md#Sessions table schema]
- [Source: _bmad-output/planning-artifacts/prd.md#Journey 2: Spontaneous Practitioner]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
