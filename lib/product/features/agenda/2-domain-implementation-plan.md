# Agenda Module — Domain Implementation Plan

## Entity: Event

**File:** `lib/features/agenda/domain/entities/event.dart`

**Constraints:** Pure Dart — no Flutter, no Drift, no external package imports (only `dart:` imports if needed — actually none needed here).

| Property | Type | Nullable | Validation |
|----------|------|----------|-----------|
| `id` | `int?` | Yes | `null` before insert; must be > 0 after |
| `title` | `String` | No | Must not be empty |
| `startTime` | `DateTime` | No | Any valid DateTime |
| `endTime` | `DateTime` | No | Must be after `startTime` |
| `category` | `EventCategory` | No | Must be one of the 3 enum values |
| `notes` | `String?` | Yes | No constraint |

**Validation method:** Expose `Result<Event> validate()` that checks:
- `title.trim().isNotEmpty` → else `Failure(AppError.databaseWriteFailed)` *(domain reuses this error; a more specific `AppError.validationFailed` would be ideal but is not in the current 8-variant enum — use the closest fit)*
- `endTime.isAfter(startTime)` → else `Failure(AppError.databaseWriteFailed)`

**`copyWith` method:** Required for undo-delete (re-insert with null id).

```dart
@immutable
class Event {
  const Event({
    this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.category,
    this.notes,
  });

  final int? id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final EventCategory category;
  final String? notes;

  Event copyWith({int? id, String? title, DateTime? startTime,
                  DateTime? endTime, EventCategory? category, String? notes});
}
```

---

## Enum: EventCategory

**File:** `lib/features/agenda/domain/entities/event.dart` (same file as `Event`)

```dart
enum EventCategory { personal, work, practice }
```

**String representation** (used by mapper):
```dart
String get name => switch (this) {
  EventCategory.personal => 'personal',
  EventCategory.work     => 'work',
  EventCategory.practice => 'practice',
};
```

---

## Repository Interface: AgendaRepository

**File:** `lib/features/agenda/domain/repositories/agenda_repository.dart`

**Constraints:** Abstract class only — no implementation, no imports from `data/`.

| Method Signature | Return Type | Notes |
|-----------------|-------------|-------|
| `addEvent(Event event)` | `Future<Result<int>>` | Returns generated id on success |
| `updateEvent(Event event)` | `Future<Result<void>>` | Requires `event.id != null` |
| `deleteEvent(int id)` | `Future<Result<void>>` | — |
| `getEventById(int id)` | `Future<Result<Event?>>` | Returns `null` inside `Success` if not found |
| `getEventsBetween(int startMs, int endMs)` | `Future<Result<List<Event>>>` | UTC epoch ms boundaries |
| `watchEventsForDay(DateTime date)` | `Stream<List<Event>>` | Not wrapped in Result; Drift stream errors handled in presentation |

---

## Use Cases

> For Epic 2, business logic is thin — the notifier handles orchestration. No standalone UseCase classes are required. The presentation `AgendaNotifier` calls the repository directly, which is acceptable when there is no multi-step business logic. If logic grows (e.g., conflict detection), extract to a UseCase in a later story.

Deferred UseCases (post-Epic 2):
- `CheckEventConflictUseCase` — for Epic 4 AI suggestions
- `GetUpcomingEventsUseCase` — for Epic 4 context builder

---

## Failure Types in Domain

All failures use existing `AppError` variants from `lib/core/domain/app_error.dart`:

| Scenario | AppError Used |
|----------|--------------|
| DB write fails (insert/update/delete) | `AppError.databaseWriteFailed` |
| DB read fails | `AppError.databaseWriteFailed` *(closest match in current enum)* |
| Validation fails (title empty, end before start) | `AppError.databaseWriteFailed` *(closest match)* |

**Note:** If a `AppError.validationFailed` variant is added in a future story, migrate the validation failures to it. For now, `databaseWriteFailed` is the broadest applicable error.

---

## Domain Layer File List

```
lib/features/agenda/domain/
├── entities/
│   └── event.dart             # Event, EventCategory
└── repositories/
    └── agenda_repository.dart # abstract AgendaRepository
```
