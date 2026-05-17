import 'package:drift/drift.dart';

@DataClassName('SkillRow')
class Skills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get metricConfig => text().nullable()();
  TextColumn get levelLabel => text().nullable()();
  IntColumn get levelUpdatedAt => integer().nullable()();
  IntColumn get sessionsSinceLevelUpdate =>
      integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get lastSessionAt => integer().nullable()();
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();
  IntColumn get suppressedUntil => integer().nullable()();
}
