# Story 5.5: Proactive Notification Delivery

Status: ready-for-dev

## Story

As a developer,
I want to send the proactive notification at 8pm with the suggestion text,
So that the user receives the suggestion at the right moment.

## Acceptance Criteria

**Given** the background task from Story 5.3 and SuggestionEngine from Story 5.2
**When** the 8pm task runs
**Then** it calls SuggestionEngine to generate a suggestion
**And** it constructs notification text: "You have 45 free minutes Thursday. Japanese is idle. Block it?"
**And** it sends the notification via flutter_local_notifications
**And** the notification is tagged so only one notification per day is shown (UX-DR19)
**And** tapping the notification opens the confirmation sheet directly
**And** the notification is best-effort (not guaranteed, but fallback exists)

## Tasks / Subtasks

- [ ] Task 1: Create NotificationService Foundation (AC: 1-3)
  - [ ] Implement flutter_local_notifications setup
  - [ ] Create notification channel configuration
  - [ ] Add suggestion text construction logic
  - [ ] Integrate with SuggestionEngine

- [ ] Task 2: Implement Notification Text Generation (AC: 4)
  - [ ] Create natural language suggestion formatting
  - [ ] Handle skill names and time slots
  - [ ] Format duration and timing information
  - [ ] Ensure text is concise and actionable

- [ ] Task 3: Add Daily Notification Management (AC: 5)
  - [ ] Implement one notification per day tagging
  - [ ] Cancel previous notifications when new one sent
  - [ ] Handle notification ID management
  - [ ] Prevent notification spam

- [ ] Task 4: Configure Deep Link Navigation (AC: 6)
  - [ ] Set up notification tap handling
  - [ ] Direct navigation to confirmation sheet
  - [ ] Pass suggestion data to sheet
  - [ ] Handle app launch from notification

- [ ] Task 5: Implement Best-Effort Reliability (AC: 7)
  - [ ] Handle notification service failures gracefully
  - [ ] Log notification delivery attempts
  - [ ] Integrate with fallback trigger system
  - [ ] Don't crash on notification errors

## Dev Notes

### Critical Architecture Requirements

**From UX Design - One AI Voice Per Day (UX-DR19):**
- Maximum one proactive notification per 24 hours
- The AI never initiates inside chat - only 8pm notification speaks first
- This distinction keeps AI from feeling like a bot
- Preserves notification signal value

**From Architecture - Background Task Reliability:**
- 8pm notification is best-effort, not guaranteed
- Fallback trigger exists when background task fails (Story 5.6)
- UI never implies notification will definitely arrive

**From PRD - NFR2:** Notification delivery reliability (8pm check-in within ±5 minutes)

### Project Structure Notes

**File Locations:**
```
lib/core/services/
├── notification_service.dart        # Main service (this story)
└── background_task_service.dart     # from Story 5.3

lib/features/ai/presentation/
└── widgets/confirmation_sheet.dart  # from Story 5.4
```

**Integration Points:**
- Called by BackgroundTaskService (Story 5.3)
- Receives suggestions from SuggestionEngine (Story 5.2)
- Opens ConfirmationSheet (Story 5.4) on tap
- Fallback integration with Story 5.6

### Technical Requirements

**NotificationService Interface:**
```dart
class NotificationService {
  static const String _channelId = 'proactive_suggestions';
  static const String _channelName = 'Practice Suggestions';
  static const String _dailyNotificationId = 'daily_8pm';
  
  /// Initialize notification service and channels
  static Future<void> initialize() async {
    final plugin = FlutterLocalNotificationsPlugin();
    
    await plugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: false,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
    
    await _createNotificationChannel(plugin);
  }
  
  /// Show proactive suggestion notification
  static Future<void> showProactiveSuggestion(Suggestion suggestion) async {
    final plugin = FlutterLocalNotificationsPlugin();
    
    // Cancel any existing daily notification first
    await plugin.cancel(_getDailyNotificationId());
    
    final notificationText = _constructSuggestionText(suggestion);
    
    await plugin.show(
      _getDailyNotificationId(),
      'TooXTips', // App name as title
      notificationText,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Proactive practice suggestions',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          enableVibration: true,
          tag: _dailyNotificationId, // Only one per day
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentSound: true,
        ),
      ),
      payload: suggestion.id.toString(),
    );
    
    // Log notification delivery for debugging
    await _logNotificationDelivery(suggestion);
  }
}
```

**Suggestion Text Construction:**
```dart
String _constructSuggestionText(Suggestion suggestion) {
  // Get readable time format
  final timeFormatter = DateFormat('EEEE'); // Thursday
  final dayName = timeFormatter.format(suggestion.slotStart);
  
  final hourFormatter = DateFormat('h:mm a'); // 9:00 AM
  final timeString = hourFormatter.format(suggestion.slotStart);
  
  final durationMinutes = suggestion.slotDuration;
  final durationText = durationMinutes >= 60 
    ? '${(durationMinutes / 60).floor()} hour${durationMinutes >= 120 ? 's' : ''}'
    : '$durationMinutes minutes';
  
  final skillName = suggestion.skill.name;
  
  // Construct natural language text
  // "You have 45 minutes free Thursday morning. Japanese is idle. Block it?"
  return 'You have $durationText free $dayName. $skillName is idle. Block it?';
}
```

**Notification Channel Setup:**
```dart
Future<void> _createNotificationChannel(FlutterLocalNotificationsPlugin plugin) async {
  const androidChannel = AndroidNotificationChannel(
    _channelId,
    _channelName,
    description: 'Proactive practice suggestions based on your schedule and idle skills',
    importance: Importance.defaultImportance,
    enableVibration: true,
    playSound: true,
  );
  
  final androidPlugin = plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  
  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(androidChannel);
  }
}
```

**Deep Link Navigation:**
```dart
static void _handleNotificationTap(NotificationResponse response) {
  final payload = response.payload;
  if (payload != null) {
    final suggestionId = int.tryParse(payload);
    if (suggestionId != null) {
      // Navigate to confirmation sheet
      _navigateToConfirmationSheet(suggestionId);
    }
  }
}

static void _navigateToConfirmationSheet(int suggestionId) {
  // Use go_router for navigation
  final context = navigatorKey.currentContext;
  if (context != null) {
    context.go('/confirmation-sheet/$suggestionId');
  }
}
```

### Daily Notification Management

**One Notification Per Day Logic:**
```dart
class DailyNotificationManager {
  static const String _lastNotificationDateKey = 'last_notification_date';
  
  /// Check if notification already sent today
  static Future<bool> wasNotificationSentToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateString = prefs.getString(_lastNotificationDateKey);
    
    if (lastDateString == null) return false;
    
    final lastDate = DateTime.parse(lastDateString);
    final today = DateTime.now();
    
    return DateUtils.isSameDay(lastDate, today);
  }
  
  /// Mark notification as sent today
  static Future<void> markNotificationSent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastNotificationDateKey, 
      DateTime.now().toIso8601String(),
    );
  }
  
  /// Get unique notification ID for today
  static int _getDailyNotificationId() {
    final today = DateTime.now();
    return today.year * 10000 + today.month * 100 + today.day;
  }
}
```

**Background Task Integration:**
```dart
// In BackgroundTaskService._handleDailyCheckTask()
Future<void> _handleDailyCheckTask() async {
  // Check if notification already sent today
  if (await DailyNotificationManager.wasNotificationSentToday()) {
    return; // Skip - already sent today
  }
  
  // Generate suggestion
  final suggestionEngine = GetIt.instance<SuggestionEngine>();
  final suggestion = await suggestionEngine.generateSuggestion();
  
  if (suggestion != null) {
    // Send notification
    await NotificationService.showProactiveSuggestion(suggestion);
    
    // Mark as sent
    await DailyNotificationManager.markNotificationSent();
  }
}
```

### Platform-Specific Configuration

**Android Notification Permissions:**
```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>

<!-- Inside <application> -->
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <category android:name="android.intent.category.DEFAULT" />
    </intent-filter>
</receiver>
```

**iOS Notification Setup:**
```swift
// AppDelegate.swift
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Request notification permissions
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
      if granted {
        print("Notification permission granted")
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Error Handling and Reliability

**Notification Failure Scenarios:**
1. **Permissions denied** - Graceful degradation, log warning
2. **Notification service unavailable** - Skip silently, fallback will trigger
3. **Invalid suggestion data** - Log error, don't send notification
4. **App killed** - OS handles notification delivery
5. **Deep link fails** - App opens normally, user can access manually

**Error Handling Implementation:**
```dart
Future<bool> showProactiveSuggestion(Suggestion suggestion) async {
  try {
    await _showNotificationInternal(suggestion);
    await _logNotificationSuccess(suggestion);
    return true;
  } on NotificationPermissionDeniedException {
    await _logNotificationSkipped('Permissions denied');
    return false; // Graceful degradation
  } catch (e) {
    await _logNotificationError(e);
    return false; // Don't crash background task
  }
}
```

**Logging for Debugging:**
```dart
class NotificationLogger {
  static Future<void> logDeliveryAttempt(Suggestion suggestion) async {
    debugPrint('Notification delivery attempted: ${suggestion.id} at ${DateTime.now()}');
  }
  
  static Future<void> logDeliverySuccess(Suggestion suggestion) async {
    debugPrint('Notification delivered successfully: ${suggestion.id}');
  }
  
  static Future<void> logDeliveryFailure(String reason) async {
    debugPrint('Notification delivery failed: $reason');
  }
}
```

### Integration with Fallback System

**Fallback Detection Support:**
```dart
class NotificationDeliveryTracker {
  static const String _lastDeliveryKey = 'last_notification_delivery';
  
  /// Record successful notification delivery
  static Future<void> recordDelivery() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDeliveryKey, DateTime.now().toIso8601String());
  }
  
  /// Check if notification delivery is overdue (used by fallback)
  static Future<bool> isDeliveryOverdue({Duration threshold = const Duration(hours: 18)}) async {
    final prefs = await SharedPreferences.getInstance();
    final lastDeliveryString = prefs.getString(_lastDeliveryKey);
    
    if (lastDeliveryString == null) return true; // Never delivered
    
    final lastDelivery = DateTime.parse(lastDeliveryString);
    return DateTime.now().difference(lastDelivery) > threshold;
  }
}
```

### Testing Requirements

**Unit Tests:**
- Suggestion text construction with various inputs
- Daily notification ID generation
- Notification channel setup
- Error handling scenarios

**Integration Tests:**
- End-to-end background task → notification flow
- Notification tap → confirmation sheet navigation
- One notification per day enforcement
- Platform-specific permission handling

**Manual Testing Scenarios:**
- Notification appears at correct time (8pm)
- Tapping opens confirmation sheet directly
- Only one notification per day sent
- Notification works when app is closed
- Deep link navigation works correctly

### Performance Requirements

**Notification Delivery:**
- Should appear within ±5 minutes of 8pm (NFR2)
- Text construction must be fast (< 50ms)
- Don't block background task on notification failures
- Minimize memory usage in background context

**Battery Usage:**
- Use system notification service (no custom polling)
- Minimal CPU usage for text construction
- Leverage OS-native notification delivery

### References

**Source Documents:**
- [Epics: Epic 5, Story 5.5] - Core requirements and acceptance criteria
- [UX Design: One AI Voice Per Day] - Single daily notification principle
- [Architecture: Background Task Reliability] - Best-effort delivery approach
- [PRD: NFR2] - Notification delivery timing requirements

**Dependencies:**
- Story 5.2: SuggestionEngine (provides suggestion data)
- Story 5.3: BackgroundTaskService (calls this service)
- Story 5.4: ConfirmationSheet (opened by notification tap)
- Story 5.6: Offline Fallback (triggered when this fails)

**External Dependencies:**
- flutter_local_notifications plugin
- Platform-specific notification permissions
- SharedPreferences for delivery tracking

## Dev Agent Record

### Agent Model Used

TBD - Will be filled during implementation

### Debug Log References

TBD - Will be filled during implementation

### Completion Notes List

- [ ] Verify notification appears at 8pm with correct text format
- [ ] Test one notification per day enforcement
- [ ] Confirm tapping opens confirmation sheet directly
- [ ] Test notification delivery when app is closed
- [ ] Verify platform-specific permissions work
- [ ] Test error handling for notification failures
- [ ] Confirm integration with fallback trigger system
- [ ] Validate deep link navigation works correctly

### File List

TBD - Will be filled during implementation
