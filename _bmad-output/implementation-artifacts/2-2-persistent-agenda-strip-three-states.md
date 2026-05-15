# Story 2.2: Persistent Agenda Strip (Three States)

Status: ready-for-dev

## Story

As a user,
I want a strip at the top of the home screen that shows what's next at all times,
so that I always know my temporal context without opening anything.

## Acceptance Criteria

1. The `AgendaStrip` widget renders at the top of the home screen in all three states
2. **State 1** (events today): shows next 2 events with time + title, titles truncated at 20 chars, format: `9:00 Standup · 11:00 Design Review`
3. **State 2** (no more events today): shows first event tomorrow with muted "Tomorrow" label, format: `Tomorrow · 9:00 Standup`
4. **State 3** (nothing scheduled): single muted line *"Nothing scheduled — free day"*
5. Strip never shows more than 2 events simultaneously
6. Tapping the strip navigates to `/home/agenda` (Agenda slide)
7. Long-pressing the strip navigates to `/home/agenda/calendar` (monthly calendar)
8. Strip uses semantic tokens only (no hardcoded colors)
9. Strip updates reactively when events are added/deleted (powered by `watchEventsForDay` stream)
10. Widget test covers all three states with correct text content

## Tasks / Subtasks

- [ ] Task 1: `AgendaStripProvider` (AC: 9)
  - [ ] `lib/features/agenda/presentation/agenda_providers.dart`
  - [ ] `agendaStripProvider`: `StreamProvider<AgendaStripState>` that watches today's events via `agendaRepositoryProvider.watchEventsForDay(DateTime.now())`
  - [ ] `AgendaStripState` sealed class: `EventsToday(List<Event>)`, `NextTomorrow(Event)`, `NothingScheduled()`
  - [ ] Logic: if today's upcoming events > 0 → `EventsToday(next2)`, else if tomorrow has events → `NextTomorrow(first)`, else → `NothingScheduled()`
- [ ] Task 2: `AgendaStrip` widget (AC: 1–8)
  - [ ] `lib/features/agenda/presentation/widgets/agenda_strip.dart`
  - [ ] `ConsumerWidget` watching `agendaStripProvider`
  - [ ] `AsyncValue.when(data:, loading:, error:)` — loading shows shimmer/skeleton, error shows State 3 text
  - [ ] `GestureDetector` with `onTap` → `context.go('/home/agenda')`, `onLongPress` → `context.go('/home/agenda/calendar')`
  - [ ] Title truncation: `title.length > 20 ? '${title.substring(0,20)}…' : title`
  - [ ] Time format via `LocaleService.formatTime(event.startTime)` (HH:mm)
  - [ ] Dot separator `·` between events
- [ ] Task 3: Wire strip into home screen (AC: 1)
  - [ ] Add `AgendaStrip` to `lib/features/home/presentation/home_screen.dart` at top
- [ ] Task 4: Widget tests (AC: 10)
  - [ ] `test/features/agenda/presentation/widgets/agenda_strip_test.dart`
  - [ ] Test State 1: provider returns 2+ events → strip shows `'HH:mm Title1 · HH:mm Title2'`
  - [ ] Test State 2: no today events, tomorrow event → strip shows `'Tomorrow · HH:mm Title'`
  - [ ] Test State 3: no events → strip shows `'Nothing scheduled — free day'`
- [ ] Task 5: Lint check
  - [ ] `flutter analyze lib/features/agenda/presentation/` — zero issues

## Dev Notes

- **State computation:** "Next 2 upcoming events today" means events with `startTime > DateTime.now()` sorted by `startTime` ascending, take 2. Events in the past are not shown.
- **Tomorrow events:** Check `getEventsBetween(tomorrowStart, tomorrowEnd)`. If multiple, show only the first (earliest).
- **Shimmer loading:** Use a single-line `Container` with `Colors.grey.withOpacity(0.2)` animated width as loading state — no third-party shimmer package.
- **Strip design:** Height ~48dp, horizontal padding `sp16`, text style `textBody` from `app_typography.dart`. Tomorrow label uses `colorTextMuted`.
- **Optimistic UI:** When an event is added (Story 2.4), the stream updates immediately — strip refreshes without any explicit refresh call.

### Project Structure Notes

```
lib/features/agenda/presentation/
├── agenda_providers.dart          # agendaStripProvider + AgendaStripState
└── widgets/
    └── agenda_strip.dart          # AgendaStrip ConsumerWidget

lib/features/home/presentation/
└── home_screen.dart               # includes AgendaStrip at top
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-2.2] — three states spec
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Pattern-Agenda-Strip] — visual design
- [Source: CLAUDE.md#UI-Design] — tokens, typography

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
