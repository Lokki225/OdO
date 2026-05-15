import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as timezone;

const _channelId = 'odo_channel';
const _channelName = 'OdO Notifications';

final class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    timezone.setLocalLocation(timezone.getLocation('Africa/Abidjan'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            importance: Importance.high,
          ),
        );
  }

  static Future<void> scheduleEventReminder({
    required int eventId,
    required DateTime eventStart,
    required String title,
  }) async {
    final scheduledTime = timezone.TZDateTime.from(
      eventStart.subtract(const Duration(minutes: 5)),
      timezone.local,
    );

    await _plugin.zonedSchedule(
      eventId,
      title,
      'Starting in 5 minutes',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(_channelId, _channelName),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelReminder(int eventId) async {
    await _plugin.cancel(eventId);
  }

  static Future<void> showEveningSessionNotification() async {
    await _plugin.show(
      0,
      'Your evening with OdO is ready',
      'Tap to begin your evening review',
      const NotificationDetails(
        android: AndroidNotificationDetails(_channelId, _channelName),
      ),
    );
  }
}
