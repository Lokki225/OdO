# Agenda Module — Test Scenarios

## Story 2.1 — Agenda Repository and DAO

| ID | Title | Preconditions | Input | Expected Output | Validation Rule | Type |
|----|-------|--------------|-------|----------------|----------------|------|
| TS-001 | Insert event and read back | In-memory Drift DB | `Event(title:'Meeting', startTime:t1, endTime:t2, category:work)` | `getEventById(id)` returns event with same fields | Fields match inserted values | unit |
| TS-002 | Update event title | Event exists with id=1 | `updateEvent(event.copyWith(title:'Updated'))` | `getEventById(1).title == 'Updated'` | Title changed; other fields unchanged | unit |
| TS-003 | Delete event | Event exists with id=1 | `deleteEvent(1)` | `getEventById(1)` returns null | Row absent in DB | unit |
| TS-004 | Range query returns only events in range | 3 events: t1, t5, t9 (epoch ms) | `getEventsBetween(t2, t8)` | Returns event at t5 only | Only t5 in range [t2, t8) | unit |
| TS-005 | Range query returns empty for no match | 2 events outside range | `getEventsBetween(t3, t4)` | Empty list | No events in narrow range | unit |
| TS-006 | watchEventsForDay emits on insert | Stream listening, DB empty | Insert event for today | Stream emits list with 1 event | Emission after insert | unit |
| TS-007 | watchEventsForDay ignores yesterday's events | Stream for today | Insert event for yesterday | Stream emits empty list | Yesterday excluded | unit |
| TS-008 | EventMapper fromRow: all fields mapped correctly | EventRow with all fields set | `EventMapper.fromRow(row)` | `Event` with identical field values; epoch→DateTime correct | DateTime equals `fromMillisecondsSinceEpoch` | unit |
| TS-009 | EventMapper toCompanion: DateTime→epoch correct | `Event` with `startTime` = known DateTime | `EventMapper.toCompanion(event)` | `companion.startTime` = `event.startTime.millisecondsSinceEpoch` | Integer epoch matches | unit |
| TS-010 | EventMapper throws on unknown category | `EventRow` with `category = 'unknown'` | `EventMapper.fromRow(row)` | `ArgumentError` thrown | Mapper validates category | unit |
| TS-011 | AgendaRepositoryImpl returns Success on insert | Valid Event | `agendaRepository.addEvent(event)` | `Result.isSuccess == true` | Wraps success | unit |
| TS-012 | AgendaRepositoryImpl returns Failure on DB exception | Simulate DB error | `agendaRepository.addEvent(event)` when DAO throws | `Failure(AppError.databaseWriteFailed)` | Wraps error correctly | unit |

---

## Story 2.2 — Persistent Agenda Strip

| ID | Title | Preconditions | Input | Expected Output | Validation Rule | Type |
|----|-------|--------------|-------|----------------|----------------|------|
| TS-013 | Strip State 1: two upcoming events | Provider returns 2 future events | Widget pump | Text: `'HH:mm Event1 · HH:mm Event2'` visible | Text matches format | unit |
| TS-014 | Strip State 1: one upcoming event | Provider returns 1 future event | Widget pump | Text: `'HH:mm Event1'` visible (no dot separator) | Single event no separator | unit |
| TS-015 | Strip State 1: title truncated at 20 chars | Event with 25-char title | Widget pump | Title shown as `title.substring(0,20) + '…'` | Truncation applied | unit |
| TS-016 | Strip State 2: no today events, tomorrow event | Provider: today empty, tomorrow has event | Widget pump | Text: `'Tomorrow · HH:mm Title'` visible | State 2 format correct | unit |
| TS-017 | Strip State 3: no events anywhere | Provider: empty for today and tomorrow | Widget pump | Text: `'Nothing scheduled — free day'` | Exact string present | unit |
| TS-018 | Strip loading state shows skeleton | Provider in loading state | Widget pump before resolve | Grey container visible (not event text) | Loading widget rendered | unit |
| TS-019 | Strip error state falls back to State 3 text | Provider returns error | Widget pump | `'Nothing scheduled — free day'` shown | Error fallback correct | unit |
| TS-020 | Strip tap navigates to /home/agenda | GoRouter mock | Tap strip | Router receives `/home/agenda` | Navigation triggered | integration |
| TS-021 | Strip long-press navigates to /home/agenda/calendar | GoRouter mock | Long-press strip | Router receives `/home/agenda/calendar` | Navigation triggered | integration |

---

## Story 2.3 — Day Timeline View

| ID | Title | Preconditions | Input | Expected Output | Validation Rule | Type |
|----|-------|--------------|-------|----------------|----------------|------|
| TS-022 | Timeline renders 34 half-hour slots (6am–11pm) | Agenda page pumped | No events | 34 time-label widgets visible | Count == 34 | unit |
| TS-023 | Event block rendered with category color (work = blue) | Work event 10:00–11:00 | Provider returns work event | Event block left border color matches `colorCategoryWork` | Color token correct | unit |
| TS-024 | Free slot ≥30 min renders distinct style | Gap between events ≥30 min | Two events with 45-min gap | Free slot widget with dashed border + muted tint visible | Distinct styling applied | unit |
| TS-025 | Free slot <30 min not shown as free | Gap between events = 20 min | Two events 20 min apart | No free slot widget between them | Short gap excluded | unit |
| TS-026 | Event block tap navigates to /home/agenda/event/:id | EventBlock for event id=7 | Tap event block | Router receives `/home/agenda/event/7` | Correct route | integration |
| TS-027 | Free slot tap sends startTime extra to add-event | Free slot at 14:00 | Tap free slot | Router receives `/home/agenda/add-event` with `extra: {startTime: 14:00}` | Extra data passed | integration |
| TS-028 | Current time indicator at correct pixel position | Current time = 10:30 | Render timeline | Indicator top offset = (10*60+30 - 360) * pixPerMin | Pixel math correct | unit |
| TS-029 | Day navigation: swipe left decrements day | selectedDayProvider = today | Swipe left | selectedDayProvider = yesterday | Provider updated | unit |
| TS-030 | Day header shows formatted date | selectedDay = 2026-05-20 | Render header | Header text = `LocaleService.formatDate(2026-05-20)` | Format matches | unit |

---

## Story 2.4 — Event CRUD

| ID | Title | Preconditions | Input | Expected Output | Validation Rule | Type |
|----|-------|--------------|-------|----------------|----------------|------|
| TS-031 | Add sheet: empty title shows validation error | Sheet open | Tap Save with empty title | Inline error "Title is required" visible; sheet stays open | Validation fires | unit |
| TS-032 | Add sheet: end before start shows error | Sheet open | End time = start time - 30 min; tap Save | Inline error "End time must be after start" visible | Time validation fires | unit |
| TS-033 | Add sheet: valid submit calls notifier and pops | Sheet open | Fill valid form; tap Save | `AgendaNotifier.addEvent` called; sheet popped | Notifier + navigation | unit |
| TS-034 | Add sheet: cancel dismisses without saving | Sheet open | Tap Cancel | Sheet popped; no notifier call | No side effects | unit |
| TS-035 | Category defaults to Personal | Sheet open without extra | Render sheet | Personal radio selected | Default category | unit |
| TS-036 | Add sheet: pre-filled from free slot tap | `extra: {startTime: 14:00}` | Render sheet | Start time field shows 14:00 | Extra data applied | unit |
| TS-037 | Event detail: all fields displayed | Event with all fields | Navigate to detail page | Title, start, end, category, notes visible | Full display | unit |
| TS-038 | Event detail: delete shows snackbar with Undo | Event on detail page | Tap Delete | Snackbar visible with "Undo" action | Snackbar appears | unit |
| TS-039 | Undo delete restores event | Snackbar with undo | Tap Undo within 5s | Event back in DB; stream emits | DB re-insert | integration |
| TS-040 | `scheduleEventReminder` called on successful create | Valid event save | `AgendaNotifier.addEvent` | `NotificationService.scheduleEventReminder` invoked | Notification scheduled | unit |
| TS-041 | `cancelReminder` called before DB delete | Event exists | `AgendaNotifier.deleteEvent(id)` | `NotificationService.cancelReminder(id)` called | Notification canceled | unit |
| TS-042 | Stream updates strip after event creation | Strip watching stream | Add event for today | Strip shows new event without refresh | Reactive update | integration |

---

## Story 2.5 — Monthly Calendar

| ID | Title | Preconditions | Input | Expected Output | Validation Rule | Type |
|----|-------|--------------|-------|----------------|----------------|------|
| TS-043 | Calendar page renders TableCalendar | Navigate to /home/agenda/calendar | No events | `TableCalendar` widget present | Widget present | unit |
| TS-044 | Day with work event shows blue dot | Work event on 2026-05-20 | Render calendar for May | 2026-05-20 cell has blue dot marker | Dot color = work | unit |
| TS-045 | Day with 4 events shows max 3 dots | 4 events on same day | Render calendar | 3 dots rendered (not 4) | Max 3 enforced | unit |
| TS-046 | Priority: work dot shown over personal | Day has both work and personal events | Render calendar | Blue dot (work) rendered, not violet | Priority ordering | unit |
| TS-047 | Tap day updates selectedDayProvider | Calendar open | Tap 2026-05-25 | `selectedDayProvider` = 2026-05-25 | Provider updated | unit |
| TS-048 | Tap day navigates to /home/agenda | Calendar open | Tap any day | Router receives `/home/agenda` | Navigation triggered | integration |
| TS-049 | Today cell has accent color highlight | Today = 2026-05-15 | Render calendar | 2026-05-15 cell decoration uses accent color | Token used | unit |
| TS-050 | monthEventsProvider loads events for full month | May 2026 selected | Render calendar | `getEventsBetween(may1, may31)` called | Correct range | unit |
| TS-051 | Month page change invalidates monthEventsProvider | Calendar on May | Swipe to June | `monthEventsProvider(June)` requested | Cache invalidated | unit |
| TS-052 | `_stripTime` helper removes time component | DateTime(2026,5,20,14,30) | `_stripTime(dt)` | DateTime(2026,5,20) | Time zeroed | unit |
