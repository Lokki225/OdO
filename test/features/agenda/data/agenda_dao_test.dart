import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:odo/core/database/app_database.dart';
import 'package:odo/core/domain/app_error.dart';
import 'package:odo/features/agenda/data/agenda_dao.dart';
import 'package:odo/features/agenda/data/mappers/event_mapper.dart';
import 'package:odo/features/agenda/data/repositories/agenda_repository_impl.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';

class _ThrowingDao extends AgendaDao {
  _ThrowingDao(super.db);

  @override
  Future<int> insertEvent(EventsCompanion companion) async =>
      throw StateError('Simulated DB error');
}

AppDatabase _openTestDb() => AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );

Event _makeEvent({
  int? id,
  String title = 'Meeting',
  DateTime? startTime,
  DateTime? endTime,
  EventCategory category = EventCategory.work,
  String? notes,
}) {
  final s = startTime ?? DateTime.utc(2026, 5, 16, 10);
  final e = endTime ?? s.add(const Duration(hours: 1));
  return Event(
    id: id,
    title: title,
    startTime: s,
    endTime: e,
    category: category,
    notes: notes,
  );
}

void main() {
  late AppDatabase db;
  late AgendaRepositoryImpl repo;

  setUp(() {
    db = _openTestDb();
    repo = AgendaRepositoryImpl(db.agendaDao);
  });

  tearDown(() => db.close());

  // TS-001
  test('insert event and read back', () async {
    final event = _makeEvent(title: 'Standup');
    final result = await repo.addEvent(event);
    expect(result.isSuccess, true);
    final id = result.getOrNull()!;
    expect(id, greaterThan(0));

    final fetched = await repo.getEventById(id);
    expect(fetched.isSuccess, true);
    final found = fetched.getOrNull()!;
    expect(found.title, 'Standup');
    expect(found.category, EventCategory.work);
  });

  // TS-002
  test('update event title', () async {
    final event = _makeEvent(title: 'Original');
    final addResult = await repo.addEvent(event);
    final id = addResult.getOrNull()!;

    final updated = event.copyWith(id: id, title: 'Updated');
    final updateResult = await repo.updateEvent(updated);
    expect(updateResult.isSuccess, true);

    final fetched = await repo.getEventById(id);
    expect(fetched.getOrNull()!.title, 'Updated');
  });

  // TS-003
  test('delete event — row absent after delete', () async {
    final event = _makeEvent();
    final addResult = await repo.addEvent(event);
    final id = addResult.getOrNull()!;

    final deleteResult = await repo.deleteEvent(id);
    expect(deleteResult.isSuccess, true);

    final fetched = await repo.getEventById(id);
    expect(fetched.getOrNull(), isNull);
  });

  // TS-004
  test('getEventsBetween returns only events in range', () async {
    final base = DateTime.utc(2026, 5, 16);
    final e1 = _makeEvent(title: 'E1', startTime: base.add(const Duration(hours: 1)));
    final e2 = _makeEvent(title: 'E2', startTime: base.add(const Duration(hours: 5)));
    final e3 = _makeEvent(title: 'E3', startTime: base.add(const Duration(hours: 9)));

    await repo.addEvent(e1);
    await repo.addEvent(e2);
    await repo.addEvent(e3);

    final startMs = base.add(const Duration(hours: 3)).millisecondsSinceEpoch;
    final endMs = base.add(const Duration(hours: 7)).millisecondsSinceEpoch;

    final result = await repo.getEventsBetween(startMs, endMs);
    expect(result.isSuccess, true);
    final list = result.getOrNull()!;
    expect(list.length, 1);
    expect(list.first.title, 'E2');
  });

  // TS-005
  test('getEventsBetween returns empty list for no match', () async {
    final base = DateTime.utc(2026, 5, 16, 10);
    await repo.addEvent(_makeEvent(startTime: base));

    final startMs = base.add(const Duration(hours: 5)).millisecondsSinceEpoch;
    final endMs = base.add(const Duration(hours: 6)).millisecondsSinceEpoch;

    final result = await repo.getEventsBetween(startMs, endMs);
    expect(result.getOrNull(), isEmpty);
  });

  // TS-006
  test('watchEventsForDay emits on insert', () async {
    final today = DateTime.utc(2026, 5, 16);
    final stream = repo.watchEventsForDay(today);

    final future = stream.first;
    await repo.addEvent(_makeEvent(startTime: today.add(const Duration(hours: 10))));

    final list = await future;
    expect(list, isNotEmpty);
  });

  // TS-007
  test('watchEventsForDay ignores yesterday events', () async {
    final yesterday = DateTime.utc(2026, 5, 15, 10);
    await repo.addEvent(_makeEvent(startTime: yesterday, endTime: yesterday.add(const Duration(hours: 1))));

    final today = DateTime.utc(2026, 5, 16);
    final list = await repo.watchEventsForDay(today).first;
    expect(list, isEmpty);
  });

  // TS-008
  test('EventMapper fromRow: all fields mapped correctly', () {
    final startMs = DateTime.utc(2026, 5, 16, 9).millisecondsSinceEpoch;
    final endMs = DateTime.utc(2026, 5, 16, 10).millisecondsSinceEpoch;
    final row = EventRow(
      id: 42,
      title: 'Design Review',
      startTime: startMs,
      endTime: endMs,
      category: 'personal',
      notes: 'Bring slides',
    );
    final event = EventMapper.fromRow(row);
    expect(event.id, 42);
    expect(event.title, 'Design Review');
    expect(event.startTime.millisecondsSinceEpoch, startMs);
    expect(event.endTime.millisecondsSinceEpoch, endMs);
    expect(event.category, EventCategory.personal);
    expect(event.notes, 'Bring slides');
  });

  // TS-009
  test('EventMapper toCompanion: DateTime to epoch correct', () {
    final event = _makeEvent(
      id: 7,
      startTime: DateTime.utc(2026, 5, 16, 14),
      endTime: DateTime.utc(2026, 5, 16, 15),
    );
    final companion = EventMapper.toCompanion(event);
    expect(
      companion.startTime.value,
      event.startTime.millisecondsSinceEpoch,
    );
    expect(
      companion.endTime.value,
      event.endTime.millisecondsSinceEpoch,
    );
    expect(companion.id.value, 7);
  });

  // TS-010
  test('EventMapper throws ArgumentError on unknown category', () {
    final row = EventRow(
      id: 1,
      title: 'Test',
      startTime: 0,
      endTime: 1000,
      category: 'unknown',
      notes: null,
    );
    expect(() => EventMapper.fromRow(row), throwsA(isA<ArgumentError>()));
  });

  // TS-011
  test('AgendaRepositoryImpl returns Success on insert', () async {
    final result = await repo.addEvent(_makeEvent());
    expect(result.isSuccess, true);
    expect(result.getOrNull(), isNotNull);
  });

  // TS-012
  test('AgendaRepositoryImpl returns Failure when DAO throws', () async {
    final failingRepo = AgendaRepositoryImpl(_ThrowingDao(db));
    final result = await failingRepo.addEvent(_makeEvent());
    expect(result.isFailure, true);
    result.when(
      success: (_) => fail('Expected failure'),
      failure: (error) => expect(error, AppError.databaseWriteFailed),
    );
  });
}
