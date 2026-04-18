# Story 4.6: AI State Management with Riverpod

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to manage AI state with Riverpod providers,
So that chat and suggestions update reactively.

## Acceptance Criteria

**Given** Claude API client from Story 4.2
**When** I create `features/ai/presentation/ai_providers.dart`
**Then** `aiProviderServiceProvider` returns AiProvider (swappable)
**And** `chatMessagesProvider` returns chat history (async)
**And** `aiResponseProvider(message)` sends message and returns response (async)
**And** `contextBuilderProvider` returns AI context payload (async)
**And** `aiNotifierProvider` provides StateNotifier for chat actions
**And** all providers use @riverpod annotation

## Tasks / Subtasks

- [ ] Task 1: Create core AI service providers (AC: AiProvider, ContextBuilder)
  - [ ] Create aiProviderServiceProvider with connectivity switching
  - [ ] Create contextBuilderProvider for AI context construction
  - [ ] Add provider dependency injection for repositories
  - [ ] Ensure provider swapping works (online/offline)
- [ ] Task 2: Implement chat state management (AC: Chat messages, responses)
  - [ ] Create chatMessagesProvider for message history
  - [ ] Create aiResponseProvider for sending messages to AI
  - [ ] Add message persistence to SQLite via providers
  - [ ] Handle chat loading and error states
- [ ] Task 3: Create AI action notifier (AC: StateNotifier for actions)
  - [ ] Create AiNotifier extending StateNotifier
  - [ ] Add methods for sending messages, clearing chat
  - [ ] Handle message retry functionality
  - [ ] Integrate with offline degradation logic
- [ ] Task 4: Add provider integration points (AC: All providers use @riverpod)
  - [ ] Use @riverpod annotation for all AI providers
  - [ ] Generate provider code with build_runner
  - [ ] Integrate providers with chat UI components
  - [ ] Test provider reactivity and state updates

## Dev Notes

### Critical Architecture Patterns

**Riverpod Provider Naming Convention:** Following the architecture specification, providers use descriptive suffixes:
- `Repository` providers = read-only data access
- `Notifier` providers = read and write state management  
- `Service` providers = call methods on services
- Computed providers = descriptive names with no suffix

**Provider Swapping Strategy:** The `aiProviderServiceProvider` automatically switches between ClaudeProvider and OfflineProvider based on connectivity state. This enables seamless offline degradation without feature code changes.

**Reactive State Management:** All AI interactions flow through Riverpod providers, enabling reactive UI updates when context changes, messages are sent, or connectivity toggles.

### Source Tree Components

**Primary Files to Create:**

```
features/ai/presentation/
├── ai_providers.dart              # All AI-related Riverpod providers
└── ai_notifier.dart              # AiNotifier StateNotifier class

features/ai/data/
└── ai_repository.dart            # AI data access layer for chat persistence
```

**Dependencies Required:**
- All previous Epic 4 stories (Context Builder, Claude Provider, Chat Interface, Offline Provider)
- `riverpod_annotation` for @riverpod syntax
- SQLite chat messages table for persistence
- ConnectivityService from Story 4.5

### Provider Architecture Design

**Core Provider Structure:**

```dart
// Service providers - return service instances
@riverpod
AiProvider aiProviderService(AiProviderServiceRef ref) {
  final isOnline = ref.watch(connectivityNotifierProvider);
  return isOnline ? ClaudeProvider() : OfflineProvider();
}

@riverpod
ContextBuilder contextBuilder(ContextBuilderRef ref) {
  final agendaRepo = ref.watch(agendaRepositoryProvider);
  final practiceRepo = ref.watch(practiceRepositoryProvider);
  return ContextBuilder(agendaRepo, practiceRepo);
}

// Data providers - return computed data
@riverpod
Future<List<ChatMessage>> chatMessages(ChatMessagesRef ref) async {
  final repository = ref.watch(aiRepositoryProvider);
  return repository.getAllMessages();
}

@riverpod
Future<ContextPayload> contextPayload(ContextPayloadRef ref) async {
  final builder = ref.watch(contextBuilderProvider);
  return builder.buildContext();
}

// Action providers - handle user interactions
@riverpod
Future<String> aiResponse(AiResponseRef ref, String message) async {
  final provider = ref.watch(aiProviderServiceProvider);
  final context = await ref.watch(contextPayloadProvider.future);
  return provider.complete(
    systemPrompt: context.toJson(),
    userMessage: message,
  );
}
```

**StateNotifier for Complex Actions:**

```dart
@riverpod
class AiNotifier extends _$AiNotifier {
  @override
  AiState build() => const AiState.initial();
  
  Future<void> sendMessage(String message) async {
    state = const AiState.loading();
    
    try {
      // Save user message
      final userMessage = ChatMessage(text: message, isUser: true);
      await _saveMessage(userMessage);
      
      // Get AI response
      final response = await ref.read(aiResponseProvider(message).future);
      
      // Save AI response
      final aiMessage = ChatMessage(text: response, isUser: false);
      await _saveMessage(aiMessage);
      
      // Refresh chat messages
      ref.invalidate(chatMessagesProvider);
      
      state = const AiState.success();
    } catch (error) {
      state = AiState.error(error.toString());
    }
  }
  
  Future<void> retryMessage(String message) async {
    final isOnline = ref.read(connectivityNotifierProvider);
    if (isOnline) {
      await sendMessage(message);
    }
  }
  
  void clearChat() {
    // Clear local chat history
    ref.read(aiRepositoryProvider).clearAllMessages();
    ref.invalidate(chatMessagesProvider);
  }
}
```

### Project Structure Notes

**Single Providers File:** Following architecture convention, all AI-related providers live in `ai_providers.dart`. This makes provider discovery predictable and maintainable.

**Integration with Other Modules:**
- Depends on `agendaRepositoryProvider` and `practiceRepositoryProvider`
- Provides context and responses to AI UI components
- Integrates with connectivity state from core services

### Chat Persistence Integration

**AIRepository for Chat Data:**

```dart
class AiRepository {
  final AppDatabase database;
  
  AiRepository(this.database);
  
  Future<List<ChatMessage>> getAllMessages() {
    return database.select(database.chatMessages).get().then(
      (rows) => rows.map((row) => ChatMessage.fromDb(row)).toList(),
    );
  }
  
  Future<void> saveMessage(ChatMessage message) {
    return database.into(database.chatMessages).insert(
      ChatMessagesCompanion.insert(
        message: message.text,
        isUserMessage: message.isUser,
        createdAt: message.timestamp,
      ),
    );
  }
  
  Future<void> clearAllMessages() {
    return database.delete(database.chatMessages).go();
  }
}
```

**Provider Integration:**

```dart
@riverpod
AiRepository aiRepository(AiRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return AiRepository(database);
}
```

### Testing Standards Summary

**Provider Testing:**
- Provider dependency injection works correctly
- Provider swapping (online/offline) functions properly
- State updates trigger UI reactivity
- Error states are handled gracefully
- Provider invalidation refreshes data

**Integration Testing:**
- Full message flow through providers
- Chat persistence via providers
- Context building through provider chain
- Offline/online transitions maintain state

**Test File Location:** `test/features/ai/presentation/ai_providers_test.dart`

### Technical Implementation Details

**Code Generation Setup:**
All providers use `@riverpod` annotation requiring build_runner:

```bash
dart run build_runner build
# Generates ai_providers.g.dart with provider implementations
```

**Provider Watching Patterns:**

```dart
// In UI components
class AiChatSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider);
    final aiState = ref.watch(aiNotifierProvider);
    
    return messages.when(
      data: (msgs) => ChatMessageList(messages: msgs),
      loading: () => ChatShimmer(),
      error: (err, stack) => ChatErrorState(),
    );
  }
}

// Sending messages
onSendPressed: () {
  ref.read(aiNotifierProvider.notifier).sendMessage(messageText);
}
```

**Provider Invalidation Strategy:**
- `chatMessagesProvider` invalidated after new messages
- `contextPayloadProvider` invalidated when agenda/practice data changes
- `aiProviderServiceProvider` updates automatically via connectivity watching

### State Classes and Models

**AI State Management:**

```dart
@freezed
class AiState with _$AiState {
  const factory AiState.initial() = _Initial;
  const factory AiState.loading() = _Loading;
  const factory AiState.success() = _Success;
  const factory AiState.error(String message) = _Error;
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isRetryable;
  
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isRetryable = false,
  });
}
```

### Error Handling in Providers

**Graceful Error Handling:**
- Network errors return OfflineProvider responses
- Database errors are logged locally, don't crash
- Provider errors are caught and converted to error states
- UI displays appropriate fallback content

**Retry Logic:**
```dart
Future<void> retryFailedMessage(String originalMessage) async {
  final connectivity = ref.read(connectivityNotifierProvider);
  if (connectivity) {
    // Attempt to resend through normal flow
    await sendMessage(originalMessage);
  } else {
    // Still offline, preserve retry option
    state = AiState.offline(originalMessage);
  }
}
```

### References

- [Architecture: Riverpod Provider Naming Convention] (architecture.md#riverpod-provider-naming--descriptive-pattern-with-suffix-convention)
- [Architecture: Provider Convention] (architecture.md#file-organization--strict-separation-with-provider-convention)
- [Architecture: Error Handling Pattern] (architecture.md#error-handling--asyncvalue-at-boundaries-result-type-internally)
- [Epic 4: AI Layer - Story 4.6] (epics.md#story-46-ai-state-management-with-riverpod)

### Epic Context & Dependencies

**This Story Completes:**
- Epic 4: AI Layer - All AI functionality with reactive state management
- Foundation for Epic 5: Proactive System (uses these providers)
- Complete AI integration pipeline: Context → Provider → Chat → Persistence

**Dependencies from Previous Work:**
- Story 4.1: ContextBuilder for context construction
- Story 4.2: ClaudeProvider for AI responses  
- Story 4.3: Chat interface for UI integration
- Story 4.4: Quick commands for enhanced chat interaction
- Story 4.5: OfflineProvider for graceful degradation

**Implementation Success Criteria:**
- Chat interface is fully reactive via providers
- Provider swapping works seamlessly (online/offline)
- Message persistence flows through provider layer
- All AI interactions are testable and maintainable

## Dev Agent Record

### Agent Model Used

Claude 3.5 Sonnet

### Debug Log References

### Completion Notes List

### File List
