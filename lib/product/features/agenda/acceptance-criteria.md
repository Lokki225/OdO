# Agenda Module — Acceptance Criteria

## Functional Requirements (FR)

### Story 2.1 — Agenda Repository and DAO

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| FR1 | `AgendaDao` defines `insertEvent` | Insert returns generated id |
| FR2 | `AgendaDao` defines `updateEvent` | Row updated; read back confirms new values |
| FR3 | `AgendaDao` defines `deleteEvent` | Row absent after delete |
| FR4 | `AgendaDao` defines `getEventById(int id)` | Returns correct row or null |
| FR5 | `AgendaDao.watchEventsForDay(DateTime)` returns `Stream<List<Event>>` | Stream emits new list after insert |
| FR6 | `AgendaDao.getEventsBetween(int startMs, int endMs)` returns `Future<List<Event>>` | Only events within range returned |
| FR7 | `Event` entity: `int? id`, `String title`, `DateTime startTime`, `DateTime endTime`, `EventCategory category`, `String? notes` | All fields present with correct types |
| FR8 | `EventCategory` enum values: `personal`, `work`, `practice` | Three values only |
| FR9 | `AgendaRepository` abstract interface matches DAO signatures | Abstract methods compile and list `Result<T>` or `Stream` return types |
| FR10 | `AgendaRepositoryImpl` wraps DAO writes in `try/catch` returning `Failure(AppError.databaseWriteFailed)` on exception | Exception caught; `Failure` returned |
| FR11 | `EventMapper.fromRow` converts `EventRow` → `Event` correctly | All fields mapped; epoch ms → DateTime correct |
| FR12 | `EventMapper.toCompanion` converts `Event` → `EventsCompanion` correctly | All fields mapped; DateTime → epoch ms correct |
| FR13 | Mapper throws `ArgumentError` on unknown category string | Unknown string causes `ArgumentError`, not silent null |

### Story 2.2 — Persistent Agenda Strip

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| FR14 | `AgendaStrip` renders `State 1`: next 2 upcoming events (time + title) | Text `'HH:mm Title1 · HH:mm Title2'` present in widget tree |
| FR15 | `AgendaStrip` renders `State 2`: first tomorrow event with "Tomorrow" label | Text `'Tomorrow · HH:mm Title'` present |
| FR16 | `AgendaStrip` renders `State 3`: "Nothing scheduled — free day" | Exact string present in widget tree |
| FR17 | Titles truncated at 20 chars with `…` | Title longer than 20 chars shows `substring(0,20) + '…'` |
| FR18 | Strip shows at most 2 events simultaneously | Never more than 2 event entries in strip text |
| FR19 | Tap navigates to `/home/agenda` | `context.go('/home/agenda')` called on tap |
| FR20 | Long-press navigates to `/home/agenda/calendar` | `context.go('/home/agenda/calendar')` called on long-press |
| FR21 | Strip uses semantic tokens (no hardcoded colors) | `Theme.of(context).colorScheme.*` or `OdoTheme.*` tokens used |
| FR22 | Strip updates reactively when events are added/deleted | New event → strip updates without explicit refresh |

### Story 2.3 — Day Timeline View

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| FR23 | Agenda page at `/home/agenda` renders a vertical scrollable timeline | Widget tree contains scrollable timeline |
| FR24 | Event blocks have colored left bar by category (violet/blue/green) | Event block widget renders 4dp left border with category color |
| FR25 | 30-minute grid lines from 6am to 11pm (34 slots) | 34 slot dividers rendered |
| FR26 | Free slots ≥30 min are visually distinct (dashed border, muted green tint) | Free slot widget renders with distinct styling |
| FR27 | Tap event block navigates to `/home/agenda/event/:id` | GoRouter receives `/home/agenda/event/42` on tap |
| FR28 | Tap free slot opens add-event sheet with slot's start time | Route `/home/agenda/add-event` receives `startTime` extra |
| FR29 | Current time indicator: horizontal line + dot in accent color | Indicator widget painted at correct pixel position |
| FR30 | Auto-scroll to current time on open (or 8am if before 8am) | `ScrollController.animateTo` called with correct offset |
| FR31 | Swipe left/right changes displayed day | `selectedDayProvider` updates on page swipe |
| FR32 | Date header shows current displayed date in `LocaleService.formatDate` format | Header text matches `formatDate(selectedDay)` |

### Story 2.4 — Event CRUD

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| FR33 | Add-event sheet fields: title, start time, end time, category, notes | All 5 input widgets present in widget tree |
| FR34 | Category defaults to `EventCategory.personal` when sheet opens without pre-fill | Radio group shows `personal` selected by default |
| FR35 | Save inserts event to DB and stream updates strip immediately | Stream emits after save; strip reflects new event |
| FR36 | Event detail screen shows: title, start time, end time, category, notes | All fields displayed |
| FR37 | Edit button opens add-event sheet pre-filled with event data | Sheet fields contain existing event values |
| FR38 | Delete shows snackbar with "Undo" action, 5-second window | Snackbar with undo action appears; undo within 5s restores event |
| FR39 | Delete cancels notification via `NotificationService.cancelReminder(eventId)` | `cancelReminder` called before DB delete |
| FR40 | Create schedules 5-min reminder via `NotificationService.scheduleEventReminder` | `scheduleEventReminder` called after successful DB insert |
| FR41 | Form validation: title required | Empty title shows inline error, save blocked |
| FR42 | Form validation: end time after start time | End ≤ start shows inline error, save blocked |

### Story 2.5 — Monthly Calendar

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| FR43 | Monthly calendar renders at `/home/agenda/calendar` | `TableCalendar` widget present in widget tree |
| FR44 | Event density shown as colored dots (up to 3 per day) | Days with events show ≤3 dot markers |
| FR45 | Dot color priority: Work > Practice > Personal | Work events produce blue dot; Practice → green; Personal → violet |
| FR46 | Tap day → close calendar, jump timeline to selected date | `selectedDayProvider` updated; `context.go('/home/agenda')` called |
| FR47 | Today highlighted with accent color | Today cell has accent-colored decoration |
| FR48 | Long-press agenda strip opens calendar (`/home/agenda/calendar`) | Calendar page opens from strip long-press |
| FR49 | Back navigation dismisses calendar; timeline retains previously selected day | Pop restores prior `selectedDayProvider` state |
| FR50 | Calendar loads events for visible month via `getEventsBetween` | Events for full month range loaded once per month |
| FR51 | `focusedDayProvider` updates on month page change | Changing month updates provider and invalidates `monthEventsProvider` |

---

## Integration Requirements (IR)

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| IR1 | `AgendaDao` is registered in `AppDatabase.daos` | App compiles; `db.agendaDao` accessible |
| IR2 | Drift stream (`watchEventsForDay`) drives both `AgendaStrip` and `DayTimeline` reactively | Single write causes both widgets to update |
| IR3 | `NotificationService.scheduleEventReminder` called only on successful DB insert | No notification on DB failure |
| IR4 | `NotificationService.cancelReminder` called before DB delete (not after) | If delete fails, notification still canceled is acceptable; important ordering is: cancel → delete |
| IR5 | `selectedDayProvider` shared between `AgendaPage`, `CalendarPage`, and strip navigation | All three read/write the same provider instance |
| IR6 | `AgendaNotifier` consumes `AgendaRepository` (domain interface), not `AgendaDao` directly | Provider dependency graph: Notifier → Repository → DAO |

---

## Edge Cases (EC)

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| EC1 | Strip State 1 shows only future events (past events excluded) | Events with `startTime < now` not shown in strip |
| EC2 | Strip with exactly 1 upcoming event today shows 1 item (not 2) | Single event displayed correctly |
| EC3 | Strip State 2: multiple tomorrow events — only first (earliest) shown | Only earliest tomorrow event shown |
| EC4 | Timeline: all events in past → no event blocks above current time line | No block rendered above the time indicator |
| EC5 | Events starting before 6am or ending after 11pm render within visible range (clipped or clamped) | No layout overflow errors |
| EC6 | Free slot detection at boundaries: 6am → first event, last event → 11pm | Boundary free slots detected correctly |
| EC7 | `getEventsBetween` with empty range returns empty list | No events outside range returned |
| EC8 | Delete with undo: undo within 5s re-inserts event and re-schedules notification | Undo restores event in DB and stream |
| EC9 | Edit an event: original notification canceled, new notification scheduled | Old `cancelReminder`, new `scheduleEventReminder` on update with time change |

---

## Error Handling (EH)

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| EH1 | DB write failure → `AgendaRepositoryImpl` returns `Failure(AppError.databaseWriteFailed)` | Exception in DAO → `Failure` returned to notifier |
| EH2 | `AgendaStrip` in loading state shows skeleton (grey animated container) | Loading state → skeleton widget visible |
| EH3 | `AgendaStrip` error state falls back to State 3 text ("Nothing scheduled — free day") | DB error → strip shows fallback text, not crash |
| EH4 | Form save while DB unavailable: notifier sets error state, UI shows snackbar | `AsyncValue.error` triggers snackbar with message |
| EH5 | Event detail loaded with invalid/deleted ID shows "Event not found" message | `getEventById` returns `null` → detail page shows error state |
| EH6 | Calendar month load failure shows empty calendar (not crash) | `monthEventsProvider` error → calendar renders with no dots |

---

## Quality Requirements (QR)

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| QR1 | `flutter analyze` shows "No issues found!" on all Epic 2 files | Zero warnings or errors |
| QR2 | All domain entities are pure Dart (no Flutter, no Drift imports) | Imports in `event.dart` are `dart:` only |
| QR3 | Presentation widgets never import from `data/` layer | No `import '.../data/...'` in any `presentation/` file |
| QR4 | All Riverpod providers for agenda live in `agenda_providers.dart` | No stray providers in widget files |
| QR5 | Test coverage ≥90% (FR + IR + EH criteria each have at least one test) | Test file count and assertions cover all FR/IR/EH items |
| QR6 | Timeline renders 34 grid slots (6am–11pm inclusive) | Count of slot widgets = 34 |
| QR7 | Event block minimum height 32dp | Block height never < 32 regardless of duration |

---

## Security Requirements (SR)

| ID | Requirement | Testable Condition |
|----|-------------|-------------------|
| SR1 | Category string validated at mapper boundary — unknown values throw `ArgumentError` not silently null | Mapper unit test: unknown string → `ArgumentError` thrown |
| SR2 | Event title stored as plain text, no HTML/script injection risk | No `innerHTML`-equivalent rendering; Flutter `Text` widget safe by default |
