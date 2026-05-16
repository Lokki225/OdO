# Agenda Module — UI Implementation Plan

## Screens

| Screen | File Path | Route | Story |
|--------|-----------|-------|-------|
| Agenda Page (Day Timeline) | `lib/features/agenda/presentation/pages/agenda_page.dart` | `/home/agenda` | 2.3 |
| Add Event Sheet | `lib/features/agenda/presentation/pages/add_event_sheet.dart` | `/home/agenda/add-event` | 2.4 |
| Event Detail Page | `lib/features/agenda/presentation/pages/event_detail_page.dart` | `/home/agenda/event/:id` | 2.4 |
| Calendar Page | `lib/features/agenda/presentation/pages/calendar_page.dart` | `/home/agenda/calendar` | 2.5 |

---

## Widgets

| Widget | File Path | Responsibility | Story |
|--------|-----------|---------------|-------|
| `AgendaStrip` | `lib/features/agenda/presentation/widgets/agenda_strip.dart` | Persistent strip: 3 states, tap/long-press navigation | 2.2 |
| `DayTimeline` | `lib/features/agenda/presentation/widgets/day_timeline.dart` | Timeline container, grid lines, free slot detection, scroll control | 2.3 |
| `EventBlock` | `lib/features/agenda/presentation/widgets/event_block.dart` | Individual event block with category color, tap navigation | 2.3 |
| `FreeSlotBlock` | `lib/features/agenda/presentation/widgets/free_slot_block.dart` | Dashed-border free slot tappable widget | 2.3 |
| `CurrentTimeIndicator` | `lib/features/agenda/presentation/widgets/current_time_indicator.dart` | Horizontal line + dot, updates every minute | 2.3 |

---

## Providers

All providers live in `lib/features/agenda/presentation/agenda_providers.dart`.

| Provider | Type | Dependencies | Story |
|----------|------|-------------|-------|
| `agendaRepositoryProvider` | `Provider<AgendaRepository>` | `appDatabaseProvider` → creates `AgendaRepositoryImpl(AgendaDao)` | 2.1 |
| `agendaStripProvider` | `StreamProvider<AgendaStripState>` | `agendaRepositoryProvider`, `DateTime.now()` | 2.2 |
| `selectedDayProvider` | `StateProvider<DateTime>` | None | 2.3 |
| `dayEventsProvider` | `StreamProvider<List<Event>>` | `agendaRepositoryProvider`, `selectedDayProvider` | 2.3 |
| `agendaNotifierProvider` | `AsyncNotifierProvider<AgendaNotifier, void>` | `agendaRepositoryProvider` | 2.4 |
| `eventDetailProvider(int id)` | `FutureProvider.family<Event?, int>` | `agendaRepositoryProvider` | 2.4 |
| `focusedDayProvider` | `StateProvider<DateTime>` | None | 2.5 |
| `monthEventsProvider(DateTime month)` | `FutureProvider.family<Map<DateTime, List<Event>>, DateTime>` | `agendaRepositoryProvider` | 2.5 |

---

## Sealed Class: AgendaStripState

**File:** `lib/features/agenda/presentation/agenda_providers.dart`

```dart
sealed class AgendaStripState {}
class EventsToday extends AgendaStripState {
  EventsToday(this.events); // max 2 events
  final List<Event> events;
}
class NextTomorrow extends AgendaStripState {
  NextTomorrow(this.event);
  final Event event;
}
class NothingScheduled extends AgendaStripState {}
```

**State logic:**
1. Get today's events from stream; filter `startTime > DateTime.now()`, sort ascending, take 2.
2. If list non-empty → `EventsToday(list)`.
3. Else call `getEventsBetween(tomorrowStart, tomorrowEnd)`: if non-empty → `NextTomorrow(first)`.
4. Else → `NothingScheduled()`.

---

## UI States per Screen/Widget

### AgendaStrip
| State | Trigger | Widget Shown |
|-------|---------|-------------|
| Loading | `AsyncValue.loading` | `Container(height: 20, color: grey.withOpacity(0.2))` animated width |
| EventsToday | `AsyncValue.data(EventsToday)` | Row with time + title items, `·` separator |
| NextTomorrow | `AsyncValue.data(NextTomorrow)` | "Tomorrow · HH:mm Title" |
| NothingScheduled / Error | `AsyncValue.data(NothingScheduled)` or `error` | "Nothing scheduled — free day" |

### AgendaPage
| State | Trigger | Widget Shown |
|-------|---------|-------------|
| Loading | `dayEventsProvider` loading | `CircularProgressIndicator` centered |
| Loaded | `dayEventsProvider` data | `DayTimeline` with events |
| Error | `dayEventsProvider` error | Error text with retry |
| Empty | Empty list | Timeline with only grid lines + free slots |

### AddEventSheet
| State | Trigger | Widget Shown |
|-------|---------|-------------|
| Default | Sheet opens | Empty form, Personal selected |
| Pre-filled | `GoRouterState.extra` has event | Form fields populated |
| Validation error | Save with invalid data | Inline red error messages |
| Saving | `agendaNotifierProvider` loading | Save button disabled, loading indicator |
| Error | `agendaNotifierProvider` error | Snackbar with error message |

### EventDetailPage
| State | Trigger | Widget Shown |
|-------|---------|-------------|
| Loading | `eventDetailProvider` loading | `CircularProgressIndicator` |
| Loaded | `eventDetailProvider` data | Full event display |
| Not found | `eventDetailProvider` returns null | "Event not found" text |
| Error | `eventDetailProvider` error | Error text |

### CalendarPage
| State | Trigger | Widget Shown |
|-------|---------|-------------|
| Loading | `monthEventsProvider` loading | `TableCalendar` without dots |
| Loaded | `monthEventsProvider` data | `TableCalendar` with dots |
| Error | `monthEventsProvider` error | `TableCalendar` without dots (empty) |

---

## Navigation Flow

```
Home (AgendaStrip)
  ├── tap ──────────────────────────→ /home/agenda
  └── long-press ───────────────────→ /home/agenda/calendar

/home/agenda (AgendaPage)
  ├── free slot tap ────────────────→ /home/agenda/add-event + extra: {startTime}
  ├── event block tap ──────────────→ /home/agenda/event/:id
  └── (implied from nav bar) ───────→ /home/agenda/calendar (via strip long-press)

/home/agenda/add-event (AddEventSheet)
  ├── save ─────────────────────────→ pop (returns to caller)
  └── cancel ───────────────────────→ pop

/home/agenda/event/:id (EventDetailPage)
  ├── edit ─────────────────────────→ /home/agenda/add-event + extra: {event}
  └── delete ───────────────────────→ pop (after confirmation)

/home/agenda/calendar (CalendarPage)
  └── day tap ──────────────────────→ /home/agenda (updates selectedDayProvider)
```

---

## Design Tokens Used

| Token | Usage |
|-------|-------|
| `colorAccent` | Current time indicator dot, today cell in calendar, active navigation |
| `colorCategoryPersonal` (`#7C4DFF`) | Personal event left bar, dot marker |
| `colorCategoryWork` (`#5B8BD4`) | Work event left bar, dot marker |
| `colorCategoryPractice` (`#1D9E75`) | Practice event left bar, dot marker |
| `colorTextPrimary` | Event titles, time labels |
| `colorTextMuted` | "Tomorrow" label, past day text in calendar |
| `colorSurface` | Event block background |
| `colorBorder` | Grid line color |
| `colorBackground` | Screen background |

**Typography:**
- `textBody` (16px DM Sans) — event titles in strip
- `textBodyMuted` (14px DM Sans) — time labels in strip
- `textCaption` (12px DM Sans) — time grid labels, event block time range
- `textTitle` (22px System) — date header

---

## Timeline Layout Math

```
Visible range: 6:00 → 23:00 = 17 hours = 34 half-hour slots
Slot height: 32dp (sp32 from AppSpacing)
Total timeline height: 34 * 32dp = 1088dp

Event top offset: (startMin - 360) * (32/30) dp
  where 360 = 6 * 60 (minutes since midnight at 6am)
  and 32/30 = pixelsPerMinute

Event height: max(32, durationMinutes * (32/30))

Current time offset: (nowHour * 60 + nowMinute - 360) * (32/30)
Auto-scroll target: max(currentTimeOffset - screenHeight/2, 0)
Before 8am: scroll to (8*60 - 360) * (32/30) = 240 * 32/30 ≈ 256dp
```

---

## Home Screen Integration

**File:** `lib/features/home/presentation/home_screen.dart` (modify)

Add `AgendaStrip` at the top of the home screen body, above existing content:
```dart
Column(children: [
  const AgendaStrip(),
  Expanded(child: /* existing home content */),
])
```
