# Story 2.5: Monthly Calendar

Status: ready-for-dev

## Story

As a user,
I want a monthly calendar inside the Agenda slide,
so that I can navigate to other dates and see density at a glance.

## Acceptance Criteria

1. Monthly calendar renders inside the Agenda slide at `/home/agenda/calendar`
2. Uses `table_calendar` package (already in pubspec)
3. Event density shown as colored dots per day (up to 3 dots)
4. Dot color reflects the highest-priority category: Work (`colorCategoryWork`) > Practice (`colorCategoryPractice`) > Personal (`colorCategoryPersonal`)
5. Tapping a day closes the calendar and jumps the timeline to that date (updates `selectedDayProvider`)
6. Today is highlighted with the active theme accent color
7. Long-pressing the agenda strip (from Story 2.2) opens this calendar view
8. Calendar can be dismissed via back navigation; timeline returns to previously selected day
9. Calendar loads event data for the visible month range using `getEventsBetween`
10. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: Month events provider (AC: 3, 4, 9)
  - [ ] `monthEventsProvider(DateTime month)`: `FutureProvider.family<Map<DateTime, List<Event>>, DateTime>`
  - [ ] Loads events for `month.firstDay` to `month.lastDay` using `agendaRepositoryProvider.getEventsBetween`
  - [ ] Returns `Map<DateTime, List<Event>>` keyed by local date (time stripped)
- [ ] Task 2: Calendar page (AC: 1, 2, 5–8)
  - [ ] `lib/features/agenda/presentation/pages/calendar_page.dart`
  - [ ] Uses `TableCalendar` widget with `calendarFormat: CalendarFormat.month`
  - [ ] `selectedDay` bound to `selectedDayProvider`
  - [ ] `onDaySelected`: update `selectedDayProvider` and `context.go('/home/agenda')` (back to timeline)
  - [ ] `calendarBuilders.markerBuilder`: renders dots for event density
- [ ] Task 3: Dot marker builder (AC: 3, 4)
  - [ ] Helper `_buildMarkers(List<Event> events)`: returns up to 3 `Container` dots (8dp circle)
  - [ ] Priority sort: work first, then practice, then personal
  - [ ] Dot colors from semantic tokens
- [ ] Task 4: Today highlight (AC: 6)
  - [ ] `TableCalendar.todayDecoration`: `BoxDecoration(color: colorAccent.withOpacity(0.15), shape: BoxShape.circle)`
  - [ ] Selected day decoration: `BoxDecoration(color: colorAccent, shape: BoxShape.circle)`
- [ ] Task 5: Month page change handler (AC: 9)
  - [ ] `TableCalendar.onPageChanged`: update `focusedDayProvider` and invalidate `monthEventsProvider` for new month
- [ ] Task 6: Lint check (AC: 10)
  - [ ] `flutter analyze lib/features/agenda/presentation/pages/calendar_page.dart` — zero issues

## Dev Notes

- **`table_calendar` v3.1.2:** API: `TableCalendar(firstDay:, lastDay:, focusedDay:, selectedDayPredicate:, onDaySelected:, eventLoader:, calendarBuilders:)`. Pass events via `eventLoader: (day) => monthEvents[_stripTime(day)] ?? []`.
- **Strip time helper:** `DateTime _stripTime(DateTime d) => DateTime(d.year, d.month, d.day)` — necessary for map key lookup since `table_calendar` passes full `DateTime`.
- **Month range:** `firstDay` = 3 years ago, `lastDay` = 3 years ahead — standard `table_calendar` requirement.
- **`colorTextMuted` for past days:** Use `CalendarBuilders.defaultBuilder` to style past day text in `colorTextMuted`.
- **Performance:** `monthEventsProvider` is a `FutureProvider.family` — it caches by month. Each month's events are fetched once and retained until provider is disposed.

### Project Structure Notes

```
lib/features/agenda/presentation/
├── pages/
│   └── calendar_page.dart         # TableCalendar wrapper
└── agenda_providers.dart          # monthEventsProvider added here
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-2.5] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#Starter-Template] — table_calendar in pubspec

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
