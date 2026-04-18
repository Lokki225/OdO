# Domain Layer Implementation Plan — [Epic Name]

**Epic**: [Epic Name]  
**Layer**: Domain (entities, use cases, repository contracts)  
**Created**: YYYY-MM-DD  
**Architecture**: Clean Architecture — Domain Layer  
**Source**: epics.md, architecture.md

---

## 📋 Overview

The Domain layer is responsible for:

- **Entities**: Pure business objects with validation rules
- **Use Cases**: Single-responsibility business logic operations
- **Repository Contracts**: Abstract interfaces defining data access needs

**Dependency Rule**: Domain layer imports NOTHING from Data or Presentation layers. It is the innermost layer.

---

## 📁 File Structure

```
lib/features/[feature]/domain/
├── entities/
│   └── [entity].dart                    # Pure business object
├── usecases/
│   ├── [action]_[entity].dart           # e.g., create_event.dart
│   └── get_[entities].dart              # e.g., get_events.dart
└── repositories/
    └── [feature]_repository.dart        # Abstract contract
```

---

## 🏗️ Entities

### Entity 1: [EntityName]

- **Purpose**: [What this entity represents in the domain]
- **Properties**:

| Property | Type | Required | Validation Rules |
|----------|------|----------|-----------------|
| id | int | Yes | Positive integer |
| [property] | [type] | [Yes/No] | [Rules] |

- **Business Rules**:
  - [Rule 1: e.g., "title cannot be empty"]
  - [Rule 2: e.g., "endTime must be after startTime"]
- **Equality**: Based on `id`
- **Story**: [X.N]

### Entity 2: [EntityName]

- **Purpose**: [What this entity represents]
- **Properties**: [Same format]
- **Story**: [X.N]

---

## 🎯 Use Cases

### UseCase 1: [ActionEntity] (e.g., CreateEvent)

- **Purpose**: [What business operation this performs]
- **Input**: `[InputParams]` (e.g., title, startTime, endTime)
- **Output**: `Future<Either<Failure, [Entity]>>`
- **Business Logic**:
  1. [Step 1: Validate inputs]
  2. [Step 2: Apply business rules]
  3. [Step 3: Delegate to repository]
- **Error Cases**:
  - [ValidationFailure: when inputs are invalid]
  - [ConflictFailure: when business rule violated]
- **Story**: [X.N]

### UseCase 2: [GetEntities] (e.g., GetEventsForDate)

- **Purpose**: [What query this performs]
- **Input**: `[QueryParams]`
- **Output**: `Future<Either<Failure, List<[Entity]>>>`
- **Business Logic**: [Steps]
- **Error Cases**: [Failure types]
- **Story**: [X.N]

---

## 📜 Repository Contracts

### [Feature]Repository (abstract)

- **Purpose**: Defines data access needs for this feature
- **Methods**:

| Method | Parameters | Return Type | Story |
|--------|-----------|-------------|-------|
| `create[Entity]()` | `[Entity]` | `Future<Either<Failure, [Entity]>>` | [X.N] |
| `get[Entity]ById()` | `int id` | `Future<Either<Failure, [Entity]?>>` | [X.N] |
| `getAll[Entities]()` | none | `Future<Either<Failure, List<[Entity]>>>` | [X.N] |
| `update[Entity]()` | `[Entity]` | `Future<Either<Failure, [Entity]>>` | [X.N] |
| `delete[Entity]()` | `int id` | `Future<Either<Failure, void>>` | [X.N] |

---

## ⚠️ Failure Types

| Failure | When | Message |
|---------|------|---------|
| `ValidationFailure` | Invalid input | "[field] is required" |
| `NotFoundFailure` | Entity not found | "[Entity] not found" |
| `DatabaseFailure` | DB operation fails | "Failed to [operation]" |
| `[CustomFailure]` | [Condition] | "[Message]" |

---

## 🧪 Domain Layer Tests

| Test File | Tests | Story |
|-----------|-------|-------|
| `test/features/[feature]/domain/entities/[entity]_test.dart` | Validation, business rules, equality | [X.N] |
| `test/features/[feature]/domain/usecases/[usecase]_test.dart` | Happy path, error cases, edge cases | [X.N] |

**Mocking**: Repository contracts are mocked (use `mocktail` or `mockito`)

---

## ✅ Implementation Checklist

- [ ] All entities created with complete properties
- [ ] All entity validation rules implemented
- [ ] All use cases implement single-responsibility business logic
- [ ] All use cases return `Either<Failure, T>`
- [ ] All repository contracts define complete data access needs
- [ ] All failure types defined and documented
- [ ] All domain layer tests passing
- [ ] ZERO imports from data or presentation layers
- [ ] flutter analyze: No issues in domain layer files

---

## 📝 Implementation Order

1. **Entities first** — Define business objects and validation
2. **Repository contracts second** — Define data access interfaces
3. **Use cases last** — Implement business logic using entities + repository contracts
