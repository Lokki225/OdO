---
stepsCompleted: []
inputDocuments:
  - epics.md
  - architecture.md
  - ux-design-specification.md
projectName: TooXTips
userName: Lokki
date: 2026-03-30
status: ready-for-dev
storyId: "2.3"
storyKey: "2-3-calendar-view-day-and-week-modes"
---

# Story 2.3: Calendar View (Day and Week Modes)

## Story Statement

As a user,
I want to view my calendar in day and week modes,
So that I can see my schedule at different time scales.

## Acceptance Criteria

**Given** the Agenda module requirements (FR1)
**When** I create `features/agenda/presentation/agenda_slide.dart` with calendar view
**Then** day mode shows hourly timeline with events positioned by time
**And** week mode shows 7-day grid with events
**And** user can swipe between day and week modes
**And** current day is highlighted
**And** tapping an event shows event details
**And** calendar uses table_calendar package for rendering

## Technical Context

### Architecture Compliance

**Widget Hierarchy:**
```
AgendaSlide (main calendar container)
├── DayView (hourly timeline)
│   ├── TimeColumn (left side with hours)
│   └── EventsColumn (events positioned by time)
└── WeekView (7-day grid)
    ├── DayHeaders (Mon-Sun)
    └── EventGrid (events in cells)
```

**State Management:**
- Use Riverpod provider for selected date
- Watch `todayAgendaProvider` and `weekAgendaProvider` from Story 2.5
- Handle loading and error states

**Folder Structure:**
```
features/agenda/presentation/
├── agenda_slide.dart            # Main calendar view (new)
├── widgets/
│   ├── day_view.dart            # Day mode widget (new)
│   ├── week_view.dart           # Week mode widget (new)
│   ├── event_card.dart          # Event display (new)
│   └── agenda_strip.dart        # From Story 2.2
└── _providers.dart              # Riverpod providers
```

### Key Implementation Details

**Day Mode:**
- Hourly timeline (6 AM to 10 PM, or configurable)
- Events positioned vertically by start time
- Event height proportional to duration
- Current time indicator (red line at current hour)
- Tap event to show details or edit

**Week Mode:**
- 7-day grid (Monday to Sunday)
- Current day highlighted with background color
- Events shown as small cards in day cells
- Tap event to show details
- Swipe left/right to navigate weeks

**Navigation Between Modes:**
- PageView or TabBarView for swipe navigation
- Smooth transition animation
- Preserve selected date when switching modes

**Event Display:**
- Event title (truncated if needed)
- Start and end time
- Category color indicator (if applicable)
- Tap to open event details sheet (Story 2.4)

**Date Navigation:**
- Show current date at top
- Navigation buttons to go to previous/next day/week
- "Today" button to jump to current date

### Dependencies & Imports

**From Story 2.1 & 2.5:**
- `features/agenda/data/agenda_repository.dart` — AgendaRepository
- `features/agenda/presentation/_providers.dart` — todayAgendaProvider, weekAgendaProvider

**From Story 1.2 & 1.3:**
- `app/theme.dart` — Spacing constants, animation durations
- `core/constants/app_colors.dart` — Color tokens

**External Packages:**
- `table_calendar: ^3.0.0` — Calendar widget (add to pubspec.yaml if not present)
- `flutter_riverpod` — State management

**Flutter:**
- `material.dart` — Material design widgets
- `intl.dart` — DateFormat for time display

### Testing Requirements

**Widget Tests:**
- Test day view renders hourly timeline
- Test week view renders 7-day grid
- Test swipe navigation between modes
- Test current day highlighting
- Test event positioning by time
- Test tap gesture opens event details
- Test date navigation (previous/next, today button)

**Test File Location:**
```
test/features/agenda/presentation/agenda_slide_test.dart
test/features/agenda/presentation/widgets/day_view_test.dart
test/features/agenda/presentation/widgets/week_view_test.dart
```

### Performance Considerations

- Use ListView.builder for day view hours (lazy loading)
- Use GridView.builder for week view (lazy loading)
- Cache formatted times to avoid repeated calculations
- Limit event rendering to visible area (virtualization)
- Use const constructors where possible

### Previous Story Intelligence

**From Story 2.1 (Event Data Access Layer):**
- AgendaRepository provides `getEventsForDate()` and `getEventsForWeek()` methods
- Returns Future<List<AgendaEvent>> ordered by startTime

**From Story 2.2 (Persistent Agenda Strip):**
- Strip is persistent above main content
- Tapping strip should open calendar modal (this story)

**From Story 1.3 (Theme System):**
- Animation durations: durationFast (150ms), durationDefault (250ms), durationSlow (400ms)
- Spacing constants: sp8, sp12, sp16, sp20, sp24

### Files to Create/Modify

**New Files:**
1. `lib/features/agenda/presentation/agenda_slide.dart` — Main calendar view
2. `lib/features/agenda/presentation/widgets/day_view.dart` — Day mode
3. `lib/features/agenda/presentation/widgets/week_view.dart` — Week mode
4. `lib/features/agenda/presentation/widgets/event_card.dart` — Event display
5. `test/features/agenda/presentation/agenda_slide_test.dart` — Tests

**Existing Files to Reference:**
- `lib/app/theme.dart` — Theme constants
- `lib/core/constants/app_colors.dart` — Color tokens
- `lib/features/agenda/presentation/_providers.dart` — Riverpod providers

**Dependencies to Add:**
- `table_calendar: ^3.0.0` in pubspec.yaml (if not already present)

## Implementation Notes

- Use PageView for smooth swipe transitions between day and week modes
- All times displayed in 24-hour format (HH:MM)
- All times in UTC+0 timezone
- Current time indicator (red line) only in day view
- Event colors based on category (if applicable)
- Ensure touch targets are at least 44dp (accessibility requirement)

## Completion Checklist

- [ ] AgendaSlide main widget created
- [ ] DayView widget implemented with hourly timeline
- [ ] WeekView widget implemented with 7-day grid
- [ ] EventCard widget created for event display
- [ ] Swipe navigation between modes working
- [ ] Current day/time highlighting implemented
- [ ] Tap event opens details sheet
- [ ] Date navigation (previous/next/today) working
- [ ] Loading and error states handled
- [ ] Widget tests written and passing
- [ ] Uses semantic color tokens
- [ ] Spacing follows design system
- [ ] Code follows CONVENTIONS.md patterns
- [ ] table_calendar dependency added to pubspec.yaml
