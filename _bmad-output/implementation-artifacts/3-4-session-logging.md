# Story 3.4: Session Logging

Status: ready-for-dev

## Story

As a user,
I want to log a session with a duration and optional note,
so that the system records my practice.

## Acceptance Criteria

1. The log-session bottom sheet (`/home/practice/log-session/:skillId`) has: duration (preset chips: 15/25/45/60 min + custom input), optional notes field, `started_at` time (defaults to now, editable)
2. The selected skill name is shown at the top of the sheet
3. Save commits to `sessions` table with `is_anchored` determined automatically: `0` if no overlapping practice event in the agenda exists, `1` if an overlapping `practice` event is found
4. Completion animation runs on save: `durationSlow` opacity + scale-down → sheet dismisses
5. Streak updates immediately after save (via reactive stream from `PracticeNotifier`)
6. Skill card's last-session line updates immediately after save
7. Custom duration input accepts a positive integer (minutes); validation rejects 0 or negative
8. `started_at` is editable: tapping the time opens `showTimePicker`
9. Form validation: duration required; skill ID must be valid
10. Widget tests: chip selection, custom duration input, save triggers correct notifier call

## Tasks / Subtasks

- [ ] Task 1: `is_anchored` detection logic (AC: 3)
  - [ ] Helper in `PracticeNotifier` or a use case: `_isAnchoredSession(DateTime startedAt, int durationMinutes)`
  - [ ] Calls `agendaRepositoryProvider.getEventsBetween(startMs, endMs)` filtered by `category == 'practice'`
  - [ ] Returns `true` if any such event overlaps the session time window
- [ ] Task 2: Log-session bottom sheet (AC: 1, 2, 4, 7–9)
  - [ ] `lib/features/practice/presentation/pages/log_session_sheet.dart`
  - [ ] Duration chips: `Wrap` of `FilterChip` with labels `'15 min'`, `'25 min'`, `'45 min'`, `'60 min'`
  - [ ] Custom chip: opens `TextField` (numeric keyboard) inline when selected
  - [ ] `started_at` row: `Text(formatTime(startedAt))` + edit icon → `showTimePicker`
  - [ ] Notes: optional `TextFormField`
  - [ ] Save button → calls `practiceNotifier.logSession(...)` → triggers completion animation → `context.pop()`
- [ ] Task 3: Completion animation (AC: 4)
  - [ ] Use `flutter_animate` package: `.animate().fadeOut(duration: durationSlow).scaleXY(end: 0.9, duration: durationSlow)`
  - [ ] Animation plays on the save button feedback, then sheet pops
- [ ] Task 4: `PracticeNotifier.logSession` (AC: 3, 5, 6)
  - [ ] Computes `isAnchored` via helper
  - [ ] Calls `practiceRepositoryProvider.insertSession(session)`
  - [ ] On success, triggers state refresh (stream auto-refreshes via Drift `watchAllSkills`)
- [ ] Task 5: Widget tests (AC: 10)
  - [ ] Select 25-min chip → verify value
  - [ ] Enter custom 90 → verify saved correctly
  - [ ] Mock repo save → verify notifier called
- [ ] Task 6: Lint check

## Dev Notes

- **`is_anchored` check:** Query events table for `category = 'practice'` events where `start_time <= session.startedAt.ms` AND `end_time >= session.startedAt.ms`. Use `agendaRepositoryProvider` (cross-feature dependency — acceptable in presentation layer via providers).
- **Sheet navigation:** Opened via long-press on `SkillCard` (`context.go('/home/practice/log-session/${skill.id}')`) or from `QuickAdd` menu. `GoRouterState.pathParameters['skillId']` provides the skill ID.
- **`flutter_animate` API:** `widget.animate().then(delay:...).fadeOut()` — chain effects. Use `onComplete` callback to call `context.pop()` after animation finishes.
- **Custom duration:** When "Custom" chip is selected, replace it with an inline `TextFormField(keyboardType: TextInputType.number)`. On submit, store the parsed value.

### Project Structure Notes

```
lib/features/practice/presentation/
├── pages/
│   └── log_session_sheet.dart
└── practice_providers.dart    # PracticeNotifier.logSession added here
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-3.4] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#SQLite-Schema] — is_anchored column logic

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
