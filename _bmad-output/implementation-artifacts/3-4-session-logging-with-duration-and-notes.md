# Story 3.4: Session Logging with Duration and Notes

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to log a practice session with duration and optional notes,
So that I can track my practice history.

## Acceptance Criteria

**Given** a skill card from Story 3.2 and PracticeRepository from Story 3.1
**When** I tap the card and open the session logging sheet
**Then** the sheet shows: duration input (minutes), optional notes field, "Log Session" button
**And** the sheet has quick-select buttons for common durations (15, 30, 45, 60 min)
**And** tapping "Log Session" creates the session in SQLite with isAnchored = false
**And** the sheet dismisses with completion animation (400ms, scale-down effect) (UX-DR12)
**And** the skill card updates immediately with new streak and last session date
**And** the session is logged without prompting for calendar event

## Tasks / Subtasks

- [ ] Create session logging sheet UI (AC: 1-2)
  - [ ] Create `features/practice/presentation/widgets/session_logging_sheet.dart`
  - [ ] Add duration input field (minutes)
  - [ ] Add optional notes text field
  - [ ] Add quick-select duration buttons (15, 30, 45, 60 min)
  - [ ] Add "Log Session" primary action button
- [ ] Implement session creation logic (AC: 3)
  - [ ] Validate duration input (positive number)
  - [ ] Create session with isAnchored = false
  - [ ] Use PracticeRepository.logSession() method
  - [ ] Handle success and error states
- [ ] Implement completion animation (AC: 4)
  - [ ] 400ms scale-down animation on completion
  - [ ] Use durationSlow from theme system
  - [ ] Auto-dismiss sheet after animation
- [ ] Update UI reactively (AC: 5)
  - [ ] Skill card updates immediately with new data
  - [ ] Show updated streak and last session date
  - [ ] No manual refresh required

## Dev Notes

### Architecture Patterns and Constraints

- **UI Framework**: Flutter bottom sheet with Material Design 3
- **State Management**: Riverpod for session creation and reactive updates
- **Navigation**: go_router bottom sheet as route
- **Animation**: Custom completion animation with scale transform
- **Data Flow**: Session logged → Repository update → Provider notification → UI update

### UX Design Requirements

From epics.md UX specifications:
- **UX-DR8**: Session logging feels like completion, not a prompt for more
- **UX-DR12**: Completion animation 400ms (durationSlow) with scale-down effect
- **UX-DR21**: Completion sheet dismisses with Navigator.pop() after 400ms animation
- **UX-DR24**: Spacing scale (sp2, sp4, sp8, sp12, sp16, sp20, sp24)

### Session Data Requirements

**Session Schema** (from architecture.md):
```sql
id, skill_id, started_at, duration_minutes,
notes, is_anchored, suggested_time
```

**Critical Fields for This Story:**
- `skill_id`: From the tapped skill card
- `started_at`: Current timestamp when session logged
- `duration_minutes`: User input from duration field
- `notes`: Optional user input
- `is_anchored`: Always false for manual sessions (no calendar event)
- `suggested_time`: null (not from AI suggestion)

### Quick-Select Duration Design

**Button Layout:**
- Horizontal row of duration chips
- Common practice durations: 15, 30, 45, 60 minutes
- Tapping duration chip fills the input field
- Custom duration can still be typed manually
- Visual feedback on selection

### Completion Animation Specifications

**Animation Details:**
- Duration: 400ms (durationSlow from theme)
- Effect: Scale-down transform (1.0 → 0.95 → dismiss)
- Timing: Material motion easing curve
- Trigger: After successful session creation
- Sequence: Animate → Navigator.pop()

### Source Tree Components to Touch

- `features/practice/presentation/widgets/session_logging_sheet.dart` (NEW)
- `features/practice/presentation/widgets/skill_card.dart` (modify tap gesture)
- `features/practice/presentation/practice_providers.dart` (session creation logic)
- `features/practice/data/practice_repository.dart` (logSession method)

### Testing Standards Summary

- Widget test for session logging sheet UI
- Test quick-select duration buttons
- Test session creation with valid/invalid inputs
- Test completion animation timing
- Integration test: tap skill → log session → see updated card

### Project Structure Notes

Integration with existing components:
```
features/practice/presentation/
├── widgets/
│   ├── skill_card.dart            # Modified: add tap gesture
│   ├── session_logging_sheet.dart # NEW: session logging UI
│   └── first_launch_sheet.dart    # Existing from Story 3.3
└── practice_providers.dart        # Modified: session creation
```

**Navigation Flow:**
1. User taps skill card (Story 3.2)
2. go_router navigates to session logging sheet
3. User fills duration/notes and taps "Log Session"
4. Session created via PracticeRepository (Story 3.1)
5. Completion animation plays
6. Sheet dismisses, skill card updates reactively

### Error Handling

**Validation Rules:**
- Duration must be positive number (> 0)
- Notes are optional (can be empty)
- Show inline validation errors
- Disable "Log Session" button for invalid input

**Error States:**
- Database write failure
- Network-related errors (should not apply for local SQLite)
- Invalid input handling with user feedback

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.4: Session Logging with Duration and Notes]
- [Source: _bmad-output/planning-artifacts/epics.md#UX-DR8, UX-DR12, UX-DR21]
- [Source: _bmad-output/planning-artifacts/architecture.md#Sessions Table Schema]
- [Source: _bmad-output/planning-artifacts/prd.md#Practice module requirements]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
