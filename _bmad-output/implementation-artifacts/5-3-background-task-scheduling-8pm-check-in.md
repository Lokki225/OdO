# Story 5.3: Background Task Scheduling (8pm Check-in)

Status: ready-for-dev

## Story

As a developer,
I want to schedule a background task that runs daily at 8pm,
So that the proactive notification is delivered reliably.

## Acceptance Criteria

**Given** the workmanager package from dependencies
**When** I create `core/services/background_task_service.dart`
**Then** it registers a periodic task via workmanager to run at 8pm daily
**And** the task is platform-specific (Android: AlarmManager, iOS: background fetch)
**And** the task runs even if app is closed
**And** it handles platform-specific constraints (battery optimization, OS throttling)
**And** it logs task execution for debugging

## Tasks / Subtasks

- [ ] Task 1: Create BackgroundTaskService Foundation (AC: 1-2)
  - [ ] Implement workmanager initialization
  - [ ] Create 8pm daily scheduling logic
  - [ ] Handle platform-specific configurations
  - [ ] Add task registration methods

- [ ] Task 2: Implement Platform-Specific Handling (AC: 3)
  - [ ] Android: AlarmManager integration
  - [ ] iOS: background fetch setup
  - [ ] Handle battery optimization constraints
  - [ ] Manage OS throttling scenarios

- [ ] Task 3: Add Task Execution Logic (AC: 4)
  - [ ] Create background task handler
  - [ ] Integrate with SuggestionEngine (Story 5.2)
  - [ ] Handle task execution when app is closed
  - [ ] Ensure database access works in background

- [ ] Task 4: Implement Logging and Debug Support (AC: 5)
  - [ ] Add task execution logging
  - [ ] Create debug information capture
  - [ ] Log platform-specific constraints
  - [ ] Add failure tracking and diagnostics

## Dev Notes

### Critical Architecture Requirements

**From Architecture - Background Task Reliability:**
- workmanager on Android is subject to battery optimization killing tasks
- iOS background fetch is throttled by OS based on usage patterns
- Neither platform guarantees 8pm task execution
- Product decision: 8pm notification is best-effort, not guaranteed
- Fallback trigger exists when user opens app (Story 5.6)

**From PRD - NFR2:** Notification delivery reliability (8pm check-in within ±5 minutes)

**From main.dart Setup Requirements:**
- BackgroundTaskService.initialize() must happen before runApp
- Sequencing is critical or workmanager dispatcher isn't registered

### Project Structure Notes

**File Locations:**
```
lib/core/services/
├── background_task_service.dart     # Main service (this story)
├── notification_service.dart        # from dependencies
└── connectivity_service.dart        # from dependencies

android/app/src/main/AndroidManifest.xml  # Permissions
ios/Runner/AppDelegate.swift              # iOS background setup
```

**Integration Points:**
- main.dart initialization sequence
- SuggestionEngine (Story 5.2) for 8pm logic
- NotificationService (Story 5.5) for delivery
- Offline fallback trigger (Story 5.6)

### Technical Requirements

**Core Service Interface:**
```dart
class BackgroundTaskService {
  static const String _taskIdentifier = 'daily_8pm_check';
  
  /// Initialize workmanager and register tasks
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
    await _registerDailyTask();
  }
  
  /// Register daily 8pm task
  static Future<void> _registerDailyTask() async {
    await Workmanager().registerPeriodicTask(
      _taskIdentifier,
      _taskIdentifier,
      frequency: Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      constraints: Constraints(
        networkType: NetworkType.not_required, // Offline-first
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
      ),
    );
  }
  
  /// Calculate delay until next 8pm
  static Duration _calculateInitialDelay() {
    final now = DateTime.now();
    var next8pm = DateTime(now.year, now.month, now.day, 20, 0); // 8pm UTC+0
    
    if (now.isAfter(next8pm)) {
      next8pm = next8pm.add(Duration(days: 1));
    }
    
    return next8pm.difference(now);
  }
}
```

**Background Task Handler:**
```dart
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await _handleDailyCheckTask();
      return Future.value(true);
    } catch (e) {
      // Log error but don't crash
      debugPrint('Background task failed: $e');
      return Future.value(false);
    }
  });
}

Future<void> _handleDailyCheckTask() async {
  // Initialize minimal services for background context
  await _initializeBackgroundServices();
  
  // Generate suggestion using SuggestionEngine
  final suggestionEngine = GetIt.instance<SuggestionEngine>();
  final suggestion = await suggestionEngine.generateSuggestion();
  
  if (suggestion != null) {
    // Trigger notification via NotificationService
    final notificationService = GetIt.instance<NotificationService>();
    await notificationService.showProactiveSuggestion(suggestion);
  }
  
  // Log execution for debugging
  await _logTaskExecution(suggestion != null);
}
```

**Platform-Specific Configurations:**

**Android Permissions (AndroidManifest.xml):**
```xml
<!-- Background task permissions -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>

<!-- Inside <application> -->
<receiver
    android:name="androidx.work.impl.background.systemalarm.RescheduleReceiver"
    android:exported="false" />
```

**iOS Background Setup (AppDelegate.swift):**
```swift
import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Register for background processing
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "daily_8pm_check")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Platform Constraint Handling

**Android Battery Optimization:**
```dart
class BatteryOptimizationHelper {
  /// Check if battery optimization is enabled
  static Future<bool> isBatteryOptimizationEnabled() async {
    // Use battery_plus or platform channels
    // Return true if optimization might kill background tasks
  }
  
  /// Guide user to disable battery optimization (optional)
  static Future<void> showBatteryOptimizationDialog() async {
    // Show dialog explaining background task reliability
    // Optional: deep-link to battery optimization settings
  }
}
```

**iOS Background App Refresh:**
```dart
class BackgroundAppRefreshHelper {
  /// Check if background app refresh is enabled
  static Future<bool> isBackgroundAppRefreshEnabled() async {
    // Use platform channels to check iOS setting
  }
  
  /// Guide user to enable background app refresh (optional)  
  static Future<void> showBackgroundRefreshDialog() async {
    // Explain why background tasks need this setting
  }
}
```

### Reliability and Fallback Strategy

**Task Execution Tracking:**
```dart
class TaskExecutionLogger {
  static const String _lastExecutionKey = 'last_background_task_execution';
  
  /// Record successful task execution
  static Future<void> recordExecution() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastExecutionKey, DateTime.now().toIso8601String());
  }
  
  /// Get time of last successful execution
  static Future<DateTime?> getLastExecution() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastExecutionKey);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }
  
  /// Check if task execution is overdue (used by fallback trigger)
  static Future<bool> isExecutionOverdue({Duration threshold = const Duration(hours: 18)}) async {
    final lastExecution = await getLastExecution();
    if (lastExecution == null) return true; // Never executed
    
    return DateTime.now().difference(lastExecution) > threshold;
  }
}
```

**Fallback Integration Point:**
- Story 5.6 (Offline Fallback Trigger) uses `TaskExecutionLogger.isExecutionOverdue()`
- If no execution in 18 hours, fallback runs suggestion on app open
- This covers background task failure without user awareness

### Error Handling Requirements

**Background Task Failure Modes:**
1. **Task killed by OS** - Fallback trigger handles (Story 5.6)
2. **Database unavailable** - Skip gracefully, try tomorrow
3. **SuggestionEngine fails** - Log error, no notification sent
4. **Notification service fails** - Log error, try again tomorrow
5. **Network unavailable** - Offline-first, should work anyway

**Error Handling Pattern:**
```dart
Future<bool> _handleDailyCheckTask() async {
  try {
    // Task logic here
    await TaskExecutionLogger.recordExecution();
    return true;
  } catch (e) {
    // Log for debugging but don't crash background process
    await _logTaskFailure(e);
    return false; // Indicates task failure to workmanager
  }
}
```

### Testing Requirements

**Unit Tests:**
- Initial delay calculation (8pm targeting)
- Task registration and unregistration
- Execution logging and retrieval
- Platform constraint detection

**Integration Tests:**
- Background task actually executes
- SuggestionEngine integration works in background
- NotificationService integration works
- Task survives app restart

**Platform Testing:**
- Android: Test with battery optimization enabled/disabled
- iOS: Test with background app refresh enabled/disabled
- Test task execution reliability over multiple days
- Verify fallback trigger activates when tasks fail

### Performance and Resource Requirements

**Memory Usage:**
- Background task should use minimal memory
- Initialize only essential services
- Avoid loading heavy UI components

**Execution Time:**
- Target < 10 seconds for background execution
- iOS gives limited background time
- Suggestion generation must be fast (< 2 seconds)

**Power Usage:**
- Minimize CPU usage in background
- Use efficient database queries
- Avoid unnecessary network calls (offline-first)

### References

**Source Documents:**
- [Epics: Epic 5, Story 5.3] - Core requirements and acceptance criteria
- [Architecture: Background Task Reliability] - Platform constraints and fallback strategy
- [Architecture: main.dart Setup] - Initialization sequence requirements
- [PRD: NFR2] - Notification delivery reliability requirements

**Dependencies:**
- Story 5.2: SuggestionEngine (consumed by background task)
- Story 5.5: NotificationService (triggered by background task)
- Story 5.6: Offline Fallback Trigger (fallback when this fails)
- Epic 1: Database and service setup

**External Dependencies:**
- workmanager package for cross-platform background tasks
- SharedPreferences for execution tracking
- Platform-specific permissions and setup

## Dev Agent Record

### Agent Model Used

TBD - Will be filled during implementation

### Debug Log References  

TBD - Will be filled during implementation

### Completion Notes List

- [ ] Verify workmanager initialization sequence in main.dart
- [ ] Test 8pm targeting works correctly across timezones (UTC+0)
- [ ] Confirm background task executes when app is closed
- [ ] Test platform-specific constraint handling
- [ ] Verify integration with SuggestionEngine and NotificationService
- [ ] Test fallback detection logic for Story 5.6
- [ ] Validate task execution logging and retrieval

### File List

TBD - Will be filled during implementation
