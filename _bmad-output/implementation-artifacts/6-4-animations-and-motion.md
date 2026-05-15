# Story 6.4: Animations and Motion

Status: ready-for-dev

## Story

As a user,
I want OdO to feel alive but never frantic,
so that interactions feel intentional.

## Acceptance Criteria

1. Orb breathing animation is at ~12 BPM (5-second cycle) — already specified in Story 5.3; this story verifies and tunes
2. Session completion animation: `durationSlow` (500ms) opacity fade + scale-down from 1.0 → 0.9, then sheet dismisses
3. Bottom sheet open/close: `durationDefault` (300ms) with `Curves.easeInOut` slide-up curve
4. Confirmation sheet uses `durationSlow` (500ms) for its appearance
5. `MediaQuery.disableAnimations` disables all non-essential motion; orb becomes static; sheets open/close instantly
6. No animation feels like a loading spinner or a "waiting" state — all animations communicate state change, not pending work
7. `flutter_animate` package is used for all non-orb animations (already in pubspec)
8. All animations respect the `durationFast/Default/Slow` constants from `app_durations.dart` — no hardcoded `Duration` values in widget files
9. Widget test: `MediaQuery.disableAnimations = true` → animated widgets produce static output

## Tasks / Subtasks

- [ ] Task 1: Session completion animation (AC: 2)
  - [ ] In `LogSessionSheet` save path (Story 3.4): apply `.animate().fadeOut(duration: durationSlow).scaleXY(end: 0.9, duration: durationSlow)` to the sheet content
  - [ ] On `onComplete`: call `context.pop()`
- [ ] Task 2: Bottom sheet custom animation (AC: 3)
  - [ ] In `router.dart`, for all bottom sheet routes, use `CustomTransitionPage` with `SlideTransition(position: Tween<Offset>(begin: Offset(0,1), end: Offset.zero).animate(CurvedAnimation(curve: Curves.easeInOut, parent: animation)))` with `durationDefault`
- [ ] Task 3: Confirmation sheet animation (AC: 4)
  - [ ] Same `CustomTransitionPage` as Task 2 but with `durationSlow` — gives the suggestion sheet a slightly more deliberate feel
- [ ] Task 4: `disableAnimations` audit (AC: 5)
  - [ ] For `flutter_animate`: wrap in `if (!MediaQuery.disableAnimationsOf(context)) widget.animate()... else widget`
  - [ ] For `AnimationController`-based widgets (Orb): already handled in Story 5.3
  - [ ] Audit all animated widgets; add the check where missing
- [ ] Task 5: Duration constant audit (AC: 8)
  - [ ] `grep -r "Duration(milliseconds" lib/` — replace all hardcoded values with named constants
  - [ ] `grep -r "Duration(seconds" lib/` — review each; most should be `durationSlow` or a named constant
- [ ] Task 6: Widget tests (AC: 9)
- [ ] Task 7: Lint check

## Dev Notes

- **`flutter_animate` conditional:** `context.disableAnimations` helper:
  ```dart
  extension on BuildContext {
    bool get disableAnimations => MediaQuery.disableAnimationsOf(this);
  }
  ```
  Use `disableAnimations ? widget : widget.animate()...` pattern.
- **"Never frantic" principle:** Maximum 1 concurrent animation per screen. Never auto-play multiple animations simultaneously. Each animation completes before the next starts.
- **`Curves.easeInOut`:** Standard for all UI transitions. Only the session completion uses a custom curve feel (scale-down implies "going away").
- **Orb breathing at 12 BPM:** Verify 5s cycle with physical timer in debug mode. Adjust `AnimationController.duration` if it feels too fast or slow.

### Project Structure Notes

Changes are spread across existing files:
- `lib/features/practice/presentation/pages/log_session_sheet.dart` (Task 1)
- `lib/app/router.dart` (Tasks 2, 3)
- `lib/core/widgets/orb.dart` (verify Task 4)
- All animated widget files (Task 4)

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-6.4] — animation specs
- [Source: 1-3-theme-system-with-runtime-swap.md] — durationFast/Default/Slow constants

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List