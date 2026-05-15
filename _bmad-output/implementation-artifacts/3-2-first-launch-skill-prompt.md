# Story 3.2: First-Launch Skill Prompt

Status: ready-for-dev

## Story

As a first-time user,
I want OdO to ask me one question on first launch,
so that I feel useful from minute one.

## Acceptance Criteria

1. When the home screen renders and `skills` table is empty, a bottom sheet appears automatically with text: *"What's one skill you're working on?"*
2. The sheet has exactly one `TextFormField` and one button labeled "Add it"
3. Submitting a non-empty skill name creates a `Skill` in the database and dismisses the sheet
4. After the first skill is created, the home screen shows the skill card (Story 3.3 implements the card)
5. The first-launch sheet never appears again once at least one skill exists
6. The sheet cannot be dismissed by tapping outside or pressing back (forces the user to add or tap a "Skip" option)
7. A "Skip" text button is available as a secondary option — tapping it dismisses the sheet and stores a flag in `SharedPreferences` so it never re-appears
8. Empty submission shows an inline validation error: *"Give your skill a name"*
9. Widget test: empty skills list → sheet shows; after add → sheet dismissed and skill visible

## Tasks / Subtasks

- [ ] Task 1: First-launch flag logic (AC: 5, 7)
  - [ ] `lib/features/practice/presentation/practice_providers.dart`
  - [ ] `shouldShowFirstLaunchPromptProvider`: `FutureProvider<bool>` — checks if skills count == 0 AND no `shared_preferences` skip flag
  - [ ] `markFirstLaunchPromptDone()`: sets `prefs.setBool('first_launch_prompt_done', true)`
- [ ] Task 2: First-launch bottom sheet widget (AC: 1–3, 6–8)
  - [ ] `lib/features/practice/presentation/widgets/first_launch_skill_sheet.dart`
  - [ ] `showModalBottomSheet` with `isDismissible: false`, `enableDrag: false`
  - [ ] `TextFormField` with `autofocus: true`, validator
  - [ ] "Add it" button → `practiceNotifier.addSkill(name)` → `markFirstLaunchPromptDone()` → `context.pop()`
  - [ ] "Skip" `TextButton` → `markFirstLaunchPromptDone()` → `context.pop()`
- [ ] Task 3: Auto-show on home screen (AC: 1, 5)
  - [ ] In `home_screen.dart`, watch `shouldShowFirstLaunchPromptProvider`
  - [ ] When `AsyncData(true)`, call `showModalBottomSheet` in `WidgetsBinding.instance.addPostFrameCallback`
- [ ] Task 4: `practiceNotifier.addSkill` (AC: 3)
  - [ ] Add to `PracticeNotifier` (see Story 3.3): `addSkill(String name)` creates `Skill` via repository
- [ ] Task 5: Widget test (AC: 9)
  - [ ] Mock `practiceRepositoryProvider` returning empty skills list
  - [ ] Verify sheet appears; tap "Add it" → verify `addSkill` called
- [ ] Task 6: Lint check

## Dev Notes

- **`isDismissible: false`:** Prevents accidental dismissal. `WillPopScope` or `PopScope` to block Android back button on the sheet.
- **Post-frame callback:** Never call `showModalBottomSheet` synchronously in `build` — always defer to `addPostFrameCallback` to avoid build-phase errors.
- **Skip vs Add:** Both paths call `markFirstLaunchPromptDone()` to prevent re-showing. Skip just doesn't create a skill.
- **Flag key:** `'first_launch_prompt_done'` — consistent with the skip flag. Alternatively, checking `skills.count == 0` at every launch is simpler but could re-show after a user deletes all skills (which is a valid UX concern — the flag prevents this).

### Project Structure Notes

```
lib/features/practice/presentation/
├── practice_providers.dart                 # shouldShowFirstLaunchPromptProvider
└── widgets/
    └── first_launch_skill_sheet.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-3.2] — acceptance criteria

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
