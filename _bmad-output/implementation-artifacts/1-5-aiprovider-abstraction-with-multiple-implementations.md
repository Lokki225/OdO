---
storyId: 1.5
storyKey: 1-5-aiprovider-abstraction-with-multiple-implementations
epicId: 1
projectName: TooXTips
date: 2026-03-29
status: ready-for-dev
---

# Story 1.5: AiProvider Abstraction with Multiple Implementations

## Story Statement

As a developer,
I want to create an AiProvider abstract interface with concrete implementations (Claude, Gemini, Groq, OpenAI, Offline),
So that the AI provider can be swapped via a single constant without touching feature code.

## Acceptance Criteria

**Given** the AI provider architecture specification
**When** I create `core/services/ai_provider.dart` with abstract AiProvider interface
**Then** the interface defines `complete()` method with systemPrompt, userMessage, maxTokens parameters
**And** `ClaudeProvider` implements the interface for claude-sonnet-4-6
**And** `GeminiProvider` implements the interface for Gemini 1.5 Flash
**And** `GroqProvider` implements the interface for Llama 3.1 8B
**And** `OpenAiProvider` implements the interface for GPT-4o mini
**And** `OfflineProvider` returns empty string (graceful offline fallback)
**And** `core/constants/ai_constants.dart` defines AiConfig with provider selection
**And** Riverpod provider wiring allows swapping with one-line change

## Technical Requirements

### Abstract AiProvider Interface

```dart
abstract class AiProvider {
  /// Send a request to the AI provider and get a response
  /// 
  /// [systemPrompt]: System instructions for the AI
  /// [userMessage]: The user's message or query
  /// [maxTokens]: Maximum tokens in the response (default 1000)
  /// 
  /// Returns the AI's response text, or empty string if offline/error
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1000,
  });
}
```

### Claude Provider Implementation

```dart
class ClaudeProvider implements AiProvider {
  final String apiKey;
  
  ClaudeProvider({required this.apiKey});
  
  @override
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1000,
  }) async {
    // Implement Claude API integration
    // Model: claude-sonnet-4-6
    // Timeout: 3 seconds
    // Handle errors gracefully
  }
}
```

### Gemini Provider Implementation

```dart
class GeminiProvider implements AiProvider {
  final String apiKey;
  
  GeminiProvider({required this.apiKey});
  
  @override
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1000,
  }) async {
    // Implement Gemini API integration
    // Model: gemini-1.5-flash
    // Timeout: 3 seconds
    // Handle errors gracefully
  }
}
```

### Groq Provider Implementation

```dart
class GroqProvider implements AiProvider {
  final String apiKey;
  
  GroqProvider({required this.apiKey});
  
  @override
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1000,
  }) async {
    // Implement Groq API integration
    // Model: llama-3.1-8b-instant
    // Timeout: 3 seconds
    // Handle errors gracefully
  }
}
```

### OpenAI Provider Implementation

```dart
class OpenAiProvider implements AiProvider {
  final String apiKey;
  
  OpenAiProvider({required this.apiKey});
  
  @override
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1000,
  }) async {
    // Implement OpenAI API integration
    // Model: gpt-4o-mini
    // Timeout: 3 seconds
    // Handle errors gracefully
  }
}
```

### Offline Provider Implementation

```dart
class OfflineProvider implements AiProvider {
  @override
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1000,
  }) async {
    // Return empty string for graceful offline fallback
    return '';
  }
}
```

### AI Configuration

Create `lib/core/constants/ai_constants.dart`:

```dart
enum AiProviderType {
  claude,
  gemini,
  groq,
  openai,
  offline,
}

class AiConfig {
  // Change this single constant to swap providers
  static const AiProviderType activeProvider = AiProviderType.claude;
  
  // API keys (passed via --dart-define at build time)
  static const String claudeApiKey = String.fromEnvironment('CLAUDE_API_KEY', defaultValue: '');
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const String groqApiKey = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  static const String openaiApiKey = String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  
  // API endpoints
  static const String claudeEndpoint = 'https://api.anthropic.com/v1/messages';
  static const String geminiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  static const String groqEndpoint = 'https://api.groq.com/openai/v1/chat/completions';
  static const String openaiEndpoint = 'https://api.openai.com/v1/chat/completions';
  
  // Model names
  static const String claudeModel = 'claude-sonnet-4-6';
  static const String geminiModel = 'gemini-1.5-flash';
  static const String groqModel = 'llama-3.1-8b-instant';
  static const String openaiModel = 'gpt-4o-mini';
  
  // Timeout
  static const Duration apiTimeout = Duration(seconds: 3);
}
```

### Riverpod Provider Wiring

```dart
@riverpod
AiProvider aiProvider(AiProviderRef ref) {
  switch (AiConfig.activeProvider) {
    case AiProviderType.claude:
      return ClaudeProvider(apiKey: AiConfig.claudeApiKey);
    case AiProviderType.gemini:
      return GeminiProvider(apiKey: AiConfig.geminiApiKey);
    case AiProviderType.groq:
      return GroqProvider(apiKey: AiConfig.groqApiKey);
    case AiProviderType.openai:
      return OpenAiProvider(apiKey: AiConfig.openaiApiKey);
    case AiProviderType.offline:
      return OfflineProvider();
  }
}
```

## Implementation Details

### File Structure

Create two files:

1. `lib/core/services/ai_provider.dart`:
   - Abstract AiProvider interface
   - All five concrete implementations
   - Riverpod provider wiring

2. `lib/core/constants/ai_constants.dart`:
   - AiProviderType enum
   - AiConfig class with configuration

### Key Constraints

- All implementations MUST implement the AiProvider interface
- API keys MUST be passed via `String.fromEnvironment()` (never hardcoded)
- All API calls MUST have 3-second timeout
- All implementations MUST handle errors gracefully (return empty string)
- Provider swapping MUST require only one-line change in AiConfig
- OfflineProvider MUST return empty string (no errors)
- Riverpod provider MUST use @riverpod annotation

### API Integration Notes

- Claude: Use Anthropic API with messages endpoint
- Gemini: Use Google Generative AI API
- Groq: Use Groq API (OpenAI-compatible)
- OpenAI: Use OpenAI API
- All: Implement timeout handling and error recovery

### Verification Steps

1. Create `lib/core/services/ai_provider.dart`
2. Create `lib/core/constants/ai_constants.dart`
3. Implement abstract interface
4. Implement all five providers
5. Create Riverpod provider wiring
6. Run `flutter analyze` to check for errors
7. Verify provider can be swapped with one-line change
8. Test that OfflineProvider returns empty string

## Success Criteria

- ✓ AiProvider abstract interface defined
- ✓ ClaudeProvider implemented for claude-sonnet-4-6
- ✓ GeminiProvider implemented for Gemini 1.5 Flash
- ✓ GroqProvider implemented for Llama 3.1 8B
- ✓ OpenAiProvider implemented for GPT-4o mini
- ✓ OfflineProvider implemented (returns empty string)
- ✓ AiConfig class with provider selection
- ✓ API keys passed via String.fromEnvironment
- ✓ Riverpod provider wiring complete
- ✓ Provider swappable with one-line change
- ✓ Files compile without errors
- ✓ Ready for AI layer integration (Story 4.2)

## Dependencies

- Depends on: Story 1.1 (Project Setup)
- Blocks: Story 4.2 (Claude API Client)

## Notes

- This abstraction enables easy provider switching without code changes
- API keys are never stored in source code; passed at build time
- All providers follow the same interface for consistency
- OfflineProvider enables graceful degradation when offline
- The Riverpod provider makes swapping trivial (one constant change)
- Error handling is consistent across all implementations
