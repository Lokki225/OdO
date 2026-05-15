# Foundation Epic — Domain Implementation Plan

## Scope

The Foundation domain layer provides the `Result<S, F>` type and `AppFailure` type used across all 41 stories, plus abstract repository interfaces and the `AiProvider` abstraction. These live in `lib/core/domain/` and `lib/core/types/`.

---

## Result Type (Story 1.7)

### `Result<S, F>` — Sealed Class

**File:** `lib/core/types/result.dart`  
**Purpose:** Typed success/failure return value replacing `throw` throughout the domain  
**No external imports** (pure Dart)

| Property/Method | Type | Description |
|-----------------|------|-------------|
| `isSuccess()` | bool | Returns true if Success variant |
| `isFailure()` | bool | Returns true if Failure variant |
| `getOrNull()` | S? | Returns value if Success, null if Failure |
| `getOrThrow()` | S | Returns value or throws `StateError` |
| `failureOrNull()` | F? | Returns failure if Failure variant, null if Success |
| `fold(onSuccess, onFailure)` | T | Pattern-match execution |
| `mapSuccess(fn)` | Result<T, F> | Transform success value |

**Validation rules:**
- Sealed class: only `Success<S, F>` and `Failure<S, F>` can extend `Result`
- `Success.value` is the `S` payload
- `Failure.failure` is the `F` payload

---

### `AppFailure` — Sealed Class

**File:** `lib/core/types/app_failure.dart`  
**Purpose:** Typed domain failures replacing untyped exceptions  
**No external imports**

| Variant | Fields | Use case |
|---------|--------|----------|
| `ValidationFailure` | `String message` | Entity validation errors (empty name, etc.) |
| `DatabaseFailure` | `String message` | Drift / SQLite errors |
| `NetworkFailure` | `String message`, `int? statusCode` | HTTP failures for AI API |
| `NotFoundFailure` | `String entity`, `String id` | Entity not found in DB |
| `UnknownFailure` | `String message`, `Object? cause` | Catch-all for unexpected errors |

---

## AiProvider Abstraction (Story 1.5)

### `AiProvider` — Abstract Interface

**File:** `lib/core/services/ai_provider.dart`  
**Purpose:** Swappable AI provider abstraction; all 5 providers implement this  
**No Flutter imports, no Drift imports**

| Method | Signature | Description |
|--------|-----------|-------------|
| `sendMessage` | `Future<Result<String, AppFailure>> sendMessage(String prompt, {String? context})` | Send a message, get a text response |
| `isAvailable` | `Future<bool> isAvailable()` | Check if this provider is reachable |
| `providerName` | `String get providerName` | Human-readable name for debug/settings |

### Provider Implementations

| Class | File | Story | Notes |
|-------|------|-------|-------|
| `ClaudeAiProvider` | `lib/core/services/ai_providers/claude_ai_provider.dart` | 1.5 | Active V1 impl; uses `http` package; model `claude-sonnet-4-6` |
| `GeminiAiProvider` | `lib/core/services/ai_providers/gemini_ai_provider.dart` | 1.5 | V1 stub (returns `OfflineStubAiProvider` delegation) |
| `GroqAiProvider` | `lib/core/services/ai_providers/groq_ai_provider.dart` | 1.5 | V1 stub |
| `OpenAiProvider` | `lib/core/services/ai_providers/open_ai_provider.dart` | 1.5 | V1 stub |
| `OfflineStubAiProvider` | `lib/core/services/ai_providers/offline_stub_ai_provider.dart` | 1.5 | Always returns `NetworkFailure`; used when offline |

**Active provider selection:**
```dart
// lib/core/constants/ai_constants.dart
const activeAiProvider = AiProviderType.claude;
```
Riverpod wires the active provider via `aiProviderServiceProvider`.

---

## Core Service Interfaces (Story 1.6)

### `LocaleService` — Pure Dart

**File:** `lib/core/services/locale_service.dart`  
**No Flutter imports**

| Method | Signature | Description |
|--------|-----------|-------------|
| `formatXof` | `static String formatXof(int amount)` | e.g. `15000 → "15 000 F"` (thin-space U+202F) |
| `formatDate` | `static String formatDate(DateTime dt)` | DD/MM/YYYY |
| `formatTime` | `static String formatTime(DateTime dt)` | HH:mm (24h) |
| `formatDateShort` | `static String formatDateShort(DateTime dt)` | "Today", "Tomorrow", or DD/MM |

**Validation rules:**
- XOF: no decimal places, thin-space thousands separator, " F" suffix
- All dates: DD/MM/YYYY
- All times: HH:mm 24h format

### `NotificationService`

**File:** `lib/core/services/notification_service.dart`  
**Imports:** `flutter_local_notifications`, `timezone`

| Method | Description |
|--------|-------------|
| `static Future<void> initialize()` | Initialize notification plugin; request permissions |
| `Future<void> scheduleEveningSession(DateTime date)` | Schedule 8pm notification |
| `Future<void> cancelEveningSession()` | Cancel scheduled evening session notification |
| `Future<void> showImmediateNotification(String title, String body)` | For testing / one-shot triggers |

### `BackgroundTaskService`

**File:** `lib/core/services/background_task_service.dart`  
**Imports:** `workmanager`

| Method | Description |
|--------|-------------|
| `static Future<void> initialize()` | Register workmanager callback dispatcher |
| `static Future<void> scheduleEveningCheck()` | Register 8pm periodic task |
| `static Future<void> cancelEveningCheck()` | Cancel periodic task |
| `static void callbackDispatcher()` | Top-level function for workmanager |

**Constraint:** `callbackDispatcher` must be a top-level function (not a class method) for workmanager to call it across isolates.

### `ConnectivityService`

**File:** `lib/core/services/connectivity_service.dart`  
**Imports:** `connectivity_plus`

| Method/Property | Description |
|--------|-------------|
| `Stream<bool> isOnline` | Reactive stream of connectivity state |
| `Future<bool> checkIsOnline()` | One-shot connectivity check |

### `VoiceService`

**File:** `lib/core/services/voice_service.dart`  
**Imports:** `speech_to_text`, `flutter_tts`

| Method | Description |
|--------|-------------|
| `Future<void> initialize()` | Request mic permission, initialize STT |
| `Future<String?> listenOnce({Duration timeout})` | Listen until 1.5s silence; return transcript or null |
| `Future<void> speak(String text)` | TTS output |
| `void stop()` | Cancel any in-progress listen/speak |
| `bool get isListening` | Current state |

---

## Abstract Repository Interfaces (Story 1.4 / per-feature stories)

These interfaces live in `lib/features/[feature]/domain/repositories/`. They are defined in domain, implemented in data.

| Interface | File | Implementing Story |
|-----------|------|-------------------|
| `EventRepository` | `lib/features/agenda/domain/repositories/event_repository.dart` | 2.1 |
| `SkillRepository` | `lib/features/practice/domain/repositories/skill_repository.dart` | 3.1 |
| `SessionRepository` | `lib/features/practice/domain/repositories/session_repository.dart` | 3.1 |
| `SuggestionRepository` | `lib/features/ai/domain/repositories/suggestion_repository.dart` | 5.6 |
| `EveningSessionRepository` | `lib/features/evening_session/domain/repositories/evening_session_repository.dart` | 5.4 |

---

## Failure Type Mapping

| Layer | Exception | Maps to |
|-------|-----------|---------|
| Domain entity validation | — | `ValidationFailure` |
| Drift DAO | `SqliteException` | `DatabaseFailure` |
| HTTP (Claude API) | `SocketException` | `NetworkFailure` |
| HTTP (Claude API) | `HttpException`, non-200 | `NetworkFailure(statusCode: N)` |
| Any | Not found in DB | `NotFoundFailure` |
| Any unexpected | `Exception`, `Error` | `UnknownFailure` |
