import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/types/result.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/domain/repositories/agenda_repository.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';
import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/entities/skill_type.dart';
import 'package:odo/features/practice/domain/repositories/practice_repository.dart';
import 'package:odo/features/practice/presentation/pages/log_session_sheet.dart';
import 'package:odo/features/practice/presentation/practice_providers.dart';

class _FakePracticeRepository implements PracticeRepository {
  bool addSessionCalled = false;
  Session? lastSession;

  @override
  Stream<List<Skill>> watchAllSkills() => Stream.value([
        Skill(
          id: 1,
          name: 'Chess',
          type: SkillType.strategy,
          sessionssSinceLevelUpdate: 0,
          createdAt: DateTime(2024, 1, 1),
          isArchived: false,
        ),
      ]);

  @override
  Future<Result<int>> addSkill(Skill skill) async => const Success(1);

  @override
  Future<Result<void>> updateSkill(Skill skill) async => const Success(null);

  @override
  Future<Result<void>> deleteSkill(int id) async => const Success(null);

  @override
  Future<Result<int>> addSession(Session session) async {
    addSessionCalled = true;
    lastSession = session;
    return const Success(1);
  }

  @override
  Future<Result<List<Session>>> getSessionsForSkill(int skillId,
          {DateTime? since}) async =>
      const Success([]);

  @override
  Future<Result<Session?>> getLastSession(int skillId) async =>
      const Success(null);

  @override
  Future<Result<List<Session>>> getUnanchoredSessions(int skillId,
          {DateTime? since}) async =>
      const Success([]);
}

class _FakeAgendaRepository implements AgendaRepository {
  @override
  Future<Result<List<Event>>> getEventsBetween(int startMs, int endMs) async =>
      const Success([]);

  @override
  Future<Result<int>> addEvent(Event event) async => const Success(1);

  @override
  Future<Result<void>> updateEvent(Event event) async => const Success(null);

  @override
  Future<Result<void>> deleteEvent(int id) async => const Success(null);

  @override
  Future<Result<Event?>> getEventById(int id) async => const Success(null);

  @override
  Stream<List<Event>> watchEventsForDay(DateTime date) => Stream.value([]);
}

Widget _buildSheet(
  _FakePracticeRepository practiceRepo, {
  _FakeAgendaRepository? agendaRepo,
}) {
  return ProviderScope(
    overrides: [
      practiceRepositoryProvider.overrideWithValue(practiceRepo),
      agendaRepositoryProvider.overrideWithValue(
        agendaRepo ?? _FakeAgendaRepository(),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const LogSessionSheet(skillId: 1),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('LogSessionSheet', () {
    testWidgets('save button disabled until duration is selected',
        (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Enregistrer'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('selecting 25-min chip enables save button', (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, '25 min'));
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Enregistrer'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('tapping save with 25-min chip calls addSession with 25 min',
        (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, '25 min'));
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
      await tester.pumpAndSettle();

      expect(repo.addSessionCalled, isTrue);
      expect(repo.lastSession?.durationMinutes, 25);
    });

    testWidgets('custom duration input enables save and passes correct value',
        (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Autre'));
      await tester.pump();

      // first TextField is the custom duration input (appears before notes)
      await tester.enterText(find.byType(TextField).first, '90');
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Enregistrer'),
      );
      expect(button.onPressed, isNotNull);

      await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
      await tester.pumpAndSettle();

      expect(repo.addSessionCalled, isTrue);
      expect(repo.lastSession?.durationMinutes, 90);
    });

    testWidgets('shows skill name at top of sheet', (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Chess'), findsOneWidget);
    });

    testWidgets('custom duration 0 keeps save disabled', (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Autre'));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, '0');
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Enregistrer'),
      );
      expect(button.onPressed, isNull);
    });
  });
}
