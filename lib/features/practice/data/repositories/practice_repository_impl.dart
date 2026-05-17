import 'package:odo/core/types/result.dart';
import 'package:odo/features/practice/data/mappers/session_mapper.dart';
import 'package:odo/features/practice/data/mappers/skill_mapper.dart';
import 'package:odo/features/practice/data/practice_dao.dart';
import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/repositories/practice_repository.dart';

class PracticeRepositoryImpl implements PracticeRepository {
  PracticeRepositoryImpl(this._dao);

  final PracticeDao _dao;

  @override
  Future<Result<int>> addSkill(Skill skill) async {
    try {
      final id = await _dao.insertSkill(SkillMapper.toCompanion(skill));
      return Success(id);
    } catch (_) {
      return Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<void>> updateSkill(Skill skill) async {
    try {
      await _dao.updateSkill(SkillMapper.toCompanion(skill));
      return const Success(null);
    } catch (_) {
      return Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<void>> deleteSkill(int id) async {
    try {
      await _dao.deleteSkill(id);
      return const Success(null);
    } catch (_) {
      return Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Stream<List<Skill>> watchAllSkills() {
    return _dao.watchAllSkills().map(
          (rows) => rows.map(SkillMapper.fromRow).toList(),
        );
  }

  @override
  Future<Result<int>> addSession(Session session) async {
    try {
      final id = await _dao
          .insertSessionAtomic(SessionMapper.toCompanion(session));
      return Success(id);
    } catch (_) {
      return Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<List<Session>>> getSessionsForSkill(
    int skillId, {
    DateTime? since,
  }) async {
    try {
      final rows = await _dao.getSessionsForSkill(
        skillId,
        sinceMs: since?.millisecondsSinceEpoch,
      );
      return Success(rows.map(SessionMapper.fromRow).toList());
    } catch (_) {
      return Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<Session?>> getLastSession(int skillId) async {
    try {
      final row = await _dao.getLastSession(skillId);
      return Success(row != null ? SessionMapper.fromRow(row) : null);
    } catch (_) {
      return Failure(AppError.databaseWriteFailed);
    }
  }

  @override
  Future<Result<List<Session>>> getUnanchoredSessions(
    int skillId, {
    DateTime? since,
  }) async {
    try {
      final rows = await _dao.getUnanchoredSessions(
        skillId,
        sinceMs: since?.millisecondsSinceEpoch,
      );
      return Success(rows.map(SessionMapper.fromRow).toList());
    } catch (_) {
      return Failure(AppError.databaseWriteFailed);
    }
  }
}
