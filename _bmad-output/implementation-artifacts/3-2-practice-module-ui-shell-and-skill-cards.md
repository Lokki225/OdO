# Story 3.2: Practice Module UI Shell and Skill Cards

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see my skills as cards in the Practice module,
So that I can track and interact with each skill.

## Acceptance Criteria

**Given** the Practice module specification (FR4) and PracticeRepository from Story 3.1
**When** I create `features/practice/presentation/practice_slide.dart` and `features/practice/presentation/widgets/skill_card.dart`
**Then** each skill card shows: skill name, streak (7-day bar), last session date, session count
**And** the streak bar is visually significant and feels worth protecting (UX-DR14)
**And** tapping a card opens session logging sheet
**And** cards are displayed in a scrollable list
**And** the module handles empty state (no skills) with first-launch prompt

## Tasks / Subtasks

- [ ] Create Practice slide UI shell (AC: 1)
  - [ ] Create `features/practice/presentation/practice_slide.dart`
  - [ ] Implement scrollable container for skill cards
  - [ ] Handle loading and error states
  - [ ] Integrate with main app carousel
- [ ] Create Skill Card widget (AC: 2-3)
  - [ ] Create `features/practice/presentation/widgets/skill_card.dart`
  - [ ] Display skill name prominently
  - [ ] Implement 7-day streak bar visualization
  - [ ] Show last session date with proper formatting
  - [ ] Display total session count
  - [ ] Add tap gesture to open session logging
- [ ] Implement streak bar visualization (AC: 2)
  - [ ] Create visually significant streak bar (worth protecting feel)
  - [ ] 7-day maximum display with proportional fill
  - [ ] Use accent colors from theme system
  - [ ] Animate streak updates
- [ ] Handle empty state (AC: 4)
  - [ ] Detect when no skills exist
  - [ ] Show appropriate empty state message
  - [ ] Integrate with first-launch prompt (Story 3.3 dependency)

## Dev Notes

### Architecture Patterns and Constraints

- **UI Framework**: Flutter with Material Design 3
- **State Management**: Riverpod providers with AsyncValue for reactive updates
- **Theme System**: Two-layer color tokens (raw palette → semantic tokens)
- **Navigation**: Tap gestures trigger session logging sheet via go_router
- **Animation**: Use defined durations (durationFast: 150ms, durationDefault: 250ms, durationSlow: 400ms)

### UX Design Requirements

From epics.md UX requirements:
- **UX-DR14**: Streak indicator should feel emotionally significant and worth protecting
- **UX-DR15**: Minimal UI with persistent Agenda strip, one-slide carousel, persistent AI component
- **UX-DR22**: Two-layer colour token system with semantic tokens (colorAccentPractice)
- **UX-DR23**: System fonts (SF Pro / Roboto) with tabular figures for clock display
- **UX-DR24**: Spacing scale (sp2, sp4, sp8, sp12, sp16, sp20, sp24)

### Streak Bar Design Specifications

**Visual Design:**
- 7 segments representing days
- Filled segments show consecutive practice days
- Emotionally significant colors (success green, accent orange)
- Subtle animations when streak updates
- Clear visual hierarchy (more prominent than session count)

**Data Requirements:**
- Current streak count from StreakCalculator (Story 3.5)
- Last session date for display
- Total session count for secondary info

### Source Tree Components to Touch

- `features/practice/presentation/practice_slide.dart` (NEW)
- `features/practice/presentation/widgets/skill_card.dart` (NEW)
- `features/practice/presentation/practice_providers.dart` (dependency from Story 3.8)
- `core/constants/app_colors.dart` (reference for colorAccentPractice)
- `app/theme.dart` (reference for spacing and typography)

### Testing Standards Summary

- Widget tests for SkillCard component
- Test tap gestures and navigation
- Test empty state handling
- Test streak bar visualization with different streak values
- Integration test with PracticeRepository mock data

### Project Structure Notes

Following confirmed architecture structure:
```
features/practice/presentation/
├── practice_slide.dart      # Main Practice module UI
├── widgets/
│   └── skill_card.dart     # Individual skill card widget
└── practice_providers.dart # Riverpod providers (Story 3.8)
```

**Integration Points:**
- Main app carousel integration (app/app_shell.dart)
- Session logging sheet navigation (Story 3.4)
- First-launch prompt integration (Story 3.3)
- Streak computation display (Story 3.5)

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.2: Practice Module UI Shell and Skill Cards]
- [Source: _bmad-output/planning-artifacts/epics.md#UX Design Requirements]
- [Source: _bmad-output/planning-artifacts/architecture.md#Theme System]
- [Source: _bmad-output/planning-artifacts/prd.md#Practice module requirements]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
