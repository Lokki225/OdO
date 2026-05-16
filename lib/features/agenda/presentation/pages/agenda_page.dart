import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/services/locale_service.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';
import 'package:odo/features/agenda/presentation/widgets/day_timeline.dart';

class AgendaPage extends ConsumerWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final eventsAsync = ref.watch(dayEventsProvider);
    final locale = LocaleService();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _DayHeader(selectedDay: selectedDay, locale: locale),
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity == null) return;
                  if (details.primaryVelocity! < -200) {
                    ref.read(selectedDayProvider.notifier).setDay(
                          selectedDay.add(const Duration(days: 1)),
                        );
                  } else if (details.primaryVelocity! > 200) {
                    ref.read(selectedDayProvider.notifier).setDay(
                          selectedDay.subtract(const Duration(days: 1)),
                        );
                  }
                },
                child: eventsAsync.when(
                  data: (events) => DayTimeline(events: events),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Text(
                      'Could not load events',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/home/agenda/add-event'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.selectedDay, required this.locale});

  final DateTime selectedDay;
  final LocaleService locale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp16,
        vertical: AppSpacing.sp12,
      ),
      child: Row(
        children: [
          Text(
            locale.formatDate(selectedDay),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => context.go('/home/agenda/calendar'),
          ),
        ],
      ),
    );
  }
}
