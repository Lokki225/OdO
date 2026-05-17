import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/constants/app_typography.dart';
import 'package:odo/features/practice/domain/entities/skill_with_stats.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({super.key, required this.stats});

  final SkillWithStats stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final skill = stats.skill;
    final id = skill.id;

    return GestureDetector(
      onTap: id != null
          ? () => context.go('/home/practice/skill/$id')
          : null,
      onLongPress: id != null
          ? () => context.go('/home/practice/log-session/$id')
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: colorScheme.outline),
        ),
        padding: const EdgeInsets.all(AppSpacing.sp16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    skill.name,
                    style: AppTypography.textTitle.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (stats.currentStreak > 0)
                  Text(
                    '🔥 ${stats.currentStreak}',
                    style: AppTypography.textBody.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sp12),
            _ActivityBar(activity: stats.activityLast7Days),
            const SizedBox(height: AppSpacing.sp12),
            Text(
              _lastSessionText(),
              style: AppTypography.textCaption.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _lastSessionText() {
    final last = stats.lastSession;
    if (last == null) return 'Aucune session';
    final days = DateTime.now().difference(last.startedAt).inDays;
    final dateStr = switch (days) {
      0 => "aujourd'hui",
      1 => 'hier',
      _ => 'il y a $days jours',
    };
    return '${last.durationMinutes} min · $dateStr';
  }
}

class _ActivityBar extends StatelessWidget {
  const _ActivityBar({required this.activity});

  final List<bool> activity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(7, (i) {
        final active = i < activity.length && activity[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 6 ? AppSpacing.sp4 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: AppSpacing.sp24,
              decoration: BoxDecoration(
                color: active
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm / 2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
