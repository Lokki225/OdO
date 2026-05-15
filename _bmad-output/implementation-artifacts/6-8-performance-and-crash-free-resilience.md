# Story 6.8: Performance and Crash-Free Resilience

Status: ready-for-dev

## Story

As a developer,
I want OdO to feel fast and never crash,
so that the user trusts it daily.

## Acceptance Criteria

1. Perceived latency for any local action is <500ms (optimistic UI where appropriate)
2. 2 consecutive weeks of daily personal use produce zero crashes
3. Background task (8pm session) fires successfully ≥70% of days; fallback covers the rest (verified via manual daily use log)
4. App cold-starts in <1.5 seconds on a mid-range Android device (measured from tap to first frame)
5. All Riverpod providers use lazy initialization — no work done at startup for data not immediately needed
6. Drift queries use indexes where beneficial: `events.start_time`, `sessions.skill_id + started_at`, `sessions.is_anchored`
7. The AI context build (`ContextBuilder.build`) completes in <50ms (it's pure Dart computation, no I/O)
8. Memory usage: no memory leaks from `StreamController`s, `AnimationController`s, or `Timer`s — all disposed in `dispose()`
9. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: Optimistic UI audit (AC: 1)
  - [ ] Verify all write operations (addEvent, logSession, addSkill) update UI before DB confirmation
  - [ ] Pattern: insert into local state immediately → DB write in background → on error, rollback state + show snackbar
  - [ ] `AgendaNotifier.addEvent`: use `state = AsyncData([...state.value!, newEvent])` before awaiting DB write
- [ ] Task 2: Cold start profiling (AC: 4)
  - [ ] Run `flutter run --profile` and measure `first_frame` time in DevTools
  - [ ] Goal: ≤1500ms. Common causes of slow startup: `GoogleFonts` fetch (fix: `GoogleFonts.config.allowRuntimeFetching = false`), large `main.dart` sync work
  - [ ] Move all async init (DB open, notification init, workmanager init) to `FutureProvider` — not in `main()` sync
- [ ] Task 3: Lazy provider initialization (AC: 5)
  - [ ] All providers are `@riverpod` annotated — lazy by default (only build when first watched)
  - [ ] Verify no provider eagerly subscribes to expensive streams without a watcher
  - [ ] `appDatabaseProvider`: confirm it's not opened until first access
- [ ] Task 4: SQLite index additions (AC: 6)
  - [ ] In `app_database.dart` migration `onCreate`: add `CREATE INDEX idx_events_start ON events(start_time)` and `CREATE INDEX idx_sessions_skill ON sessions(skill_id, started_at)` and `CREATE INDEX idx_sessions_anchored ON sessions(is_anchored)`
  - [ ] Or define indices in Drift table definitions using `@TableIndex` annotation
- [ ] Task 5: Dispose audit (AC: 8)
  - [ ] All `StatefulWidget._dispose()` methods must call `controller.dispose()` for `AnimationController`s
  - [ ] All `StreamController`s in services: closed in service dispose or app lifecycle end
  - [ ] All `Timer`s: cancelled in dispose
  - [ ] Run Flutter DevTools memory profiler: look for leaked `AnimationController` instances
- [ ] Task 6: `ContextBuilder` performance (AC: 7)
  - [ ] Benchmark with `Stopwatch`: `ContextBuilder.build()` with 100 skills + 200 events — must complete in <50ms
  - [ ] If slow: profile string concatenation; use `StringBuffer` instead of `+` concatenation
- [ ] Task 7: Lint check (AC: 9)

## Dev Notes

- **Optimistic UI pattern:** The key is to update `AsyncNotifier` state with the new item BEFORE awaiting the repository write. If the write fails, restore previous state and show a `SnackBar`. This gives instant UI feedback.
- **Cold start bottleneck:** `NativeDatabase.createInBackground` (Drift) opens DB on an isolate. The UI renders before the DB is ready. Use `AsyncValue` loading states everywhere so the app renders immediately even while the DB initializes.
- **`GoogleFonts.config.allowRuntimeFetching = false`:** Add in `main()`. Without this, GoogleFonts may attempt network font download on first run → adds startup latency.
- **SQLite indexes:** `events.start_time` is queried on every strip update. `sessions.skill_id + started_at` is queried on every streak computation. These two indexes will have the largest impact on query performance.
- **Memory profiling:** Run Flutter DevTools (`flutter run --profile --observatory-port=8888`). Go to Memory tab. Perform 10 sessions of logging/navigating. Check for growing heap.

### Project Structure Notes

Changes across: `app_database.dart` (indexes), `main.dart` (GoogleFonts config), all `AsyncNotifier` files (optimistic UI audit), all `StatefulWidget` files (dispose audit).

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-6.8] — performance targets: <500ms, <1.5s cold start, zero crashes
- [Source: _bmad-output/planning-artifacts/architecture.md] — performance: sub-500ms via optimistic UI

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List