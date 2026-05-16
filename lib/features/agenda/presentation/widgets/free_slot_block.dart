import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/constants/app_spacing.dart';

class FreeSlotBlock extends StatelessWidget {
  const FreeSlotBlock({
    super.key,
    required this.topOffset,
    required this.height,
    required this.startTime,
  });

  final double topOffset;
  final double height;
  final DateTime startTime;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topOffset,
      left: 56,
      right: 8,
      height: height,
      child: GestureDetector(
        onTap: () => context.go(
          '/home/agenda/add-event',
          extra: {'startTime': startTime},
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.colorCategoryPractice.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: AppColors.colorCategoryPractice.withValues(alpha: 0.3),
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
