import 'package:drift/drift.dart';

import 'skills_table.dart';

@DataClassName('SessionRow')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get skillId =>
      integer().references(Skills, #id, onDelete: KeyAction.cascade)();
  IntColumn get startedAt => integer()();
  IntColumn get durationMinutes => integer()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isAnchored =>
      boolean().withDefault(const Constant(false))();
  IntColumn get suggestedTime => integer().nullable()();
}
