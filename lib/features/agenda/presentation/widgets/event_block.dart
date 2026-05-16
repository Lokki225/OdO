import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/services/locale_service.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';

class EventBlock extends StatelessWidget {
  const EventBlock({
    super.key,
    required this.event,
    required this.topOffset,
    required this.height,
  });

  final Event event;
  final double topOffset;
  final double height;

  static const double _minHeight = 32.0;
  static const double _categoryBarWidth = 4.0;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height.clamp(_minHeight, double.infinity);
    final colorScheme = Theme.of(context).colorScheme;
    final locale = LocaleService();

    return Positioned(
      top: topOffset,
      left: 56,
      right: 8,
      height: effectiveHeight,
      child: GestureDetector(
        onTap: () => context.push('/home/agenda/event/${event.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Row(
            children: [
              Container(
                width: _categoryBarWidth,
                decoration: BoxDecoration(
                  color: _categoryColor(event.category),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusSm),
                    bottomLeft: Radius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sp8),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.sp4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (effectiveHeight > _minHeight)
                        Text(
                          '${locale.formatTime(event.startTime.toLocal())} – '
                          '${locale.formatTime(event.endTime.toLocal())}',
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: 1,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sp4),
            ],
          ),
        ),
      ),
    );
  }

  static Color _categoryColor(EventCategory category) => switch (category) {
        EventCategory.personal => AppColors.colorCategoryPersonal,
        EventCategory.work => AppColors.colorCategoryWork,
        EventCategory.practice => AppColors.colorCategoryPractice,
      };
}
