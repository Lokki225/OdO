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
storyId: "2.2"
storyKey: "2-2-persistent-agenda-strip-widget"
---

# Story 2.2: Persistent Agenda Strip Widget

## Story Statement

As a user,
I want to see the next 2-3 upcoming events in a persistent strip at the top of every screen,
So that I always know what's coming next without scrolling.

## Acceptance Criteria

**Given** the Agenda strip specification (UX-DR2, UX-DR3) and AgendaRepository from Story 2.1
**When** I create `features/agenda/presentation/widgets/agenda_strip.dart`
**Then** the strip shows next 2 events with time and title (truncated at 20 chars)
**And** if no events today, it shows first event tomorrow with "tomorrow" label
**And** if nothing scheduled, it shows "Nothing scheduled — free day"
**And** the strip is always visible above the main content
**And** tapping the strip opens the calendar modal
**And** the strip updates in real-time when events are added/deleted

## Technical Context

### UX Specification Reference

**UX-DR2: Agenda strip information hierarchy with three states**
- Events today: show next 2 events with time and title
- No events today: show first event tomorrow with "tomorrow" label
- Nothing scheduled: show "Nothing scheduled — free day"

**UX-DR3: Agenda strip shows max 2 events simultaneously, truncated at 20 characters**
- Maximum 2 events visible at once
- Titles truncated at 20 characters
- Time format: HH:MM (24-hour, UTC+0)

### Architecture Compliance

**Widget Hierarchy:**
```
AppShell (main app container)
├── AgendaStrip (persistent at top)
├── MainContent (carousel/navigation)
└── BottomNav (if applicable)
```

**State Management:**
- Watch `nextEventsProvider` from Story 2.5 (Riverpod async provider)
- Rebuild automatically when events change
- Handle loading and error states gracefully

**Folder Structure:**
```
features/agenda/presentation/
├── widgets/
│   └── agenda_strip.dart        # New: Persistent strip widget
├── agenda_slide.dart            # Calendar view (Story 2.3)
└── _providers.dart              # Riverpod providers (Story 2.5)
```

### Key Implementation Details

**Widget Behavior:**

1. **Three States:**
   - **Events Today:** Display next 2 events with time (HH:MM) and title (max 20 chars)
   - **No Events Today:** Display first event tomorrow with "Tomorrow" label
   - **Nothing Scheduled:** Display "Nothing scheduled — free day"

2. **Visual Design:**
   - Height: 56dp (standard Material height for persistent UI)
   - Padding: sp12 (12dp) horizontal, sp8 (8dp) vertical
   - Background: colorSurface token (from Story 1.2)
   - Text: colorText token with opacity for secondary text
   - Divider: colorBorder token at bottom

3. **Event Display Format:**
   - Time: HH:MM (24-hour format, e.g., "14:30")
   - Title: Truncated at 20 characters with ellipsis
   - Layout: Time on left, title on right, stacked vertically if 2 events

4. **Interactivity:**
   - Tap anywhere on strip to open calendar modal
   - No navigation push/pop, use go_router bottom sheet route
   - Tapping preserves carousel position (state not lost)

5. **Real-time Updates:**
   - Watch `nextEventsProvider` (async Riverpod provider)
   - Automatically rebuild when provider updates
   - Handle loading state with skeleton loader (optional for MVP)
   - Handle error state with fallback message

**Loading State:**
- Show skeleton loader (shimmer effect) while events load
- Or show "Loading..." text (simpler for MVP)

**Error State:**
- Show "Unable to load schedule" with retry option
- Never crash or show raw error messages

### Dependencies & Imports

**From Story 2.1:**
- `features/agenda/data/agenda_repository.dart` — AgendaRepository
- `features/agenda/presentation/_providers.dart` — nextEventsProvider

**From Story 1.2 & 1.3:**
- `app/theme.dart` — ThemeData and spacing constants (sp8, sp12, sp16)
- `core/constants/app_colors.dart` — colorSurface, colorText, colorBorder tokens

**Riverpod:**
- `flutter_riverpod` — ConsumerWidget, useWatch
- `riverpod_annotation` — @riverpod (if creating local providers)

**Flutter:**
- `material.dart` — Material design widgets
- `intl.dart` — DateFormat for time formatting (if not already used)

### Testing Requirements

**Widget Tests:**
- Mock nextEventsProvider with different states (loading, error, data)
- Test three display states (events today, tomorrow, nothing scheduled)
- Test title truncation at 20 characters
- Test tap gesture opens calendar modal
- Test real-time updates when provider changes

**Test File Location:**
```
test/features/agenda/presentation/widgets/agenda_strip_test.dart
```

### Performance Considerations

- Use ConsumerWidget for efficient Riverpod watching
- Avoid rebuilding entire app when strip updates (scoped to widget)
- Cache event formatting (time/title) if performance needed
- Limit to next 2 events only (no scrolling within strip)

### Previous Story Intelligence

**From Story 2.1 (Event Data Access Layer):**
- AgendaRepository provides `getNextEvents(count)` method
- Returns Future<List<AgendaEvent>> ordered by startTime

**From Story 1.2 (Design Tokens):**
- Color tokens defined: colorSurface, colorText, colorBorder
- All colors use semantic tokens, never raw hex values

**From Story 1.3 (Theme System):**
- Spacing constants: sp2, sp4, sp8, sp12, sp16, sp20, sp24
- Animation durations: durationFast (150ms), durationDefault (250ms), durationSlow (400ms)

### Files to Create/Modify

**New Files:**
1. `lib/features/agenda/presentation/widgets/agenda_strip.dart` — Main widget
2. `test/features/agenda/presentation/widgets/agenda_strip_test.dart` — Widget tests

**Existing Files to Reference:**
- `lib/app/theme.dart` — Spacing and theme constants
- `lib/core/constants/app_colors.dart` — Color tokens
- `lib/features/agenda/presentation/_providers.dart` — Riverpod providers

## Implementation Notes

- Use ConsumerWidget for Riverpod integration
- Time format must be 24-hour (HH:MM)
- All text must use semantic color tokens, never hardcoded colors
- Ensure strip is always visible and doesn't scroll with content
- Handle edge cases: very long event titles, events at midnight, timezone boundaries

## Completion Checklist

- [ ] AgendaStrip widget created with ConsumerWidget
- [ ] Three display states implemented (today, tomorrow, nothing)
- [ ] Event titles truncated at 20 characters
- [ ] Time format is 24-hour (HH:MM)
- [ ] Tap gesture opens calendar modal via go_router
- [ ] Real-time updates working (watches nextEventsProvider)
- [ ] Loading and error states handled gracefully
- [ ] Widget tests written and passing
- [ ] Uses semantic color tokens (no hardcoded colors)
- [ ] Spacing follows design system (sp8, sp12, etc.)
- [ ] Code follows CONVENTIONS.md patterns
