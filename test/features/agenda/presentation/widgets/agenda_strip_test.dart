import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/domain/repositories/agenda_repository.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';
import 'package:odo/features/agenda/presentation/widgets/agenda_strip.dart';

class _ThrowingRepository extends Fake implements AgendaRepository {
  @override
  Stream<List<Event>> watchEventsForDay(DateTime date) =>
      Stream.error(Exception('DB error'));
}

Event _event({required int id, required String title, required DateTime start}) {
  return Event(
    id: id,
    title: title,
    startTime: start,
    endTime: start.add(const Duration(hours: 1)),
    category: EventCategory.work,
  );
}

GoRouter _buildRouter() => GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const Scaffold(body: AgendaStrip())),
      GoRoute(path: '/home/agenda', builder: (_, __) => const Scaffold(body: Text('Agenda'))),
      GoRoute(path: '/home/agenda/calendar', builder: (_, __) => const Scaffold(body: Text('Calendar'))),
    ]);

void main() {
  // TS-013
  testWidgets('State 1: two upcoming events shown', (tester) async {
    final now = DateTime.now();
    final e1 = _event(id: 1, title: 'Event One', start: now.add(const Duration(hours: 1)));
    final e2 = _event(id: 2, title: 'Event Two', start: now.add(const Duration(hours: 2)));

    await tester.pumpWidget(ProviderScope(
      overrides: [
        agendaStripProvider.overrideWith((ref) => Stream.value(EventsToday([e1, e2]))),
      ],
      child: MaterialApp.router(routerConfig: _buildRouter()),
    ));
    await tester.pump();

    expect(find.textContaining('Event One'), findsOneWidget);
    expect(find.textContaining('Event Two'), findsOneWidget);
    expect(find.textContaining('·'), findsOneWidget);
  });

  // TS-014
  testWidgets('State 1: single upcoming event — no dot separator', (tester) async {
    final now = DateTime.now();
    final e1 = _event(id: 1, title: 'Solo Event', start: now.add(const Duration(hours: 1)));

    await tester.pumpWidget(ProviderScope(
      overrides: [
        agendaStripProvider.overrideWith((ref) => Stream.value(EventsToday([e1]))),
      ],
      child: MaterialApp.router(routerConfig: _buildRouter()),
    ));
    await tester.pump();

    expect(find.textContaining('Solo Event'), findsOneWidget);
    expect(find.textContaining('·'), findsNothing);
  });

  // TS-015
  testWidgets('State 1: title truncated at 20 chars', (tester) async {
    final now = DateTime.now();
    const longTitle = 'A Very Long Event Title Here';
    final e1 = _event(id: 1, title: longTitle, start: now.add(const Duration(hours: 1)));

    await tester.pumpWidget(ProviderScope(
      overrides: [
        agendaStripProvider.overrideWith((ref) => Stream.value(EventsToday([e1]))),
      ],
      child: MaterialApp.router(routerConfig: _buildRouter()),
    ));
    await tester.pump();

    expect(find.textContaining('A Very Long Event Ti…'), findsOneWidget);
  });

  // TS-016
  testWidgets('State 2: Tomorrow label and event shown', (tester) async {
    final tomorrow = DateTime.now().add(const Duration(hours: 20));
    final e = _event(id: 3, title: 'Morning Run', start: tomorrow);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        agendaStripProvider.overrideWith((ref) => Stream.value(NextTomorrow(e))),
      ],
      child: MaterialApp.router(routerConfig: _buildRouter()),
    ));
    await tester.pump();

    expect(find.textContaining('Tomorrow'), findsOneWidget);
    expect(find.textContaining('Morning Run'), findsOneWidget);
  });

  // TS-017
  testWidgets('State 3: nothing scheduled message shown', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        agendaStripProvider.overrideWith((ref) => Stream.value(const NothingScheduled())),
      ],
      child: MaterialApp.router(routerConfig: _buildRouter()),
    ));
    await tester.pump();

    expect(find.textContaining('Nothing scheduled — free day'), findsOneWidget);
  });

  // TS-018
  testWidgets('Loading state shows a Container (skeleton)', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        agendaStripProvider.overrideWith((ref) => const Stream.empty()),
      ],
      child: MaterialApp.router(routerConfig: _buildRouter()),
    ));
    await tester.pump();

    // In loading state, shows Container skeleton — not event text
    expect(find.byType(Container), findsWidgets);
    expect(find.textContaining('Nothing scheduled'), findsNothing);
  });

  // TS-019
  // Overrides the repository (not the strip provider) so the real provider's
  // try/catch error handling is exercised. Stream error → NothingScheduled.
  testWidgets('Error state falls back to nothing scheduled text', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        agendaRepositoryProvider.overrideWith((ref) => _ThrowingRepository()),
      ],
      child: MaterialApp.router(routerConfig: _buildRouter()),
    ));
    await tester.pump(); // subscribe + trigger async* body
    await tester.pump(); // error caught, NothingScheduled yielded, widget rebuilds

    expect(find.textContaining('Nothing scheduled — free day'), findsOneWidget);
  });
}
