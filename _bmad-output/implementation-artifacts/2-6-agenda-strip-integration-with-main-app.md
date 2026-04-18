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
storyId: "2.6"
storyKey: "2-6-agenda-strip-integration-with-main-app"
---

# Story 2.6: Agenda Strip Integration with Main App

## Story Statement

As a user,
I want the Agenda strip to appear on every screen and update when events change,
So that temporal context is always available.

## Acceptance Criteria

**Given** AgendaStrip widget from Story 2.2 and Riverpod providers from Story 2.5
**When** I integrate the strip into the main app shell
**Then** the strip appears above the carousel on every screen
**And** it watches `nextEventsProvider` and updates reactively
**And** it handles loading state with skeleton loader
**And** it handles error state gracefully
**And** tapping the strip opens calendar modal without losing carousel position

## Technical Context

### Architecture Compliance

**App Shell Structure:**
```
MyApp (main widget)
├── ProviderScope (Riverpod)
├── MaterialApp
│   └── GoRouter
│       └── AppShell
│           ├── AgendaStrip (persistent at top)
│           ├── MainContent (carousel/navigation)
│           │   ├── AgendaSlide
│           │   ├── PracticeSlide
│           │   └── AiSlide
│           └── BottomNav (if applicable)
```

**Navigation Pattern:**
- Use go_router for all navigation
- Bottom sheets as routes (not imperative pushes)
- Calendar modal opened via go_router route
- Carousel position preserved when opening calendar

**Folder Structure:**
```
lib/
├── main.dart                    # App initialization
├── app/
│   ├── app_shell.dart          # Main app container (new)
│   └── theme.dart              # Theme configuration
├── features/
│   ├── agenda/
│   │   └── presentation/
│   │       ├── _providers.dart
│   │       ├── agenda_slide.dart
│   │       └── widgets/
│   │           └── agenda_strip.dart
│   ├── practice/
│   │   └── presentation/
│   │       └── practice_slide.dart
│   └── ai/
│       └── presentation/
│           └── ai_slide.dart
└── core/
    ├── database/
    ├── services/
    └── constants/
```

### Key Implementation Details

**AppShell Widget:**
- Main container for entire app
- Holds AgendaStrip at top (persistent)
- Contains carousel/navigation in middle
- Manages route transitions
- Uses go_router for navigation

**AgendaStrip Integration:**
- Placed above main content (fixed position)
- Watches `nextEventsProvider` for real-time updates
- Handles three states: loading, error, data
- Loading state: skeleton loader or shimmer
- Error state: "Unable to load schedule" message
- Data state: displays next 2 events

**Carousel/Navigation:**
- PageView or similar for swipe navigation
- Contains AgendaSlide, PracticeSlide, AiSlide
- Position preserved when opening calendar modal
- Smooth transitions between slides

**Calendar Modal:**
- Opened via go_router bottom sheet route
- Doesn't interrupt carousel state
- Returns to same carousel position when closed
- Full-screen calendar view (Story 2.3)

**State Preservation:**
- Use PageController to maintain carousel position
- Use go_router for navigation (preserves state)
- Riverpod providers auto-cache data

### Dependencies & Imports

**From Story 2.2 & 2.5:**
- `features/agenda/presentation/widgets/agenda_strip.dart` — AgendaStrip widget
- `features/agenda/presentation/_providers.dart` — Riverpod providers

**From Story 1.3:**
- `app/theme.dart` — Theme configuration

**Navigation:**
- `go_router` — Routing and navigation
- `flutter_riverpod` — State management

**Flutter:**
- `material.dart` — Material design widgets

### Testing Requirements

**Widget Tests:**
- Test AppShell renders AgendaStrip at top
- Test AgendaStrip updates when events change
- Test loading state displays skeleton loader
- Test error state displays error message
- Test tapping strip opens calendar modal
- Test carousel position preserved after modal
- Test carousel swipe navigation works
- Test all slides render correctly

**Integration Tests:**
- Test full app flow: open app → see strip → tap strip → view calendar → return to carousel
- Test real-time updates across multiple screens
- Test error recovery (network error → retry)

**Test File Location:**
```
test/app/app_shell_test.dart
test/integration/agenda_strip_integration_test.dart
```

### Performance Considerations

- Use ConsumerWidget for efficient Riverpod watching
- Avoid rebuilding entire app when strip updates (scoped to widget)
- Cache carousel position to avoid rebuilds
- Use const constructors where possible
- Lazy-load slides in carousel (PageView.builder)

### Previous Story Intelligence

**From Story 2.2 (Persistent Agenda Strip):**
- AgendaStrip widget is ready for integration
- Watches `nextEventsProvider` for updates
- Handles loading and error states

**From Story 2.3 (Calendar View):**
- AgendaSlide provides full calendar view
- Opened as modal from strip tap

**From Story 2.5 (State Management):**
- `nextEventsProvider` provides real-time event data
- Riverpod auto-caches and invalidates providers

**From Story 1.3 (Theme System):**
- ThemeData configured with dark/light modes
- Spacing and animation constants defined

### Files to Create/Modify

**New Files:**
1. `lib/app/app_shell.dart` — Main app container with strip integration
2. `test/app/app_shell_test.dart` — Widget tests
3. `test/integration/agenda_strip_integration_test.dart` — Integration tests

**Existing Files to Modify:**
1. `lib/main.dart` — Update to use AppShell
2. `lib/app/theme.dart` — Reference only

**Existing Files to Reference:**
- `lib/features/agenda/presentation/widgets/agenda_strip.dart` — Strip widget
- `lib/features/agenda/presentation/_providers.dart` — Riverpod providers
- `lib/app/theme.dart` — Theme configuration

### Navigation Routes

**go_router Configuration:**
```
/                           → AppShell (home)
  /calendar                 → Calendar modal (bottom sheet)
  /add-event                → Add event sheet
  /event/:id/edit           → Edit event sheet
```

## Implementation Notes

- Use go_router for all navigation (no imperative pushes)
- AppShell should be a StatefulWidget to manage carousel position
- Preserve PageController state when opening modals
- AgendaStrip should be const if possible (performance)
- Use ConsumerWidget for Riverpod integration
- Handle all error states gracefully (no crashes)

## Completion Checklist

- [ ] AppShell widget created
- [ ] AgendaStrip integrated at top of app
- [ ] Carousel/navigation implemented with PageView
- [ ] AgendaSlide, PracticeSlide, AiSlide integrated
- [ ] Calendar modal opens via go_router
- [ ] Carousel position preserved when opening modal
- [ ] Loading state displays skeleton loader
- [ ] Error state displays error message
- [ ] Real-time updates working (watches nextEventsProvider)
- [ ] Swipe navigation between slides working
- [ ] Widget tests written and passing
- [ ] Integration tests written and passing
- [ ] go_router configuration complete
- [ ] Code follows CONVENTIONS.md patterns
