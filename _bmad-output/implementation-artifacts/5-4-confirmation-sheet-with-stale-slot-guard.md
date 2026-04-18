# Story 5.4: Confirmation Sheet with Stale Slot Guard

Status: ready-for-dev

## Story

As a user,
I want to see a confirmation sheet when I tap the proactive notification,
So that I can quickly accept or dismiss the suggestion.

## Acceptance Criteria

**Given** the notification from Story 5.3
**When** I tap the notification
**Then** a confirmation sheet opens (not the app home screen) (UX-DR7)
**And** the sheet shows: suggestion text, context (slot duration + skill idle days), "Block it" button, "Not now" button (UX-DR1)
**And** before rendering, it rechecks the Agenda to verify the slot still exists (UX-DR11)
**And** if slot is gone, it shows: "This slot is no longer available" with "Close" button
**And** if slot exists, tapping "Block it" creates the event in both Agenda and Practice
**And** tapping "Not now" dismisses the sheet
**And** the sheet has a thumbs-down micro-action for silent feedback (UX-DR10, UX-DR26)
**And** after action, the sheet dismisses with 400ms completion animation (UX-DR12)

## Tasks / Subtasks

- [ ] Task 1: Create Confirmation Sheet UI (AC: 1-3)
  - [ ] Design confirmation sheet layout with 4 elements
  - [ ] Implement suggestion text display
  - [ ] Add context information display
  - [ ] Create primary and secondary action buttons

- [ ] Task 2: Implement Stale Slot Guard (AC: 4-5)
  - [ ] Add slot validation before rendering
  - [ ] Create "slot unavailable" error state
  - [ ] Handle graceful failure when slot is gone
  - [ ] Recheck agenda data freshness

- [ ] Task 3: Implement Sheet Actions (AC: 6-7)
  - [ ] "Block it" creates events in both modules
  - [ ] "Not now" dismisses without action
  - [ ] Handle success and error states
  - [ ] Integrate with suggestion feedback system

- [ ] Task 4: Add Thumbs-Down Micro-Action (AC: 8)
  - [ ] Create subtle thumbs-down button
  - [ ] Implement silent feedback recording
  - [ ] Integrate with suppression algorithm
  - [ ] No explanation required from user

- [ ] Task 5: Implement Completion Animation (AC: 9)
  - [ ] 400ms completion animation
  - [ ] Scale-down effect for success
  - [ ] Navigate back after animation
  - [ ] Handle different entry points

## Dev Notes

### Critical UX Requirements

**From UX Design - Confirmation Sheet Anatomy:**
The sheet must contain exactly four elements:
1. **Suggestion** - AI suggestion in natural language (one sentence)
2. **Context** - Contextual reason in muted text below
3. **Primary action** - "Block it" button, full width, violet background  
4. **Secondary action** - "Not now" text button, no border, muted colour

**What's NOT included:**
- No close icon
- No "remind me later"
- No explanation of how AI decided
- No additional options

**From UX Design - Stale Slot Guard:**
User gets 8pm notification but doesn't tap until 11am next day. The "45 free minutes Thursday" slot may no longer exist. Recheck Agenda before rendering. If slot gone, show: "This slot is no longer available" with "Close" button only.

### Project Structure Notes

**File Locations:**
```
lib/features/ai/presentation/
├── widgets/
│   ├── confirmation_sheet.dart      # Main sheet (this story)
│   ├── suggestion_display.dart      # Suggestion text component
│   └── slot_validation_error.dart   # Stale slot error state
└── ai_providers.dart                # Add confirmation sheet providers
```

**Navigation Integration:**
- Sheet opens from notification tap, not normal navigation
- Uses go_router bottom sheet routes, not imperative pushes
- Returns to original context after action

### Technical Requirements

**Confirmation Sheet Interface:**
```dart
class ConfirmationSheet extends ConsumerWidget {
  final Suggestion suggestion;
  
  const ConfirmationSheet({
    Key? key,
    required this.suggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(slotValidationProvider(suggestion)).when(
      data: (isValid) => isValid 
        ? _buildValidSheet(context, ref)
        : _buildStaleSlotError(context),
      loading: () => _buildLoadingSheet(context),
      error: (error, stack) => _buildErrorSheet(context),
    );
  }
}
```

**Stale Slot Validation:**
```dart
@riverpod
Future<bool> slotValidation(SlotValidationRef ref, Suggestion suggestion) async {
  final agendaRepo = ref.read(agendaRepositoryProvider);
  final now = DateTime.now();
  
  // Get events that might conflict with suggested slot
  final conflictingEvents = await agendaRepo.getEventsInRange(
    suggestion.slotStart,
    suggestion.slotStart.add(Duration(minutes: suggestion.slotDuration)),
  );
  
  // Slot is valid if no conflicting events exist
  return conflictingEvents.isEmpty;
}
```

**Sheet Layout Structure:**
```dart
Widget _buildValidSheet(BuildContext context, WidgetRef ref) {
  return Container(
    padding: EdgeInsets.all(sp24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Suggestion text
        _SuggestionDisplay(suggestion: suggestion),
        
        SizedBox(height: sp12),
        
        // 2. Context information  
        _ContextDisplay(suggestion: suggestion),
        
        SizedBox(height: sp24),
        
        // 3. Primary action button
        _BlockItButton(
          onPressed: () => _handleBlockIt(context, ref),
        ),
        
        SizedBox(height: sp12),
        
        // 4. Secondary action + thumbs down
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NotNowButton(
              onPressed: () => _handleNotNow(context, ref),
            ),
            _ThumbsDownButton(
              onPressed: () => _handleThumbsDown(context, ref),
            ),
          ],
        ),
      ],
    ),
  );
}
```

**Action Implementations:**
```dart
Future<void> _handleBlockIt(BuildContext context, WidgetRef ref) async {
  final agendaRepo = ref.read(agendaRepositoryProvider);
  final practiceRepo = ref.read(practiceRepositoryProvider);
  final suggestionRepo = ref.read(suggestionRepositoryProvider);
  
  try {
    // Create agenda event
    final event = AgendaEvent(
      title: '${suggestion.skill.name} Practice',
      startTime: suggestion.slotStart,
      endTime: suggestion.slotStart.add(Duration(minutes: suggestion.slotDuration)),
      category: 'Practice',
    );
    await agendaRepo.createEvent(event);
    
    // Create practice session (pre-scheduled)
    final session = PracticeSession(
      skillId: suggestion.skillId,
      startedAt: suggestion.slotStart,
      durationMinutes: suggestion.slotDuration,
      isAnchored: true, // This session has an agenda event
      suggestedTime: suggestion.slotStart,
    );
    await practiceRepo.scheduleSession(session);
    
    // Record acceptance in suggestions
    await suggestionRepo.recordAcceptance(suggestion.id);
    
    // Show completion animation then dismiss
    await _showCompletionAnimation(context);
    Navigator.of(context).pop();
    
  } catch (e) {
    // Handle error - show error state but don't crash
    _showErrorSnackBar(context, 'Failed to schedule practice session');
  }
}

Future<void> _handleNotNow(BuildContext context, WidgetRef ref) async {
  final suggestionRepo = ref.read(suggestionRepositoryProvider);
  
  // Record dismissal for suppression algorithm
  await suggestionRepo.recordDismissal(suggestion.id);
  
  // Simple dismiss - no animation needed
  Navigator.of(context).pop();
}

Future<void> _handleThumbsDown(BuildContext context, WidgetRef ref) async {
  final suggestionRepo = ref.read(suggestionRepositoryProvider);
  
  // Record thumbs down for longer suppression
  await suggestionRepo.recordThumbsDown(suggestion.id);
  
  // Dismiss immediately - user feedback recorded
  Navigator.of(context).pop();
}
```

**Completion Animation:**
```dart
Future<void> _showCompletionAnimation(BuildContext context) async {
  // 400ms scale-down animation as per UX-DR12
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _CompletionAnimationDialog(),
  );
}

class _CompletionAnimationDialog extends StatefulWidget {
  const _CompletionAnimationDialog();

  @override
  State<_CompletionAnimationDialog> createState() => _CompletionAnimationDialogState();
}

class _CompletionAnimationDialogState extends State<_CompletionAnimationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: durationSlow, // 400ms
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    // Start animation and auto-dismiss
    _controller.forward().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colorAccentPractice,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Error Handling Requirements

**Stale Slot Error State:**
```dart
Widget _buildStaleSlotError(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(sp24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'This slot is no longer available',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: sp24),
        
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    ),
  );
}
```

**Error Handling Scenarios:**
1. **Slot validation fails** - Show stale slot error
2. **Database write fails** - Show error snackbar, don't dismiss sheet
3. **Network unavailable** - Should work offline (local-first)
4. **Suggestion data corrupted** - Graceful fallback, close sheet

### Navigation and Routing

**go_router Integration:**
```dart
// Add to app router configuration
GoRoute(
  path: '/confirmation-sheet/:suggestionId',
  pageBuilder: (context, state) {
    final suggestionId = state.pathParameters['suggestionId']!;
    
    return MaterialPage(
      key: state.pageKey,
      child: FutureBuilder<Suggestion?>(
        future: _loadSuggestion(suggestionId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ConfirmationSheet(suggestion: snapshot.data!);
          }
          return _LoadingSheet();
        },
      ),
    );
  },
),
```

**Notification Deep Link:**
- Notification payload includes suggestion ID
- Tapping notification navigates to confirmation sheet route
- Sheet opens even if app was closed
- Returns to appropriate context after action

### Testing Requirements

**Unit Tests:**
- Slot validation logic with various agenda states
- Action handlers (block it, not now, thumbs down)
- Completion animation timing and behavior
- Error state handling

**Widget Tests:**
- Confirmation sheet renders correctly
- All four required elements present
- Button interactions work
- Stale slot error displays correctly
- Loading states render properly

**Integration Tests:**
- End-to-end notification → sheet → action flow
- Database writes work correctly for both modules
- Suppression algorithm integration
- Navigation back to original context

### Accessibility Requirements

**From Architecture - Accessibility:**
- Minimum 44dp touch targets for all interactive elements
- WCAG AA text contrast compliance
- Semantic labels for screen readers
- Focus indicators for keyboard navigation

**Accessibility Implementation:**
```dart
// Primary button
ElevatedButton(
  onPressed: _handleBlockIt,
  style: ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, 44), // 44dp minimum
    backgroundColor: colorAccentAgenda,
  ),
  child: Text(
    'Block it',
    semanticsLabel: 'Schedule this practice session',
  ),
)

// Thumbs down micro-action  
IconButton(
  onPressed: _handleThumbsDown,
  constraints: BoxConstraints(minWidth: 44, minHeight: 44),
  icon: Icon(Icons.thumb_down_outlined),
  tooltip: 'Not relevant',
  semanticsLabel: 'Mark suggestion as not relevant',
)
```

### Performance Requirements

**Loading Performance:**
- Sheet should open < 200ms from notification tap
- Slot validation must be fast (< 100ms)
- Don't block UI thread during database writes
- Use optimistic UI for "Block it" action

**Animation Performance:**
- 60fps completion animation
- Use Transform.scale (GPU accelerated)
- Dispose animation controllers properly

### References

**Source Documents:**
- [Epics: Epic 5, Story 5.4] - Core requirements and acceptance criteria
- [UX Design: Confirmation Sheet Anatomy] - Exact UI specification with 4 elements
- [UX Design: Stale Slot Guard] - Slot validation requirements
- [UX Design: Completion Animation] - 400ms animation specification
- [Architecture: go_router] - Navigation patterns and bottom sheet routes

**Dependencies:**
- Story 5.1: Suggestion Storage (feedback recording)
- Story 5.2: SuggestionEngine (suggestion data structure)
- Story 5.3: Background Task (notification trigger)
- Epic 2: Agenda Module (event creation)
- Epic 3: Practice Module (session scheduling)

## Dev Agent Record

### Agent Model Used

TBD - Will be filled during implementation

### Debug Log References

TBD - Will be filled during implementation

### Completion Notes List

- [ ] Verify sheet opens directly from notification (not app home)
- [ ] Test stale slot validation with realistic timing scenarios
- [ ] Confirm completion animation timing matches UX spec (400ms)
- [ ] Validate all 4 required UI elements are present
- [ ] Test thumbs-down integration with suppression algorithm
- [ ] Verify "Block it" creates events in both Agenda and Practice
- [ ] Test error handling for database write failures
- [ ] Confirm accessibility requirements are met

### File List

TBD - Will be filled during implementation
