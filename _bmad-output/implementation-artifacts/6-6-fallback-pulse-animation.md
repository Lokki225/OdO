# Story 6.6: Fallback Pulse Animation

Status: ready-for-dev

## Story

As a user,
I want to see a subtle pulse on the AI component when a fallback suggestion is queued,
so that I know there's something waiting for me without being intrusive.

## Acceptance Criteria

**Given** the offline fallback trigger from Story 5.6
**When** a fallback suggestion is queued on app open
**Then** the AI component pulse dot animates once (single slow pulse) (UX-DR27)
**And** the pulse uses durationSlow (400ms)
**And** the pulse never repeats (single animation only)
**And** no badge count or persistent indicator is shown
**And** if user taps the AI component, the suggestion appears in chat

## Tasks / Subtasks

- [ ] Task 1: Pulse Animation Implementation (AC: 1-3)
  - [ ] Create single pulse animation using durationSlow (400ms)
  - [ ] Implement pulse dot on AI component
  - [ ] Ensure animation runs only once per fallback trigger
  - [ ] Test animation timing and visual effect

- [ ] Task 2: Fallback Trigger Integration (AC: 1, 5)
  - [ ] Connect pulse animation to offline fallback system
  - [ ] Trigger pulse when background task missed 18-hour window
  - [ ] Ensure pulse only appears when fallback suggestion exists
  - [ ] Test integration with SuggestionEngine fallback logic

- [ ] Task 3: No Persistent Indicators (AC: 4)
  - [ ] Ensure no badge counts are displayed
  - [ ] Avoid continuous or repeating animations
  - [ ] Implement single-use animation state management
  - [ ] Test that pulse doesn't become persistent notification

- [ ] Task 4: User Interaction Handling (AC: 5)
  - [ ] Handle tap on AI component during/after pulse
  - [ ] Display queued suggestion as first chat message
  - [ ] Clear pulse state after user interaction
  - [ ] Test user interaction flow end-to-end

## Dev Notes

### Architecture Context

- **Offline Fallback Integration**: Connects with Story 5.6 offline fallback trigger system
- **Animation System**: Uses established animation durations from Epic 1
- **AI Component Integration**: Works with existing AI chat interface from Epic 4
- **Subtle UX Design**: Follows UX-DR27 specification for non-intrusive notification

### Technical Requirements from Architecture

**Animation Requirements (UX-DR27)**:

- Single slow pulse animation only (never continuous)
- Use durationSlow (400ms) from established animation constants
- Pulse dot visual design integrated with AI component
- No badge counts or persistent visual indicators

**Offline Fallback Integration (Story 5.6)**:

- Triggered when background task fails (18-hour window missed)
- Connected to SuggestionEngine fallback suggestion generation
- Coordinated with app open detection system
- Works entirely offline (no network dependency)

**State Management Requirements**:

- Track pulse animation state to prevent repetition
- Coordinate with AI component state
- Handle user interaction to clear pulse state
- Ensure animation doesn't interfere with normal AI functionality

### Project Structure Notes

**File Modifications Required**:

- AI component widgets for pulse dot integration
- Animation controller for pulse effect
- State management for pulse triggering
- Integration with offline fallback system from Epic 5

**Animation Implementation Pattern**:

- Use AnimationController with SingleTickerProviderStateMixin
- Implement fade or scale animation for pulse effect
- Proper animation disposal and lifecycle management
- Coordinate with AI component rendering

**Testing Standards**:

- Unit tests for pulse animation logic
- Integration tests with offline fallback system
- Widget tests for pulse visual rendering
- User interaction tests for suggestion display

### Architecture Compliance

**AI Component Integration**:

- Pulse animation integrated with existing AI chat interface
- Coordinate with AI state providers from Epic 4
- Ensure pulse doesn't interfere with chat functionality
- Proper focus management during user interaction

**Offline System Coordination**:

- Work with ConnectivityService for offline detection
- Integrate with BackgroundTaskService failure detection
- Coordinate with SuggestionEngine fallback logic
- Ensure entirely local operation (no API dependency)

**Performance Considerations**:

- Minimal performance impact for pulse animation
- Efficient animation disposal after single use
- No continuous animations or timers
- Optimize for battery life during offline operation

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 6: Story 6.6]
- [Source: _bmad-output/planning-artifacts/epics.md#UX-DR27: AI component pulse dot animation]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.6: Offline Fallback Trigger]
- [Source: _bmad-output/planning-artifacts/architecture.md#Animation durations]

### Previous Story Intelligence

**Offline Fallback System (Story 5.6)**:

- Background task failure detection (18-hour window)
- SuggestionEngine fallback generation system
- App open detection for fallback trigger
- Offline suggestion queueing mechanism

**Animation System (Epic 1, Story 6.2)**:

- Animation duration constants established (durationSlow: 400ms)
- Animation controller patterns for completion effects
- Performance-optimized animation implementation
- Theme-independent animation design

**AI Component Architecture (Epic 4)**:

- AI chat interface with state management
- Chat message display and interaction patterns
- AI component rendering and update system
- Integration with suggestion display logic

### Latest Technical Information

**Flutter Animation Best Practices for Subtle Effects**:

- Use Opacity or Transform.scale for pulse effects
- Consider using AnimatedOpacity for simple fade pulse
- Implement proper animation curves (Curves.easeInOut for pulse)
- Use single-shot animations with animation.forward() only

**State Management for One-Time Events**:

- Use StateNotifier for pulse state management
- Implement boolean flags for pulse completion tracking
- Clear state after user interaction or timeout
- Coordinate state across app lifecycle events

**Performance Optimization for Subtle Animations**:

- Use RepaintBoundary to isolate pulse animation
- Minimal animation overhead for battery life
- Proper disposal of animation controllers
- Consider using ImplicitlyAnimatedWidget for simple pulse

## Dev Agent Record

### Agent Model Used

Cascade

### Debug Log References

### Completion Notes List

### File List
