import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/entities/skill_type.dart';
import 'package:odo/features/practice/domain/entities/skill_with_stats.dart';
import 'package:odo/features/practice/presentation/widgets/skill_card.dart';

SkillWithStats _makeStats({
  String name = 'Chess',
  int id = 42,
  int streak = 0,
  Session? lastSession,
  List<bool>? activity,
}) {
  return SkillWithStats(
    skill: Skill(
      id: id,
      name: name,
      type: SkillType.strategy,
      sessionssSinceLevelUpdate: 0,
      createdAt: DateTime(2024, 1, 1),
      isArchived: false,
    ),
    currentStreak: streak,
    lastSession: lastSession,
    activityLast7Days: activity ?? List.filled(7, false),
  );
}

Widget _buildCard(SkillWithStats stats) {
  return MaterialApp(
    home: Scaffold(body: SkillCard(stats: stats)),
  );
}

void main() {
  group('SkillCard', () {
    testWidgets('displays skill name', (tester) async {
      await tester.pumpWidget(_buildCard(_makeStats(name: 'Japonais')));
      expect(find.text('Japonais'), findsOneWidget);
    });

    testWidgets('shows streak badge when streak > 0', (tester) async {
      await tester.pumpWidget(_buildCard(_makeStats(streak: 7)));
      expect(find.text('🔥 7'), findsOneWidget);
    });

    testWidgets('hides streak badge when streak is 0', (tester) async {
      await tester.pumpWidget(_buildCard(_makeStats()));
      expect(find.textContaining('🔥'), findsNothing);
    });

    testWidgets('renders exactly 7 animated containers in activity bar',
        (tester) async {
      await tester.pumpWidget(
        _buildCard(_makeStats(
          activity: [true, false, true, false, true, false, true],
        )),
      );
      expect(find.byType(AnimatedContainer), findsNWidgets(7));
    });

    testWidgets('shows "Aucune session" when no last session', (tester) async {
      await tester.pumpWidget(_buildCard(_makeStats()));
      expect(find.text('Aucune session'), findsOneWidget);
    });

    testWidgets('shows duration and "il y a N jours" for past session',
        (tester) async {
      final session = Session(
        id: 1,
        skillId: 42,
        startedAt: DateTime.now().subtract(const Duration(days: 2)),
        durationMinutes: 35,
        modeTags: const [],
        isAnchored: false,
        isMilestone: false,
      );
      await tester.pumpWidget(_buildCard(_makeStats(lastSession: session)));
      expect(find.text('35 min · il y a 2 jours'), findsOneWidget);
    });

    testWidgets("shows \"aujourd'hui\" for session started today",
        (tester) async {
      final session = Session(
        id: 2,
        skillId: 42,
        startedAt: DateTime.now(),
        durationMinutes: 20,
        modeTags: const [],
        isAnchored: false,
        isMilestone: false,
      );
      await tester.pumpWidget(_buildCard(_makeStats(lastSession: session)));
      expect(find.text("20 min · aujourd'hui"), findsOneWidget);
    });

    testWidgets('shows "hier" for session started yesterday', (tester) async {
      final session = Session(
        id: 3,
        skillId: 42,
        startedAt: DateTime.now().subtract(const Duration(days: 1)),
        durationMinutes: 45,
        modeTags: const [],
        isAnchored: false,
        isMilestone: false,
      );
      await tester.pumpWidget(_buildCard(_makeStats(lastSession: session)));
      expect(find.text('45 min · hier'), findsOneWidget);
    });
  });
}
