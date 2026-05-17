import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:odo/core/database/database_providers.dart';
import 'package:odo/core/types/result.dart';
import 'package:odo/features/practice/data/practice_dao.dart';
import 'package:odo/features/practice/data/repositories/practice_repository_impl.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/repositories/practice_repository.dart';

final practiceDaoProvider = Provider<PracticeDao>((ref) {
  return ref.watch(appDatabaseProvider).practiceDao;
});

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  return PracticeRepositoryImpl(ref.watch(practiceDaoProvider));
});

final allSkillsProvider = StreamProvider<List<Skill>>((ref) {
  return ref.watch(practiceRepositoryProvider).watchAllSkills();
});

class PracticeNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Result<int>> addSkill(Skill skill) =>
      ref.read(practiceRepositoryProvider).addSkill(skill);

  Future<Result<void>> updateSkill(Skill skill) =>
      ref.read(practiceRepositoryProvider).updateSkill(skill);

  Future<Result<void>> deleteSkill(int id) =>
      ref.read(practiceRepositoryProvider).deleteSkill(id);
}

final practiceNotifierProvider =
    AsyncNotifierProvider<PracticeNotifier, void>(PracticeNotifier.new);
