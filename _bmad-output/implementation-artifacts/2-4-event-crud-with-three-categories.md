# Story 2.4: Event CRUD with Three Categories

Status: ready-for-dev

## Story

As a user,
I want to create, read, update, and delete events with a category,
so that I can manage my schedule.

## Acceptance Criteria

1. The add-event bottom sheet (`/home/agenda/add-event`) contains fields: title (text), start time (time picker), end time (time picker), category (Personal/Work/Practice radio group), optional notes (text)
2. Category defaults to Personal when the sheet opens without a pre-filled category
3. Save commits to the `events` table and updates the agenda strip immediately (optimistic UI — strip reacts via stream)
4. The event detail screen (`/home/agenda/event/:id`) shows full event info and has Edit and Delete actions
5. Edit opens the add-event sheet pre-filled with the event's current data
6. Delete shows a confirmation snackbar with undo option (5-second window)
7. Deleting an event with a scheduled notification cancels the notification via `NotificationService.cancelReminder(eventId)`
8. On event creation, a 5-minute pre-event reminder is scheduled via `NotificationService.scheduleEventReminder(...)`
9. Form validation: title is required (non-empty); end time must be after start time; error messages shown inline
10. All form fields support keyboard and touch input; no voice parsing in this story (voice is Epic 4)
11. Widget tests cover: form validation errors, successful save updates provider, cancel dismisses sheet

## Tasks / Subtasks

- [ ] Task 1: `AgendaNotifier` (AC: 3)
  - [ ] `lib/features/agenda/presentation/agenda_providers.dart`
  - [ ] `@riverpod` class `AgendaNotifier extends _$AgendaNotifier implements AsyncNotifier<void>`
  - [ ] `addEvent(Event event)`: calls repo, then schedules notification
  - [ ] `updateEvent(Event event)`: calls repo
  - [ ] `deleteEvent(int id)`: calls repo, cancels notification
- [ ] Task 2: Add-event bottom sheet (AC: 1, 2, 3, 9)
  - [ ] `lib/features/agenda/presentation/pages/add_event_sheet.dart`
  - [ ] `ConsumerStatefulWidget` with form `GlobalKey<FormState>`
  - [ ] Title: `TextFormField` with `validator`
  - [ ] Time pickers: `showTimePicker` Flutter built-in, displayed as `HH:mm`
  - [ ] Category: three-option radio group using `RadioListTile` with category color indicators
  - [ ] Notes: optional `TextFormField` (multiline, 3 lines max)
  - [ ] Save button: validates form, calls `ref.read(agendaNotifierProvider.notifier).addEvent(...)`, then `context.pop()`
- [ ] Task 3: Event detail screen (AC: 4, 5, 6, 7)
  - [ ] `lib/features/agenda/presentation/pages/event_detail_page.dart`
  - [ ] Loads event by ID from `agendaRepositoryProvider.getEventById(id)`
  - [ ] Edit button → `context.push('/home/agenda/add-event', extra: {'event': event})`
  - [ ] Delete button → shows `ScaffoldMessenger.showSnackBar` with action "Undo"
  - [ ] Undo: re-inserts the deleted event within 5s; after 5s, cancels notification
- [ ] Task 4: Notification integration (AC: 7, 8)
  - [ ] In `AgendaNotifier.addEvent`: call `notificationService.scheduleEventReminder(...)` after successful DB insert
  - [ ] In `AgendaNotifier.deleteEvent`: call `notificationService.cancelReminder(eventId)` before DB delete
- [ ] Task 5: Widget tests (AC: 11)
  - [ ] `test/features/agenda/presentation/pages/add_event_sheet_test.dart`
  - [ ] Test: empty title → validation error shown
  - [ ] Test: end before start → validation error shown
  - [ ] Test: valid form submit → notifier called
- [ ] Task 6: Lint check
  - [ ] `flutter analyze lib/features/agenda/` — zero issues

## Dev Notes

- **Optimistic UI:** The agenda strip uses a `watchEventsForDay` stream. When the notifier inserts an event, the Drift stream emits automatically — no manual strip refresh needed.
- **Pre-filled slot time:** When opening the add sheet from a free slot tap (Story 2.3), `GoRouterState.extra` contains `{'startTime': DateTime}`. The sheet initializes the start time picker from this.
- **Time picker localization:** `showTimePicker` with `initialEntryMode: TimePickerEntryMode.input` and `builder` wrapping with `Directionality.ltr`. Format as 24-hour clock.
- **Undo delete pattern:** Save the deleted `Event` object before calling `deleteEvent`. Snackbar action calls `addEvent(savedEvent)` (without a new notification — preserve original `id` if possible, or re-schedule).
- **`EventsCompanion` vs `EventData`:** Use `EventsCompanion.insert(...)` for inserts (nullable id), `EventData` for reads. Mapper handles both.

### Project Structure Notes

```
lib/features/agenda/presentation/
├── pages/
│   ├── add_event_sheet.dart
│   └── event_detail_page.dart
└── agenda_providers.dart     # AgendaNotifier (addEvent, updateEvent, deleteEvent)
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-2.4] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#Agenda-Module] — event CRUD pattern
- [Source: 1-6-core-services.md] — NotificationService interface

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
