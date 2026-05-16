import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:odo/core/database/database_providers.dart';
import 'package:odo/core/services/notification_service.dart';
import 'package:odo/features/agenda/data/repositories/agenda_repository_impl.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/domain/repositories/agenda_repository.dart';

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

final agendaRepositoryProvider = Provider<AgendaRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AgendaRepositoryImpl(db.agendaDao);
});

// ---------------------------------------------------------------------------
// AgendaStripState
// ---------------------------------------------------------------------------

sealed class AgendaStripState {
  const AgendaStripState();
}

class EventsToday extends AgendaStripState {
  const EventsToday(this.events);
  final List<Event> events;
}

class NextTomorrow extends AgendaStripState {
  const NextTomorrow(this.event);
  final Event event;
}

class NothingScheduled extends AgendaStripState {
  const NothingScheduled();
}

// ---------------------------------------------------------------------------
// Story 2.2 — Agenda Strip
// ---------------------------------------------------------------------------

final agendaStripProvider = StreamProvider<AgendaStripState>((ref) async* {
  try {
    final repo = ref.watch(agendaRepositoryProvider);
    final today = DateTime.now();

    await for (final events in repo.watchEventsForDay(today)) {
      final now = DateTime.now();
      final upcoming = (events.where((e) => e.startTime.isAfter(now)).toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime)))
          .take(2)
          .toList();

      if (upcoming.isNotEmpty) {
        yield EventsToday(upcoming);
      } else {
        final tomorrow = now.add(const Duration(days: 1));
        final tStart = DateTime(tomorrow.year, tomorrow.month, tomorrow.day)
            .toUtc()
            .millisecondsSinceEpoch;
        final tEnd =
            DateTime(tomorrow.year, tomorrow.month, tomorrow.day + 1)
                .toUtc()
                .millisecondsSinceEpoch;
        final result = await repo.getEventsBetween(tStart, tEnd);
        final tomorrowEvents = result.getOrNull() ?? [];
        if (tomorrowEvents.isNotEmpty) {
          tomorrowEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
          yield NextTomorrow(tomorrowEvents.first);
        } else {
          yield const NothingScheduled();
        }
      }
    }
  } catch (_) {
    yield const NothingScheduled();
  }
});

// ---------------------------------------------------------------------------
// Story 2.3 — Day Timeline
// ---------------------------------------------------------------------------

class _SelectedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void setDay(DateTime day) => state = day;
}

final selectedDayProvider =
    NotifierProvider<_SelectedDayNotifier, DateTime>(_SelectedDayNotifier.new);

final dayEventsProvider = StreamProvider<List<Event>>((ref) {
  final repo = ref.watch(agendaRepositoryProvider);
  final day = ref.watch(selectedDayProvider);
  return repo.watchEventsForDay(day);
});

// ---------------------------------------------------------------------------
// Story 2.4 — Event CRUD Notifier
// ---------------------------------------------------------------------------

class AgendaNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addEvent(Event event) async {
    state = const AsyncLoading();
    final repo = ref.read(agendaRepositoryProvider);
    final result = await repo.addEvent(event);
    await result.when(
      success: (id) async {
        try {
          await NotificationService.scheduleEventReminder(
            eventId: id,
            eventStart: event.startTime,
            title: event.title,
          );
        } catch (_) {
          // Notification scheduling is best-effort; don't block the save.
        }
        state = const AsyncData(null);
      },
      failure: (error) async {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }

  Future<void> updateEvent(Event event) async {
    state = const AsyncLoading();
    final repo = ref.read(agendaRepositoryProvider);
    final result = await repo.updateEvent(event);
    result.when(
      success: (_) => state = const AsyncData(null),
      failure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  Future<void> deleteEvent(int id) async {
    state = const AsyncLoading();
    try {
      await NotificationService.cancelReminder(id);
    } catch (_) {
      // Cancellation is best-effort; don't block the delete.
    }
    final repo = ref.read(agendaRepositoryProvider);
    final result = await repo.deleteEvent(id);
    result.when(
      success: (_) => state = const AsyncData(null),
      failure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }
}

final agendaNotifierProvider =
    AsyncNotifierProvider<AgendaNotifier, void>(AgendaNotifier.new);

final eventDetailProvider =
    FutureProvider.family<Event?, int>((ref, id) async {
  final repo = ref.watch(agendaRepositoryProvider);
  final result = await repo.getEventById(id);
  return result.getOrNull();
});

// ---------------------------------------------------------------------------
// Story 2.5 — Monthly Calendar
// ---------------------------------------------------------------------------

class _FocusedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void setDay(DateTime day) => state = day;
}

final focusedDayProvider =
    NotifierProvider<_FocusedDayNotifier, DateTime>(_FocusedDayNotifier.new);

final monthEventsProvider =
    FutureProvider.family<Map<DateTime, List<Event>>, DateTime>(
        (ref, month) async {
  final repo = ref.watch(agendaRepositoryProvider);
  final firstDay = DateTime(month.year, month.month, 1).toUtc();
  final lastDay = DateTime(month.year, month.month + 1, 1).toUtc();
  final result = await repo.getEventsBetween(
    firstDay.millisecondsSinceEpoch,
    lastDay.millisecondsSinceEpoch,
  );
  final events = result.getOrNull() ?? [];
  final map = <DateTime, List<Event>>{};
  for (final event in events) {
    final key = _stripTime(event.startTime.toLocal());
    map.putIfAbsent(key, () => []).add(event);
  }
  return map;
});

DateTime _stripTime(DateTime d) => DateTime(d.year, d.month, d.day);
