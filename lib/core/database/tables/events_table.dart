import 'package:drift/drift.dart';

@DataClassName('EventRow')
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get startTime => integer()();
  IntColumn get endTime => integer()();
  TextColumn get category => text()();
  TextColumn get notes => text().nullable()();
}
