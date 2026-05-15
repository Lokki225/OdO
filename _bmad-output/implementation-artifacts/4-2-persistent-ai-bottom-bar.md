# Story 4.2: Persistent AI Bottom Bar

Status: ready-for-dev

## Story

As a user,
I want a bottom bar on the home screen with quick-add, text input, and mic toggle,
so that OdO is always one tap away.

## Acceptance Criteria

1. The AI bottom bar renders at the bottom of the home screen (above the navigation bar) and on the Glance Screen
2. Three elements visible left-to-right: quick-add (+) button on left, text input field center, microphone toggle on right
3. Tapping the text input expands into the chat sheet (`context.push('/chat')` — modal)
4. Tapping the microphone toggle initiates voice capture (Story 4.4 wires the actual pipeline; this story puts the button in place with a tap callback)
5. Tapping quick-add (+) opens a bottom sheet with three options: "Add event", "Log session", "Add skill" — each navigates to the corresponding route
6. The bar is a shared widget used on both home screen and Glance Screen (same widget, different parent)
7. Bar uses semantic tokens: `colorSurface` background, `colorBorder` top border, `colorTextMuted` placeholder text
8. Mic icon changes color to `colorAccent` when voice is active (driven by `voiceStateProvider`)
9. Widget test: tapping text input → chat route triggered; tapping + → quick-add sheet shows 3 options

## Tasks / Subtasks

- [ ] Task 1: `AiBottomBar` widget (AC: 1–7)
  - [ ] `lib/features/ai/presentation/widgets/ai_bottom_bar.dart`
  - [ ] `ConsumerWidget` with `onMicTap` callback parameter
  - [ ] Quick-add (+): `IconButton` → `showModalBottomSheet` with three `ListTile` options
  - [ ] Text input: `GestureDetector` wrapping a read-only `TextField` (tapping opens chat, not keyboard) → `onTap: () => context.push('/chat')`
  - [ ] Mic: `IconButton` with dynamic color from `voiceStateProvider`
  - [ ] Layout: `Row` with `Container` wrapping the text input (flex: 1), fixed-width side buttons
  - [ ] Bar height: 56dp; horizontal padding: `sp16`
- [ ] Task 2: Quick-add sheet (AC: 5)
  - [ ] Inline bottom sheet content: `Column` with three `ListTile` entries
  - [ ] "Add event" → `context.go('/home/agenda/add-event')`
  - [ ] "Log session" → show skill picker first (if multiple skills) or go directly if one skill
  - [ ] "Add skill" → `context.go('/home/practice/add-skill')` (placeholder route for now)
- [ ] Task 3: `voiceStateProvider` (AC: 8)
  - [ ] `lib/features/ai/presentation/ai_providers.dart`
  - [ ] `voiceStateProvider`: `StreamProvider<VoiceState>` wrapping `voiceService.stateStream$`
  - [ ] Mic icon: `Icons.mic` when idle, `Icons.mic_none` when listening, `Icons.stop` when parsing
- [ ] Task 4: Wire into home screen and Glance Screen (AC: 1, 6)
  - [ ] Add `AiBottomBar` to home screen scaffold above nav bar
  - [ ] Glance Screen (Story 5.1) will also include `AiBottomBar`
- [ ] Task 5: Widget tests (AC: 9)
  - [ ] `test/features/ai/presentation/widgets/ai_bottom_bar_test.dart`
- [ ] Task 6: Lint check

## Dev Notes

- **Text input UX:** The center element looks like a `TextField` but acts as a button (taps open chat sheet, no inline keyboard). Use `GestureDetector` + `AbsorbPointer` or set `readOnly: true` and handle `onTap`.
- **Shared widget:** `AiBottomBar` takes an optional `onMicTap` callback. Home screen and Glance Screen provide their own mic callbacks (same logic, different parent context).
- **Bottom safe area:** Wrap the bar in `SafeArea(top: false, bottom: true)` to respect notches.
- **`/chat` route:** Add this to `router.dart` (Story 1.8 may not have included it — add it now as a modal bottom sheet route).

### Project Structure Notes

```
lib/features/ai/presentation/
├── widgets/
│   └── ai_bottom_bar.dart
└── ai_providers.dart      # voiceStateProvider
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-4.2] — three elements spec
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md] — bottom bar layout

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List