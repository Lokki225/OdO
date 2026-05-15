# Story 5.5: Evening Session — Persistence Until Midnight

Status: ready-for-dev

## Story

As a user,
I want my evening session to survive interruption until midnight,
so that I can return to it after a phone call or distraction.

## Acceptance Criteria

1. When the user reopens the app between 8pm and midnight, if an in-progress session exists for today (started but `completed_at` and `abandoned_at` are null), the session resumes from the current step
2. All previously tagged highlights remain tagged on resume
3. At local midnight (00:00), any in-progress session for today is marked `abandoned_at = midnight_timestamp`
4. A session abandoned at midnight is no longer resumable — tomorrow's session starts fresh
5. The resume check runs on every app-open when local time is between 20:00 and 23:59
6. A midnight sweep job: either a `workmanager` one-shot task or an app-open check at midnight catches unclosed sessions
7. Unit tests cover: start → background → resume same day (correct highlight index restored); start → cross midnight → session marked abandoned

## Tasks / Subtasks

- [ ] Task 1: Resume detection on app open (AC: 1, 2, 5)
  - [ ] `lib/features/evening_session/presentation/evening_session_providers.dart`
  - [ ] `checkForInProgressSessionProvider`: `FutureProvider<EveningSessionRow?>` — queries `evening_sessions WHERE session_date = today AND completed_at IS NULL AND abandoned_at IS NULL`
  - [ ] In home screen (or router redirect): if provider returns non-null AND local time 20:00–23:59 → navigate to `/evening` automatically
  - [ ] `EveningSessionNotifier.resume(EveningSessionRow row)`: loads existing highlights, finds first untagged → sets state to `highlights(list, firstUntaggedIndex)`
- [ ] Task 2: Midnight abandon sweep (AC: 3, 4, 6)
  - [ ] Method in `EveningSessionNotifier.markAbandonedIfOverdue()`:
    - Queries `evening_sessions WHERE session_date < today AND completed_at IS NULL AND abandoned_at IS NULL`
    - For each found: sets `abandoned_at = midnight of session_date`
  - [ ] Called on app open (in `main.dart` after init or via `BackgroundTaskService`)
  - [ ] Also scheduled as a `workmanager` task at midnight (best-effort)
- [ ] Task 3: Cross-midnight safety check (AC: 5)
  - [ ] If local time is after midnight (00:00–07:59) and there's a stale open session from yesterday → mark abandoned immediately on app open, do not resume
- [ ] Task 4: `EveningSessionDao` persistence methods (AC: 1–4)
  - [ ] Add to `lib/features/evening_session/data/evening_session_dao.dart`
  - [ ] `getTodayInProgressSession()`: returns the row if open session exists for today
  - [ ] `markAbandoned(int id, int abandonedAtMs)`: updates the row
  - [ ] `getExpiredInProgressSessions()`: returns sessions from past dates not closed
- [ ] Task 5: Unit tests (AC: 7)
  - [ ] `test/features/evening_session/data/evening_session_dao_test.dart`
  - [ ] Test resume scenario and midnight-abandon scenario
- [ ] Task 6: Lint check

## Dev Notes

- **"Today" at midnight boundary:** Use local time. `DateTime.now()` in local timezone. `session_date` is stored as `'YYYY-MM-DD'` string — compare against `DateFormat('yyyy-MM-dd').format(DateTime.now())`.
- **Resume highlight index:** The `display_order` column on `evening_highlights` tracks position. `firstUntaggedIndex` = first highlight where `user_tag IS NULL`. On resume, set `currentIndex = firstUntaggedIndex`.
- **Background midnight task:** `workmanager` fires best-effort. The app-open check in `main.dart` is the primary fallback. Both paths call `markAbandonedIfOverdue()` — it's idempotent.
- **Router redirect:** In `GoRouter.redirect`, check `checkForInProgressSessionProvider` value before routing to home. If a session needs resuming, redirect to `/evening`.

### Project Structure Notes

```
lib/features/evening_session/
├── data/evening_session_dao.dart     # getTodayInProgressSession, markAbandoned
└── presentation/evening_session_providers.dart  # checkForInProgressSessionProvider
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.5] — persistence-until-midnight spec
- [Source: _bmad-output/planning-artifacts/architecture.md#Evening-Session-Interruption] — exact mitigation strategy

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List