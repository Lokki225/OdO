import 'package:drift/drift.dart';

import 'package:odo/core/database/app_database.dart';
import 'package:odo/core/database/tables/events_table.dart';

part 'agenda_dao.g.dart';

@DriftAccessor(tables: [Events])
class AgendaDao extends DatabaseAccessor<AppDatabase> with _$AgendaDaoMixin {
  AgendaDao(super.db);

  Future<int> insertEvent(EventsCompanion companion) =>
      into(events).insert(companion);

  Future<bool> updateEvent(EventsCompanion companion) =>
      update(events).replace(companion);

  Future<int> deleteEvent(int id) =>
      (delete(events)..where((e) => e.id.equals(id))).go();

  Future<EventRow?> getEventById(int id) =>
      (select(events)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<List<EventRow>> getEventsBetween(int startMs, int endMs) =>
      (select(events)
            ..where(
              (e) =>
                  e.startTime.isBiggerOrEqualValue(startMs) &
                  e.startTime.isSmallerThanValue(endMs),
            )
            ..orderBy([(e) => OrderingTerm(expression: e.startTime)]))
          .get();

  Stream<List<EventRow>> watchEventsForDay(DateTime date) {
    final dayStart =
        DateTime(date.year, date.month, date.day).toUtc().millisecondsSinceEpoch;
    final dayEnd = DateTime(date.year, date.month, date.day + 1)
        .toUtc()
        .millisecondsSinceEpoch;
    return (select(events)
          ..where(
            (e) =>
                e.startTime.isBiggerOrEqualValue(dayStart) &
                e.startTime.isSmallerThanValue(dayEnd),
          )
          ..orderBy([(e) => OrderingTerm(expression: e.startTime)]))
        .watch();
  }
}
