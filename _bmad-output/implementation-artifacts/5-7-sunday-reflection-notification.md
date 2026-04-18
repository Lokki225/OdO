# Story 5.7: Sunday Reflection Notification

Status: ready-for-dev

## Story

As a user,
I want to receive a weekly reflection on Sunday at 8pm,
So that I can see my practice progress without extra effort.

## Acceptance Criteria

**Given** the background task from Story 5.3
**When** Sunday 8pm arrives
**Then** the background task detects it's Sunday
**And** it generates a reflection line from session data: "This week: 4 Japanese sessions, 2 Chess. Best week yet for Japanese."
**And** it sends a notification with this text (no "Block it" action, no confirmation sheet) (UX-DR28)
**And** tapping the notification opens the app (no special handling)
**And** the reflection is computed locally (no API call)

## Tasks / Subtasks

- [ ] Task 1: Create Sunday Detection Logic (AC: 1-2)
  - [ ] Implement Sunday 8pm detection in background task
  - [ ] Modify background task to handle two different notification types
  - [ ] Add day-of-week checking logic
  - [ ] Handle timezone considerations (UTC+0)

- [ ] Task 2: Implement Reflection Generation (AC: 3-5)
  - [ ] Create ReflectionGenerator service
  - [ ] Analyze session data from past week
  - [ ] Generate natural language reflection text
  - [ ] Handle various session count scenarios
  - [ ] Compute locally without API calls

- [ ] Task 3: Create Sunday Notification (AC: 4-5)
  - [ ] Send reflection notification (different from proactive)
  - [ ] No "Block it" action - just reflection text
  - [ ] No confirmation sheet on tap
  - [ ] Simple app opening behavior
  - [ ] Different notification ID from daily suggestions

- [ ] Task 4: Integrate with Background Task Service (AC: 1)
  - [ ] Update BackgroundTaskService to detect Sunday
  - [ ] Route to reflection logic vs suggestion logic
  - [ ] Maintain existing daily suggestion functionality
  - [ ] Handle both notification types appropriately

## Dev Notes

### Critical UX Requirements

**From UX Design - Sunday Reflection (UX-DR28):**
- Sunday 8pm notification is qualitatively different from weekday notifications
- Reflection line only, no "Block it" action, no confirmation sheet
- Computed locally from session data - no API call required
- Tapping opens app normally, no special handling

**From Epics - FR22:**
- Weekly Sunday reflection notification
- Locally-computed sentence from streak data and session counts
- No API call required

### Project Structure Notes

**File Locations:**
```
lib/core/services/
├── background_task_service.dart     # Update for Sunday detection
├── reflection_generator.dart        # New service (this story)
└── notification_service.dart        # Update for reflection notifications

lib/features/practice/domain/
└── weekly_stats_calculator.dart     # Weekly session analysis
```

**Integration Points:**
- BackgroundTaskService (Story 5.3) - add Sunday detection
- NotificationService (Story 5.5) - add reflection notification type
- PracticeRepository (Epic 3) - session data access
- No confirmation sheet or special navigation

### Technical Requirements

**Sunday Detection in Background Task:**
```dart
class BackgroundTaskService {
  static Future<void> _handleDailyCheckTask() async {
    final now = DateTime.now();
    
    // Check if it's Sunday
    if (now.weekday == DateTime.sunday) {
      await _handleSundayReflection();
    } else {
      await _handleDailyProactiveSuggestion();
    }
  }
  
  static Future<void> _handleSundayReflection() async {
    try {
      // Generate reflection from local data
      final reflectionGenerator = GetIt.instance<ReflectionGenerator>();
      final reflectionText = await reflectionGenerator.generateWeeklyReflection();
      
      if (reflectionText.isNotEmpty) {
        // Send reflection notification
        await NotificationService.showWeeklyReflection(reflectionText);
      }
      
      // Log execution for debugging
      await TaskExecutionLogger.recordExecution();
    } catch (e) {
      debugPrint('Sunday reflection failed: $e');
    }
  }
  
  static Future<void> _handleDailyProactiveSuggestion() async {
    // Existing daily suggestion logic from Story 5.3
    // Check if notification already sent today
    if (await DailyNotificationManager.wasNotificationSentToday()) {
      return;
    }
    
    // Generate and send suggestion...
    // (existing logic)
  }
}
```

**Reflection Generator Service:**
```dart
class ReflectionGenerator {
  final PracticeRepository practiceRepo;
  
  ReflectionGenerator(this.practiceRepo);
  
  /// Generate weekly reflection from session data
  Future<String> generateWeeklyReflection() async {
    final weekStart = _getWeekStart(DateTime.now());
    final weekEnd = weekStart.add(Duration(days: 7));
    
    // Get all sessions from this week
    final sessions = await practiceRepo.getSessionsInRange(weekStart, weekEnd);
    
    if (sessions.isEmpty) {
      return "No practice sessions this week. Fresh start next week!";
    }
    
    // Analyze sessions by skill
    final sessionsBySkill = _groupSessionsBySkill(sessions);
    
    // Generate reflection text
    return _constructReflectionText(sessionsBySkill);
  }
  
  /// Get start of current week (Monday)
  DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }
  
  /// Group sessions by skill name
  Map<String, List<PracticeSession>> _groupSessionsBySkill(List<PracticeSession> sessions) {
    final grouped = <String, List<PracticeSession>>{};
    
    for (final session in sessions) {
      final skillName = session.skill.name;
      grouped[skillName] = (grouped[skillName] ?? [])..add(session);
    }
    
    return grouped;
  }
  
  /// Construct natural language reflection
  String _constructReflectionText(Map<String, List<PracticeSession>> sessionsBySkill) {
    if (sessionsBySkill.isEmpty) {
      return "Quiet week for practice. Tomorrow is a new day!";
    }
    
    // Sort skills by session count (most active first)
    final sortedSkills = sessionsBySkill.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
    
    // Build reflection parts
    final parts = <String>[];
    
    // Week summary
    final totalSessions = sessionsBySkill.values.fold<int>(
      0, (sum, sessions) => sum + sessions.length);
    parts.add("This week: $totalSessions session${totalSessions == 1 ? '' : 's'}");
    
    // Top skills (max 3)
    final topSkills = sortedSkills.take(3);
    for (final entry in topSkills) {
      final skillName = entry.key;
      final sessionCount = entry.value.length;
      parts.add("$skillName $sessionCount");
    }
    
    // Achievement detection
    final achievement = _detectAchievement(sessionsBySkill, sortedSkills);
    if (achievement.isNotEmpty) {
      parts.add(achievement);
    }
    
    return parts.join(" · ");
  }
  
  /// Detect weekly achievements
  String _detectAchievement(
    Map<String, List<PracticeSession>> sessionsBySkill,
    List<MapEntry<String, List<PracticeSession>>> sortedSkills,
  ) {
    if (sortedSkills.isEmpty) return "";
    
    final topSkill = sortedSkills.first;
    final topSkillName = topSkill.key;
    final sessionCount = topSkill.value.length;
    
    // Simple achievement patterns
    if (sessionCount >= 5) {
      return "Strong week for $topSkillName";
    } else if (sessionCount >= 3) {
      return "Good consistency with $topSkillName";
    } else if (sessionsBySkill.length >= 3) {
      return "Nice variety this week";
    }
    
    return "Every session counts";
  }
}
```

**Weekly Reflection Notification:**
```dart
class NotificationService {
  static const int _weeklyReflectionId = 9999; // Different from daily notifications
  
  /// Show weekly reflection notification
  static Future<void> showWeeklyReflection(String reflectionText) async {
    final plugin = FlutterLocalNotificationsPlugin();
    
    await plugin.show(
      _weeklyReflectionId,
      'Weekly Reflection', // Different title
      reflectionText,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Weekly practice reflection',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          enableVibration: true,
          // No special action - just opens app
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentSound: true,
        ),
      ),
      // No payload - just opens app normally
    );
    
    // Log reflection delivery
    await _logReflectionDelivery(reflectionText);
  }
  
  static Future<void> _logReflectionDelivery(String reflectionText) async {
    debugPrint('Weekly reflection delivered: $reflectionText');
  }
}
```

**Weekly Stats Calculator:**
```dart
class WeeklyStatsCalculator {
  /// Calculate session statistics for the past week
  static Future<WeeklyStats> calculateWeeklyStats(
    PracticeRepository practiceRepo,
  ) async {
    final now = DateTime.now();
    final weekStart = _getWeekStart(now);
    final weekEnd = weekStart.add(Duration(days: 7));
    
    final sessions = await practiceRepo.getSessionsInRange(weekStart, weekEnd);
    
    return WeeklyStats(
      totalSessions: sessions.length,
      sessionsBySkill: _groupBySkill(sessions),
      totalMinutes: _calculateTotalMinutes(sessions),
      daysWithSessions: _calculateActiveDays(sessions),
    );
  }
  
  static DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }
  
  static Map<String, int> _groupBySkill(List<PracticeSession> sessions) {
    final skillCounts = <String, int>{};
    for (final session in sessions) {
      skillCounts[session.skill.name] = (skillCounts[session.skill.name] ?? 0) + 1;
    }
    return skillCounts;
  }
  
  static int _calculateTotalMinutes(List<PracticeSession> sessions) {
    return sessions.fold<int>(0, (sum, session) => sum + session.durationMinutes);
  }
  
  static int _calculateActiveDays(List<PracticeSession> sessions) {
    final days = <int>{};
    for (final session in sessions) {
      days.add(session.startedAt.day);
    }
    return days.length;
  }
}

class WeeklyStats {
  final int totalSessions;
  final Map<String, int> sessionsBySkill;
  final int totalMinutes;
  final int daysWithSessions;
  
  const WeeklyStats({
    required this.totalSessions,
    required this.sessionsBySkill,
    required this.totalMinutes,
    required this.daysWithSessions,
  });
}
```

### Reflection Text Examples

**Various Scenarios:**
```dart
// High activity week
"This week: 7 sessions · Japanese 4 · Chess 2 · Guitar 1 · Strong week for Japanese"

// Moderate activity
"This week: 3 sessions · Japanese 2 · Chess 1 · Good consistency with Japanese"

// Low activity
"This week: 1 session · Japanese 1 · Every session counts"

// No activity
"No practice sessions this week. Fresh start next week!"

// Variety focus
"This week: 4 sessions · Japanese 2 · Chess 1 · Piano 1 · Nice variety this week"
```

### Error Handling Requirements

**Reflection Generation Failures:**
1. **No sessions data** - Return encouraging message
2. **Database unavailable** - Skip gracefully, don't crash background task
3. **Session data corrupted** - Generate generic reflection
4. **Reflection text empty** - Don't send notification

**Error Handling Implementation:**
```dart
Future<String> generateWeeklyReflection() async {
  try {
    final sessions = await practiceRepo.getSessionsInRange(weekStart, weekEnd);
    return _constructReflectionText(_groupSessionsBySkill(sessions));
  } on DatabaseException {
    return "Week complete. Keep up the great work!"; // Generic fallback
  } catch (e) {
    debugPrint('Reflection generation failed: $e');
    return ""; // Empty string = no notification sent
  }
}
```

### Integration with Existing Systems

**Background Task Coordination:**
```dart
// Ensure Sunday reflection doesn't conflict with daily suggestions
static Future<void> _handleDailyCheckTask() async {
  final now = DateTime.now();
  
  if (now.weekday == DateTime.sunday) {
    // Sunday: send reflection only
    await _handleSundayReflection();
  } else {
    // Other days: check for daily suggestion
    await _handleDailyProactiveSuggestion();
  }
  
  // Both paths record execution for fallback detection
  await TaskExecutionLogger.recordExecution();
}
```

**Notification Management:**
- Sunday reflection uses different notification ID
- No conflict with daily suggestion notifications
- Simple tap behavior (opens app, no deep linking)
- Different notification channel if needed

### Testing Requirements

**Unit Tests:**
- Sunday detection logic (timezone handling)
- Reflection text generation with various session data
- Weekly stats calculation accuracy
- Achievement detection logic
- Error handling for missing data

**Integration Tests:**
- Background task Sunday routing
- Notification delivery on Sunday 8pm
- Reflection generation from real session data
- No conflict with daily suggestion system

**Manual Testing Scenarios:**
- Change device date to Sunday 8pm, verify reflection appears
- Test with different session counts and skill combinations
- Verify no "Block it" action in Sunday notification
- Confirm tapping opens app normally (no special navigation)

### Performance Requirements

**Reflection Generation:**
- Must be fast in background context (< 1 second)
- Efficient database queries (limit to past 7 days)
- Minimal memory usage for session analysis
- No blocking of background task execution

**Text Construction:**
- Simple string operations, no complex NLP
- Predefined templates for consistent format
- Handle edge cases without complex logic
- Readable and encouraging tone

### References

**Source Documents:**
- [Epics: Epic 5, Story 5.7] - Core requirements and acceptance criteria
- [UX Design: Sunday Reflection (UX-DR28)] - Sunday notification behavior
- [Epics: FR22] - Weekly reflection specification
- [Architecture: Background Task Reliability] - Integration with background task system

**Dependencies:**
- Story 5.3: BackgroundTaskService (update for Sunday detection)
- Story 5.5: NotificationService (add reflection notification type)
- Epic 3: Practice Module (session data access)
- No dependencies on AI or external services

**External Dependencies:**
- DateTime and weekday calculation
- Local database access for session history
- flutter_local_notifications for delivery

## Dev Agent Record

### Agent Model Used

TBD - Will be filled during implementation

### Debug Log References

TBD - Will be filled during implementation

### Completion Notes List

- [ ] Verify Sunday detection works correctly with UTC+0 timezone
- [ ] Test reflection generation with various session data scenarios
- [ ] Confirm Sunday notification has different ID from daily suggestions
- [ ] Verify no "Block it" action in Sunday notifications
- [ ] Test reflection text quality and encouragement tone
- [ ] Confirm tapping opens app normally (no deep linking)
- [ ] Test background task routing for Sunday vs other days
- [ ] Validate error handling for missing session data

### File List

TBD - Will be filled during implementation
