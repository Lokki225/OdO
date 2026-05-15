import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

const _kEveningCheckTask = 'odo.evening_check';
const _kDataShiftCheckTask = 'odo.data_shift_check';

// Must be top-level: workmanager invokes this from a background isolate.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case _kEveningCheckTask:
      // Evening check logic handled by NotificationService in the task body.
      case _kDataShiftCheckTask:
      // Data shift logic (stub — implemented in a later epic).
    }
    return Future.value(true);
  });
}

final class BackgroundTaskService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  static Future<void> scheduleEveningCheck() async {
    final now = DateTime.now();
    var next8pm = DateTime(now.year, now.month, now.day, 20);
    if (!next8pm.isAfter(now)) {
      next8pm = next8pm.add(const Duration(days: 1));
    }
    final initialDelay = next8pm.difference(now);

    await Workmanager().registerPeriodicTask(
      _kEveningCheckTask,
      _kEveningCheckTask,
      frequency: const Duration(days: 1),
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<void> scheduleDataShiftCheck() async {
    await Workmanager().registerOneOffTask(
      _kDataShiftCheckTask,
      _kDataShiftCheckTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }
}
