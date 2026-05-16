import 'package:odo/core/types/result.dart';
import 'package:odo/features/agenda/data/agenda_dao.dart';
import 'package:odo/features/agenda/data/mappers/event_mapper.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/domain/repositories/agenda_repository.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  AgendaRepositoryImpl(this._dao);

  final AgendaDao _dao;

  @override
  Future<Result<int>> addEvent(Event event) async {
    try {
      final id = await _dao.insertEvent(EventMapper.toCompanion(event));
      return Success(id);
    } catch (_) {
      return const Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<void>> updateEvent(Event event) async {
    try {
      await _dao.updateEvent(EventMapper.toCompanion(event));
      return const Success(null);
    } catch (_) {
      return const Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<void>> deleteEvent(int id) async {
    try {
      await _dao.deleteEvent(id);
      return const Success(null);
    } catch (_) {
      return const Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<Event?>> getEventById(int id) async {
    try {
      final row = await _dao.getEventById(id);
      return Success(row != null ? EventMapper.fromRow(row) : null);
    } catch (_) {
      return const Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<List<Event>>> getEventsBetween(int startMs, int endMs) async {
    try {
      final rows = await _dao.getEventsBetween(startMs, endMs);
      return Success(rows.map(EventMapper.fromRow).toList());
    } catch (_) {
      return const Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Stream<List<Event>> watchEventsForDay(DateTime date) {
    return _dao
        .watchEventsForDay(date)
        .map((rows) => rows.map(EventMapper.fromRow).toList());
  }
}
