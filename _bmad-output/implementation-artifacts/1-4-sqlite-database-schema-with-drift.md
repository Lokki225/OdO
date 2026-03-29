---
storyId: 1.4
storyKey: 1-4-sqlite-database-schema-with-drift
epicId: 1
projectName: TooXTips
date: 2026-03-29
status: ready-for-dev
---

# Story 1.4: SQLite Database Schema with Drift

## Story Statement

As a developer,
I want to define the SQLite schema using Drift with critical tables (skills, sessions, events, suggestions),
So that all data is persisted locally with type-safe access.

## Acceptance Criteria

**Given** the architecture specification with schema decisions
**When** I create `core/database/app_database.dart` with Drift tables
**Then** `skills` table exists with id, name, createdAt, lastSessionAt
**And** `sessions` table exists with id, skillId, startedAt, durationMinutes, isAnchored, suggestedTime, notes
**And** `events` table exists with id, title, startTime, endTime, category
**And** `suggestions` table exists with id, skillId, slotStart, slotDuration, suggestedAt, acceptedAt, dismissedAt, thumbsDownAt, suppressedUntil
**And** `dart run build_runner build` generates all Drift code without errors
**And** the database compiles and is ready for data access

## Technical Requirements

### Database Tables

#### Skills Table

```dart
@DataClassName('SkillData')
class Skills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastSessionAt => dateTime().nullable()();
}
```

#### Sessions Table

```dart
@DataClassName('SessionData')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get skillId => integer().references(Skills, #id)();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationMinutes => integer()();
  BoolColumn get isAnchored => boolean().withDefault(const Constant(false))();
  DateTimeColumn get suggestedTime => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}
```

#### Events Table

```dart
@DataClassName('EventData')
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get category => text().nullable()();
}
```

#### Suggestions Table

```dart
@DataClassName('SuggestionData')
class Suggestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get skillId => integer().references(Skills, #id)();
  DateTimeColumn get slotStart => dateTime()();
  IntColumn get slotDuration => integer()(); // in minutes
  DateTimeColumn get suggestedAt => dateTime()();
  DateTimeColumn get acceptedAt => dateTime().nullable()();
  DateTimeColumn get dismissedAt => dateTime().nullable()();
  DateTimeColumn get thumbsDownAt => dateTime().nullable()();
  DateTimeColumn get suppressedUntil => dateTime().nullable()();
}
```

### Database Class

```dart
@DriftDatabase(tables: [Skills, Sessions, Events, Suggestions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // DAOs will be added in later stories
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tooxips.db'));
    return NativeDatabase(file);
  });
}
```

### Naming Conventions

- Table names: PascalCase (Skills, Sessions, Events, Suggestions)
- Column names: snake_case in database, camelCase in Dart
- Primary keys: `id` (auto-increment integer)
- Foreign keys: `{tableName}Id` format
- Timestamps: `DateTime` type (stored as Unix timestamps)
- Boolean flags: `is{Property}` format

## Implementation Details

### File Structure

Create `lib/core/database/app_database.dart` with:

1. Import statements for Drift and dependencies
2. Part directive for generated code
3. Table definitions (Skills, Sessions, Events, Suggestions)
4. Database class definition
5. Connection helper function

### Key Constraints

- All tables MUST use integer primary keys (auto-increment)
- Foreign keys MUST reference correct tables
- DateTime columns MUST use `dateTime()` type
- Boolean columns MUST use `boolean()` type
- Nullable columns MUST use `.nullable()`
- Default values MUST be explicit where needed
- Column names MUST follow snake_case convention
- Database file MUST be stored in app documents directory

### Code Generation

After creating the file:

1. Run `dart run build_runner build`
2. Verify `app_database.g.dart` is generated
3. Verify no compilation errors
4. Check generated code for correctness

### Verification Steps

1. Create `lib/core/database/app_database.dart`
2. Define all four tables with correct columns
3. Create AppDatabase class with schema version
4. Create connection helper function
5. Run `dart run build_runner build`
6. Verify generated files exist and compile
7. Run `flutter analyze` to check for errors

## Success Criteria

- ✓ Skills table defined with all required columns
- ✓ Sessions table defined with foreign key to Skills
- ✓ Events table defined with all required columns
- ✓ Suggestions table defined with foreign key to Skills
- ✓ AppDatabase class created with correct schema version
- ✓ Connection helper function implemented
- ✓ `dart run build_runner build` succeeds without errors
- ✓ Generated code files created (app_database.g.dart)
- ✓ File compiles without errors
- ✓ Ready for DAO implementation (Stories 2.1, 3.1)

## Dependencies

- Depends on: Story 1.1 (Project Setup)
- Blocks: Story 2.1 (Agenda Data Access), Story 3.1 (Practice Data Access)

## Notes

- This is the foundational data layer; all data access goes through this database
- Drift generates type-safe code; leverage it to prevent runtime errors
- The schema is designed for offline-first architecture with complete local storage
- All timestamps use UTC+0 timezone (enforced in business logic, not database)
- Foreign keys ensure referential integrity
- The database file persists across app restarts
