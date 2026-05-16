import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';
import 'package:odo/features/agenda/presentation/widgets/day_timeline.dart';

class AgendaPage extends ConsumerWidget {
  const AgendaPage({super.key});

  static const _frenchDaysFull = [
    'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche',
  ];
  static const _frenchDayAbbrevs = [
    'LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM', 'DIM',
  ];
  static const _frenchMonths = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
  ];

  static List<DateTime> _weekDays(DateTime day) {
    final monday = day.subtract(Duration(days: day.weekday - 1));
    final mondayDate = DateTime(monday.year, monday.month, monday.day);
    return List.generate(7, (i) => mondayDate.add(Duration(days: i)));
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final eventsAsync = ref.watch(dayEventsProvider);
    final monthEventsAsync = ref.watch(monthEventsProvider(selectedDay));

    final eventMap = switch (monthEventsAsync) {
      AsyncData(:final value) => value,
      _ => <DateTime, List<Event>>{},
    };

    final weekDays = _weekDays(selectedDay);
    final dayName = _frenchDaysFull[selectedDay.weekday - 1];
    final dateStr =
        '${selectedDay.day} ${_frenchMonths[selectedDay.month - 1]} ${selectedDay.year}';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sp16,
                vertical: AppSpacing.sp12,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        dateStr,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_month_outlined),
                    onPressed: () => context.go('/home/agenda/calendar'),
                  ),
                ],
              ),
            ),

            // 7-day strip
            _DayStrip(
              days: weekDays,
              selectedDay: selectedDay,
              eventMap: eventMap,
              abbrevs: _frenchDayAbbrevs,
              onDayTap: (day) =>
                  ref.read(selectedDayProvider.notifier).setDay(day),
              isSameDay: _isSameDay,
            ),

            const Divider(height: 1),

            // Timeline
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
                      'Impossible de charger les événements',
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _DayStrip extends StatelessWidget {
  const _DayStrip({
    required this.days,
    required this.selectedDay,
    required this.eventMap,
    required this.abbrevs,
    required this.onDayTap,
    required this.isSameDay,
  });

  final List<DateTime> days;
  final DateTime selectedDay;
  final Map<DateTime, List<Event>> eventMap;
  final List<String> abbrevs;
  final void Function(DateTime) onDayTap;
  final bool Function(DateTime, DateTime) isSameDay;

  static const _dotColors = {
    EventCategory.personal: AppColors.colorCategoryPersonal,
    EventCategory.work: AppColors.colorCategoryWork,
    EventCategory.practice: AppColors.colorCategoryPractice,
  };

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp8,
        vertical: AppSpacing.sp8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          final isSelected = isSameDay(day, selectedDay);
          final isToday = isSameDay(day, today);
          final highlight = isSelected || isToday;
          final key = DateTime(day.year, day.month, day.day);
          final dayEvents = eventMap[key] ?? [];
          final categories = dayEvents.map((e) => e.category).toSet().toList();

          return GestureDetector(
            onTap: () => onDayTap(day),
            child: SizedBox(
              width: 36,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    abbrevs[day.weekday - 1],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: highlight
                              ? accent
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.45),
                          letterSpacing: 0.4,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: highlight
                        ? BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          )
                        : null,
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: highlight ? Colors.white : null,
                            fontWeight:
                                highlight ? FontWeight.w600 : FontWeight.w400,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  SizedBox(
                    height: 6,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: categories.take(3).map((cat) {
                        return Container(
                          width: 4,
                          height: 4,
                          margin:
                              const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: _dotColors[cat],
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
