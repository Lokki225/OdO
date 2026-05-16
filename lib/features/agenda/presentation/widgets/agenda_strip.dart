
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/services/locale_service.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';

class AgendaStrip extends ConsumerWidget {
  const AgendaStrip({super.key});

  static const double _height = 48.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stripAsync = ref.watch(agendaStripProvider);

    return GestureDetector(
      onTap: () => context.go('/home/agenda'),
      onLongPress: () => context.go('/home/agenda/calendar'),
      child: Container(
        height: _height,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp16),
        alignment: Alignment.centerLeft,
        child: stripAsync.when(
          data: (state) => _buildContent(context, state),
          loading: () => _buildLoading(context),
          error: (_, __) => _buildNothingScheduled(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AgendaStripState state) =>
      switch (state) {
        EventsToday(:final events) => _buildEventsToday(context, events),
        NextTomorrow(:final event) => _buildNextTomorrow(context, event),
        NothingScheduled() => _buildNothingScheduled(context),
      };

  Widget _buildEventsToday(BuildContext context, List<Event> events) {
    final locale = LocaleService();
    final parts = events.map((e) {
      final time = locale.formatTime(e.startTime.toLocal());
      final title = _truncate(e.title);
      return '$time $title';
    }).join(' · ');

    return Text(
      parts,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildNextTomorrow(BuildContext context, Event event) {
    final locale = LocaleService();
    final time = locale.formatTime(event.startTime.toLocal());
    final title = _truncate(event.title);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Tomorrow',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
        ),
        Text(
          ' · $time $title',
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildNothingScheduled(BuildContext context) {
    return Text(
      'Nothing scheduled — free day',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.5),
          ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      height: 16,
      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    );
  }

  static String _truncate(String title) =>
      title.length > 20 ? '${title.substring(0, 20)}…' : title;
}
