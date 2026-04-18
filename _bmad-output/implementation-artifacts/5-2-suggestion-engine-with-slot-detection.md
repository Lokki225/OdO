# Story 5.2: SuggestionEngine with Slot Detection

Status: ready-for-dev

## Story

As a developer,
I want to create the SuggestionEngine that detects free slots and idle skills,
So that the system can generate proactive suggestions.

## Acceptance Criteria

**Given** Agenda and Practice data from Epics 2 and 3, and Suggestion Storage from Story 5.1
**When** I create `features/ai/domain/suggestion_engine.dart`
**Then** it finds free slots in the next 48 hours (gaps between events)
**And** it identifies idle skills (longest days since last session)
**And** it applies suppression filters (dismissed: 3d, thumbs-down: 7d, accepted: 1d) (UX-DR26)
**And** it prioritizes: longest idle skill first, then shortest available slot, then earliest free slot (UX-DR18)
**And** it returns one suggestion per call (first match wins)
**And** it handles edge cases (no free slots, all skills suppressed, etc.)

## Tasks / Subtasks

- [ ] Task 1: Create Free Slot Detection Algorithm (AC: 1)
  - [ ] Implement gap detection between agenda events
  - [ ] Filter slots by minimum duration (30 minutes default)
  - [ ] Handle 48-hour window constraint
  - [ ] Account for timezone (UTC+0)

- [ ] Task 2: Implement Idle Skill Detection (AC: 2)
  - [ ] Calculate days since last session per skill
  - [ ] Sort skills by idle duration (longest first)
  - [ ] Handle edge case of skills with no sessions

- [ ] Task 3: Integrate Suppression Filtering (AC: 3)
  - [ ] Query non-suppressed skills from Story 5.1
  - [ ] Apply three-tier suppression logic
  - [ ] Filter out suppressed skills from consideration

- [ ] Task 4: Implement Suggestion Priority Algorithm (AC: 4)
  - [ ] Longest idle skill first
  - [ ] Shortest available slot second
  - [ ] Earliest free slot third
  - [ ] Return first match (one suggestion per call)

- [ ] Task 5: Handle Edge Cases and Error States (AC: 5-6)
  - [ ] No free slots available
  - [ ] All skills suppressed
  - [ ] No skills exist
  - [ ] Agenda data unavailable
  - [ ] Return null/empty for edge cases

## Dev Notes

### Critical Architecture Requirements

**From Architecture Decision #1 - Context Payload Strategy:**
- 48-hour agenda window is deliberate (today + tomorrow is actionable)
- Week of events = 7x tokens for marginal reasoning improvement
- Free slot detection must respect this constraint

**From UX Design - Suggestion Construction Algorithm:**
```
1. Longest idle skill first — Most days since last session
2. If tied — Shortest available free slot that fits a default session
3. If still tied — Earliest free slot in the week (sooner is more actionable)
```

**Minimum Slot Duration:** 30 minutes default for practice sessions

### Project Structure Notes

**File Locations:**
```
lib/features/ai/
├── domain/
│   ├── suggestion_engine.dart       # Core algorithm (this story)
│   ├── free_slot_detector.dart      # Slot detection logic
│   ├── idle_skill_ranker.dart       # Skill prioritization
│   └── suggestion.dart              # from Story 5.1
├── data/
│   └── suggestion_repository.dart   # from Story 5.1
└── presentation/
    └── ai_providers.dart            # Add SuggestionEngine provider
```

**Dependencies:**
- AgendaRepository (Epic 2) - for event data
- PracticeRepository (Epic 3) - for skill/session data  
- SuggestionRepository (Story 5.1) - for suppression filtering

### Technical Requirements

**Core SuggestionEngine Interface:**
```dart
class SuggestionEngine {
  final AgendaRepository agendaRepo;
  final PracticeRepository practiceRepo; 
  final SuggestionRepository suggestionRepo;

  Future<Suggestion?> generateSuggestion({
    DateTime? targetDate,
    Duration minSlotDuration = const Duration(minutes: 30),
  });
}
```

**Free Slot Detection Algorithm:**
```dart
class FreeSlotDetector {
  List<TimeSlot> findFreeSlots({
    required List<AgendaEvent> events,
    required DateTime startTime,
    required DateTime endTime,
    Duration minDuration = const Duration(minutes: 30),
  }) {
    // Sort events by start time
    final sortedEvents = events..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    final freeSlots = <TimeSlot>[];
    var currentTime = startTime;
    
    for (final event in sortedEvents) {
      // Gap between current time and next event
      if (event.startTime.isAfter(currentTime)) {
        final gapDuration = event.startTime.difference(currentTime);
        if (gapDuration >= minDuration) {
          freeSlots.add(TimeSlot(
            start: currentTime,
            end: event.startTime,
            duration: gapDuration,
          ));
        }
      }
      currentTime = event.endTime;
    }
    
    // Gap after last event until end time
    if (currentTime.isBefore(endTime)) {
      final finalGap = endTime.difference(currentTime);
      if (finalGap >= minDuration) {
        freeSlots.add(TimeSlot(
          start: currentTime,
          end: endTime,
          duration: finalGap,
        ));
      }
    }
    
    return freeSlots;
  }
}
```

**Idle Skill Ranking Algorithm:**
```dart
class IdleSkillRanker {
  List<SkillIdleDuration> rankSkillsByIdleDuration(List<Skill> skills) {
    final now = DateTime.now();
    
    return skills.map((skill) {
      final daysSinceLastSession = skill.lastSessionAt != null 
        ? now.difference(skill.lastSessionAt!).inDays
        : 999; // Never practiced = highest priority
        
      return SkillIdleDuration(
        skill: skill,
        daysSinceLastSession: daysSinceLastSession,
      );
    }).toList()
      ..sort((a, b) => b.daysSinceLastSession.compareTo(a.daysSinceLastSession));
  }
}
```

**Suggestion Generation Logic:**
```dart
Future<Suggestion?> generateSuggestion() async {
  // 1. Get 48-hour agenda window
  final now = DateTime.now();
  final windowEnd = now.add(Duration(hours: 48));
  final events = await agendaRepo.getEventsInRange(now, windowEnd);
  
  // 2. Find free slots
  final freeSlots = freeSlotDetector.findFreeSlots(
    events: events,
    startTime: now,
    endTime: windowEnd,
  );
  
  if (freeSlots.isEmpty) return null; // No free time
  
  // 3. Get non-suppressed skills, ranked by idle duration
  final nonSuppressedSkillIds = await suggestionRepo.getNonSuppressedSkillIds();
  final skills = await practiceRepo.getSkillsByIds(nonSuppressedSkillIds);
  
  if (skills.isEmpty) return null; // All skills suppressed
  
  final rankedSkills = idleSkillRanker.rankSkillsByIdleDuration(skills);
  
  // 4. Apply priority algorithm
  for (final skillIdle in rankedSkills) {
    // Find shortest slot that fits this skill's default session duration
    final suitableSlots = freeSlots.where(
      (slot) => slot.duration >= Duration(minutes: 30)
    ).toList()
      ..sort((a, b) => a.duration.compareTo(b.duration)); // Shortest first
    
    if (suitableSlots.isNotEmpty) {
      final selectedSlot = suitableSlots.first;
      
      return Suggestion(
        skillId: skillIdle.skill.id,
        slotStart: selectedSlot.start,
        slotDuration: Duration(minutes: 30), // Standard session
        suggestedAt: now,
      );
    }
  }
  
  return null; // No suitable slot found
}
```

### Error Handling Requirements

**Expected Edge Cases:**
1. **No free slots** - Return null, background task handles gracefully
2. **All skills suppressed** - Return null, try again tomorrow 
3. **No skills exist** - Return null, user needs to create skills first
4. **Agenda unavailable** - Return null, offline fallback handles this
5. **Database errors** - Use Result<T> pattern, log but don't crash

**Error Handling Pattern:**
```dart
Future<Result<Suggestion?, AppError>> generateSuggestion() async {
  try {
    final suggestion = await _generateSuggestionInternal();
    return Success(suggestion);
  } catch (e) {
    return Failure(AppError.suggestionGenerationFailed);
  }
}
```

### Testing Requirements

**Unit Tests (Critical):**
- Free slot detection with various event layouts
- Idle skill ranking with different session histories  
- Priority algorithm with multiple skills and slots
- Edge case handling (no slots, no skills, all suppressed)
- 48-hour window boundary conditions
- Timezone handling (UTC+0)

**Test Data Scenarios:**
```dart
// Scenario 1: Simple gap
events = [Event(9:00-10:00), Event(14:00-15:00)]
expected = [TimeSlot(10:00-14:00), TimeSlot(15:00-18:00)]

// Scenario 2: No gaps (back-to-back)  
events = [Event(9:00-12:00), Event(12:00-15:00)]
expected = [TimeSlot(15:00-18:00)]

// Scenario 3: Gaps too small
events = [Event(9:00-9:15), Event(9:30-10:00)]  
expected = [] // 15-minute gap < 30-minute minimum
```

### Performance Requirements

**From Architecture NFR1:** Sub-500ms perceived latency
- Suggestion generation must be fast (< 100ms)
- Cache skill data, don't query repeatedly
- Limit agenda window to 48 hours for performance
- Use efficient sorting algorithms

**Memory Constraints:**
- Typical agenda: 10-20 events per day = 40 events max
- Typical skills: 3-10 skills
- Keep data structures minimal

### References

**Source Documents:**
- [Epics: Epic 5, Story 5.2] - Core requirements and acceptance criteria  
- [Architecture: Decision #1] - Context payload strategy and 48-hour window
- [UX Design: Suggestion Construction Algorithm] - Priority algorithm specification
- [UX Design: Core UX Patterns] - Edge case handling requirements

**Dependencies:**
- Story 5.1: Suggestion Storage and Suppression Algorithm
- Epic 2: Agenda Module (AgendaRepository) 
- Epic 3: Practice Module (PracticeRepository)
- Epic 1: Database schema and Riverpod setup

## Dev Agent Record

### Agent Model Used

TBD - Will be filled during implementation

### Debug Log References

TBD - Will be filled during implementation  

### Completion Notes List

- [ ] Verify 48-hour window performance with realistic data
- [ ] Test all edge cases return appropriate nulls
- [ ] Confirm priority algorithm matches UX specification exactly
- [ ] Test timezone handling for UTC+0 
- [ ] Validate suppression integration with Story 5.1
- [ ] Performance test with maximum expected data load

### File List

TBD - Will be filled during implementation
