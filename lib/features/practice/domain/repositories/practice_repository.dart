import 'package:odo/core/types/result.dart';
import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';

abstract class PracticeRepository {
  Future<Result<int>> addSkill(Skill skill);
  Future<Result<void>> updateSkill(Skill skill);
  Future<Result<void>> deleteSkill(int id);
  Stream<List<Skill>> watchAllSkills();
  Future<Result<int>> addSession(Session session);
  Future<Result<List<Session>>> getSessionsForSkill(
    int skillId, {
    DateTime? since,
  });
  Future<Result<Session?>> getLastSession(int skillId);
  Future<Result<List<Session>>> getUnanchoredSessions(
    int skillId, {
    DateTime? since,
  });
}
