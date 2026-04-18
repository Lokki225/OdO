# Story 3.3: First-Launch Skill Prompt

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a new user,
I want to be asked "What's one skill you're working on?" on first launch,
So that I can create my first skill without friction.

## Acceptance Criteria

**Given** the app is launched for the first time
**When** the Practice module loads and no skills exist
**Then** a bottom sheet appears with the question "What's one skill you're working on?"
**And** the sheet has a free-text input field (no categories)
**And** tapping "Create" creates the skill and dismisses the sheet
**And** the skill card appears immediately in the Practice module
**And** this prompt never appears again (flag in SharedPreferences)

## Tasks / Subtasks

- [ ] Create first-launch detection logic (AC: 1)
  - [ ] Check SharedPreferences for first-launch flag
  - [ ] Check if Practice module has zero skills
  - [ ] Trigger prompt only when both conditions met
- [ ] Create first-launch bottom sheet (AC: 2-3)
  - [ ] Create `features/practice/presentation/widgets/first_launch_sheet.dart`
  - [ ] Implement question text: "What's one skill you're working on?"
  - [ ] Add free-text input field (no categories/dropdowns)
  - [ ] Add "Create" button with validation
- [ ] Implement skill creation flow (AC: 4)
  - [ ] Validate input is not empty
  - [ ] Create skill using PracticeRepository
  - [ ] Dismiss sheet after successful creation
  - [ ] Ensure skill card appears immediately in Practice module
- [ ] Implement persistence flag (AC: 5)
  - [ ] Set SharedPreferences flag after first skill creation
  - [ ] Ensure prompt never shows again for this user
  - [ ] Handle edge cases (app uninstall/reinstall)

## Dev Notes

### Architecture Patterns and Constraints

- **State Management**: Riverpod for skill creation and UI state
- **Navigation**: go_router for bottom sheet as route
- **Persistence**: SharedPreferences for first-launch flag
- **Input Validation**: Basic text validation (non-empty)
- **Error Handling**: AsyncValue pattern for creation errors

### First-Launch Requirements

From epics.md functional requirements:
- **FR21**: Single first-launch bottom sheet asking "What's one skill you're working on?" — free text, no categories, creates first skill card
- **UX-DR15**: Minimal UI approach - simple question, single input, single action

### UX Design Specifications

**Bottom Sheet Design:**
- Modal bottom sheet (blocks interaction with background)
- Clean, minimal design with clear hierarchy
- Question text prominently displayed
- Single text input field with focus on appear
- Primary "Create" button (colorAccentPractice theme)
- No close/cancel button (user must create skill)

**Interaction Flow:**
1. User opens app for first time
2. Practice module loads, detects no skills
3. Bottom sheet slides up automatically
4. User types skill name and taps "Create"
5. Sheet dismisses, skill appears in Practice module
6. Flag set in SharedPreferences

### Source Tree Components to Touch

- `features/practice/presentation/widgets/first_launch_sheet.dart` (NEW)
- `features/practice/presentation/practice_slide.dart` (modify for detection)
- `features/practice/presentation/practice_providers.dart` (add creation logic)
- `core/services/shared_prefs_service.dart` (create if needed)

### SharedPreferences Key

```dart
static const String firstLaunchCompleted = 'first_launch_completed';
```

### Testing Standards Summary

- Widget test for first launch sheet UI
- Integration test for skill creation flow
- Test SharedPreferences flag persistence
- Test that prompt doesn't appear after first skill created
- Test edge case: empty input validation

### Project Structure Notes

Integration with existing Practice module:
```
features/practice/presentation/
├── practice_slide.dart          # Modified: first-launch detection
├── widgets/
│   ├── skill_card.dart         # Existing from Story 3.2
│   └── first_launch_sheet.dart # NEW: first launch prompt
└── practice_providers.dart     # Modified: skill creation
```

**Critical Integration Points:**
- Practice module empty state detection (Story 3.2)
- Skill creation via PracticeRepository (Story 3.1)
- Immediate UI update after skill creation
- Bottom sheet navigation via go_router

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.3: First-Launch Skill Prompt]
- [Source: _bmad-output/planning-artifacts/epics.md#FR21: First-launch requirements]
- [Source: _bmad-output/planning-artifacts/architecture.md#Navigation patterns]
- [Source: _bmad-output/planning-artifacts/prd.md#User Journeys]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
