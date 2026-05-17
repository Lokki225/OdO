import 'package:flutter/foundation.dart';

import 'package:odo/core/types/result.dart';
import 'skill_type.dart';

@immutable
class Skill {
  const Skill({
    this.id,
    required this.name,
    required this.type,
    this.metricConfig,
    this.levelLabel,
    this.levelUpdatedAt,
    required this.sessionssSinceLevelUpdate,
    required this.createdAt,
    this.lastSessionAt,
    required this.isArchived,
    this.suppressedUntil,
  });

  final int? id;
  final String name;
  final SkillType type;
  final String? metricConfig;
  final String? levelLabel;
  final DateTime? levelUpdatedAt;
  final int sessionssSinceLevelUpdate;
  final DateTime createdAt;
  final DateTime? lastSessionAt;
  final bool isArchived;
  final DateTime? suppressedUntil;

  Result<Skill> validate() {
    if (name.trim().isEmpty) {
      return Failure(AppError.validationFailed);
    }
    return Success(this);
  }

  Skill copyWith({
    int? id,
    String? name,
    SkillType? type,
    String? metricConfig,
    String? levelLabel,
    DateTime? levelUpdatedAt,
    int? sessionssSinceLevelUpdate,
    DateTime? createdAt,
    DateTime? lastSessionAt,
    bool? isArchived,
    DateTime? suppressedUntil,
    bool clearId = false,
  }) {
    return Skill(
      id: clearId ? null : (id ?? this.id),
      name: name ?? this.name,
      type: type ?? this.type,
      metricConfig: metricConfig ?? this.metricConfig,
      levelLabel: levelLabel ?? this.levelLabel,
      levelUpdatedAt: levelUpdatedAt ?? this.levelUpdatedAt,
      sessionssSinceLevelUpdate:
          sessionssSinceLevelUpdate ?? this.sessionssSinceLevelUpdate,
      createdAt: createdAt ?? this.createdAt,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
      isArchived: isArchived ?? this.isArchived,
      suppressedUntil: suppressedUntil ?? this.suppressedUntil,
    );
  }
}
