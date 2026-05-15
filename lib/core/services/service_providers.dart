import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'background_task_service.dart';
import 'connectivity_service.dart';
import 'locale_service.dart';
import 'notification_service.dart';
import 'voice_service.dart';

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final backgroundTaskServiceProvider = Provider<BackgroundTaskService>(
  (ref) => BackgroundTaskService(),
);

final voiceServiceProvider = Provider<VoiceService>((ref) {
  final service = VoiceService();
  ref.onDispose(service.dispose);
  return service;
});

final localeServiceProvider = Provider<LocaleService>(
  (ref) => LocaleService(),
);
