import 'package:flutter/foundation.dart';

import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';

@immutable
class SkillWithStats {
  const SkillWithStats({
    required this.skill,
    required this.currentStreak,
    this.lastSession,
    required this.activityLast7Days,
  });

  final Skill skill;
  final int currentStreak;
  final Session? lastSession;
  final List<bool> activityLast7Days;
}
