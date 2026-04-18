# Story 6.9: Settings Screen with Data Clear Option

Status: ready-for-dev

## Story

As a user,
I want to access a settings screen where I can clear all local data,
so that I can reset the app if needed and have control over my data.

## Acceptance Criteria

**Given** the app is running
**When** I access the settings screen (via menu or navigation)
**Then** the screen shows: theme toggle (dark/light), "Clear All Data" button
**And** tapping "Clear All Data" shows a confirmation dialog
**And** the dialog warns: "This will delete all events, skills, and sessions. This cannot be undone."
**And** the dialog has two buttons: "Cancel" and "Clear"
**And** tapping "Clear" deletes all data from SQLite (skills, sessions, events, suggestions, chat history)
**And** after clearing, the app resets to first-launch state (first-launch skill prompt appears)
**And** the app does not crash during or after data clearing

## Tasks / Subtasks

- [ ] Task 1: Settings Screen UI Implementation (AC: 1-2)
  - [ ] Create settings screen with proper navigation
  - [ ] Add theme toggle widget (dark/light mode)
  - [ ] Add "Clear All Data" button with proper styling
  - [ ] Test settings screen accessibility and usability

- [ ] Task 2: Data Clearing Confirmation Dialog (AC: 3-4)
  - [ ] Implement confirmation dialog with warning message
  - [ ] Add "Cancel" and "Clear" action buttons
  - [ ] Style dialog appropriately for both themes
  - [ ] Test dialog behavior and user interaction

- [ ] Task 3: Complete Data Deletion (AC: 5)
  - [ ] Implement data clearing for all SQLite tables
  - [ ] Clear skills, sessions, events, suggestions, chat history
  - [ ] Ensure SharedPreferences are also cleared where appropriate
  - [ ] Test data clearing completeness and verification

- [ ] Task 4: App Reset to First-Launch State (AC: 6)
  - [ ] Reset app state after data clearing
  - [ ] Trigger first-launch skill prompt to appear
  - [ ] Ensure proper navigation to initial state
  - [ ] Test complete reset workflow end-to-end

- [ ] Task 5: Error Handling and Crash Prevention (AC: 7)
  - [ ] Handle database errors gracefully during clearing
  - [ ] Prevent app crashes during data deletion
  - [ ] Implement proper error recovery
  - [ ] Test error scenarios and edge cases

## Dev Notes

### Architecture Context

- **Settings Integration**: Create dedicated settings screen accessible from main navigation
- **Data Management**: Comprehensive clearing of all local data stores
- **State Reset**: Return app to pristine first-launch state
- **User Safety**: Confirmation dialog prevents accidental data loss

### Technical Requirements from Architecture

**Database Management (Story 1.4)**:

- Clear all Drift database tables: skills, sessions, events, suggestions
- Handle database constraints and foreign key relationships
- Ensure complete data removal without corruption
- Reset database to initial empty state

**Theme Integration (Stories 1.3, 6.1)**:

- Settings screen works in both dark and light themes
- Theme toggle functionality integrated with existing theme system
- Proper theme persistence through SharedPreferences
- Settings UI follows established design patterns

**State Management (Architecture)**:

- Clear Riverpod provider states after data deletion
- Reset all cached data and computed states
- Ensure proper state synchronization after clearing
- Handle navigation state reset appropriately

**First-Launch Integration (Story 3.3)**:

- Trigger first-launch skill prompt after data clearing
- Reset first-launch flags in SharedPreferences
- Ensure proper integration with Practice module initialization
- Test complete onboarding flow restoration

### Project Structure Notes

**File Structure Required**:

- Settings screen implementation (location depends on app shell structure)
- Data clearing service or utility functions
- Integration with existing database and state management
- Confirmation dialog component (reusable across app)

**Navigation Integration**:

- Add settings screen to app navigation structure
- Implement proper routing with go_router
- Handle back navigation and state preservation
- Consider settings access patterns (menu, drawer, etc.)

**Testing Standards**:

- Unit tests for data clearing logic
- Widget tests for settings screen UI
- Integration tests for complete reset workflow
- Test data clearing safety and completeness

### Architecture Compliance

**Database Operation Patterns**:

- Use Drift database patterns established in Epic 1
- Follow repository pattern for data operations
- Implement proper transaction handling for bulk operations
- Ensure ACID properties during data clearing

**User Experience Patterns**:

- Follow Material Design patterns for settings screens
- Implement proper confirmation patterns for destructive actions
- Use consistent styling and theming throughout
- Provide clear feedback during data clearing operation

**Error Handling Integration**:

- Use established error handling patterns (Result, AsyncValue)
- Graceful degradation if data clearing partially fails
- Proper logging for debugging data clearing issues
- User-friendly error messages for any failures

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 6: Story 6.9]
- [Source: _bmad-output/planning-artifacts/epics.md#FR26: Settings screen with option to clear all local data]
- [Source: _bmad-output/implementation-artifacts/1-4-sqlite-database-schema-with-drift.md]
- [Source: _bmad-output/implementation-artifacts/3-3-first-launch-skill-prompt.md]

### Previous Story Intelligence

**Database Foundation (Story 1.4)**:

- SQLite schema with Drift ORM established
- Database tables: skills, sessions, events, suggestions defined
- Database access patterns and repository implementation
- Transaction handling and constraint management

**Theme System (Stories 1.3, 6.1)**:

- Theme toggle implementation patterns established
- SharedPreferences integration for theme persistence
- Dark and light mode support across all UI components
- Theme switching without app restart capability

**First-Launch System (Story 3.3)**:

- First-launch skill prompt implementation
- SharedPreferences flags for first-launch detection
- Integration with Practice module initialization
- User onboarding flow patterns established

**State Management Patterns (Multiple Stories)**:

- Riverpod provider patterns for state management
- AsyncValue for UI state handling
- Provider disposal and reset patterns
- Cross-module state coordination

### Latest Technical Information

**Flutter Settings Screen Best Practices**:

- Use ListView with proper sections and dividers
- Implement ListTile widgets for consistent styling
- Consider using SettingsSection widgets for organization
- Follow Material Design guidelines for settings UI

**Safe Data Deletion Patterns**:

- Use database transactions for atomic operations
- Implement backup/restore considerations
- Proper cleanup of related data and caches
- User confirmation patterns for destructive actions

**State Reset Strategies**:

- Clear provider states before navigation
- Reset SharedPreferences selectively
- Handle navigation stack reset appropriately
- Consider memory cleanup after data clearing

**Error Recovery Patterns**:

- Partial failure handling in bulk operations
- User feedback during long-running operations
- Progress indicators for data clearing process
- Rollback strategies if clearing fails partway

## Dev Agent Record

### Agent Model Used

Cascade

### Debug Log References

### Completion Notes List

### File List
