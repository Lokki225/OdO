import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:odo/app/app.dart';
import 'package:odo/core/services/background_task_service.dart';
import 'package:odo/core/services/notification_service.dart';
import 'package:odo/core/services/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await BackgroundTaskService.initialize();
  await NotificationService.initialize();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const OdoApp(),
    ),
  );
}
