import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';
import 'package:odo/features/agenda/presentation/pages/add_event_sheet.dart';

class _FakeAgendaNotifier extends AgendaNotifier {
  bool addEventCalled = false;
  Event? lastEvent;

  @override
  Future<void> addEvent(Event event) async {
    addEventCalled = true;
    lastEvent = event;
    state = const AsyncData(null);
  }
}

GoRouter _sheetRouter(Widget sheet) => GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => Scaffold(body: sheet)),
    ]);

void main() {
  // TS-031
  testWidgets('Empty title shows validation error', (tester) async {
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp.router(routerConfig: _sheetRouter(const AddEventSheet())),
    ));
    await tester.pump();

    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    expect(find.text('Le titre est requis'), findsOneWidget);
  });

  // TS-034
  testWidgets('Cancel dismisses without saving', (tester) async {
    final fakeNotifier = _FakeAgendaNotifier();

    await tester.pumpWidget(ProviderScope(
      overrides: [agendaNotifierProvider.overrideWith(() => fakeNotifier)],
      child: MaterialApp.router(routerConfig: _sheetRouter(const AddEventSheet())),
    ));
    await tester.pump();

    await tester.tap(find.text('Annuler'));
    await tester.pump();

    expect(fakeNotifier.addEventCalled, isFalse);
  });

  // TS-035
  testWidgets('Category defaults to Personal', (tester) async {
    final fakeNotifier = _FakeAgendaNotifier();

    await tester.pumpWidget(ProviderScope(
      overrides: [agendaNotifierProvider.overrideWith(() => fakeNotifier)],
      child: MaterialApp.router(routerConfig: _sheetRouter(const AddEventSheet())),
    ));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).first, 'Test');
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    // Consume GoError from context.pop() — expected in single-route test context
    tester.takeException();

    expect(fakeNotifier.lastEvent?.category, EventCategory.personal);
  });

  // TS-033
  testWidgets('Valid form calls notifier — no title validation error', (tester) async {
    final fakeNotifier = _FakeAgendaNotifier();

    await tester.pumpWidget(ProviderScope(
      overrides: [agendaNotifierProvider.overrideWith(() => fakeNotifier)],
      child: MaterialApp.router(routerConfig: _sheetRouter(const AddEventSheet())),
    ));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).first, 'Team Standup');
    await tester.pump();

    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    // Consume GoError from context.pop() — expected in single-route test context
    tester.takeException();

    expect(find.text('Le titre est requis'), findsNothing);
    expect(fakeNotifier.addEventCalled, isTrue);
  });

  // TS-036
  testWidgets('Pre-filled start time shown in sheet', (tester) async {
    final prefillStart = DateTime(2026, 5, 16, 14);

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp.router(
        routerConfig: _sheetRouter(AddEventSheet(prefillStartTime: prefillStart)),
      ),
    ));
    await tester.pump();

    expect(find.text('14:00'), findsOneWidget);
  });
}
