# Story 5.8: Background Tasks (8pm + Pre-Event + Throughout-Day)

Status: ready-for-dev

## Story

As a user,
I want OdO to nudge me at the right moments without me opening the app,
so that the daily rhythm runs on its own.

## Acceptance Criteria

1. An 8pm local-time task fires a notification: *"Your evening with OdO is ready"*
2. 5-minute pre-event reminders fire for each event (already scheduled in Story 2.4 via `NotificationService`); this story wires the workmanager-based periodic trigger for the 8pm session
3. Throughout-day suggestion notifications fire on meaningful data shift: event canceled, streak at risk (last session > 2 days ago), pattern threshold crossed
4. "One AI voice per day" rule: if a throughout-day suggestion fires, the evening session's cross-domain insight is suppressed (flag `throughout_day_suggestion_fired_today` in `SharedPreferences`)
5. If the 8pm workmanager task doesn't fire (OS killed it), the app-open fallback: if local time is 20:00–23:59 and no evening session exists for today, surface the session inline as the first home-screen interaction
6. After-midnight policy: if it's past midnight, today's session is gone — no retroactive surfacing
7. Background task callback logs errors via `debugPrint` (never crashes silently)
8. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: 8pm workmanager task registration (AC: 1)
  - [ ] In `BackgroundTaskService.scheduleEveningCheck()`: register a periodic `workmanager` task
  - [ ] Calculate initial delay to next 8pm: `DateTime(today.year, today.month, today.day, 20, 0).difference(DateTime.now())`; if negative (past 8pm), schedule for tomorrow 8pm
  - [ ] Task name: `'odo.evening_session_invite'`
  - [ ] In `callbackDispatcher`: handle `'odo.evening_session_invite'` → call `NotificationService.showEveningSessionNotification()`
- [ ] Task 2: Data-shift trigger (AC: 3, 4)
  - [ ] `BackgroundTaskService.triggerDataShiftCheck()`: registers a one-shot workmanager task
  - [ ] In `callbackDispatcher`: handle `'odo.data_shift_check'` → run `SuggestionEngine.generate()` → if suggestion found, fire notification + set `throughout_day_suggestion_fired_today` flag
  - [ ] Called from: `AgendaNotifier.deleteEvent` (event canceled), `PracticeNotifier.logSession` (streak update), `PatternDetector` match found
- [ ] Task 3: App-open fallback (AC: 5, 6)
  - [ ] In `main.dart` (or `app.dart`) post-init check:
    ```dart
    final now = DateTime.now();
    if (now.hour >= 20 && now.hour < 24) {
      final session = await db.getTodayInProgressOrCompleted();
      if (session == null) navigateToEveningSession();
    }
    ```
  - [ ] Only triggers if no session started today
- [ ] Task 4: Notification content (AC: 1, 3)
  - [ ] Evening: title `"OdO"`, body `"Your evening with OdO is ready"`
  - [ ] Throughout-day: title `"OdO"`, body `"I have a suggestion for you"` + tap opens `/confirm-suggestion/:id`
  - [ ] Notification tap payload: pass suggestion ID for throughout-day notification
- [ ] Task 5: "One AI voice per day" enforcement (AC: 4)
  - [ ] Check `prefs.getBool('throughout_day_suggestion_fired_${dateStr}')` in evening session's `HighlightRanker` → if true, skip cross-domain insight
  - [ ] Flag resets at midnight (never persisted across days — use date-keyed key)
- [ ] Task 6: Lint check (AC: 8)

## Dev Notes

- **`workmanager` periodic constraint:** Use `Constraints(networkType: NetworkType.not_required)` to ensure the task runs without connectivity.
- **iOS background limitations:** iOS severely limits background execution. The 8pm task may not fire reliably. The app-open fallback (Task 3) is the primary UX path on iOS.
- **`callbackDispatcher` must be top-level function** — already established in Story 1.6. Add new task handlers to the existing switch statement.
- **Notification tap → route:** Use `flutter_local_notifications` payload to pass the suggestion ID. In `NotificationService.initialize()`, set `onDidReceiveNotificationResponse` callback → `router.go('/confirm-suggestion/$id')`.
- **Idempotency:** `scheduleEveningCheck()` should check if the task is already scheduled before re-registering. Use `workmanager.cancelByUniqueName` + re-register pattern.

### Project Structure Notes

```
lib/core/services/background_task_service.dart   # updated
lib/core/services/notification_service.dart       # notification tap routing updated
lib/main.dart                                     # app-open fallback added
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.8] — three task types + one-AI-voice rule
- [Source: _bmad-output/planning-artifacts/architecture.md#Background-Task-Reliability] — fallback strategy

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List