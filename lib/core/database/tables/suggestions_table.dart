import 'package:drift/drift.dart';

import 'skills_table.dart';

@DataClassName('SuggestionRow')
class Suggestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get skillId => integer()
      .nullable()
      .references(Skills, #id, onDelete: KeyAction.setNull)();
  IntColumn get slotStart => integer()();
  IntColumn get slotDuration => integer()();
  IntColumn get suggestedAt => integer()();
  IntColumn get acceptedAt => integer().nullable()();
  IntColumn get dismissedAt => integer().nullable()();
  IntColumn get thumbsDownAt => integer().nullable()();
  IntColumn get suppressedUntil => integer().nullable()();
  TextColumn get category => text().nullable()();
}
