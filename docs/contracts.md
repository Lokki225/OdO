# OdO Clean Architecture Contracts

**Version**: 2.0  
**Last Updated**: 2026-05-13  
**Purpose**: Define strict layer separation and communication rules for OdO (Flutter/Dart)

---

## Layers (Authoritative)

OdO uses exactly three layers per feature:

```
lib/features/[feature]/
  domain/        Pure Dart. No Flutter, no Drift, no http imports.
  data/          Imports domain only.
  presentation/  Imports domain only. NEVER imports data directly.
```

### `domain/`

**Contents:** Entities, abstract repository interfaces, use cases  
**Dart imports allowed:** `dart:core`, `dart:async`, `package:result_dart` (or equivalent)  
**Forbidden imports:** `flutter/`, `drift/`, `http`, any data-layer file  
**Rule:** All validation and business logic lives here. Entities return `Result<T, AppFailure>`.

### `data/`

**Contents:** Drift DAOs, repository implementations, mappers (entity ↔ Drift row)  
**Imports allowed:** `domain/` (entities, interfaces), `drift/`, `core/database/`  
**Forbidden imports:** `presentation/`, `flutter/widgets`  
**Rule:** DAOs extend `DatabaseAccessor<AppDatabase>`. Repository impls implement domain interfaces. No business logic here — only persistence and mapping.

### `presentation/`

**Contents:** Riverpod providers, pages, widgets  
**Imports allowed:** `domain/` (entities, use cases, repository interfaces via providers)  
**Forbidden imports:** `data/` (never import a DAO, repository impl, or Drift model directly)  
**Rule:** All Riverpod providers for a feature live in `[feature]_providers.dart`. Widgets consume `AsyncValue<T>` and always handle loading / data / error states.

---

## Allowed Communication Paths

```
presentation/ ──ref.watch──► domain interfaces (via Riverpod DI)
                                     ▲
data/ ──implements──────────────────►│
                                     │
domain/ ◄──── no external deps ──────┘
```

Only these paths are valid:
- `presentation` reads domain entities and calls use cases through Riverpod providers
- `data` implements domain repository interfaces and maps Drift rows to domain entities
- `domain` has zero outward dependencies

---

## Forbidden Paths

| From | To | Why |
|------|----|-----|
| `presentation/` | `data/` | Widgets must never depend on persistence details |
| `data/` | `presentation/` | No reverse dependency |
| `domain/` | `data/` or `presentation/` | Domain must be infrastructure-free |
| Any layer | Flutter widgets in `domain/` | Domain is pure Dart |
| Any widget | Drift row types directly | Only domain entities cross the presentation boundary |

---

## Data Transfer Rules

### Domain Layer — Entities

- Pure Dart classes, no annotations
- Immutable (use `final` fields, optionally `copyWith`)
- Validation returns `Result<Entity, AppFailure>`
- No `toJson` / `fromJson` in entities (that belongs in mappers)

```dart
// CORRECT — pure Dart entity
class Skill {
  final String id;
  final String name;
  final DateTime createdAt;

  const Skill({required this.id, required this.name, required this.createdAt});

  static Result<Skill, AppFailure> create({required String name}) {
    if (name.trim().isEmpty) return Failure(AppFailure.validation('Name required'));
    return Success(Skill(id: const Uuid().v4(), name: name.trim(), createdAt: DateTime.now()));
  }
}

// WRONG — entity with Drift annotation
@DataClassName('SkillRow')  // ← Drift annotation; belongs in data layer only
class SkillsTable extends Table { ... }
```

### Data Layer — DAOs

- Extend `DatabaseAccessor<AppDatabase>`
- Methods return `Stream<List<SkillRow>>` or `Future<void>`
- No business logic — only SQL operations

```dart
// CORRECT — DAO with only persistence operations
part 'skills_dao.g.dart';

@DriftAccessor(tables: [SkillsTable])
class SkillsDao extends DatabaseAccessor<AppDatabase> with _$SkillsDaoMixin {
  SkillsDao(super.db);

  Stream<List<SkillRow>> watchAllSkills() => select(skillsTable).watch();

  Future<void> insertSkill(SkillRow row) => into(skillsTable).insert(row);

  Future<void> deleteSkill(String id) =>
      (delete(skillsTable)..where((t) => t.id.equals(id))).go();
}

// WRONG — business logic in DAO
Future<void> addSkillIfNotDuplicate(String name) async {
  final exists = await (select(skillsTable)..where((t) => t.name.equals(name))).getSingleOrNull();
  if (exists != null) throw Exception('Duplicate');  // ← business rule; belongs in domain
  await into(skillsTable).insert(SkillRow(id: uuid(), name: name, createdAt: DateTime.now()));
}
```

### Data Layer — Repository Implementations

- Implement domain repository interfaces
- Inject the DAO; map Drift rows ↔ domain entities via mappers
- Error mapping: `SqliteException` → `AppFailure`

```dart
// CORRECT — repository impl mapping rows to entities
class SkillRepositoryImpl implements SkillRepository {
  SkillRepositoryImpl(this._dao);
  final SkillsDao _dao;

  @override
  Stream<List<Skill>> watchAllSkills() =>
      _dao.watchAllSkills().map((rows) => rows.map(SkillMapper.fromRow).toList());

  @override
  Future<Result<void, AppFailure>> addSkill(Skill skill) async {
    try {
      await _dao.insertSkill(SkillMapper.toRow(skill));
      return const Success(null);
    } on SqliteException catch (e) {
      return Failure(AppFailure.database(e.message));
    }
  }
}

// WRONG — repository impl importing a widget
import 'package:flutter/material.dart';  // ← forbidden in data layer
```

### Presentation Layer — Riverpod Providers

- `@riverpod` annotation + code generation
- `AsyncNotifier` for CRUD; `StreamProvider` for reactive Drift queries
- Never import `data/` — inject repository via `ref.watch(skillRepositoryProvider)`

```dart
// CORRECT — AsyncNotifier using domain interface only
@riverpod
class SkillsNotifier extends _$SkillsNotifier {
  @override
  Stream<List<Skill>> build() {
    final repo = ref.watch(skillRepositoryProvider);
    return repo.watchAllSkills();  // domain interface, not DAO
  }

  Future<void> addSkill(String name) async {
    final result = Skill.create(name: name);
    if (result.isFailure()) {
      // surface error via state
      return;
    }
    await ref.read(skillRepositoryProvider).addSkill(result.getOrThrow());
  }
}

// WRONG — provider importing data layer directly
import 'package:odo/features/practice/data/datasources/skills_dao.dart';  // ← forbidden
```

---

## Contract Enforcement Checklist

Before any story is marked done, verify:

- [ ] No `domain/` file imports `flutter/`, `drift/`, or `data/`
- [ ] No `presentation/` file imports anything from `data/`
- [ ] All Drift row types are confined to `data/` (mappers, DAOs, repository impls)
- [ ] All domain entities are pure Dart classes with no framework annotations
- [ ] Repository interfaces in `domain/` are abstract classes only — no implementations
- [ ] All Riverpod providers live in `[feature]/presentation/[feature]_providers.dart`
- [ ] Every `AsyncNotifier` handles all three `AsyncValue` states in the UI
- [ ] No business logic in DAOs or repository impls — only persistence operations
- [ ] `flutter analyze` passes on all changed files before story is marked done

---

## Common Violations

### Violation 1: Widget importing DAO directly

```dart
// WRONG
import 'package:odo/features/practice/data/datasources/skills_dao.dart';

class SkillsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dao = SkillsDao(ref.read(appDatabaseProvider));  // ← bypasses domain
    ...
  }
}

// CORRECT — use the provider, which injects domain interface
class SkillsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsNotifierProvider);
    ...
  }
}
```

### Violation 2: Drift row type crossing into presentation

```dart
// WRONG — Drift row in a widget
Widget build(BuildContext context, WidgetRef ref) {
  final AsyncValue<List<SkillRow>> rows = ref.watch(skillsProvider);  // ← SkillRow is a Drift type
  ...
}

// CORRECT — domain entity in widget
Widget build(BuildContext context, WidgetRef ref) {
  final AsyncValue<List<Skill>> skills = ref.watch(skillsNotifierProvider);  // ← Skill is a domain entity
  ...
}
```

### Violation 3: Business logic in repository impl

```dart
// WRONG — validation in data layer
@override
Future<Result<void, AppFailure>> addSkill(Skill skill) async {
  if (skill.name.isEmpty) return Failure(AppFailure.validation('Name required'));  // ← belongs in entity
  await _dao.insertSkill(SkillMapper.toRow(skill));
  return const Success(null);
}

// CORRECT — validation stays in domain entity; repository only persists
@override
Future<Result<void, AppFailure>> addSkill(Skill skill) async {
  try {
    await _dao.insertSkill(SkillMapper.toRow(skill));
    return const Success(null);
  } on SqliteException catch (e) {
    return Failure(AppFailure.database(e.message));
  }
}
```

### Violation 4: Domain entity importing Flutter

```dart
// WRONG
import 'package:flutter/foundation.dart';  // ← forbidden in domain

@immutable
class Skill { ... }

// CORRECT — use Dart's own const/final; no Flutter annotations needed
class Skill {
  final String id;
  const Skill({required this.id, ...});
}
```

---

## Dependency Direction

```
presentation/
     │  ref.watch(provider)
     ▼
domain/ ◄──── data/
(interfaces)  (implements)
```

**Never reverse these dependencies.**  
`domain/` must compile without `data/` or `presentation/` on the classpath.

---

## Core Layer Contracts (`lib/core/`)

### `core/types/result.dart`

- `Result<S, F>` sealed class: `Success<S, F>` and `Failure<S, F>`
- Used by all domain entity factory methods and repository interfaces
- No Flutter imports

### `core/database/app_database.dart`

- Single `AppDatabase` class; Drift `@DriftDatabase` annotation
- `onCreate` callback runs all `CREATE TABLE` and `CREATE INDEX` statements
- `schemaVersion` incremented for every migration
- Provided via `appDatabaseProvider` (`FutureProvider<AppDatabase>` or lazy singleton)

### `core/services/`

- `AiProvider` — abstract interface; `ClaudeAiProvider` is the V1 implementation
- `LocaleService` — static methods: `formatXof`, `formatDate`, `formatTime` — pure Dart, no Flutter
- `NotificationService` — wraps `flutter_local_notifications`; no business logic
- `BackgroundTaskService` — wraps `workmanager`; registers and cancels tasks only

### `core/constants/`

- `app_colors.dart` — raw palette (never used directly in widgets)
- `app_spacing.dart` / `app_typography.dart` — spacing and text style tokens
- `ai_constants.dart` — `contextMaxChars = 4000`, model ID, timeout values
