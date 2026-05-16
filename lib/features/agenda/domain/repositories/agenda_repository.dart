import 'package:odo/core/types/result.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';

abstract class AgendaRepository {
  Future<Result<int>> addEvent(Event event);
  Future<Result<void>> updateEvent(Event event);
  Future<Result<void>> deleteEvent(int id);
  Future<Result<Event?>> getEventById(int id);
  Future<Result<List<Event>>> getEventsBetween(int startMs, int endMs);
  Stream<List<Event>> watchEventsForDay(DateTime date);
}
