
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final focusedDay = ref.watch(focusedDayProvider);
    final monthEventsAsync = ref.watch(monthEventsProvider(focusedDay));
    final accent = Theme.of(context).colorScheme.primary;

    final eventMap = switch (monthEventsAsync) {
      AsyncData(:final value) => value,
      _ => <DateTime, List<Event>>{},
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: TableCalendar<Event>(
        firstDay: DateTime.utc(DateTime.now().year - 3, 1, 1),
        lastDay: DateTime.utc(DateTime.now().year + 3, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        calendarFormat: CalendarFormat.month,
        eventLoader: (day) => eventMap[_stripTime(day)] ?? [],
        onDaySelected: (selected, focused) {
          final now = DateTime.now();
          ref.read(selectedDayProvider.notifier).setDay(
                DateTime(selected.year, selected.month, selected.day,
                    now.hour, now.minute),
              );
          ref.read(focusedDayProvider.notifier).setDay(focused);
          context.go('/home/agenda');
        },
        onPageChanged: (focused) {
          ref.read(focusedDayProvider.notifier).setDay(focused);
          ref.invalidate(monthEventsProvider(focused));
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: accent),
          selectedDecoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(color: Colors.white),
          outsideDaysVisible: false,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return null;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _buildMarkers(events.cast<Event>()),
              ),
            );
          },
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        rowHeight: 52,
        daysOfWeekHeight: AppSpacing.sp32,
      ),
    );
  }

  static List<Widget> _buildMarkers(List<Event> events) {
    final prioritized = _prioritizeEvents(events).take(3).toList();
    return prioritized
        .map(
          (e) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: _categoryColor(e.category),
              shape: BoxShape.circle,
            ),
          ),
        )
        .toList();
  }

  static List<Event> _prioritizeEvents(List<Event> events) {
    final work = events.where((e) => e.category == EventCategory.work).toList();
    final practice =
        events.where((e) => e.category == EventCategory.practice).toList();
    final personal =
        events.where((e) => e.category == EventCategory.personal).toList();
    return [...work, ...practice, ...personal];
  }

  static Color _categoryColor(EventCategory cat) => switch (cat) {
        EventCategory.personal => AppColors.colorCategoryPersonal,
        EventCategory.work => AppColors.colorCategoryWork,
        EventCategory.practice => AppColors.colorCategoryPractice,
      };

  static DateTime _stripTime(DateTime d) => DateTime(d.year, d.month, d.day);
}
