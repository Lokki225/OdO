# Story 4.5: Offline Degradation for AI

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want the app to work when offline and gracefully degrade AI functionality,
So that I can still use Agenda and Practice without connectivity.

## Acceptance Criteria

**Given** the ConnectivityService from architecture
**When** the app detects offline state
**Then** the AI provider switches to OfflineProvider
**And** chat messages show: "Couldn't reach AI · Tap to retry"
**And** when connectivity returns, the message can be retried
**And** the user's message is preserved (not lost)
**And** the app never shows error states or spinners for AI unavailability

## Tasks / Subtasks

- [ ] Task 1: Implement ConnectivityService (AC: Detect offline state)
  - [ ] Create connectivity monitoring service
  - [ ] Provide real-time online/offline state
  - [ ] Integrate with connectivity_plus package
  - [ ] Add Riverpod provider for connectivity state
- [ ] Task 2: Create OfflineProvider (AC: AI provider switches)
  - [ ] Implement OfflineProvider class extending AiProvider
  - [ ] Return graceful empty responses
  - [ ] Never throw exceptions or errors
  - [ ] Match AiProvider interface exactly
- [ ] Task 3: Implement graceful chat degradation (AC: Chat messages, retry)
  - [ ] Show offline messages in chat interface
  - [ ] Preserve user messages for retry
  - [ ] Add "tap to retry" functionality
  - [ ] Handle seamless transition back online
- [ ] Task 4: Ensure no error states (AC: Never shows error states)
  - [ ] Remove all AI-related error UI
  - [ ] Replace with neutral offline messages
  - [ ] Ensure app never breaks without connectivity
  - [ ] Test offline functionality thoroughly

## Dev Notes

### Critical Architecture Patterns

**Offline-First Principle:** The app works completely without connectivity. AI is an enhancement layer that degrades gracefully, never breaking the core experience. This is fundamental to the user experience in Abidjan with intermittent connectivity.

**Provider Swapping:** When offline, the AiProvider automatically switches to OfflineProvider. This happens transparently - no feature code changes needed. The architecture abstracts connectivity state from feature implementation.

**Graceful Degradation:** The AI never comments on its own absence. No error states, no spinners, no explanations. Just tell the user what to do next: "Couldn't reach AI · Tap to retry."

### Source Tree Components

**Primary Files to Create:**

```
core/services/
├── connectivity_service.dart        # Monitor network connectivity
└── offline_provider.dart           # OfflineProvider implementation

core/providers/
└── connectivity_provider.dart      # Riverpod connectivity state

features/ai/presentation/widgets/
├── offline_message.dart            # Offline chat message widget
└── retry_button.dart               # Tap to retry functionality
```

**Dependencies Required:**
- `connectivity_plus` package (already in pubspec.yaml)
- AiProvider interface from Epic 1
- Chat interface from Story 4.3 for offline message integration

### ConnectivityService Implementation

**Real-time Connectivity Monitoring:**

```dart
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  Stream<bool> get onlineStream {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }
  
  Future<bool> get isOnline async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
```

**Riverpod Integration:**
```dart
@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  @override
  bool build() {
    final service = ref.watch(connectivityServiceProvider);
    // Listen to connectivity changes
    ref.listen(connectivityStreamProvider, (_, isOnline) {
      state = isOnline.value ?? false;
    });
    return true; // Default to online assumption
  }
}
```

### OfflineProvider Implementation

**Graceful Offline Responses:**

```dart
class OfflineProvider implements AiProvider {
  @override
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1024,
  }) async {
    // Always return empty string - matches expected offline behavior
    return '';
  }
}
```

**Key Design Decision:** OfflineProvider returns empty string, not error messages. The UI layer handles offline messaging, not the provider layer. This keeps provider interfaces clean.

### Project Structure Notes

**Connectivity Integration Pattern:**
```
Connectivity State → AiProvider Selection → Feature Usage
     ↓                    ↓                    ↓
ConnectivityService → ClaudeProvider OR → Chat Interface
                      OfflineProvider
```

**Service Layer Separation:**
- ConnectivityService = detect network state
- OfflineProvider = graceful AI fallback
- UI components = handle offline messaging

### Offline Chat Message Patterns

**Message Preservation Strategy:**
When user sends message while offline:
1. Message appears in chat thread immediately
2. Below message, show: "Couldn't reach AI · Tap to retry"
3. Store message locally for retry
4. When online, "tap to retry" resends exact message
5. User never has to retype their thought

**UI Implementation:**
```dart
class OfflineMessage extends StatelessWidget {
  final String userMessage;
  final VoidCallback onRetry;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatMessage(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
        GestureDetector(
          onTap: onRetry,
          child: Text(
            "Couldn't reach AI · Tap to retry",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
```

### Testing Standards Summary

**Offline Functionality Tests:**
- App launches and functions without connectivity
- AI provider switches to OfflineProvider when offline
- Chat messages preserved for retry
- No error states or crashes when offline
- Seamless transition back to ClaudeProvider when online

**Integration Tests:**
- Full offline → online → offline cycle
- Message retry functionality
- Provider switching reliability
- UI state consistency during transitions

**Test File Location:** `test/core/services/connectivity_service_test.dart`

### Technical Implementation Details

**Provider Switching Logic:**
```dart
@riverpod
AiProvider aiProvider(AiProviderRef ref) {
  final isOnline = ref.watch(connectivityNotifierProvider);
  
  if (!isOnline) {
    return OfflineProvider();
  }
  
  // Return configured provider (Claude, Gemini, etc.)
  return ClaudeProvider(claudeConfig);
}
```

**Retry Mechanism:**
```dart
Future<void> retryMessage(String message) async {
  final isOnline = await ref.read(connectivityServiceProvider).isOnline;
  
  if (isOnline) {
    // Send message through normal flow
    await _sendToAi(message);
    // Remove offline message, show AI response
  } else {
    // Still offline - keep retry option available
    _showStillOfflineMessage();
  }
}
```

**State Transition Handling:**
- Offline → Online: Preserve all pending messages for retry
- Online → Offline: Current AI calls complete, future calls use OfflineProvider
- Rapid toggles: Debounce connectivity changes to prevent UI flicker

### Offline UI Patterns

**No Error States Rule:**
Never show:
- "Connection Error"
- "Network Unavailable"  
- Red error messages
- Spinners that never resolve
- "Try again later" without specific action

Always show:
- "Couldn't reach AI · Tap to retry"
- Neutral, actionable language
- Clear next steps for user

**Offline Behavior Consistency:**
- Agenda module: Works 100% offline (local SQLite)
- Practice module: Works 100% offline (local SQLite)  
- AI module: Degrades gracefully, preserves messages
- All core features remain functional

### References

- [Architecture: Offline-First with AI as Enhancement] (architecture.md#offline-first-with-ai-as-enhancement)
- [Architecture: AI Provider Abstraction - OfflineProvider] (architecture.md#ai-provider-abstraction-swappable-without-feature-code-changes)
- [UX Design: Offline State for AI Chat] (ux-design-specification.md#pattern-3-offline-state-for-ai-chat)
- [Epic 4: AI Layer - Story 4.5] (epics.md#story-45-offline-degradation-for-ai)
- [Architecture: Graceful AI Degradation] (architecture.md#graceful-ai-degradation-when-offline)

### Epic Context & Dependencies

**This Story Enables:**
- Reliable app usage in low-connectivity environments
- Zero-friction AI interaction that never breaks
- Foundation for proactive system (Epic 5) offline logic

**Dependencies from Previous Work:**
- Epic 1: AiProvider abstraction for provider swapping
- Story 4.3: Chat interface for offline message integration
- ConnectivityService architecture specification

**Critical Success Factor:**
Users in Abidjan with intermittent connectivity should never feel that the app is broken. Offline state should be invisible - the app just works, with or without AI.

## Dev Agent Record

### Agent Model Used

Claude 3.5 Sonnet

### Debug Log References

### Completion Notes List

### File List
