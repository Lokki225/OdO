# Story 4.2: Claude API Client with Error Handling

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to create a Claude API client that handles requests and responses,
So that the app can communicate with Claude API.

## Acceptance Criteria

**Given** the AiProvider abstraction from Epic 1
**When** I create `features/ai/data/claude_provider.dart` implementing AiProvider
**Then** it sends POST requests to Claude API with systemPrompt and userMessage
**And** it includes context payload from Story 4.1
**And** it handles API timeout (3 second max) gracefully
**And** it returns parsed response text
**And** it handles API errors without crashing (returns empty string or error message)
**And** API key is passed via String.fromEnvironment (NFR16)

## Tasks / Subtasks

- [ ] Task 1: Implement ClaudeProvider class (AC: All)
  - [ ] Create ClaudeProvider implementing AiProvider interface
  - [ ] Add HTTP client with 3-second timeout
  - [ ] Implement complete() method with Claude API format
  - [ ] Add API key handling via String.fromEnvironment
- [ ] Task 2: Add comprehensive error handling (AC: API errors, timeout)
  - [ ] Handle network timeouts gracefully
  - [ ] Handle API rate limiting (429) responses
  - [ ] Handle authentication errors (401)
  - [ ] Handle malformed responses
  - [ ] Return appropriate fallback responses
- [ ] Task 3: Integrate context payload (AC: Context inclusion)
  - [ ] Accept ContextPayload from Story 4.1
  - [ ] Format context into Claude API system prompt
  - [ ] Ensure payload size validation before API call
- [ ] Task 4: Add response parsing and validation (AC: Parsed response)
  - [ ] Parse Claude API JSON response format
  - [ ] Extract message content from response
  - [ ] Validate response structure
  - [ ] Handle empty or malformed responses

## Dev Notes

### Critical Architecture Patterns

**AiProvider Abstraction:** This implements the swappable AI provider pattern from architecture.md. ClaudeProvider is one concrete implementation of the AiProvider interface, allowing future swapping to Gemini, Groq, OpenAI, or Offline providers without changing feature code.

**API Key Security (NFR16):** API keys are never hardcoded in source. They're passed at build time via `--dart-define=CLAUDE_API_KEY=sk-...` and accessed through `String.fromEnvironment('CLAUDE_API_KEY')`. This ensures keys never appear in version control.

**Error Handling Pattern:** Uses Result<T> pattern internally (from architecture.md conventions) but returns simple String responses to match AiProvider interface. Network failures gracefully degrade rather than crashing the app.

### Source Tree Components

**Primary Files to Create:**

```
features/ai/data/
├── claude_provider.dart          # Main ClaudeProvider implementation
├── ai_api_models.dart           # Claude API request/response models
└── ai_error_handler.dart        # Centralized error handling utilities
```

**Dependencies Required:**
- `http` package for API calls (already in pubspec.yaml)
- `features/ai/domain/context_builder.dart` (Story 4.1) - For context payload
- `core/services/ai_provider.dart` (Epic 1) - AiProvider interface

**Integration Points:**
- AiProvider interface from Epic 1
- ContextBuilder from Story 4.1 for context payload construction
- Future Riverpod provider registration in Story 4.6

### Claude API Specifications

**Endpoint Configuration:**
```dart
const claudeApiUrl = 'https://api.anthropic.com/v1/messages';
const claudeModel = 'claude-3-5-sonnet-20241022';  // Latest stable
const maxTokens = 1024;  // Sufficient for structured responses
```

**Request Format:**
```dart
final requestBody = {
  'model': claudeModel,
  'max_tokens': maxTokens,
  'system': systemPrompt,  // Context payload goes here
  'messages': [
    {
      'role': 'user',
      'content': userMessage,
    }
  ]
};
```

**Headers Required:**
```dart
final headers = {
  'Content-Type': 'application/json',
  'x-api-key': String.fromEnvironment('CLAUDE_API_KEY'),
  'anthropic-version': '2023-06-01',
};
```

### Project Structure Notes

**Alignment with Architecture:**
- Follows data/domain/presentation separation
- ClaudeProvider is data layer - handles external API
- Implements domain interface (AiProvider) without UI dependencies
- Error handling follows Result<T> pattern internally

**File Organization Rationale:**
- `claude_provider.dart` - Main implementation
- `ai_api_models.dart` - Request/response data structures  
- `ai_error_handler.dart` - Reusable error handling logic

### Testing Standards Summary

**Unit Test Coverage Required:**
- Successful API request/response flow
- Network timeout handling (3-second limit)
- Various HTTP error codes (401, 429, 500, etc.)
- Malformed response handling
- API key validation
- Context payload integration

**Test File Location:** `test/features/ai/data/claude_provider_test.dart`

**Mock Strategy:** Mock HTTP client responses for deterministic testing without actual API calls.

### Technical Implementation Details

**Timeout Implementation:**
```dart
final client = http.Client();
try {
  final response = await client.post(
    Uri.parse(claudeApiUrl),
    headers: headers,
    body: jsonEncode(requestBody),
  ).timeout(const Duration(seconds: 3));
} on TimeoutException {
  return 'Request timed out - please try again';
} finally {
  client.close();
}
```

**Error Response Strategy:**
- Network errors: Return user-friendly message, don't crash
- API errors: Log status code locally, return graceful fallback
- Timeout: Return retry message
- Empty response: Return empty string (matches OfflineProvider)

**Response Parsing:**
```dart
try {
  final decoded = jsonDecode(response.body);
  final content = decoded['content']?[0]?['text'] as String? ?? '';
  return content;
} catch (e) {
  print('⚠️  Claude response parsing failed: $e');
  return 'Unable to process response';
}
```

**Local Logging Pattern:**
```dart
// Local logging only - no analytics
print('🔗 Claude API call: ${response.statusCode}');
print('⚠️  Claude API error: ${response.statusCode} - ${response.reasonPhrase}');
```

### Context Integration Strategy

**System Prompt Construction:**
The context payload from Story 4.1 becomes the system prompt:

```dart
Future<String> complete({
  required String systemPrompt,
  required String userMessage,
  int maxTokens = 1024,
}) async {
  // systemPrompt contains the structured context from ContextBuilder
  // userMessage contains the user's chat message or AI query
  
  final requestBody = {
    'model': claudeModel,
    'max_tokens': maxTokens,
    'system': systemPrompt,  // Pre-built context payload
    'messages': [
      {'role': 'user', 'content': userMessage}
    ]
  };
  
  // ... API call logic
}
```

### References

- [Architecture: AI Provider Abstraction] (architecture.md#ai-provider-abstraction-swappable-without-feature-code-changes)
- [Architecture: API Key Security] (architecture.md#api-key-security)
- [Architecture: Error Handling Pattern] (architecture.md#error-handling--asyncvalue-at-boundaries-result-type-internally)
- [Epic 4: AI Layer - Story 4.2] (epics.md#story-42-claude-api-client-with-error-handling)
- [Architecture: Claude Model Version] (architecture.md#claude-model-version--pinned-to-claude-sonnet-4-6)

### Epic Context & Dependencies

**This Story Enables:**
- Story 4.3: AI Chat Interface (requires working Claude provider)
- Story 4.6: AI State Management (requires provider for Riverpod integration)
- Epic 5: Proactive System (requires AI provider for suggestion generation)

**Dependencies from Previous Work:**
- Epic 1: AiProvider interface and abstraction setup
- Story 4.1: ContextBuilder for context payload construction

**Integration Testing:**
After implementation, test the full flow: ContextBuilder → ClaudeProvider → parsed response. This validates the complete AI pipeline before UI integration.

## Dev Agent Record

### Agent Model Used

Claude 3.5 Sonnet

### Debug Log References

### Completion Notes List

### File List
