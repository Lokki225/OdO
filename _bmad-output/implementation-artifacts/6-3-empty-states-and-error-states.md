# Story 6.3: Empty States and Error States

Status: ready-for-dev

## Story

As a user,
I want every screen to handle empty and error states gracefully,
so that I never see a broken-looking app.

## Acceptance Criteria

1. Empty Agenda: persistent strip shows *"Nothing scheduled — free day"* (already in Story 2.2); timeline shows an illustration (simple SVG or icon) + `"Add your first event"` with a quick-add CTA button
2. Empty Practice: if user deletes all skills, shows *"No skills yet"* with a `+` add skill button (first-launch prompt already covers initial empty state)
3. Empty Chat: starter quick-command chips are visible (already in Story 4.3)
4. Offline AI: chat shows retry pattern; orb continues breathing (already in Stories 4.3, 4.5)
5. Database error: silent fallback to in-memory empty state for the affected screen; `debugPrint` the error to console; user sees the empty state, not a crash
6. No screen shows raw error stack traces or unstyled Flutter error widgets (no `ErrorWidget.builder` red screens)
7. Empty Glance Screen: no events + no suggestion → info cards section shows nothing (not a placeholder); this is a valid state, not an error
8. Global error widget override: `ErrorWidget.builder` is replaced with a styled fallback widget in `main.dart`
9. Widget tests: empty agenda → CTA visible; all screens tested with error state → styled fallback shown

## Tasks / Subtasks

- [ ] Task 1: Empty agenda timeline (AC: 1)
  - [ ] In `AgendaPage`: when `dayEventsProvider` returns empty list → show `EmptyTimelineWidget`
  - [ ] `EmptyTimelineWidget`: `Column(Icon(Icons.calendar_today_outlined), Text('Nothing here yet'), ElevatedButton('Add event', onPressed: () => context.go('/home/agenda/add-event')))`
- [ ] Task 2: Empty practice page (AC: 2)
  - [ ] In `PracticePage`: when `practiceNotifierProvider` returns empty list AND `shouldShowFirstLaunchPromptProvider` is false → show `EmptyPracticeWidget`
  - [ ] `EmptyPracticeWidget`: `Text('No skills yet') + IconButton(Icons.add, onPressed: () => context.go('/home/practice/add-skill'))`
- [ ] Task 3: Database error fallback (AC: 5)
  - [ ] In all `AsyncValue.when(error:)` handlers: log error with `debugPrint('DB error: $error\n$stackTrace')` and return the empty state widget (not an error widget)
  - [ ] Never re-throw database errors to the UI — empty state is always safer than an error screen
- [ ] Task 4: Global error widget override (AC: 6, 8)
  - [ ] In `main.dart`:
    ```dart
    ErrorWidget.builder = (details) => Scaffold(
      body: Center(child: Text('Something went wrong', style: textBody)),
    );
    ```
  - [ ] This catches any unhandled Flutter widget build errors and shows a styled fallback
- [ ] Task 5: `OdoErrorWidget` shared widget (AC: 6)
  - [ ] `lib/core/widgets/odo_error_widget.dart`
  - [ ] Used in all `AsyncValue.when(error:)` blocks that should not show empty state
  - [ ] Shows a calm message in `colorTextMuted` — no stack trace
- [ ] Task 6: Widget tests (AC: 9)
- [ ] Task 7: Lint check

## Dev Notes

- **Empty vs error:** Not all error states should show the error widget. Database read errors → show empty state. Database write errors → show a `ScaffoldMessenger.showSnackBar` with error message. Network errors → already handled by offline degradation (Story 4.5).
- **Illustration:** Use `Icon(Icons.calendar_today_outlined, size: 64, color: colorTextMuted)` as the placeholder illustration — no external SVG asset needed.
- **`ErrorWidget.builder` override:** Only catches Flutter widget build errors, not all app crashes. For crashless resilience, all `AsyncValue.when` handlers must cover `error:` explicitly — never use `AsyncValue.when(data:, loading:)` without `error:`.

### Project Structure Notes

```
lib/core/widgets/
└── odo_error_widget.dart

lib/features/agenda/presentation/widgets/
└── empty_timeline_widget.dart

lib/features/practice/presentation/widgets/
└── empty_practice_widget.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-6.3] — five empty/error scenarios

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List