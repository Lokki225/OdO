import 'package:drift/drift.dart';

import 'package:odo/core/database/app_database.dart';
import 'package:odo/core/database/tables/sessions_table.dart';
import 'package:odo/core/database/tables/skills_table.dart';

part 'practice_dao.g.dart';

@DriftAccessor(tables: [Skills, Sessions])
class PracticeDao extends DatabaseAccessor<AppDatabase>
    with _$PracticeDaoMixin {
  PracticeDao(super.db);

  Future<int> insertSkill(SkillsCompanion companion) =>
      into(skills).insert(companion);

  Future<bool> updateSkill(SkillsCompanion companion) =>
      update(skills).replace(companion);

  Future<int> deleteSkill(int id) =>
      (delete(skills)..where((t) => t.id.equals(id))).go();

  Stream<List<SkillRow>> watchAllSkills() => select(skills).watch();

  Future<SkillRow?> getSkillById(int id) =>
      (select(skills)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertSession(SessionsCompanion companion) =>
      into(sessions).insert(companion);

  Future<List<SessionRow>> getSessionsForSkill(
    int skillId, {
    int? sinceMs,
  }) {
    final query = select(sessions)
      ..where((t) => t.skillId.equals(skillId));
    if (sinceMs != null) {
      query.where((t) => t.startedAt.isBiggerOrEqualValue(sinceMs));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.startedAt)]);
    return query.get();
  }

  Future<SessionRow?> getLastSession(int skillId) =>
      (select(sessions)
            ..where((t) => t.skillId.equals(skillId))
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<SessionRow>> getUnanchoredSessions(
    int skillId, {
    int? sinceMs,
  }) {
    final query = select(sessions)
      ..where((t) => t.skillId.equals(skillId))
      ..where((t) => t.isAnchored.equals(false));
    if (sinceMs != null) {
      query.where((t) => t.startedAt.isBiggerOrEqualValue(sinceMs));
    }
    query
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
      ..limit(3);
    return query.get();
  }

  Future<void> updateSessionsCountAndLastSessionAt(
    int skillId,
    DateTime lastAt,
  ) {
    return customUpdate(
      'UPDATE skills '
      'SET sessions_since_level_update = sessions_since_level_update + 1, '
      '    last_session_at = ? '
      'WHERE id = ?',
      variables: [
        Variable.withInt(lastAt.millisecondsSinceEpoch),
        Variable.withInt(skillId),
      ],
      updates: {skills},
    );
  }

  Future<int> insertSessionAtomic(SessionsCompanion companion) {
    return transaction(() async {
      final id = await into(sessions).insert(companion);
      final row = await (select(sessions)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      await updateSessionsCountAndLastSessionAt(
        row.skillId,
        DateTime.fromMillisecondsSinceEpoch(row.startedAt),
      );
      return id;
    });
  }
}
