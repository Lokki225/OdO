# Story 6.1: Light Mode Implementation

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to toggle between dark and light modes,
so that I can use the app in different lighting conditions, especially outdoor environments with high brightness.

## Acceptance Criteria

**Given** the theme system from Epic 1
**When** I create light mode ThemeData
**Then** semantic tokens are remapped for light mode (no hardcoded colors change)
**And** light mode is optimized for outdoor readability (high contrast, bright backgrounds)
**And** the toggle is in settings and persists via SharedPreferences
**And** switching modes updates the entire app without restart
**And** both modes render correctly on all screens

## Tasks / Subtasks

- [ ] Task 1: Create Light Mode ThemeData (AC: 1-4)
  - [ ] Remap semantic tokens from dark to light values
  - [ ] Optimize for outdoor readability with high contrast
  - [ ] Test all UI components render correctly in light mode
  - [ ] Ensure no hardcoded colors are used

- [ ] Task 2: Implement Theme Toggle in Settings (AC: 3)
  - [ ] Add theme toggle widget in settings screen
  - [ ] Persist theme preference via SharedPreferences
  - [ ] Load saved theme preference on app startup

- [ ] Task 3: Enable Runtime Theme Switching (AC: 4)
  - [ ] Implement theme switching without app restart
  - [ ] Update all active widgets when theme changes
  - [ ] Test theme switching across all app screens

- [ ] Task 4: Cross-Screen Validation (AC: 5)
  - [ ] Validate Agenda module renders correctly in both themes
  - [ ] Validate Practice module renders correctly in both themes
  - [ ] Validate AI chat interface renders correctly in both themes
  - [ ] Validate all widgets and components work in both themes

## Dev Notes

### Architecture Context

- **Theme System Foundation**: Built on two-layer color token system from Epic 1 (raw palette → semantic tokens)
- **SharedPreferences Integration**: Use existing SharedPreferences setup for persistence
- **Riverpod State Management**: Theme state must be managed via Riverpod providers for reactive updates
- **Material Design Compliance**: Follow Material 3 design system for light theme colors

### Technical Requirements from Architecture

**Color Token System (Epic 1 Foundation)**:

- Raw colors defined in `core/constants/app_colors.dart` must NOT change
- Only semantic tokens (colorAccentAgenda, colorSurface, etc.) should be remapped
- Maintain existing dark mode as hardcoded default per UX-DR13

**Performance Requirements (NFR1, NFR13)**:

- Theme switching must complete in <500ms perceived latency
- Use optimistic UI updates during theme changes
- No loading states for theme switching

**Accessibility Requirements (NFR7, NFR8)**:

- WCAG AA text contrast compliance (4.5:1 for normal text, 3:1 for large text)
- Maintain 44dp minimum touch targets in both themes
- High-brightness outdoor readability (NFR12) - key requirement for light mode

**Locale Considerations (NFR9-11)**:

- Ensure XOF currency formatting works in both themes
- DD/MM/YYYY date format consistent across themes
- UTC+0 timezone handling unaffected by theme changes

### Project Structure Notes

**File Modifications Required**:

- `lib/app/theme.dart` - Add light mode ThemeData configuration
- `lib/core/constants/app_colors.dart` - Add light mode semantic token mapping
- Settings screen implementation (location TBD based on app shell structure)
- Update any providers managing theme state

**Dependency Alignment**:

- Follow existing Riverpod code-gen syntax (@riverpod) established in Epic 1
- Use SharedPreferences pattern consistent with other app preferences
- Maintain feature-based folder structure (agenda, practice, ai)

**Testing Standards**:

- Unit tests for theme switching logic
- Widget tests for all major components in both themes
- Integration tests for theme persistence across app restarts

### Architecture Compliance

**ThemeData Structure**:

- Use Material 3 ColorScheme.fromSeed() approach for consistency
- Implement proper typography with tabular figures (FontFeature.tabularFigures())
- Include spacing scale constants (sp2-sp24) in both themes
- Maintain animation durations (durationFast, durationDefault, durationSlow)

**State Management Pattern**:

- Theme provider must follow suffix convention (ThemeNotifier, ThemeService)
- Error handling via AsyncValue at UI boundaries
- Separate business logic from UI presentation

**Integration Points**:

- Agenda module: Ensure calendar views work in both themes
- Practice module: Skill cards and streak displays must be readable in light mode
- AI component: Chat interface and confirmation sheets must support both themes

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 6: Story 6.1]
- [Source: _bmad-output/planning-artifacts/architecture.md#ThemeSystem Component]
- [Source: _bmad-output/planning-artifacts/epics.md#UX-DR13: Dark mode as hardcoded default]
- [Source: _bmad-output/planning-artifacts/epics.md#NFR7: WCAG AA text contrast compliance]
- [Source: _bmad-output/planning-artifacts/epics.md#NFR12: High-brightness outdoor readability]

### Previous Story Intelligence

**Theme System Foundation (Epic 1)**:

- Two-layer color token system already established in Story 1.2
- ThemeData configuration with dark mode default implemented in Story 1.3
- SharedPreferences integration pattern established
- Typography and spacing scales defined

**Key Patterns to Follow**:

- Semantic tokens over hardcoded colors (critical for light mode remapping)
- Riverpod provider patterns for state management
- Material 3 design system integration
- Code-gen syntax for providers (@riverpod annotation)

### Latest Technical Information

**Flutter Theme System (Current Best Practices)**:

- Material 3 ColorScheme.fromSeed() recommended over manual color definitions
- Use ThemeExtension for custom semantic tokens
- Implement proper theme animations via AnimatedTheme widget
- SharedPreferences.setBool() for theme persistence is still current standard

**Accessibility Updates**:

- WCAG AA contrast ratios: 4.5:1 normal text, 3:1 large text (18pt+)
- Material 3 includes improved contrast ratios for light themes
- Use ColorScheme.onSurface with proper opacity for text colors

**Performance Considerations**:

- Theme switching triggers full widget rebuild - optimize with const constructors
- Use Theme.of(context).colorScheme pattern for reactive updates
- Avoid setState() for theme changes - use Riverpod state management

## Dev Agent Record

### Agent Model Used

Cascade

### Debug Log References

### Completion Notes List

### File List
