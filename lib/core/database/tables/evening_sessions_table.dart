import 'package:drift/drift.dart';

@DataClassName('EveningSessionRow')
class EveningSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionDate => text()();
  IntColumn get startedAt => integer()();
  IntColumn get completedAt => integer().nullable()();
  IntColumn get abandonedAt => integer().nullable()();
  TextColumn get headline => text()();
  TextColumn get closeSummary => text().nullable()();
}
