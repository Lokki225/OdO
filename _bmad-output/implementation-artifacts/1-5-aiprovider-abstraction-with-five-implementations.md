# Story 1.5: AiProvider Abstraction with Five Implementations

Status: ready-for-dev

## Story

As a developer,
I want an `AiProvider` abstract interface with concrete implementations,
so that the AI provider can be swapped via a single constant.

## Acceptance Criteria

1. `lib/features/ai/domain/ai_provider.dart` defines `AiProvider` abstract class with: `String get name`, `Future<Result<AiResponse>> sendContext(AiContextPayload payload)`, `Future<Result<Stream<String>>> streamResponse(AiContextPayload payload)`
2. `AiContextPayload` is a pure Dart value class with: `String contextText`, `String userMessage`, `List<ChatMessage> history`
3. `AiResponse` is a pure Dart value class with: `String text`, `DateTime timestamp`
4. `ChatMessage` is a pure Dart value class with: `String role` (`'user'|'assistant'`), `String content`, `DateTime timestamp`
5. `ClaudeAiProvider` in `lib/features/ai/data/claude_ai_provider.dart` is fully functional using `http` package and `--dart-define=AI_API_KEY`; targets `claude-sonnet-4-6` model
6. `GeminiAiProvider`, `GroqAiProvider`, `OpenAiAiProvider` stub implementations exist in `lib/features/ai/data/` — return `Failure(AppError.aiUnavailable)` for all methods in V1
7. `OfflineStubAiProvider` returns a deterministic canned response for testing
8. `lib/core/constants/ai_config.dart` defines `kActiveAiProvider` as a `const` string selecting the active provider (default `'claude'`)
9. `lib/features/ai/presentation/ai_providers.dart` exposes `aiProviderServiceProvider` which instantiates the correct `AiProvider` based on `kActiveAiProvider`
10. API keys never appear in source control — accessed via `String.fromEnvironment('AI_API_KEY')`
11. All files pass `flutter analyze` with no issues

## Tasks / Subtasks

- [ ] Task 1: Define domain types (AC: 1–4)
  - [ ] `lib/features/ai/domain/ai_provider.dart` — abstract class + `AiContextPayload`, `AiResponse`, `ChatMessage`
  - [ ] All types are `@immutable` with `const` constructors
  - [ ] Import only `dart:core` and `core/types/result.dart`
- [ ] Task 2: Implement `ClaudeAiProvider` (AC: 5, 10)
  - [ ] `lib/features/ai/data/claude_ai_provider.dart`
  - [ ] Use `http.Client` injected in constructor (testable)
  - [ ] POST to `https://api.anthropic.com/v1/messages`
  - [ ] Headers: `x-api-key`, `anthropic-version: 2023-06-01`, `content-type: application/json`
  - [ ] Model: `claude-sonnet-4-6`, `max_tokens: 1024`
  - [ ] `sendContext`: builds messages array from payload, returns `Success(AiResponse(text: content))`
  - [ ] `streamResponse`: uses SSE streaming endpoint, returns `Success(Stream<String>)`
  - [ ] API key from `const String.fromEnvironment('AI_API_KEY')`
  - [ ] Catches `http.ClientException` and socket errors → `Failure(AppError.aiUnavailable)`
- [ ] Task 3: Implement stub providers (AC: 6, 7)
  - [ ] `GeminiAiProvider`, `GroqAiProvider`, `OpenAiAiProvider`: one file each, implement interface, return `Failure(AppError.aiUnavailable)` for all methods
  - [ ] `OfflineStubAiProvider`: returns `Success(AiResponse(text: 'OdO offline stub response'))` — used in tests
- [ ] Task 4: Create `ai_config.dart` and Riverpod provider (AC: 8, 9)
  - [ ] `lib/core/constants/ai_config.dart`: `const kActiveAiProvider = 'claude'`
  - [ ] `lib/features/ai/presentation/ai_providers.dart`: `aiProviderServiceProvider` — switch on `kActiveAiProvider`, instantiate correct impl
- [ ] Task 5: Unit tests for `ClaudeAiProvider` (AC: 5)
  - [ ] Mock `http.Client` using `mockito` or `http` package's `MockClient`
  - [ ] Test: successful response → `Success(AiResponse)`
  - [ ] Test: HTTP 401 → `Failure(AppError.aiUnavailable)`
  - [ ] Test: network error → `Failure(AppError.aiUnavailable)`
- [ ] Task 6: Lint check (AC: 11)
  - [ ] `flutter analyze lib/features/ai/` — zero issues

## Dev Notes

- **Claude API endpoint:** `POST https://api.anthropic.com/v1/messages`; body: `{"model":"claude-sonnet-4-6","max_tokens":1024,"messages":[{"role":"user","content":"..."}]}`
- **Streaming:** For `streamResponse`, use `http.Client.send(request)` with `HttpClient` and listen to `response.stream`. Each SSE event starting with `data:` contains JSON; extract `delta.text` field.
- **`Result<T>` type:** Defined in Story 1.7. This story depends on Story 1.7 — if not yet implemented, create a minimal `Result<T>` placeholder (sealed class with `Success` and `Failure`) here and merge when Story 1.7 ships.
- **`AppError.aiUnavailable`:** Defined in Story 1.7. Same dependency — use a placeholder if needed.
- **Do NOT add** `dart:html` or web-specific imports — this is mobile only.
- **`http` package version:** `^1.2.1` — use `http.Response`, not deprecated `http.get` function. Use `http.Client` for testability.
- **Anthropic SDK:** There is no official Dart SDK from Anthropic — use raw `http` as specified.

### Project Structure Notes

```
lib/features/ai/
├── domain/
│   └── ai_provider.dart       # abstract AiProvider + value types
├── data/
│   ├── claude_ai_provider.dart
│   ├── gemini_ai_provider.dart
│   ├── groq_ai_provider.dart
│   ├── openai_ai_provider.dart
│   └── offline_stub_ai_provider.dart
└── presentation/
    └── ai_providers.dart      # aiProviderServiceProvider

lib/core/constants/
└── ai_config.dart             # kActiveAiProvider
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.5] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#AiService] — provider abstraction design
- [Source: CLAUDE.md#Tech-stack] — `http` package for AI; model `claude-sonnet-4-6`

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
