# Story 6.3: Empty States and Error States

Status: ready-for-dev

## Story

As a user,
I want to see helpful empty states and error messages,
so that I understand what to do next when there's no content or something goes wrong.

## Acceptance Criteria

**Given** the modules from Epics 2, 3, 4
**When** the Agenda module has no events
**Then** it shows: "Nothing scheduled — free day" (not a blank screen)
**And** when the Practice module has no skills
**Then** the first-launch prompt appears (Story 3.2)
**And** when the chat fails to reach the AI
**Then** it shows: "Couldn't reach AI · Tap to retry" (not an error icon)
**And** when a database query fails
**Then** a graceful error message appears (not a crash)

## Tasks / Subtasks

- [ ] Task 1: Agenda Module Empty States (AC: 1)
  - [ ] Implement "Nothing scheduled — free day" message for empty calendar
  - [ ] Style empty state to match app design system
  - [ ] Test empty state appears correctly in day and week views
  - [ ] Ensure empty state is helpful and not discouraging

- [ ] Task 2: Practice Module Empty States (AC: 2)
  - [ ] Ensure first-launch skill prompt appears when no skills exist
  - [ ] Implement consistent empty state pattern across Practice module
  - [ ] Test empty state handling for new users
  - [ ] Verify empty state integrates with first-launch flow

- [ ] Task 3: AI Chat Error States (AC: 3)
  - [ ] Implement "Couldn't reach AI · Tap to retry" message
  - [ ] Add retry functionality for failed AI requests
  - [ ] Style error message to be helpful, not alarming
  - [ ] Test offline and connection error scenarios

- [ ] Task 4: Database Error Handling (AC: 4)
  - [ ] Implement graceful error messages for database failures
  - [ ] Add proper error logging for debugging
  - [ ] Ensure app doesn't crash on database errors
  - [ ] Test error recovery and user guidance

- [ ] Task 5: Consistent Error State Design System
  - [ ] Create reusable error state components
  - [ ] Establish consistent messaging patterns
  - [ ] Implement proper error state styling
  - [ ] Test error states across both themes (dark/light)

## Dev Notes

### Architecture Context

- **Error Handling Pattern**: Use Result pattern in services and AsyncValue at UI boundaries (established in architecture)
- **Empty State Design**: Follow UX design patterns for helpful, not discouraging messaging
- **Offline Capability**: Error states must work offline and provide clear guidance
- **User Experience**: Error states should educate users and provide actionable next steps

### Technical Requirements from Architecture

**Error Handling Architecture**:

- Use Result<T> in service layer for error propagation
- AsyncValue at UI boundaries for loading/error states
- Never crash the app - all errors must be handled gracefully
- Proper error logging for debugging without exposing technical details to users

**Performance Requirements (NFR1, NFR5)**:

- Error states must render within perceived latency limits
- 99%+ crash-free sessions requires proper error handling
- Error recovery should not impact app performance
- Empty states should load immediately without delays

**Offline Requirements (NFR14, NFR20)**:

- All error states must work offline
- Graceful AI degradation when offline per NFR20
- Offline error messages should be helpful and actionable
- Error states should not depend on network connectivity

**User Experience Requirements**:

- Error messages should be human-friendly, not technical
- Provide actionable guidance ("Tap to retry", not "Network error 404")
- Empty states should be encouraging, not discouraging
- Maintain consistency across all modules

### Project Structure Notes

**File Modifications Required**:

- `features/agenda/presentation/widgets/` - Empty agenda state widget
- `features/practice/presentation/widgets/` - Empty practice state handling
- `features/ai/presentation/widgets/` - AI error state messages
- `core/widgets/` - Reusable error state components
- Update error handling in all repository implementations

**Error State Component Design**:

- Create reusable ErrorStateWidget for consistent styling
- EmptyStateWidget for no-content scenarios
- RetryableErrorWidget for network/API failures
- Implement proper accessibility labels for error states

**Testing Standards**:

- Unit tests for error handling logic
- Widget tests for error state rendering
- Integration tests for error recovery flows
- Test error states in both online and offline modes

### Architecture Compliance

**State Management Integration**:

- Error states managed through Riverpod AsyncValue
- Proper error state transitions in providers
- Error handling coordinated with loading states
- Optimistic UI with error fallback patterns

**Database Error Patterns**:

- Wrap Drift queries in try-catch blocks
- Return Result<T> from repository methods
- Handle SQLite constraint violations gracefully
- Provide meaningful error messages for data corruption

**AI Integration Error Handling**:

- Handle API timeouts (3 second limit from Story 4.2)
- Graceful fallback to offline provider
- Retry mechanisms with exponential backoff
- Clear messaging for different error types

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 6: Story 6.3]
- [Source: _bmad-output/planning-artifacts/epics.md#UX-DR4: Offline state message for AI chat]
- [Source: _bmad-output/planning-artifacts/architecture.md#Error handling patterns]
- [Source: _bmad-output/planning-artifacts/epics.md#NFR5: 99%+ crash-free sessions]
- [Source: _bmad-output/planning-artifacts/epics.md#NFR20: Graceful AI degradation when offline]

### Previous Story Intelligence

**Error Handling Foundation (Architecture)**:

- Result<T> pattern established for service layer error handling
- AsyncValue pattern established for UI error states
- Offline-first architecture supports graceful error handling
- Theme system supports error state styling in both modes

**Integration Points from Previous Stories**:

- Practice module first-launch prompt (Story 3.3) already handles empty state
- AI offline degradation (Story 4.5) provides foundation for error handling
- Database schema (Story 1.4) includes error constraint handling
- Theme system (Stories 1.3, 6.1) supports error state styling

### Latest Technical Information

**Flutter Error Handling Best Practices**:

- Use FlutterError.reportError() for non-fatal errors
- Implement proper error boundaries with ErrorWidget.builder
- Use PlatformException for platform-specific errors
- Consider using Sentry or similar for production error tracking

**User Experience Patterns**:

- Use progressive disclosure for error details
- Implement "try again" patterns with proper state management
- Provide contextual help for common error scenarios
- Use consistent iconography and messaging across error states

**Accessibility Considerations**:

- Proper semantics labels for error states
- Screen reader friendly error messages
- High contrast error state styling
- Keyboard navigation support for retry actions

## Dev Agent Record

### Agent Model Used

Cascade

### Debug Log References

### Completion Notes List

### File List
