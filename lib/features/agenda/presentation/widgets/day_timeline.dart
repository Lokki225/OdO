import 'package:flutter/material.dart';

import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/widgets/current_time_indicator.dart';
import 'package:odo/features/agenda/presentation/widgets/event_block.dart';
import 'package:odo/features/agenda/presentation/widgets/free_slot_block.dart';

class DayTimeline extends StatefulWidget {
  const DayTimeline({super.key, required this.events});

  final List<Event> events;

  static const int _startHour = 6;
  static const int _endHour = 23;
  static const int _totalSlots = (_endHour - _startHour) * 2; // 34 slots
  static const double _slotHeight = AppSpacing.sp32; // 32dp per 30 min
  static const double _pixelsPerMinute = _slotHeight / 30.0;
  static const double _timeColumnWidth = 48.0;
  static const double _totalHeight = _totalSlots * _slotHeight;

  @override
  State<DayTimeline> createState() => _DayTimelineState();
}

class _DayTimelineState extends State<DayTimeline> {
  late ScrollController _scrollController;
  late double _nowOffset;

  @override
  void initState() {
    super.initState();
    _nowOffset = _offsetForTime(DateTime.now());
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNow() {
    if (!_scrollController.hasClients) return;
    final screenHeight = MediaQuery.of(context).size.height;
    final target = (_nowOffset - screenHeight / 3).clamp(0.0, double.infinity);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  static double _offsetForTime(DateTime dt) {
    final now = dt;
    final hour = now.hour.clamp(DayTimeline._startHour, DayTimeline._endHour);
    final minutesSince6am =
        (hour * 60 + now.minute) - DayTimeline._startHour * 60;
    return minutesSince6am * DayTimeline._pixelsPerMinute;
  }

  List<_FreeSlot> _computeFreeSlots(List<Event> sorted) {
    final slots = <_FreeSlot>[];
    final startOfDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DayTimeline._startHour,
    );
    final endOfDay = startOfDay.copyWith(hour: DayTimeline._endHour);

    final boundaries = <DateTime>[startOfDay];
    for (final e in sorted) {
      boundaries.add(e.startTime.toLocal());
      boundaries.add(e.endTime.toLocal());
    }
    boundaries.add(endOfDay);

    for (var i = 0; i < boundaries.length - 1; i += 2) {
      final gapStart = boundaries[i];
      final gapEnd = boundaries[i + 1];
      final gapMinutes = gapEnd.difference(gapStart).inMinutes;
      if (gapMinutes >= 30) {
        slots.add(_FreeSlot(start: gapStart, durationMinutes: gapMinutes));
      }
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.events]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final freeSlots = _computeFreeSlots(sorted);
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: DayTimeline._totalHeight,
        child: Stack(
          children: [
            // Grid lines and time labels
            ..._buildGrid(context, colorScheme),

            // Free slot blocks
            for (final slot in freeSlots)
              FreeSlotBlock(
                topOffset: _offsetForTime(slot.start),
                height: slot.durationMinutes * DayTimeline._pixelsPerMinute,
                startTime: slot.start,
              ),

            // Event blocks
            for (final event in sorted)
              EventBlock(
                event: event,
                topOffset: _offsetForTime(event.startTime.toLocal()),
                height: event.endTime
                        .difference(event.startTime)
                        .inMinutes *
                    DayTimeline._pixelsPerMinute,
              ),

            // Current time indicator
            CurrentTimeIndicator(
              topOffset: _nowOffset,
              onOffsetChanged: (offset) {
                if (mounted) setState(() => _nowOffset = offset);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGrid(BuildContext context, ColorScheme colorScheme) {
    final widgets = <Widget>[];
    for (var i = 0; i < DayTimeline._totalSlots; i++) {
      final totalMinutes = DayTimeline._startHour * 60 + i * 30;
      final hour = totalMinutes ~/ 60;
      final minute = totalMinutes % 60;
      final isHour = minute == 0;

      widgets.add(
        Positioned(
          top: i * DayTimeline._slotHeight,
          left: 0,
          right: 0,
          child: SizedBox(
            height: DayTimeline._slotHeight,
            child: Row(
              children: [
                SizedBox(
                  width: DayTimeline._timeColumnWidth,
                  child: isHour
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: AppSpacing.sp8, top: AppSpacing.sp2),
                          child: Text(
                            '${hour.toString().padLeft(2, '0')}:00',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.5)),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isHour
                              ? colorScheme.outline.withValues(alpha: 0.4)
                              : colorScheme.outline.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

class _FreeSlot {
  const _FreeSlot({required this.start, required this.durationMinutes});
  final DateTime start;
  final int durationMinutes;
}
