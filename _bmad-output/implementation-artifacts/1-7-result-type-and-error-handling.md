# Story 1.7: Result Type and Error Handling

Status: ready-for-dev

## Story

As a developer,
I want a sealed `Result<T, AppError>` type and an `AppError` enum,
so that services and repositories communicate failures explicitly.

## Acceptance Criteria

1. `lib/core/types/result.dart` defines a sealed `Result<T>` class with `Success<T>(T value)` and `Failure<T>(AppError error)` subclasses
2. `lib/core/domain/app_error.dart` defines `AppError` enum with variants: `aiUnavailable`, `databaseWriteFailed`, `suggestionSuppressed`, `contextPayloadTooLarge`, `voiceCaptureFailed`, `voiceParseAmbiguous`, `slotNoLongerAvailable`, `authFailed`
3. `Result<T>` supports: `.when(success:, failure:)`, `.getOrNull()`, `.isSuccess`, `.isFailure` convenience members
4. All services and repositories in the project use `Result<T>` for fallible operations (not raw exceptions exposed to callers)
5. `try/catch` blocks are reserved for third-party library calls only (Drift operations, HTTP calls, platform channel calls) — never in domain or presentation layers
6. Widgets and providers consume errors via `AsyncValue.when` at the provider boundary — not via raw `Result` in widgets
7. Unit tests confirm: `Success.when(success: (v) => v, failure: (_) => null)` returns value; `Failure.when(...)` returns null
8. All files pass `flutter analyze` with no issues

## Tasks / Subtasks

- [ ] Task 1: Create `Result<T>` sealed class (AC: 1, 3)
  - [ ] `lib/core/types/result.dart`
  - [ ] `sealed class Result<T>`
  - [ ] `final class Success<T> extends Result<T>` with `final T value`
  - [ ] `final class Failure<T> extends Result<T>` with `final AppError error`
  - [ ] `.when<R>({required R Function(T) success, required R Function(AppError) failure})` method
  - [ ] `.getOrNull()` → `T?`
  - [ ] `bool get isSuccess`, `bool get isFailure`
- [ ] Task 2: Create `AppError` enum (AC: 2)
  - [ ] `lib/core/domain/app_error.dart`
  - [ ] All 8 variants listed in AC
  - [ ] Optional: `String get message` — human-readable description for each error (used in logs only, never shown raw to users)
- [ ] Task 3: Unit tests (AC: 7)
  - [ ] `test/core/types/result_test.dart`
  - [ ] Tests: Success.when, Failure.when, getOrNull on both, isSuccess/isFailure
- [ ] Task 4: Lint check (AC: 8)
  - [ ] `flutter analyze lib/core/types/ lib/core/domain/` — zero issues

## Dev Notes

- **Dart 3 sealed classes:** Use `sealed class`, `final class` — requires Dart 3.0+ (Flutter 3.22+). No `freezed` needed for this simple type.
- **`Result<T>` NOT `Result<T, E>`:** The error type is always `AppError` — don't add a second type parameter. Keeps usage concise.
- **Exhaustive pattern matching:** With `sealed class`, Dart enforces exhaustive `switch` patterns. Use this for safety in all handler sites.
- **Do NOT use `Either` from `dartz` or `fpdart`** — these packages are not in the dependency list and would add unnecessary complexity.
- **`try/catch` rule:** Wrap Drift DAO calls in try/catch inside repository implementations; convert exceptions to `Failure(AppError.databaseWriteFailed)`. Never let database exceptions propagate past the repository.
- **`AsyncValue` bridge:** In Riverpod notifiers, when a repository returns `Failure(error)`, set state to `AsyncValue.error(error, StackTrace.current)`. This allows widgets to use `state.when(data:, loading:, error:)` uniformly.

### Project Structure Notes

```
lib/core/
├── types/
│   └── result.dart            # Result<T>, Success<T>, Failure<T>
└── domain/
    └── app_error.dart         # AppError enum
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.7] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#Error-Handling] — Result pattern and AppError enum
- [Source: CLAUDE.md#Tech-stack] — Riverpod AsyncValue integration

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
