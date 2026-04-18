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
storyId: "2.4"
storyKey: "2-4-event-crud-operations"
---

# Story 2.4: Event CRUD Operations

## Story Statement

As a user,
I want to create, read, update, and delete calendar events,
So that I can manage my schedule.

## Acceptance Criteria

**Given** the calendar view from Story 2.3 and AgendaRepository from Story 2.1
**When** I create `features/agenda/presentation/widgets/add_event_sheet.dart` and event editing
**Then** tapping "+" or empty time slot opens add event bottom sheet
**And** the sheet has fields for title, start time, end time, category
**And** saving creates the event in Agenda and persists to SQLite
**And** tapping an event opens edit sheet with same fields
**And** saving updates the event in SQLite
**And** swiping left on event shows delete confirmation
**And** deleting removes event from SQLite and UI updates immediately

## Technical Context

### Architecture Compliance

**Widget Hierarchy:**
```
AgendaSlide
├── DayView / WeekView
│   └── EventCard (tap to edit)
└── AddEventSheet (bottom sheet)
    ├── TitleField
    ├── StartTimeField
    ├── EndTimeField
    ├── CategoryField
    └── SaveButton
```

**State Management:**
- Use Riverpod notifier for event CRUD actions
- Watch `todayAgendaProvider` and `weekAgendaProvider` for real-time updates
- Optimistic UI updates (update local state before API call)

**Folder Structure:**
```
features/agenda/presentation/
├── widgets/
│   ├── add_event_sheet.dart     # Add/edit event bottom sheet (new)
│   ├── event_card.dart          # From Story 2.3
│   └── agenda_strip.dart        # From Story 2.2
└── _providers.dart              # Riverpod providers with notifier
```

### Key Implementation Details

**Add Event Sheet:**
- Triggered by tapping "+" button or empty time slot
- Bottom sheet (go_router route, not imperative push)
- Fields: title (required), start time, end time, category (optional)
- Time picker: Material time picker or custom (HH:MM format)
- Save button: creates event in SQLite
- Cancel button: dismisses sheet without saving
- Validation: end time must be after start time

**Edit Event Sheet:**
- Same layout as add event sheet
- Pre-populated with existing event data
- Save button: updates event in SQLite
- Delete button: shows confirmation, then deletes

**Delete Confirmation:**
- Swipe left on event card shows delete button
- Or delete button in edit sheet
- Confirmation dialog: "Delete this event?"
- Confirm: removes from SQLite, UI updates immediately
- Cancel: dismisses dialog

**Real-time Updates:**
- After save/delete, Riverpod provider automatically refreshes
- UI rebuilds with new event list
- No manual state management needed

**Error Handling:**
- Validation errors: show inline error messages
- Database errors: show snackbar with retry option
- Never crash or show raw exceptions

### Dependencies & Imports

**From Story 2.1 & 2.5:**
- `features/agenda/data/agenda_repository.dart` — AgendaRepository
- `features/agenda/presentation/_providers.dart` — Riverpod providers with notifier

**From Story 1.2 & 1.3:**
- `app/theme.dart` — Spacing constants, animation durations
- `core/constants/app_colors.dart` — Color tokens

**Flutter:**
- `material.dart` — Material design widgets
- `intl.dart` — DateFormat for time display

**Riverpod:**
- `flutter_riverpod` — StateNotifier for CRUD actions

### Testing Requirements

**Widget Tests:**
- Test add event sheet opens on "+" tap
- Test add event sheet opens on empty slot tap
- Test form validation (end time after start time)
- Test event creation saves to SQLite
- Test edit event sheet pre-populates data
- Test event update saves to SQLite
- Test delete confirmation dialog
- Test event deletion removes from SQLite
- Test real-time UI updates after CRUD operations

**Test File Location:**
```
test/features/agenda/presentation/widgets/add_event_sheet_test.dart
test/features/agenda/presentation/widgets/event_card_test.dart
```

### Performance Considerations

- Use optimistic UI updates (update local state immediately)
- Debounce rapid save clicks to prevent duplicate events
- Cache time picker state to avoid rebuilds
- Use const constructors where possible

### Previous Story Intelligence

**From Story 2.1 (Event Data Access Layer):**
- AgendaRepository provides `createEvent()`, `updateEvent()`, `deleteEvent()` methods
- All methods return Future and handle errors

**From Story 2.3 (Calendar View):**
- EventCard widget displays events
- Tap event to open edit sheet
- Swipe left to delete

**From Story 1.3 (Theme System):**
- Animation durations: durationFast (150ms), durationDefault (250ms), durationSlow (400ms)
- Spacing constants: sp8, sp12, sp16, sp20, sp24

### Files to Create/Modify

**New Files:**
1. `lib/features/agenda/presentation/widgets/add_event_sheet.dart` — Add/edit sheet
2. `test/features/agenda/presentation/widgets/add_event_sheet_test.dart` — Tests

**Existing Files to Modify:**
1. `lib/features/agenda/presentation/widgets/event_card.dart` — Add swipe-to-delete
2. `lib/features/agenda/presentation/_providers.dart` — Add StateNotifier for CRUD

**Existing Files to Reference:**
- `lib/app/theme.dart` — Theme constants
- `lib/core/constants/app_colors.dart` — Color tokens
- `lib/features/agenda/data/agenda_repository.dart` — Repository methods

## Implementation Notes

- All times in 24-hour format (HH:MM)
- All times in UTC+0 timezone
- Use go_router for bottom sheet navigation (not imperative push)
- Optimistic UI updates: update local state before database call
- Handle database errors gracefully with user-friendly messages
- Ensure form validation prevents invalid data

## Completion Checklist

- [ ] AddEventSheet widget created
- [ ] Form fields: title, start time, end time, category
- [ ] Add event functionality working (creates in SQLite)
- [ ] Edit event functionality working (updates in SQLite)
- [ ] Delete confirmation dialog implemented
- [ ] Delete functionality working (removes from SQLite)
- [ ] Real-time UI updates after CRUD operations
- [ ] Form validation implemented
- [ ] Error handling with user-friendly messages
- [ ] Widget tests written and passing
- [ ] Uses semantic color tokens
- [ ] Spacing follows design system
- [ ] Code follows CONVENTIONS.md patterns
- [ ] go_router integration for bottom sheet
