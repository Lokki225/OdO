import 'dart:async';

import 'package:flutter/material.dart';

import 'package:odo/core/constants/app_spacing.dart';

class CurrentTimeIndicator extends StatefulWidget {
  const CurrentTimeIndicator({
    super.key,
    required this.topOffset,
    required this.onOffsetChanged,
  });

  final double topOffset;
  final void Function(double offset) onOffsetChanged;

  @override
  State<CurrentTimeIndicator> createState() => _CurrentTimeIndicatorState();
}

class _CurrentTimeIndicatorState extends State<CurrentTimeIndicator> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      widget.onOffsetChanged(_offsetForNow());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static double _offsetForNow() {
    final now = DateTime.now();
    final minutesSince6am = now.hour * 60 + now.minute - 360;
    return minutesSince6am * (32.0 / 30.0);
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Positioned(
      top: widget.topOffset - 1,
      left: 48,
      right: 0,
      child: Row(
        children: [
          Container(
            width: AppSpacing.sp8,
            height: AppSpacing.sp8,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}
