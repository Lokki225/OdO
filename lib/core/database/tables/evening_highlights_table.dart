import 'package:drift/drift.dart';

import 'evening_sessions_table.dart';

@DataClassName('HighlightRow')
class EveningHighlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eveningSessionId => integer()
      .references(EveningSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get displayOrder => integer()();
  TextColumn get content => text()();
  TextColumn get sourceType => text()();
  IntColumn get sourceRefId => integer().nullable()();
  TextColumn get userTag => text().nullable()();
  IntColumn get taggedAt => integer().nullable()();
}
