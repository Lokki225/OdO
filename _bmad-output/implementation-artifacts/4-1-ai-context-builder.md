# Story 4.1: AI Context Builder

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to construct the AI context payload from Agenda and Practice data,
So that the AI has the information needed to make suggestions.

## Acceptance Criteria

**Given** Agenda and Practice data from Epics 2 and 3
**When** I create `features/ai/domain/context_builder.dart`
**Then** it builds payload with: today + next 48 hours events, all skills with streak/last_session, last 7 days unanchored sessions, last 3 suggestions with status, current_datetime, timezone (UTC+0)
**And** it enforces 4000 character hard cap (contextMaxChars)
**And** if payload exceeds cap, it truncates session history first, then extends agenda window
**And** it logs warning locally if truncation occurs
**And** it returns structured context as JSON-serializable object

## Tasks / Subtasks

- [ ] Task 1: Create ContextBuilder domain class (AC: All)
  - [ ] Define ContextPayload data structure with all required fields
  - [ ] Implement buildContext() method with 4000 char limit enforcement
  - [ ] Add truncation logic (sessions first, then agenda window)
  - [ ] Add local logging for truncation events
- [ ] Task 2: Create context aggregation utilities (AC: All)
  - [ ] Create helpers for agenda window extraction (48hr)
  - [ ] Create helpers for unanchored session filtering (7 days)
  - [ ] Create suggestion status aggregation (last 3)
- [ ] Task 3: Implement JSON serialization (AC: All)
  - [ ] Make ContextPayload JSON-serializable
  - [ ] Add toJson() and fromJson() methods
  - [ ] Ensure timezone handling (UTC+0) in datetime fields

## Dev Notes

### Critical Architecture Patterns

**Selective Context Strategy:** This implements the core architectural decision from architecture.md - selective context with defined boundaries, not full context. The 48-hour agenda window and 7-day unanchored session window are deliberate constraints to prevent token limit issues.

**Context Payload Composition (from architecture.md):**
```dart
// What always goes in the payload
- Agenda: today + next 48 hours (tomorrow is actionable, day-after-tomorrow is noise)
- Skills: all skills with name, streak, last_session_at (not full session history)
- Sessions: last 7 days, unanchored sessions only (anchored sessions are resolved, irrelevant)
- Suggestions: last 3 suggestions with accepted/dismissed status (behavioural context)
- Meta: current_datetime, timezone (UTC+0), active_screen
```

**Hard Cap Implementation:** `contextMaxChars = 4000` is enforced before API calls. Truncation order: session history first (oldest removed), then agenda window (day-after-tomorrow removed), and logs warning locally. AI never receives malformed or oversized request.

### Source Tree Components

**Primary Files to Create:**
- `features/ai/domain/context_builder.dart` - Main ContextBuilder class
- `features/ai/domain/context_payload.dart` - Data structure for context
- `features/ai/domain/context_aggregators.dart` - Helper utilities

**Dependencies Required:**
- `features/agenda/data/agenda_repository.dart` (Epic 2) - For agenda events
- `features/practice/data/practice_repository.dart` (Epic 3) - For skills/sessions
- Future suggestion storage (Epic 5) - Will be integrated later

**Integration Points:**
- AgendaRepository for event queries (getEventsForRange)
- PracticeRepository for skills (getAllSkills) and sessions (getUnanchoredSessions)
- Future SuggestionRepository integration in Epic 5

### Project Structure Notes

**Alignment with Architecture:**
- Domain layer placement follows data/domain/presentation separation
- Context builder is domain logic, not data access or presentation
- JSON serialization enables future API provider swapping
- Local logging aligns with no-analytics principle

**File Organization:**
```
features/ai/
├── domain/
│   ├── context_builder.dart      # Main implementation
│   ├── context_payload.dart      # Data structures
│   └── context_aggregators.dart  # Helper utilities
```

### Testing Standards Summary

**Unit Test Coverage Required:**
- Context payload construction with various data combinations
- 4000 character limit enforcement and truncation logic
- JSON serialization/deserialization round-trip
- Timezone handling (UTC+0) accuracy
- Edge cases: empty agenda, no skills, no unanchored sessions

**Test File Location:** `test/features/ai/domain/context_builder_test.dart`

### Technical Implementation Details

**Character Counting Strategy:**
```dart
// Count JSON-serialized string length, not object properties
final jsonString = jsonEncode(payload.toJson());
if (jsonString.length > contextMaxChars) {
  // Apply truncation logic
}
```

**Truncation Priority Order:**
1. Remove oldest unanchored sessions first
2. If still over limit, reduce agenda window from 48hr to 24hr
3. If still over limit, reduce to today only
4. Log warning with actual vs limit character count

**Timezone Handling:**
- All DateTime objects in payload use UTC+0 explicitly
- Current datetime includes timezone offset information
- Agenda events maintain their stored timezone but context normalizes to UTC+0

**Logging Pattern:**
```dart
// Local logging only - no analytics
print('⚠️  Context payload truncated: ${actualChars} → ${contextMaxChars} chars');
```

### References

- [Architecture: AI Context Payload Strategy - Selective Context] (architecture.md#ai-context-payload-strategy--selective-context)
- [Architecture: Context Payload Composition] (architecture.md#context-payload-composition)
- [PRD: Technical Architecture - AI Context Model] (prd.md#ai-context-model)
- [Epic 4: AI Layer - Story 4.1] (epics.md#story-41-ai-context-builder)
- [Architecture: Hard Cap Implementation] (architecture.md#hard-cap-contextmaxchars--4000)

### Epic Context & Dependencies

**This Story Enables:**
- Story 4.2: Claude API Client (requires context payload)
- Story 4.3: AI Chat Interface (requires context for conversations)
- Epic 5: Proactive System (requires context for suggestion generation)

**Dependencies from Previous Epics:**
- Epic 1: SQLite database schema (skills, sessions, events tables)
- Epic 2: AgendaRepository for event data access
- Epic 3: PracticeRepository for skills and session data access

**Cross-Module Integration:**
This is the first true cross-module integration point. The ContextBuilder reads from both Agenda and Practice modules to create AI context. This establishes the pattern for future cross-module AI reasoning.

## Dev Agent Record

### Agent Model Used

Claude 3.5 Sonnet

### Debug Log References

### Completion Notes List

### File List
