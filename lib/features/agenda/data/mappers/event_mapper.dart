import 'package:drift/drift.dart';

import 'package:odo/core/database/app_database.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';

abstract final class EventMapper {
  static Event fromRow(EventRow row) {
    return Event(
      id: row.id,
      title: row.title,
      startTime: DateTime.fromMillisecondsSinceEpoch(row.startTime, isUtc: true),
      endTime: DateTime.fromMillisecondsSinceEpoch(row.endTime, isUtc: true),
      category: _parseCategory(row.category),
      notes: row.notes,
    );
  }

  static EventsCompanion toCompanion(Event event) {
    return EventsCompanion(
      id: event.id != null ? Value(event.id!) : const Value.absent(),
      title: Value(event.title),
      startTime: Value(event.startTime.toUtc().millisecondsSinceEpoch),
      endTime: Value(event.endTime.toUtc().millisecondsSinceEpoch),
      category: Value(event.category.value),
      notes: Value(event.notes),
    );
  }

  static EventCategory _parseCategory(String s) => switch (s) {
        'personal' => EventCategory.personal,
        'work' => EventCategory.work,
        'practice' => EventCategory.practice,
        _ => throw ArgumentError('Unknown EventCategory: $s'),
      };
}
