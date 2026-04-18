# Story 4.3: AI Chat Interface

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to chat with the AI to ask questions and get suggestions,
So that I can interact with the system conversationally.

## Acceptance Criteria

**Given** the Claude API client from Story 4.2
**When** I create `features/ai/presentation/ai_chat_sheet.dart`
**Then** the chat opens with one-line state summary at top: "3 events today · Japanese idle 5 days · 2 free slots this week" (UX-DR5)
**And** below the summary are quick-command suggestions (UX-DR6)
**And** the message input is always at bottom, thumb-reachable
**And** user can type a message and tap send
**And** the message appears in chat thread immediately
**And** the AI response appears below with loading state
**And** chat history persists in SQLite
**And** offline message handling: "Couldn't reach AI · Tap to retry" (UX-DR4)

## Tasks / Subtasks

- [ ] Task 1: Create AI chat sheet UI (AC: Chat interface, input positioning)
  - [ ] Build bottom sheet with persistent input at bottom
  - [ ] Add one-line state summary at top
  - [ ] Create chat message thread with scroll view
  - [ ] Add loading states for AI responses
- [ ] Task 2: Implement chat message handling (AC: Send/receive messages)
  - [ ] Add message input field with send button
  - [ ] Handle user message submission
  - [ ] Show messages immediately in thread
  - [ ] Integrate with Claude provider for AI responses
- [ ] Task 3: Add chat persistence (AC: Chat history persists)
  - [ ] Create chat messages table in SQLite
  - [ ] Save user and AI messages to database
  - [ ] Load previous conversation on sheet open
  - [ ] Handle message ordering and timestamps
- [ ] Task 4: Implement offline handling (AC: Offline message handling)
  - [ ] Detect when Claude provider is unavailable
  - [ ] Show "Couldn't reach AI · Tap to retry" message
  - [ ] Preserve user messages for retry when online
  - [ ] Handle graceful retry mechanism

## Dev Notes

### Critical UX Patterns

**State Summary Format (UX-DR5):** The chat opens with a one-line summary that gives immediate context without feeling like a dashboard. Format: "{events count} events today · {skill name} idle {days} days · {slots count} free slots this week". This is skimmable in under two seconds and provides AI context.

**Always-Accessible Input:** The message input stays at bottom, thumb-reachable, always ready. This follows the Claude/ChatGPT pattern for zero navigation to ask questions. The input never scrolls out of view.

**Offline Transparency (UX-DR4):** When offline, user messages appear normally but AI responses show "Couldn't reach AI · Tap to retry" in muted text below the message. The user's message is preserved for retry when connectivity returns.

### Source Tree Components

**Primary Files to Create:**

```
features/ai/presentation/
├── ai_chat_sheet.dart           # Main chat interface
├── widgets/
│   ├── chat_message.dart        # Individual message widget
│   ├── chat_state_summary.dart  # One-line summary at top
│   ├── chat_input.dart          # Bottom input with send button
│   └── chat_loading_indicator.dart # AI response loading state
└── ai_chat_providers.dart       # Chat-specific Riverpod providers
```

**Dependencies Required:**
- `features/ai/data/claude_provider.dart` (Story 4.2) - For AI responses
- `features/ai/domain/context_builder.dart` (Story 4.1) - For state summary
- Chat messages table in SQLite (new)
- ConnectivityService for offline detection

### Chat Persistence Schema

**New SQLite Table Required:**

```sql
CREATE TABLE chat_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  message TEXT NOT NULL,
  is_user_message BOOLEAN NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  retry_count INTEGER DEFAULT 0
);
```

**Message Flow:**
1. User types message → Save to SQLite as user message → Show in UI immediately
2. Send to AI provider → Show loading state
3. AI responds → Save response to SQLite → Show in UI
4. If offline → Show retry message → Allow retry when online

### Project Structure Notes

**Alignment with Architecture:**
- Chat sheet follows bottom sheet as route pattern (go_router integration)
- State management via Riverpod providers
- Persistence follows SQLite-first pattern
- Error handling uses graceful degradation, not error states

**Navigation Integration:**
Chat sheet opens as a route, not imperative push. This ensures proper back navigation and state management.

### State Summary Construction

**Context Integration:**
The state summary uses ContextBuilder from Story 4.1 but formats specifically for chat opening:

```dart
String buildStateSummary(ContextPayload context) {
  final eventsToday = context.agendaToday.length;
  final idleSkill = context.skills.reduce((a, b) => 
    a.daysSinceLastSession > b.daysSinceLastSession ? a : b);
  final freeSlots = context.freeSlots.length;
  
  return "$eventsToday events today · ${idleSkill.name} idle ${idleSkill.daysSinceLastSession} days · $freeSlots free slots this week";
}
```

### Testing Standards Summary

**UI Widget Tests:**
- Chat sheet opens and displays correctly
- Messages appear in thread when sent
- State summary shows current context
- Input remains at bottom during scroll
- Loading states display during AI calls

**Integration Tests:**
- Full message flow: user input → AI response → persistence
- Offline handling: message preserved, retry works
- State summary accuracy with various data states
- Chat history loads correctly on sheet reopen

**Test File Location:** `test/features/ai/presentation/ai_chat_sheet_test.dart`

### Technical Implementation Details

**Bottom Sheet Configuration:**
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true, // Full height control
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    height: MediaQuery.of(context).size.height * 0.9,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    child: AiChatSheet(),
  ),
);
```

**Message Thread Layout:**
- State summary fixed at top (no scroll)
- Chat messages in scrollable ListView
- Input fixed at bottom (no scroll)
- Keyboard-aware resizing

**Loading State Pattern:**
```dart
// While waiting for AI response
ChatMessage(
  text: userMessage,
  isUser: true,
  timestamp: DateTime.now(),
),
ChatLoadingIndicator(), // Shows "AI is thinking..." with animation
```

**Offline Detection:**
```dart
final isOnline = ref.watch(connectivityProvider);
if (!isOnline) {
  return ChatMessage(
    text: "Couldn't reach AI · Tap to retry",
    isUser: false,
    isRetryable: true,
    onRetry: () => _retryMessage(userMessage),
  );
}
```

### Quick Commands Integration

**Command Suggestions (UX-DR6):**
Quick commands appear below the state summary, before the message thread. These are context-aware suggestions that lower activation energy:

```dart
final quickCommands = [
  "When should I practice this week?",
  "Show my free slots today",
  "What's my longest idle skill?",
  "Plan my next practice session",
];
```

Commands are tappable and send the exact text as a message when tapped.

### Chat History Management

**Message Ordering:**
Messages load in chronological order (oldest first) with automatic scroll to bottom for new messages. SQLite query uses `ORDER BY created_at ASC`.

**Memory Management:**
For performance, limit chat history to last 100 messages. Older messages remain in SQLite but don't load in UI.

**Session Continuity:**
Chat history persists across app restarts. Opening the chat sheet shows the last conversation state.

### References

- [UX Design: AI Chat Opening State] (ux-design-specification.md#ai-chat-opening-state)
- [UX Design: Offline AI Behaviour] (ux-design-specification.md#offline-ai-behaviour)
- [UX Design: Pattern 3 - Offline State for AI Chat] (ux-design-specification.md#pattern-3-offline-state-for-ai-chat)
- [Epic 4: AI Layer - Story 4.3] (epics.md#story-43-ai-chat-interface)
- [Architecture: Error Handling Pattern] (architecture.md#error-handling--asyncvalue-at-boundaries-result-type-internally)

### Epic Context & Dependencies

**This Story Enables:**
- Story 4.4: Quick-Command Dropdown (builds on chat interface)
- Story 4.6: AI State Management (requires chat providers)
- Epic 5: Proactive System (chat interface used for suggestion follow-up)

**Dependencies from Previous Work:**
- Story 4.1: ContextBuilder for state summary construction
- Story 4.2: ClaudeProvider for AI responses
- Epic 1: SQLite database setup for message persistence

**User Experience Impact:**
This is the primary user-facing AI interaction surface. The quality of this implementation directly affects user perception of the AI's intelligence and reliability.

## Dev Agent Record

### Agent Model Used

Claude 3.5 Sonnet

### Debug Log References

### Completion Notes List

### File List
