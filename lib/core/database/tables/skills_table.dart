import 'package:drift/drift.dart';

@DataClassName('SkillRow')
class Skills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get createdAt => integer()();
  IntColumn get lastSessionAt => integer().nullable()();
}
