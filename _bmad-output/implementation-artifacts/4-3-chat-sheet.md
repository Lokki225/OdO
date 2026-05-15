# Story 4.3: Chat Sheet

Status: ready-for-dev

## Story

As a user,
I want a modal chat surface where I can ask OdO questions,
so that I have a reactive channel to the AI.

## Acceptance Criteria

1. Tapping the text input in the bottom bar opens a modal chat sheet at `/chat`
2. Previous messages from the current app launch are visible (session-scoped chat history, in-memory V1)
3. User can type and send messages; OdO responds via the active `AiProvider`
4. OdO never initiates inside the chat — only the user sends first
5. On first open, three starter quick-command chips are visible (if no history): "What should I practice today?", "What's my next event?", "What's my Japanese streak?" — tapping sends that message
6. AI response streams in word-by-word (streaming response from `aiProvider.streamResponse`)
7. When offline, the user's message stays in the thread with *"Couldn't reach AI · Tap to retry"* underneath it
8. Retry taps resend the same message without retyping
9. Sending a new message while the AI is still responding cancels the in-flight stream and starts a new request
10. Chat history is scoped to the current app launch — cleared on app restart (no persistence in V1)
11. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `ChatMessage` state and `ChatNotifier` (AC: 2–4, 6–10)
  - [ ] `lib/features/ai/presentation/ai_providers.dart`
  - [ ] `chatMessagesProvider`: `NotifierProvider<ChatNotifier, List<ChatMessageViewModel>>`
  - [ ] `ChatMessageViewModel`: `String content`, `bool isUser`, `bool isStreaming`, `bool failedOffline`, `DateTime timestamp`
  - [ ] `ChatNotifier.sendMessage(String text)`:
    1. Append user message to state
    2. Check `connectivityServiceProvider.isCurrentlyOnline`; if offline → append failure message with `failedOffline: true`
    3. Build context via `AiService.buildContext()`
    4. Call `aiProvider.streamResponse(payload)`
    5. Append AI message with `isStreaming: true`, update token-by-token
    6. On complete: set `isStreaming: false`
  - [ ] `retryLastMessage()`: re-sends the last failed user message
- [ ] Task 2: Chat sheet UI (AC: 1, 5, 6–8)
  - [ ] `lib/features/ai/presentation/pages/chat_sheet.dart`
  - [ ] Full-screen modal (`showModalBottomSheet(isScrollControlled: true)`)
  - [ ] `ListView.builder` of `ChatBubble` widgets (user: right-aligned, AI: left-aligned)
  - [ ] Starter chips: `Wrap` of `ActionChip` visible only when history is empty
  - [ ] Bottom: `TextField` + send `IconButton`; auto-scrolls to bottom on new message
  - [ ] Failed message: shows message text + `TextButton('Tap to retry', onPressed: retryLastMessage)`
- [ ] Task 3: `ChatBubble` widget (AC: 6)
  - [ ] Streaming AI bubble: show text as it arrives; blinking cursor `|` appended while `isStreaming`
  - [ ] Completed bubble: no cursor
- [ ] Task 4: Connectivity integration (AC: 7, 8)
  - [ ] Watch `connectivityServiceProvider` in `ChatNotifier`
  - [ ] On network restore, do NOT auto-retry — wait for user tap
- [ ] Task 5: Lint check (AC: 11)

## Dev Notes

- **Streaming display:** Receive `Stream<String>` from `aiProvider.streamResponse`. Accumulate tokens in a `StringBuffer` inside `ChatNotifier`; update state on each emission with `AsyncValue.guard`.
- **Cancel in-flight request:** Store the stream subscription; call `subscription.cancel()` before starting a new request.
- **Chat history scope:** In-memory `List<ChatMessageViewModel>` in the `Notifier` state. Not persisted to Drift. Cleared on app restart.
- **Starter chips:** Check `state.isEmpty` to show chips. After first message sent, chips disappear permanently for this session.
- **Sheet height:** `DraggableScrollableSheet` with `initialChildSize: 0.9` — feels like near-fullscreen.
- **Keyboard handling:** `resizeToAvoidBottomInset: true` on the scaffold inside the sheet ensures the input stays above the keyboard.

### Project Structure Notes

```
lib/features/ai/presentation/
├── pages/chat_sheet.dart
├── widgets/chat_bubble.dart
└── ai_providers.dart      # ChatNotifier, chatMessagesProvider
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-4.3] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md] — chat UI design

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List