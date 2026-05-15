# Story 6.5: Accessibility Audit

Status: ready-for-dev

## Story

As a user with accessibility needs,
I want OdO to work with screen readers and respect motion preferences,
so that I'm not excluded.

## Acceptance Criteria

1. All interactive elements have `Semantics` labels: buttons, chips, icons, tappable containers
2. The Orb announces its state: `Semantics(label: 'OdO is idle' / 'OdO is listening' / 'OdO is parsing')` based on current `OrbState`
3. All touch targets are ≥44dp (Flutter default `InteractiveViewerTheme` or explicit `GestureDetector` sizing)
4. `MediaQuery.disableAnimations` is respected throughout (verified in Story 6.4; this story confirms via audit)
5. Voice is fully equivalent to tap for all critical flows: add event, log session, dismiss suggestion — each is achievable via voice command alone
6. Color is never the only signal for state: every color-coded element has an icon or text label paired
7. The agenda strip category dots have `Semantics(label: 'Work event')` etc.
8. Manual TalkBack/VoiceOver walkthrough of key flows passes with no unlabeled elements
9. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `Semantics` audit — interactive elements (AC: 1)
  - [ ] Audit all `IconButton` widgets: add `tooltip` parameter (Flutter auto-generates Semantics from tooltip)
  - [ ] All `GestureDetector` wrapping non-button elements: wrap in `Semantics(button: true, label: '...')`
  - [ ] All `InkWell` elements: add `Semantics` wrapper
- [ ] Task 2: Orb semantics (AC: 2)
  - [ ] In `Orb` widget: wrap with `Semantics(label: _orbLabel(state), liveRegion: true)`
  - [ ] `_orbLabel(OrbState state)`: map each state to a French string: `'OdO est en veille'`, `'OdO vous écoute'`, `'OdO analyse'`, `'Action confirmée'`
- [ ] Task 3: Touch target audit (AC: 3)
  - [ ] `grep` for `IconButton` and `GestureDetector` — verify each has minimum 44dp tap area
  - [ ] Use `SizedBox(width: 44, height: 44, child: ...)` where icon is smaller than 44dp
  - [ ] Or set `IconButton(iconSize: 24, padding: EdgeInsets.all(10))` → total tap area = 44dp
- [ ] Task 4: Category color + icon pairing (AC: 6, 7)
  - [ ] Event blocks: left-bar color PLUS a small icon (`person_outline`, `work_outline`, `fitness_center`) at top-left of block
  - [ ] Agenda strip: dots have `Semantics(label: 'Événement travail')` etc.
  - [ ] Category chips in add-event form: radio buttons with both color + text label (already done, verify)
- [ ] Task 5: Voice equivalence check (AC: 5)
  - [ ] Trace add event via voice: "add event meeting at 3pm" → `VoicePipelineNotifier` → `CreateEventIntent` → add-event sheet opens pre-filled → user confirms
  - [ ] Trace log session: "log 30 min Japanese" → `LogSessionIntent` → immediate commit
  - [ ] Trace dismiss suggestion: say "not now" after suggestion notification
  - [ ] Document in Dev Agent Record: any gap where voice is not equivalent to tap
- [ ] Task 6: TalkBack walkthrough (AC: 8)
  - [ ] Manual: enable TalkBack on Android; walk through: Glance Screen, Agenda tab, Practice tab, Chat sheet
  - [ ] All elements must be reachable and labeled
- [ ] Task 7: Lint check (AC: 9)

## Dev Notes

- **`Semantics` vs `Tooltip`:** `IconButton(tooltip: 'Ajouter')` auto-generates a `Semantics` label. Prefer `tooltip` over manual `Semantics` wrap for buttons. Manual `Semantics` wrap is needed for `GestureDetector` and `InkWell`.
- **French semantics labels:** Since UI is French-primary, semantics labels should also be in French. Voice users use the system TTS which reads semantics labels.
- **44dp touch target:** Flutter's `MaterialTapTargetSize.padded` (default) adds padding to ensure 48dp tap area for `ButtonTheme`. For custom tap areas, enforce manually.
- **`liveRegion: true` on Orb:** This causes the screen reader to announce orb state changes automatically. Use with care — only for the orb (changes are meaningful) and the retry message in chat.

### Project Structure Notes

Changes are spread across all feature widgets — no new files needed. Document all changes in the File List.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-6.5] — accessibility requirements
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md] — 44dp touch targets, voice equivalence

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List