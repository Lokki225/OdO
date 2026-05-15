# Story 5.7: Confirmation Sheet (Four Elements, Stale Slot Guard)

Status: ready-for-dev

## Story

As a user,
I want a clear, four-element confirmation sheet when OdO suggests something,
so that I can act or dismiss in seconds.

## Acceptance Criteria

1. The confirmation sheet at `/confirm-suggestion/:id` renders exactly four elements: suggestion text, context line, "Block it" primary button, "Not now" secondary text button
2. No close icon, no "remind me later", no why-field — these are explicitly out of scope
3. Long-pressing "Not now" reveals one option only: *"Don't suggest this again"* — tapping sets `suppressed_until = now + 7 days` (thumbs-down)
4. On sheet open, a stale-slot check runs immediately: if `suggestion.slotStart < DateTime.now()` (slot in the past) → all four elements collapse to a single line *"This slot is no longer available"* + "Close" button
5. "Block it" commits the suggestion: creates an `Event` (Practice category, at the suggestion slot) AND logs a `Session` simultaneously; sets `accepted_at = now`; `suppressed_until = now + 1 day`; dismisses sheet
6. "Not now" (without long-press) sets `dismissed_at = now`; `suppressed_until = now + 3 days`; dismisses sheet
7. "Thumbs down" (long-press path) sets `thumbs_down_at = now`; `suppressed_until = now + 7 days`; dismisses sheet
8. The suggestion text: `"Practice {skillName} at {slotTime}"` with `textTitle` style
9. Context line: `"{skillName} — {daysIdle} days since last session"` in `textBodyMuted`
10. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `ConfirmationSheetNotifier` (AC: 4–7)
  - [ ] `lib/features/proactive/presentation/proactive_providers.dart`
  - [ ] `confirmSuggestion(int id)`: transaction — insert Event + insert Session + update suggestion `accepted_at` + `suppressed_until`
  - [ ] `dismissSuggestion(int id)`: update `dismissed_at` + `suppressed_until = now + 3 days`
  - [ ] `thumbsDownSuggestion(int id)`: update `thumbs_down_at` + `suppressed_until = now + 7 days`
  - [ ] `checkStaleSlot(Suggestion s) → bool`: `s.slotStart < DateTime.now().millisecondsSinceEpoch`
- [ ] Task 2: Confirmation sheet UI (AC: 1–3, 8, 9)
  - [ ] `lib/features/proactive/presentation/pages/confirmation_sheet.dart`
  - [ ] Route: `/confirm-suggestion/:id` (bottom sheet via `CustomTransitionPage`)
  - [ ] On build: call `checkStaleSlot`; if stale → show collapsed stale state
  - [ ] Normal state: `Column` with suggestion text, context line, `ElevatedButton('Block it')`, `TextButton('Not now')`
  - [ ] Long-press on "Not now": `showMenu` or `showModalBottomSheet` with one item: *"Don't suggest this again"*
- [ ] Task 3: "Block it" transaction (AC: 5)
  - [ ] `AgendaNotifier.addEvent(Event)` + `PracticeNotifier.logSession(Session)` in parallel
  - [ ] `Event(title: 'Practice {skillName}', startTime: slotStart, endTime: slotStart+slotDuration, category: EventCategory.practice)`
  - [ ] `Session(skillId: suggestion.skillId, startedAt: slotStart, durationMinutes: slotDuration, isAnchored: true, suggestedTime: slotStart)`
- [ ] Task 4: Stale state UI (AC: 4)
  - [ ] `AnimatedSwitcher` replacing all four elements with one `Text` + `TextButton('Close')`
- [ ] Task 5: Lint check (AC: 10)

## Dev Notes

- **Stale slot check:** Open the sheet → immediately check `slotStart < now`. The "30-minute validity window" mentioned in architecture.md is already covered by this check: if `slotStart` is in the past, it's stale.
- **Transaction:** `confirmSuggestion` must write Event + Session + update suggestion atomically. Use `db.transaction(...)` to wrap all three writes.
- **No alternative suggestion:** When slot is stale, just show "close". Do NOT generate a new suggestion inline. The AI will try again tonight.
- **Suppression durations:** accepted=+1 day, dismissed=+3 days, thumbs-down=+7 days. These are epoch ms additions.
- **"Block it" button:** Use theme accent color (`colorAccent`) as button background — it's the primary action, visually emphasized.

### Project Structure Notes

```
lib/features/proactive/presentation/
├── pages/confirmation_sheet.dart
└── proactive_providers.dart    # ConfirmationSheetNotifier
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.7] — four-element spec, stale slot guard
- [Source: _bmad-output/planning-artifacts/architecture.md#Suggestion-Staleness] — stale slot mitigation

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List