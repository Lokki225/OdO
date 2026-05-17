import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/types/result.dart';
import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/repositories/practice_repository.dart';
import 'package:odo/features/practice/presentation/pages/first_launch_sheet.dart';
import 'package:odo/features/practice/presentation/practice_providers.dart';

class _FakePracticeRepository implements PracticeRepository {
  bool addSkillCalled = false;
  Skill? lastSkill;
  Result<int> addSkillResult = const Success(1);

  @override
  Future<Result<int>> addSkill(Skill skill) async {
    addSkillCalled = true;
    lastSkill = skill;
    return addSkillResult;
  }

  @override
  Future<Result<void>> updateSkill(Skill skill) async => const Success(null);

  @override
  Future<Result<void>> deleteSkill(int id) async => const Success(null);

  @override
  Stream<List<Skill>> watchAllSkills() => Stream.value([]);

  @override
  Future<Result<int>> addSession(Session session) async => const Success(1);

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

Widget _buildSheet(_FakePracticeRepository repo) {
  return ProviderScope(
    overrides: [
      practiceRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const FirstLaunchSheet(),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('FirstLaunchSheet', () {
    testWidgets('renders text field and disabled submit when empty', (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Commencer'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('enables submit when text is non-empty', (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Chess');
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Commencer'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('tapping submit calls addSkill with entered name', (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Chess');
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Commencer'));
      await tester.pumpAndSettle();

      expect(repo.addSkillCalled, isTrue);
      expect(repo.lastSkill?.name, 'Chess');
    });

    testWidgets('submit with whitespace-only name does nothing', (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      // Button should be disabled (trimmed text is empty)
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Commencer'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows snackbar on addSkill failure', (tester) async {
      final repo = _FakePracticeRepository()
        ..addSkillResult = Failure(AppError.databaseWriteFailed);
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Yoga');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Commencer'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('auto-detects skill type from name keyword', (tester) async {
      final repo = _FakePracticeRepository();
      await tester.pumpWidget(_buildSheet(repo));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'japonais');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Commencer'));
      await tester.pumpAndSettle();

      expect(repo.lastSkill?.type.value, 'language');
    });
  });
}
