# Story 5.6: Offline Fallback Trigger

Status: ready-for-dev

## Story

As a developer,
I want to detect when the background task fails and surface a suggestion on app open,
So that the user still gets the proactive suggestion even if the background task missed.

## Acceptance Criteria

**Given** the background task from Story 5.3
**When** the app is opened and no suggestion was delivered in the last 18 hours
**Then** the fallback trigger runs SuggestionEngine synchronously
**And** if a suggestion is generated, it's queued in the AI component
**And** the AI component pulse dot animates once on app open (single slow pulse) (UX-DR27)
**And** if user taps the AI component, the suggestion appears as first message in chat
**And** the pulse never repeats (single pulse only, never continuous)

## Tasks / Subtasks

- [ ] Task 1: Create Fallback Detection Service (AC: 1-2)
  - [ ] Implement 18-hour window detection
  - [ ] Check last notification delivery timestamp
  - [ ] Trigger SuggestionEngine when fallback needed
  - [ ] Handle app open lifecycle events

- [ ] Task 2: Integrate with AI Component UI (AC: 3-4)
  - [ ] Queue fallback suggestions in AI component
  - [ ] Implement single pulse animation
  - [ ] Handle suggestion display in chat
  - [ ] Ensure suggestion appears as first message

- [ ] Task 3: Implement Single Pulse Animation (AC: 3-5)
  - [ ] Create pulse dot animation (400ms duration)
  - [ ] Ensure animation only plays once
  - [ ] Never continuous, never repeats
  - [ ] Visual signal without forcing interaction

- [ ] Task 4: Handle Chat Integration (AC: 4)
  - [ ] Display fallback suggestion when AI component tapped
  - [ ] Show as first message in chat thread
  - [ ] Clear queued suggestion after display
  - [ ] Handle edge cases (multiple suggestions, etc.)

## Dev Notes

### Critical Architecture Requirements

**From Architecture - Offline Fallback Behavior:**
- When background task fails and no suggestion delivered in 18 hours, surface suggestion as inline message with single pulse animation on app open
- AI component's pulse dot animates once — single slow pulse, never continuous
- If user taps AI bar, suggestion appears as first message in chat thread
- If user doesn't tap, suggestion stays queued for next 8pm check

**From UX Design - Fallback Pulse Animation (UX-DR27):**
- Single slow pulse only — never continuous, never a badge count
- Uses durationSlow (400ms)
- No persistent indicator after animation
- Signal presence without forcing interaction

### Project Structure Notes

**File Locations:**
```
lib/core/services/
├── fallback_trigger_service.dart    # Main service (this story)
├── background_task_service.dart     # from Story 5.3
└── notification_service.dart        # from Story 5.5

lib/features/ai/presentation/
├── widgets/
│   └── ai_component.dart            # Update with pulse animation
└── ai_providers.dart                # Add fallback providers
```

**Integration Points:**
- Triggered on app lifecycle events (app resume)
- Uses SuggestionEngine (Story 5.2) for suggestion generation
- Integrates with AI component UI and chat interface
- Uses tracking from NotificationService (Story 5.5)

### Technical Requirements

**FallbackTriggerService Interface:**
```dart
class FallbackTriggerService {
  static const Duration _fallbackThreshold = Duration(hours: 18);
  
  /// Check if fallback trigger should activate
  static Future<bool> shouldTriggerFallback() async {
    // Check if notification was delivered recently
    final lastDelivery = await NotificationDeliveryTracker.getLastDelivery();
    if (lastDelivery == null) return true; // Never delivered
    
    final timeSinceLastDelivery = DateTime.now().difference(lastDelivery);
    return timeSinceLastDelivery > _fallbackThreshold;
  }
  
  /// Execute fallback trigger - generate and queue suggestion
  static Future<void> executeFallback() async {
    try {
      // Generate suggestion using same engine as background task
      final suggestionEngine = GetIt.instance<SuggestionEngine>();
      final suggestion = await suggestionEngine.generateSuggestion();
      
      if (suggestion != null) {
        // Queue suggestion in AI component
        await AiComponentNotifier.queueFallbackSuggestion(suggestion);
        
        // Log fallback execution for debugging
        await _logFallbackExecution(suggestion);
      }
    } catch (e) {
      // Log error but don't crash app startup
      debugPrint('Fallback trigger failed: $e');
    }
  }
  
  /// Initialize fallback trigger on app startup
  static Future<void> initializeFallbackTrigger() async {
    if (await shouldTriggerFallback()) {
      await executeFallback();
    }
  }
}
```

**App Lifecycle Integration:**
```dart
// In main.dart or app.dart
class TooXTipsApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<TooXTipsApp> createState() => _TooXTipsAppState();
}

class _TooXTipsAppState extends ConsumerState<TooXTipsApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Check fallback on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FallbackTriggerService.initializeFallbackTrigger();
    });
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      // Check fallback when app is resumed
      FallbackTriggerService.initializeFallbackTrigger();
    }
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
```

**AI Component Pulse Animation:**
```dart
class AiComponent extends ConsumerStatefulWidget {
  @override
  ConsumerState<AiComponent> createState() => _AiComponentState();
}

class _AiComponentState extends ConsumerState<AiComponent> 
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _hasPlayedPulse = false;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: durationSlow, // 400ms
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final hasFallbackSuggestion = ref.watch(fallbackSuggestionProvider);
    
    // Trigger pulse animation once when fallback suggestion queued
    if (hasFallbackSuggestion && !_hasPlayedPulse) {
      _playPulseAnimation();
    }
    
    return GestureDetector(
      onTap: () => _handleAiComponentTap(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
        decoration: BoxDecoration(
          color: colorSurface,
          border: Border(top: BorderSide(color: colorBorder)),
        ),
        child: Row(
          children: [
            // Pulse dot indicator
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: hasFallbackSuggestion ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: hasFallbackSuggestion ? colorAccentPractice : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(width: sp12),
            
            // AI component content
            Expanded(
              child: Text(
                'Ask AI about your schedule and practice',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorTextMuted,
                ),
              ),
            ),
            
            Icon(Icons.keyboard_arrow_up, color: colorTextMuted),
          ],
        ),
      ),
    );
  }
  
  void _playPulseAnimation() {
    if (_hasPlayedPulse) return; // Only play once
    
    _hasPlayedPulse = true;
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }
  
  void _handleAiComponentTap(BuildContext context) {
    // Open AI chat and display fallback suggestion if queued
    final fallbackSuggestion = ref.read(fallbackSuggestionProvider.notifier).consumeFallbackSuggestion();
    
    if (fallbackSuggestion != null) {
      // Open chat with fallback suggestion as first message
      context.push('/ai-chat', extra: {'fallbackSuggestion': fallbackSuggestion});
    } else {
      // Open normal chat
      context.push('/ai-chat');
    }
  }
}
```

**Fallback Suggestion State Management:**
```dart
@riverpod
class FallbackSuggestionNotifier extends _$FallbackSuggestionNotifier {
  @override
  Suggestion? build() {
    return null; // No fallback suggestion initially
  }
  
  /// Queue a fallback suggestion
  void queueFallbackSuggestion(Suggestion suggestion) {
    state = suggestion;
  }
  
  /// Consume (retrieve and clear) the fallback suggestion
  Suggestion? consumeFallbackSuggestion() {
    final suggestion = state;
    state = null; // Clear after consuming
    return suggestion;
  }
  
  /// Check if fallback suggestion exists
  bool get hasFallbackSuggestion => state != null;
}

@riverpod
bool fallbackSuggestion(FallbackSuggestionRef ref) {
  final suggestion = ref.watch(fallbackSuggestionNotifierProvider);
  return suggestion != null;
}
```

**Chat Integration for Fallback Suggestions:**
```dart
class AiChatSheet extends ConsumerWidget {
  final Suggestion? fallbackSuggestion;
  
  const AiChatSheet({
    Key? key,
    this.fallbackSuggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // State summary line
        _buildStateSummary(context, ref),
        
        // Fallback suggestion display (if any)
        if (fallbackSuggestion != null)
          _buildFallbackSuggestionMessage(context, fallbackSuggestion!),
        
        // Quick commands
        _buildQuickCommands(context, ref),
        
        // Chat messages
        Expanded(
          child: _buildChatMessages(context, ref),
        ),
        
        // Input field
        _buildMessageInput(context, ref),
      ],
    );
  }
  
  Widget _buildFallbackSuggestionMessage(BuildContext context, Suggestion suggestion) {
    final suggestionText = _formatFallbackSuggestion(suggestion);
    
    return Container(
      margin: EdgeInsets.all(sp16),
      padding: EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: colorSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggestion from earlier:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorTextMuted,
            ),
          ),
          
          SizedBox(height: sp8),
          
          Text(
            suggestionText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          
          SizedBox(height: sp12),
          
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _handleFallbackAcceptance(context, suggestion),
                child: Text('Block it'),
              ),
              
              SizedBox(width: sp12),
              
              TextButton(
                onPressed: () => _handleFallbackDismissal(context, suggestion),
                child: Text('Not now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatFallbackSuggestion(Suggestion suggestion) {
    // Same format as notification text from Story 5.5
    final timeFormatter = DateFormat('EEEE');
    final dayName = timeFormatter.format(suggestion.slotStart);
    
    final durationMinutes = suggestion.slotDuration;
    final durationText = durationMinutes >= 60 
      ? '${(durationMinutes / 60).floor()} hour${durationMinutes >= 120 ? 's' : ''}'
      : '$durationMinutes minutes';
    
    return 'You have $durationText free $dayName. ${suggestion.skill.name} is idle. Want to block it?';
  }
}
```

### Error Handling Requirements

**Fallback Failure Scenarios:**
1. **SuggestionEngine fails** - Log error, don't crash app startup
2. **No suggestions available** - Skip gracefully, no pulse animation
3. **AI component not mounted** - Queue suggestion anyway for later
4. **Database unavailable** - Skip fallback, try again on next app open
5. **Animation controller disposed** - Prevent animation errors

**Error Handling Implementation:**
```dart
Future<void> executeFallback() async {
  try {
    final suggestion = await suggestionEngine.generateSuggestion();
    
    if (suggestion != null) {
      await _queueFallbackSuggestion(suggestion);
    }
  } on DatabaseException catch (e) {
    debugPrint('Fallback database error: $e');
    // Don't crash app startup
  } catch (e) {
    debugPrint('Fallback execution failed: $e');
    // Log for debugging but continue app startup
  }
}
```

### Integration with Background Task System

**Shared Logging Infrastructure:**
```dart
class ProactiveSystemLogger {
  /// Log background task execution
  static Future<void> logBackgroundTaskExecution(bool success, String? reason) async {
    debugPrint('Background task: $success ${reason ?? ''}');
  }
  
  /// Log fallback trigger execution
  static Future<void> logFallbackExecution(bool triggered, String? reason) async {
    debugPrint('Fallback trigger: $triggered ${reason ?? ''}');
  }
  
  /// Get execution history for debugging
  static Future<Map<String, dynamic>> getExecutionHistory() async {
    return {
      'lastBackgroundTask': await TaskExecutionLogger.getLastExecution(),
      'lastNotificationDelivery': await NotificationDeliveryTracker.getLastDelivery(),
      'fallbackThreshold': 18, // hours
    };
  }
}
```

### Testing Requirements

**Unit Tests:**
- 18-hour threshold calculation with various timestamps
- Fallback trigger activation logic
- Pulse animation state management
- Suggestion queuing and consumption

**Integration Tests:**
- App lifecycle fallback trigger
- Background task failure → fallback activation
- Pulse animation plays once and stops
- Chat integration with fallback suggestions

**Manual Testing Scenarios:**
- Disable background tasks, wait 18+ hours, open app
- Verify pulse animation plays once on app open
- Tap AI component, confirm suggestion appears in chat
- Verify pulse doesn't repeat on subsequent app opens

### Performance Requirements

**App Startup Impact:**
- Fallback check must be fast (< 100ms)
- Don't block app startup on suggestion generation
- Use async initialization after UI renders
- Minimal memory usage for suggestion queuing

**Animation Performance:**
- 60fps pulse animation
- GPU-accelerated scaling transform
- Clean animation controller disposal
- No animation memory leaks

### References

**Source Documents:**
- [Epics: Epic 5, Story 5.6] - Core requirements and acceptance criteria
- [Architecture: Offline Fallback Behavior] - Single pulse animation and fallback strategy
- [UX Design: Fallback Pulse Animation] - Animation specifications and behavior
- [Architecture: Background Task Reliability] - Integration with background task failure

**Dependencies:**
- Story 5.2: SuggestionEngine (generates fallback suggestions)
- Story 5.3: BackgroundTaskService (failure detection)
- Story 5.5: NotificationService (delivery tracking)
- AI component UI and chat interface

**External Dependencies:**
- App lifecycle observation
- SharedPreferences for timestamp tracking
- Animation controllers and widgets

## Dev Agent Record

### Agent Model Used

TBD - Will be filled during implementation

### Debug Log References

TBD - Will be filled during implementation

### Completion Notes List

- [ ] Verify 18-hour threshold detection works correctly
- [ ] Test fallback trigger on app startup and resume
- [ ] Confirm pulse animation plays once and never repeats
- [ ] Test AI component tap shows fallback suggestion in chat
- [ ] Verify fallback suggestion consumption clears state
- [ ] Test error handling for suggestion generation failures
- [ ] Confirm no impact on app startup performance
- [ ] Validate integration with background task failure scenarios

### File List

TBD - Will be filled during implementation
