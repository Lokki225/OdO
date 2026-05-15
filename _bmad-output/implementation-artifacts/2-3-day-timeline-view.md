# Story 2.3: Day Timeline View

Status: ready-for-dev

## Story

As a user,
I want a vertical timeline of my day with 30-min grid lines and category colors,
so that I can see my day at a glance.

## Acceptance Criteria

1. The Agenda slide (`/home/agenda`) renders a vertical scrollable day timeline
2. Events render as colored blocks with a category left-bar: violet (`colorCategoryPersonal`), blue (`colorCategoryWork`), green (`colorCategoryPractice`)
3. The timeline shows 30-minute grid lines from 6am to 11pm by default (34 slots)
4. Free slots ≥30 minutes are visually distinct: dashed border, muted green tint background
5. Tapping an event block navigates to `/home/agenda/event/:id`
6. Tapping a free slot opens the add-event bottom sheet at `/home/agenda/add-event` with the slot's start time pre-filled
7. Today's current time is indicated by a horizontal line with a dot marker in the active theme accent color
8. The timeline auto-scrolls to the current time on open (or 8am if before 8am)
9. Date navigation: swipe left/right changes the displayed day; current date shown in header
10. All views use semantic tokens; `flutter analyze` passes

## Tasks / Subtasks

- [ ] Task 1: `AgendaTimelineProvider` (AC: 1, 9)
  - [ ] `lib/features/agenda/presentation/agenda_providers.dart`
  - [ ] `selectedDayProvider`: `StateProvider<DateTime>` (defaults to today)
  - [ ] `dayEventsProvider`: `StreamProvider<List<Event>>` watching `watchEventsForDay(selectedDay)`
- [ ] Task 2: Timeline layout widget (AC: 2–8)
  - [ ] `lib/features/agenda/presentation/widgets/day_timeline.dart`
  - [ ] Custom `CustomPainter` or `Stack` + `Positioned` layout
  - [ ] 30-min slot height = `sp32 * 2` = 64dp per hour → 32dp per 30 min
  - [ ] Time labels on left (e.g., `09:00`) using `textCaption` style, `colorTextMuted`
  - [ ] Grid lines: `Divider` or `CustomPainter` horizontal lines at each 30-min boundary
  - [ ] Free slot detection: scan sorted events; gaps ≥30 min are free slots
  - [ ] Free slot tap → `context.go('/home/agenda/add-event', extra: {'startTime': slotStart})`
- [ ] Task 3: Event block widget (AC: 2, 5)
  - [ ] `lib/features/agenda/presentation/widgets/event_block.dart`
  - [ ] Height proportional to event duration; minimum height 32dp
  - [ ] Left border `4dp` colored by `EventCategory`
  - [ ] Title + time range in `textCaption`
  - [ ] `onTap` → `context.go('/home/agenda/event/${event.id}')`
- [ ] Task 4: Current time indicator (AC: 7, 8)
  - [ ] Timer that updates every minute; repaint indicator position
  - [ ] Auto-scroll: use `ScrollController` with `animateTo` in `initState`
- [ ] Task 5: Day navigation (AC: 9)
  - [ ] `PageView` or `GestureDetector` swipe → update `selectedDayProvider`
  - [ ] Header: date in format from `LocaleService.formatDate`
- [ ] Task 6: Agenda slide screen (AC: 1)
  - [ ] `lib/features/agenda/presentation/pages/agenda_page.dart`
  - [ ] Houses `DayTimeline` widget with `ref.watch(dayEventsProvider)`
- [ ] Task 7: Lint check (AC: 10)
  - [ ] `flutter analyze` — zero issues

## Dev Notes

- **Custom layout vs. table_calendar:** The day timeline is a CUSTOM widget (not `table_calendar` — that is reserved for the monthly calendar in Story 2.5). Build with `CustomScrollView` + `SliverList` or a `Stack` with absolute positioning.
- **Event positioning:** `top = (event.startTime.hour * 60 + event.startTime.minute - 360) * pixelsPerMinute` where 360 = 6am offset in minutes, `pixelsPerMinute = 32/30`.
- **Free slot algorithm:** Sort events by startTime; for each consecutive pair check if `nextEvent.startTime - currentEvent.endTime >= 30 minutes`. Also check 6am→first event and last event→11pm.
- **Performance:** Use `const` constructors for grid line painters; avoid rebuilding entire timeline on timer tick (only the current-time indicator widget should rebuild).
- **Scroll restoration:** Save scroll position in a `ScrollController` and restore on tab switch.

### Project Structure Notes

```
lib/features/agenda/presentation/
├── pages/
│   └── agenda_page.dart           # full Agenda slide screen
├── widgets/
│   ├── day_timeline.dart          # timeline container + layout
│   └── event_block.dart           # individual event block
└── agenda_providers.dart          # selectedDayProvider, dayEventsProvider
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-2.3] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md] — category colors, timeline design
- [Source: CLAUDE.md#UI-Design] — OLED colors, semantic tokens

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
