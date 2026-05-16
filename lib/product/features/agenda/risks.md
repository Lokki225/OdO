# Agenda Module — Risks

## R1 — Drift Code Generation Desync

**Description:** Adding `AgendaDao` to `AppDatabase.daos` requires re-running `build_runner`. If generated files (`app_database.g.dart`, `agenda_dao.g.dart`) are stale, the app won't compile.

**Probability:** High (every DAO addition triggers this)

**Impact:** High (blocks compilation; nothing can be tested)

**Severity:** Critical

**Mitigation:** Run `dart run build_runner build --delete-conflicting-outputs` immediately after editing `app_database.dart`. Verify generated file timestamps before proceeding.

**Contingency:** If conflicts persist, run `dart run build_runner clean && dart run build_runner build`.

---

## R2 — Epoch Millisecond / DateTime Timezone Drift

**Description:** `EventRow.startTime` is stored as UTC epoch ms (`int`). `DateTime.now()` returns local time. If day-boundary computations mix local and UTC without explicit conversion, `watchEventsForDay` will miss events near midnight.

**Probability:** Medium

**Impact:** High (events silently absent from strip or timeline)

**Severity:** High

**Mitigation:** Always compute day boundaries as UTC: `DateTime(d.year, d.month, d.day).toUtc().millisecondsSinceEpoch`. Add unit tests with events at 23:59 and 00:01.

**Contingency:** If symptoms appear (events missing near midnight), add debug logging of computed boundaries vs stored timestamps to isolate the conversion.

---

## R3 — `table_calendar` API Changes

**Description:** `table_calendar ^3.1.2` has a specific API. Constructor signature changes between patch versions can break the calendar page at compile time.

**Probability:** Low (patch version pinned)

**Impact:** Medium (calendar page fails to build)

**Severity:** Medium

**Mitigation:** Pin exact version in `pubspec.yaml` (`table_calendar: 3.1.2` not `^3.1.2`). Reference the exact API used in Dev Notes of Story 2.5.

**Contingency:** Downgrade to last known-good version if new patch breaks API.

---

## R4 — Notification Permission Not Granted

**Description:** `NotificationService.scheduleEventReminder` silently fails on Android/iOS if the user has not granted notification permission. The event is created but the reminder is never fired.

**Probability:** Medium (user may deny permission on first prompt)

**Impact:** Low (event created correctly; only reminder missing)

**Severity:** Low

**Mitigation:** Permission request is handled in Story 1.6 initialization. No additional handling needed in Story 2.4. Accept that if permission denied, notification is silently skipped.

**Contingency:** Epic 6 (Polish & Resilience) includes a permission recovery flow.

---

## R5 — Custom Timeline Layout Overflow

**Description:** Positioning event blocks using absolute pixel offsets (`top = (startMin - 360) * pixelsPerMinute`) requires the total height to be fixed. If screen DPI varies, events may overlap or overflow their bounds.

**Probability:** Medium

**Impact:** Medium (visual glitches; no data loss)

**Severity:** Medium

**Mitigation:** Enforce minimum event block height (32dp). Use `LayoutBuilder` to adapt `pixelsPerMinute` to screen height. Add overflow clip to the timeline container.

**Contingency:** If absolute positioning causes issues, fall back to `SliverList` with time-proportional `SizedBox` gaps between events.

---

## R6 — Stream Not Disposed Properly

**Description:** `watchEventsForDay` returns a Drift stream. If a `StreamProvider` is not properly scoped (e.g., `autoDispose` missing), the stream subscription leaks across navigation.

**Probability:** Low

**Impact:** Medium (memory leak; stale data in strip)

**Severity:** Medium

**Mitigation:** Use `@riverpod` annotation (auto-generates `autoDispose` by default). Verify in tests that provider disposes stream on widget unmount.

**Contingency:** Manually call `ref.onDispose` in provider if leak is observed.

---

## R7 — Undo-Delete Race Condition

**Description:** If the user taps Undo within the 5-second window but the `deleteEvent` DB call has already completed, re-inserting the event may create a duplicate if the original `id` is lost.

**Probability:** Low

**Impact:** Medium (duplicate event; user confusion)

**Severity:** Medium

**Mitigation:** Save the full `Event` object before calling `deleteEvent`. On undo, call `addEvent(savedEvent.copyWith(id: null))` to insert as new row, and re-schedule notification. Accept that the original `id` is not preserved on undo.

**Contingency:** If duplicate detection is needed, check for existing event with same title + start time before re-insert.
