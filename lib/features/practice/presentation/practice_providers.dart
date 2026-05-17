import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:odo/core/database/database_providers.dart';
import 'package:odo/core/types/result.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';
import 'package:odo/features/practice/data/practice_dao.dart';
import 'package:odo/features/practice/data/repositories/practice_repository_impl.dart';
import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/entities/skill_with_stats.dart';
import 'package:odo/features/practice/domain/repositories/practice_repository.dart';
import 'package:odo/features/practice/domain/usecases/streak_calculator.dart';

final practiceDaoProvider = Provider<PracticeDao>((ref) {
  return ref.watch(appDatabaseProvider).practiceDao;
});

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  return PracticeRepositoryImpl(ref.watch(practiceDaoProvider));
});

final allSkillsProvider = StreamProvider<List<Skill>>((ref) {
  return ref.watch(practiceRepositoryProvider).watchAllSkills();
});

final skillByIdProvider = Provider.family<Skill?, int>((ref, id) {
  final asyncSkills = ref.watch(allSkillsProvider);
  return switch (asyncSkills) {
    AsyncData(:final value) => value.where((s) => s.id == id).firstOrNull,
    _ => null,
  };
});

class PracticeNotifier extends AsyncNotifier<List<SkillWithStats>> {
  @override
  Future<List<SkillWithStats>> build() async {
    final skills = await ref.watch(allSkillsProvider.future);
    final repo = ref.read(practiceRepositoryProvider);
    final now = DateTime.now();
    final since = now.subtract(const Duration(days: 6));

    return Future.wait(
      skills.map((skill) async {
        final id = skill.id;
        if (id == null) {
          return SkillWithStats(
            skill: skill,
            currentStreak: 0,
            activityLast7Days: List.filled(7, false),
          );
        }
        final sessionsResult = await repo.getSessionsForSkill(id, since: since);
        final sessions = sessionsResult.getOrNull() ?? [];
        final lastResult = await repo.getLastSession(id);
        final lastSession = lastResult.getOrNull();
        return SkillWithStats(
          skill: skill,
          currentStreak: StreakCalculator.compute(sessions, now),
          lastSession: lastSession,
          activityLast7Days: _activity(sessions, now),
        );
      }),
    );
  }

  List<bool> _activity(List<Session> sessions, DateTime now) {
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return sessions.any((s) => _sameDay(s.startedAt, day));
    });
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<Result<int>> addSkill(Skill skill) async {
    final result = await ref.read(practiceRepositoryProvider).addSkill(skill);
    if (result.isSuccess) ref.invalidateSelf();
    return result;
  }

  Future<Result<void>> updateSkill(Skill skill) async {
    final result =
        await ref.read(practiceRepositoryProvider).updateSkill(skill);
    if (result.isSuccess) ref.invalidateSelf();
    return result;
  }

  Future<Result<void>> deleteSkill(int id) async {
    final result =
        await ref.read(practiceRepositoryProvider).deleteSkill(id);
    if (result.isSuccess) ref.invalidateSelf();
    return result;
  }

  Future<Result<int>> logSession({
    required int skillId,
    required int durationMinutes,
    required DateTime startedAt,
    String? notes,
  }) async {
    final agendaRepo = ref.read(agendaRepositoryProvider);
    final endMs =
        startedAt.millisecondsSinceEpoch + durationMinutes * 60 * 1000;
    final eventsResult = await agendaRepo.getEventsBetween(
      startedAt.millisecondsSinceEpoch,
      endMs,
    );
    final events = eventsResult.getOrNull() ?? [];
    final isAnchored =
        events.any((e) => e.category == EventCategory.practice);

    final session = Session(
      skillId: skillId,
      startedAt: startedAt.toUtc(),
      durationMinutes: durationMinutes,
      modeTags: const [],
      isAnchored: isAnchored,
      isMilestone: false,
      notes: notes?.isEmpty == true ? null : notes,
    );

    final result =
        await ref.read(practiceRepositoryProvider).addSession(session);
    if (result.isSuccess) ref.invalidateSelf();
    return result;
  }
}

final practiceNotifierProvider =
    AsyncNotifierProvider<PracticeNotifier, List<SkillWithStats>>(
  PracticeNotifier.new,
);
