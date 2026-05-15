# Story 5.1: Glance Screen — Layout and States

Status: ready-for-dev

## Story

As a user,
I want a Glance Screen that shows lock state, the orb, my next event, and the latest suggestion,
so that one look tells me what I need to know.

## Acceptance Criteria

1. The Glance Screen at route `/glance` renders as the initial route (app opens here)
2. Top row: lock icon (violet when locked, green when unlocked) + text label ("Locked" / "Unlocked")
3. AI orb is centered, using `OrbState.idle` breathing animation
4. Below the orb, up to 2 info cards render: next upcoming event (always shown if exists), OdO's latest suggestion (shown only if a suggestion was created in the last 18 hours)
5. Info cards never show sensitive data — event cards show title + time only (no full descriptions, no notes)
6. The AI bottom bar (from Story 4.2) renders at the bottom: quick-add, text input, mic
7. A subtle slide-up handle is visible at the very bottom (indicates swipe-up to unlock)
8. The screen background is `colorBackground` (OLED-optimized `#0D0D0F`)
9. Suggestion info card shows: `"OdO suggests: {skillName} at {slotTime}"` with a muted secondary line
10. Widget tests: locked state renders lock icon; no events → event card hidden; no recent suggestion → suggestion card hidden

## Tasks / Subtasks

- [ ] Task 1: `GlanceScreenProvider` (AC: 2, 4)
  - [ ] `lib/features/glance/presentation/glance_providers.dart`
  - [ ] `glanceLockStateProvider`: `StateProvider<bool>` (true = locked)
  - [ ] `nextEventProvider`: `FutureProvider<Event?>` — calls `agendaRepository.getEventsBetween(now, now+48h)` → returns first upcoming
  - [ ] `latestSuggestionProvider`: `FutureProvider<Suggestion?>` — queries suggestions table, filters `suggested_at > now - 18h` AND `accepted_at == null AND dismissed_at == null`
- [ ] Task 2: Glance Screen widget (AC: 1–9)
  - [ ] `lib/features/glance/presentation/pages/glance_page.dart`
  - [ ] `Scaffold(backgroundColor: colorBackground)` — no AppBar
  - [ ] Top: `Row` with `LockIcon` widget + label `Text`
  - [ ] Center: `Orb` widget (Story 5.3) watching `orbStateProvider`
  - [ ] Info cards section: `Column` with conditional `EventInfoCard` and `SuggestionInfoCard`
  - [ ] Bottom: `AiBottomBar` + `SlideUpHandle` widget (8dp drag indicator bar)
- [ ] Task 3: `EventInfoCard` widget (AC: 4, 5)
  - [ ] `lib/features/glance/presentation/widgets/event_info_card.dart`
  - [ ] Shows: `HH:mm Title` — no notes, no category
  - [ ] Card style: `colorSurface` bg, `radiusLg`, no border
- [ ] Task 4: `SuggestionInfoCard` widget (AC: 9)
  - [ ] `lib/features/glance/presentation/widgets/suggestion_info_card.dart`
  - [ ] Shows: *"OdO suggests: {skillName} at {slotTime}"* in `textBody`
  - [ ] Secondary line: *"Tap to confirm"* in `textCaption` + `colorTextMuted`
  - [ ] Tap → `context.push('/confirm-suggestion/${suggestion.id}')`
- [ ] Task 5: Widget tests (AC: 10)
- [ ] Task 6: Lint check

## Dev Notes

- **Initial route:** `GoRouter(initialLocation: '/glance')` — set in Story 1.8. Verify this is correct.
- **Lock state:** `glanceLockStateProvider` starts as `true` (locked). Authentication (Story 5.2) sets it to `false`.
- **18-hour suggestion window:** Suggestions created between now-18h and now that have `accepted_at = null` and `dismissed_at = null`. The latest one (most recent `suggested_at`) is shown.
- **`Suggestion` domain entity:** Add to `lib/features/glance/domain/` or re-export from a shared location. The suggestions table is owned by the SuggestionEngine (Story 5.6) — import the entity from there.
- **Orb stub:** Story 5.3 implements the full `Orb` widget. For this story, use a placeholder `CircleAvatar` with the active accent color — Story 5.3 will replace it.

### Project Structure Notes

```
lib/features/glance/presentation/
├── pages/glance_page.dart
├── glance_providers.dart
└── widgets/
    ├── event_info_card.dart
    └── suggestion_info_card.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.1] — layout and states spec
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Pattern-Glance-Screen] — four-element layout

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List