# Agenda Module — Spec

## Problem Statement

Franklin needs to see and manage his daily schedule without leaving the app. Today there is no agenda feature — events exist in the SQLite schema (Story 1.4) but nothing reads, writes, or displays them. The Agenda Module closes that gap end-to-end: persistent strip on the home screen, a scrollable day timeline, full CRUD with notifications, and a monthly calendar for wider navigation.

## Goals

1. Provide a persistent at-a-glance agenda strip on the home screen (3 states: today's next events, tomorrow's first event, or nothing scheduled).
2. Show a scrollable vertical day timeline with 30-minute grid, event blocks, free-slot highlights, and current-time indicator.
3. Support full event lifecycle: create, read, update, delete, with 5-minute pre-event reminders and undo-delete.
4. Provide a monthly calendar view with event density dots and accent-colored today highlight.
5. All operations are offline-first — they work without internet.

## Non-Goals

- Voice parsing of event input (Epic 4).
- AI event suggestions (Epic 4/5).
- Recurring events (v1.1 backlog).
- Reminders other than the 5-minute pre-event notification.
- Multi-user sharing or sync.

## User Flow

```
Home Screen
  └── AgendaStrip (top) — always visible
        ├── Tap → /home/agenda (Day Timeline)
        └── Long-press → /home/agenda/calendar (Monthly Calendar)

/home/agenda (Agenda Page)
  ├── Header: current date + day navigation (swipe or arrows)
  ├── DayTimeline (scrollable, 6am–11pm, 30-min grid)
  │     ├── EventBlock tap → /home/agenda/event/:id
  │     └── Free-slot tap → /home/agenda/add-event (start time pre-filled)
  └── FAB or inline add → /home/agenda/add-event

/home/agenda/add-event (AddEventSheet — bottom sheet)
  ├── Title, start time, end time, category, notes
  ├── Save → insert to DB, schedule notification, pop
  └── Cancel → pop

/home/agenda/event/:id (EventDetailPage)
  ├── Edit → /home/agenda/add-event (pre-filled)
  └── Delete → snackbar + 5s undo window; confirm → cancel notification

/home/agenda/calendar (CalendarPage)
  ├── TableCalendar month view
  ├── Dot markers (up to 3) per day, priority-ordered colors
  └── Day tap → update selectedDayProvider, go to /home/agenda
```

## Technical Constraints

- **Domain layer** is pure Dart — no Flutter, no Drift, no external imports.
- **Data layer** may import Drift; must never be imported by presentation.
- **Presentation layer** consumes only domain entities and Riverpod providers.
- `EventRow` (Drift-generated from `Events` table in Story 1.4) stores `startTime`/`endTime` as epoch milliseconds `int`.
- The `category` column is stored as `'personal'|'work'|'practice'` text; mapper throws `ArgumentError` on unknown values.
- Drift `watchEventsForDay` returns a `Stream` — never wrap streams in try/catch in the repository.
- `NotificationService` (Story 1.6) is a static class; call `scheduleEventReminder` / `cancelReminder` directly.
- `table_calendar` ^3.1.2 is already in `pubspec.yaml`.
- Navigation uses `go_router` from Story 1.8; all routes already declared.

## Dependencies

| Dependency | Status |
|---|---|
| Story 1.1 — Project setup, pubspec | COMPLETE |
| Story 1.2 — Design tokens (OdoTheme, AppColors) | COMPLETE |
| Story 1.3 — Theme system (AppTypography, AppSpacing) | COMPLETE |
| Story 1.4 — Drift schema (Events table, AppDatabase) | COMPLETE |
| Story 1.6 — NotificationService (scheduleEventReminder, cancelReminder) | COMPLETE |
| Story 1.7 — Result<T>, AppError | COMPLETE |
| Story 1.8 — Router (all agenda routes declared) | COMPLETE |

## Success Metrics

- `flutter analyze` → "No issues found!" on all new files.
- `flutter test` → ≥90% of all tests pass.
- Drift stream emits within 50ms of a write (offline-first).
- UI interactions complete within 500ms.
- Events persist correctly across app restarts.
- All 51 acceptance criteria satisfied.
