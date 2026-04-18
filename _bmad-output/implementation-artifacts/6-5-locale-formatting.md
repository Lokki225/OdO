# Story 6.5: Locale Formatting (XOF, DD/MM/YYYY, UTC+0)

Status: ready-for-dev

## Story

As a user in Abidjan,
I want the app to display dates, times, and currency in my locale,
so that the app feels native and respectful of my regional preferences.

## Acceptance Criteria

**Given** the intl package from dependencies
**When** I create `core/utils/locale_service.dart`
**Then** dates are formatted as DD/MM/YYYY (not MM/DD/YYYY)
**And** times are formatted in 24-hour format
**And** timezone is UTC+0 (no daylight saving)
**And** currency is XOF with no decimal places (e.g., "1,500 XOF")
**And** the formatting is applied consistently across the app

## Tasks / Subtasks

- [ ] Task 1: Locale Service Implementation (AC: 1-2)
  - [ ] Create `core/utils/locale_service.dart` with formatting methods
  - [ ] Implement DD/MM/YYYY date formatting using intl package
  - [ ] Implement 24-hour time formatting
  - [ ] Test date/time formatting across different scenarios

- [ ] Task 2: Currency Formatting (AC: 4)
  - [ ] Implement XOF currency formatting with no decimal places
  - [ ] Use proper thousand separators (e.g., "1,500 XOF")
  - [ ] Handle currency display in different contexts
  - [ ] Test currency formatting with various amounts

- [ ] Task 3: Timezone Management (AC: 3)
  - [ ] Ensure all datetime operations use UTC+0
  - [ ] Handle timezone consistently across the app
  - [ ] Test timezone handling with date comparisons
  - [ ] Verify no daylight saving time adjustments

- [ ] Task 4: Cross-App Integration (AC: 5)
  - [ ] Apply locale formatting in Agenda module (event times/dates)
  - [ ] Apply locale formatting in Practice module (session timestamps)
  - [ ] Apply locale formatting in AI module (context timestamps)
  - [ ] Update all date/time displays consistently

- [ ] Task 5: Locale Service Testing
  - [ ] Unit tests for all formatting methods
  - [ ] Test edge cases (leap years, month boundaries)
  - [ ] Test formatting consistency across themes
  - [ ] Integration tests for cross-module usage

## Dev Notes

### Architecture Context

- **Locale Requirements**: Target users in Abidjan, Côte d'Ivoire require specific formatting
- **Currency System**: XOF (West African CFA franc) with no decimal places
- **Date Format**: DD/MM/YYYY European-style date format preferred
- **Timezone**: UTC+0 (Greenwich Mean Time) with no daylight saving time

### Technical Requirements from Architecture

**Locale Formatting Standards (NFR9-11)**:

- XOF currency formatting with no decimal places per NFR9
- DD/MM/YYYY date format per NFR10  
- UTC+0 timezone handling per NFR11
- Consistent formatting across all app modules

**Integration Requirements**:

- Use intl package for internationalization support
- Centralized locale service for consistent formatting
- Theme-independent formatting (works in both dark/light modes)
- Performance-optimized formatting for real-time updates

**Architecture Compliance**:

- Follow service pattern established in architecture
- Implement as stateless service injected via Riverpod
- Use constants for locale configuration
- Support future internationalization expansion

### Project Structure Notes

**File Structure Required**:

- `core/utils/locale_service.dart` - Main locale formatting service
- `core/constants/locale_constants.dart` - Locale configuration constants
- Update existing date/time displays across all modules
- Add locale formatting to Riverpod providers

**Locale Service Design**:

- Static methods for formatting operations
- Configurable locale settings for future expansion
- Consistent API across different data types
- Error handling for invalid date/currency inputs

**Testing Standards**:

- Unit tests for all formatting methods
- Test locale-specific edge cases
- Integration tests for cross-module consistency
- Performance tests for formatting operations

### Architecture Compliance

**Service Integration Pattern**:

- Follow stateless service pattern from architecture
- Inject via Riverpod providers for dependency management
- Use consistent error handling patterns
- Support both sync and async operations where needed

**Cross-Module Requirements**:

- Agenda module: Event date/time formatting
- Practice module: Session timestamp formatting  
- AI module: Context timestamp formatting
- All modules: Consistent locale-aware displays

**Performance Considerations**:

- Cache formatted strings where appropriate
- Efficient date/time parsing and formatting
- Minimal overhead for real-time updates
- Consider formatting costs in list views

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 6: Story 6.5]
- [Source: _bmad-output/planning-artifacts/epics.md#NFR9: XOF currency formatting]
- [Source: _bmad-output/planning-artifacts/epics.md#NFR10: DD/MM/YYYY date format]
- [Source: _bmad-output/planning-artifacts/epics.md#NFR11: UTC+0 timezone handling]
- [Source: _bmad-output/planning-artifacts/architecture.md#LocaleService component]

### Previous Story Intelligence

**Service Architecture (Epic 1)**:

- Supporting services pattern established as stateless classes
- Riverpod injection pattern for service dependencies
- Constants organization in `core/constants/` directory
- Service naming conventions with suffix patterns

**Date/Time Usage Context**:

- Agenda module: Event scheduling and calendar display
- Practice module: Session logging timestamps  
- AI module: Context building with temporal information
- Background tasks: 8pm notification scheduling

**Theme Integration (Stories 1.3, 6.1)**:

- Locale formatting must work in both dark and light themes
- No theme-dependent formatting logic required
- Consistent display across theme switches

### Latest Technical Information

**Flutter Intl Package Best Practices**:

- Use DateFormat class for date/time formatting
- NumberFormat.currency() for currency formatting
- Locale-specific formatters with proper fallbacks
- Handle timezone with DateTime.utc() constructor

**XOF Currency Formatting**:

- Currency code: XOF (West African CFA franc)
- No decimal places required for typical transactions
- Use comma separators for thousands (French formatting style)
- Symbol placement: amount followed by currency code

**UTC+0 Timezone Handling**:

- Use DateTime.utc() for all datetime operations
- Avoid DateTime.now() in favor of DateTime.now().toUtc()
- Consistent timezone handling in database storage
- No daylight saving time calculations needed

**Performance Optimization**:

- Use static DateFormat instances where possible
- Cache frequently used formatters
- Consider lazy initialization for formatters
- Profile formatting performance in list views

## Dev Agent Record

### Agent Model Used

Cascade

### Debug Log References

### Completion Notes List

### File List
