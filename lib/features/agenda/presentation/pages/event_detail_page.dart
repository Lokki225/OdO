import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/services/locale_service.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';

class EventDetailPage extends ConsumerWidget {
  const EventDetailPage({super.key, required this.eventId});

  final int eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: eventAsync.when(
        data: (event) {
          if (event == null) {
            return Center(
              child: Text(
                'Event not found',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return _EventBody(event: event);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Could not load event',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class _EventBody extends ConsumerWidget {
  const _EventBody({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = LocaleService();
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.sp24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _categoryColor(event.category),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
          const SizedBox(height: AppSpacing.sp12),

          Text(
            event.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sp8),

          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: AppSpacing.sp8),
              Text(
                '${locale.formatTime(event.startTime.toLocal())} – '
                '${locale.formatTime(event.endTime.toLocal())}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sp4),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: AppSpacing.sp8),
              Text(
                locale.formatDate(event.startTime.toLocal()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sp4),

          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _categoryColor(event.category),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sp8),
              Text(
                _categoryLabel(event.category),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          if (event.notes != null && event.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sp16),
            Text(
              'Notes',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.sp4),
            Text(
              event.notes!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],

          const SizedBox(height: AppSpacing.sp32),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                  onPressed: () => context.push(
                    '/home/agenda/add-event',
                    extra: {'event': event},
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sp12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                  ),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final savedEvent = event;
    final notifier = ref.read(agendaNotifierProvider.notifier);

    notifier.deleteEvent(savedEvent.id!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Event deleted'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            notifier.addEvent(savedEvent.copyWith(clearId: true));
          },
        ),
      ),
    );

    context.pop();
  }

  static Color _categoryColor(EventCategory cat) => switch (cat) {
        EventCategory.personal => AppColors.colorCategoryPersonal,
        EventCategory.work => AppColors.colorCategoryWork,
        EventCategory.practice => AppColors.colorCategoryPractice,
      };

  static String _categoryLabel(EventCategory cat) => switch (cat) {
        EventCategory.personal => 'Personal',
        EventCategory.work => 'Work',
        EventCategory.practice => 'Practice',
      };
}
