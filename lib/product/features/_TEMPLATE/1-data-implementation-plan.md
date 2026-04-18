# Data Layer Implementation Plan — [Epic Name]

**Epic**: [Epic Name]  
**Layer**: Data (models, datasources, repository implementations)  
**Created**: YYYY-MM-DD  
**Architecture**: Clean Architecture — Data Layer  
**Source**: epics.md, architecture.md

---

## 📋 Overview

The Data layer is responsible for:

- **Models**: Data transfer objects (DTOs) that map to/from database and API formats
- **Data Sources**: Direct access to SQLite (Drift), APIs, or local storage
- **Repository Implementations**: Concrete implementations of domain repository contracts

**Dependency Rule**: Data layer imports Domain layer. Never imports Presentation layer.

---

## 📁 File Structure

```
lib/features/[feature]/data/
├── models/
│   ├── [entity]_model.dart          # Drift-generated or manual DTO
│   └── [entity]_model.g.dart        # Generated code (if applicable)
├── datasources/
│   ├── [feature]_local_datasource.dart   # SQLite/Drift queries
│   └── [feature]_remote_datasource.dart  # API calls (if applicable)
└── repositories/
    └── [feature]_repository_impl.dart    # Implements domain contract
```

---

## 🗄️ Models

### Model 1: [EntityName]Model

- **Purpose**: [What this model represents]
- **Maps to**: Domain entity `[EntityName]`
- **Source table**: `[table_name]` (Drift)
- **Fields**:

| Field | Type | DB Column | Nullable | Notes |
|-------|------|-----------|----------|-------|
| id | int | id | No | Auto-increment PK |
| [field] | [type] | [column] | [Yes/No] | [Notes] |

- **Serialization**: `toEntity()` → Domain entity, `fromEntity()` → Model
- **Story**: [X.N]

### Model 2: [EntityName]Model

- **Purpose**: [What this model represents]
- **Fields**: [Same format as above]
- **Story**: [X.N]

---

## 💾 Data Sources

### Local Data Source: [Feature]LocalDataSource

- **Technology**: Drift (SQLite)
- **DAO**: `[Feature]Dao` extending `DatabaseAccessor<AppDatabase>`
- **Queries**:

| Method | Return Type | SQL Operation | Story |
|--------|-------------|---------------|-------|
| `getAll[Entities]()` | `Future<List<[Model]>>` | SELECT * | [X.N] |
| `get[Entity]ById(int id)` | `Future<[Model]?>` | SELECT WHERE | [X.N] |
| `insert[Entity]([Model])` | `Future<int>` | INSERT | [X.N] |
| `update[Entity]([Model])` | `Future<bool>` | UPDATE | [X.N] |
| `delete[Entity](int id)` | `Future<int>` | DELETE | [X.N] |

- **Indexes**: [List required indexes for performance]
- **Error Handling**: Wrap in try/catch, return `Result<T>` or throw typed exceptions

### Remote Data Source: [Feature]RemoteDataSource (if applicable)

- **API Base**: [URL or service]
- **Endpoints**: [List endpoints]
- **Error Handling**: Network errors, timeout handling, retry logic

---

## 🔧 Repository Implementations

### [Feature]RepositoryImpl

- **Implements**: `[Feature]Repository` (domain contract)
- **Injects**: `[Feature]LocalDataSource`, `[Feature]RemoteDataSource` (if applicable)
- **Methods**:

| Method | Delegates To | Error Mapping | Story |
|--------|-------------|---------------|-------|
| `[method]()` | `localDataSource.[method]()` | [Failure type] | [X.N] |

- **Caching Strategy**: [If applicable]
- **Offline Handling**: [If applicable]

---

## 🧪 Data Layer Tests

| Test File | Tests | Story |
|-----------|-------|-------|
| `test/features/[feature]/data/models/[model]_test.dart` | Serialization, field mapping | [X.N] |
| `test/features/[feature]/data/datasources/[ds]_test.dart` | CRUD operations, edge cases | [X.N] |
| `test/features/[feature]/data/repositories/[repo]_test.dart` | Delegation, error mapping | [X.N] |

---

## ✅ Implementation Checklist

- [ ] All models created with correct field mappings
- [ ] All `toEntity()` / `fromEntity()` conversions tested
- [ ] All DAO queries implemented and tested
- [ ] Repository implementation delegates correctly
- [ ] Error handling covers all failure scenarios
- [ ] Drift code generation runs without errors
- [ ] All data layer tests passing
- [ ] No imports from presentation layer
- [ ] flutter analyze: No issues in data layer files

---

## 📝 Implementation Order

1. **Models first** — Define DTOs and serialization
2. **Data sources second** — Implement DAO/API access
3. **Repository impl last** — Wire data sources to domain contracts
