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
        title: const Text('Événement'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: eventAsync.when(
        data: (event) {
          if (event == null) {
            return Center(
              child: Text(
                'Événement introuvable',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return _EventBody(event: event);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Impossible de charger l\'événement',
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
    final catColor = _categoryColor(event.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full-width category color bar
        Container(height: 3, color: catColor),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.sp24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.sp16),

                // Time row
                _MetaRow(
                  icon: Icons.access_time,
                  text:
                      '${locale.formatTime(event.startTime.toLocal())} – '
                      '${locale.formatTime(event.endTime.toLocal())}',
                ),
                const SizedBox(height: AppSpacing.sp8),

                // Date row
                _MetaRow(
                  icon: Icons.calendar_today_outlined,
                  text: locale.formatDate(event.startTime.toLocal()),
                ),
                const SizedBox(height: AppSpacing.sp16),

                // Category badge
                _CategoryBadge(category: event.category, color: catColor),
                const SizedBox(height: AppSpacing.sp24),

                // Notes section (always visible)
                Text(
                  'NOTES',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.8,
                      ),
                ),
                const SizedBox(height: AppSpacing.sp8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sp16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerLow,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Text(
                    (event.notes != null && event.notes!.isNotEmpty)
                        ? event.notes!
                        : 'Aucune note',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: (event.notes == null ||
                                  event.notes!.isEmpty)
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4)
                              : null,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sp32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.edit_outlined,
                        label: 'Modifier',
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => context.push(
                          '/home/agenda/add-event',
                          extra: {'event': event},
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sp12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.delete_outline,
                        label: 'Supprimer',
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () => _confirmDelete(context, ref),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final savedEvent = event;
    final notifier = ref.read(agendaNotifierProvider.notifier);

    notifier.deleteEvent(savedEvent.id!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Événement supprimé'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Annuler',
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
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: AppSpacing.sp8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category, required this.color});
  final EventCategory category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp12,
        vertical: AppSpacing.sp4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sp8),
          Text(
            _label(category).toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  letterSpacing: 0.6,
                ),
          ),
        ],
      ),
    );
  }

  static String _label(EventCategory cat) => switch (cat) {
        EventCategory.personal => 'Personnel',
        EventCategory.work => 'Travail',
        EventCategory.practice => 'Pratique',
      };
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.sp8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
