import 'package:drift/drift.dart';

import 'package:odo/core/database/app_database.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/entities/skill_type.dart';

abstract final class SkillMapper {
  static Skill fromRow(SkillRow row) {
    final type = SkillType.values.firstWhere(
      (e) => e.value == row.type,
      orElse: () => throw ArgumentError('Unknown SkillType: ${row.type}'),
    );
    return Skill(
      id: row.id,
      name: row.name,
      type: type,
      metricConfig: row.metricConfig,
      levelLabel: row.levelLabel,
      levelUpdatedAt: row.levelUpdatedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(row.levelUpdatedAt!)
          : null,
      sessionssSinceLevelUpdate: row.sessionsSinceLevelUpdate,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      lastSessionAt: row.lastSessionAt != null
          ? DateTime.fromMillisecondsSinceEpoch(row.lastSessionAt!)
          : null,
      isArchived: row.isArchived,
      suppressedUntil: row.suppressedUntil != null
          ? DateTime.fromMillisecondsSinceEpoch(row.suppressedUntil!)
          : null,
    );
  }

  static SkillsCompanion toCompanion(Skill skill) {
    return SkillsCompanion(
      id: skill.id != null ? Value(skill.id!) : const Value.absent(),
      name: Value(skill.name),
      type: Value(skill.type.value),
      metricConfig: Value(skill.metricConfig),
      levelLabel: Value(skill.levelLabel),
      levelUpdatedAt:
          Value(skill.levelUpdatedAt?.millisecondsSinceEpoch),
      sessionsSinceLevelUpdate: Value(skill.sessionssSinceLevelUpdate),
      createdAt: Value(skill.createdAt.millisecondsSinceEpoch),
      lastSessionAt: Value(skill.lastSessionAt?.millisecondsSinceEpoch),
      isArchived: Value(skill.isArchived),
      suppressedUntil:
          Value(skill.suppressedUntil?.millisecondsSinceEpoch),
    );
  }
}
