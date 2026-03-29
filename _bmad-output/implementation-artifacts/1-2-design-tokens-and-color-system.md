---
storyId: 1.2
storyKey: 1-2-design-tokens-and-color-system
epicId: 1
projectName: TooXTips
date: 2026-03-29
status: ready-for-dev
---

# Story 1.2: Design Tokens and Color System

## Story Statement

As a developer,
I want to define the two-layer color token system (raw palette → semantic tokens),
So that all UI components use consistent colors and theme switching is centralized.

## Acceptance Criteria

**Given** the design system specification in the UX document
**When** I create `core/constants/app_colors.dart` with raw palette and semantic tokens
**Then** raw colors (violetPrimary, darkBg, etc.) are defined but never used directly in widgets
**And** semantic tokens (colorAccentAgenda, colorSurface, etc.) are defined for all UI usage
**And** light mode remapping is prepared (tokens only, no hardcoded colors in widgets)
**And** the file compiles and exports all tokens

## Technical Requirements

### Two-Layer Color System Architecture

**Layer 1: Raw Palette (Internal Use Only)**
- Define raw colors from design system
- Never import or use directly in widgets
- Serves as source of truth for all semantic tokens

**Layer 2: Semantic Tokens (Public API)**
- Map raw colors to semantic meaning
- Used exclusively in all widget code
- Enables theme switching without code changes

### Required Raw Colors

```dart
// Dark mode palette (primary)
const violetPrimary = Color(0xFF7C3AED);
const darkBg = Color(0xFF0F172A);
const darkSurface = Color(0xFF1E293B);
const darkSurfaceAlt = Color(0xFF334155);
const darkText = Color(0xFFF1F5F9);
const darkTextSecondary = Color(0xFFCBD5E1);
const darkBorder = Color(0xFF475569);

// Light mode palette
const lightBg = Color(0xFFFAFAFA);
const lightSurface = Color(0xFFFFFFFF);
const lightSurfaceAlt = Color(0xFFF3F4F6);
const lightText = Color(0xFF1F2937);
const lightTextSecondary = Color(0xFF6B7280);
const lightBorder = Color(0xFFE5E7EB);

// Accent colors (shared)
const accentAgenda = Color(0xFF06B6D4);
const accentPractice = Color(0xFF10B981);
const accentExpenses = Color(0xFFF59E0B);
const accentError = Color(0xFFEF4444);
const accentSuccess = Color(0xFF22C55E);
```

### Required Semantic Tokens (Dark Mode)

```dart
// Surface colors
const colorSurface = darkSurface;
const colorSurfaceAlt = darkSurfaceAlt;
const colorBackground = darkBg;

// Text colors
const colorText = darkText;
const colorTextSecondary = darkTextSecondary;
const colorTextTertiary = darkTextSecondary; // Lighter variant

// Border colors
const colorBorder = darkBorder;
const colorBorderLight = darkSurfaceAlt;

// Accent colors
const colorAccentAgenda = accentAgenda;
const colorAccentPractice = accentPractice;
const colorAccentExpenses = accentExpenses;
const colorAccentError = accentError;
const colorAccentSuccess = accentSuccess;

// Interactive states
const colorInteractive = violetPrimary;
const colorInteractiveHover = Color(0xFF6D28D9);
const colorInteractivePressed = Color(0xFF5B21B6);
const colorDisabled = darkSurfaceAlt;
```

### Light Mode Remapping

```dart
// Light mode token overrides (prepared for Story 1.3)
const Map<String, Color> lightModeTokens = {
  'colorSurface': lightSurface,
  'colorSurfaceAlt': lightSurfaceAlt,
  'colorBackground': lightBg,
  'colorText': lightText,
  'colorTextSecondary': lightTextSecondary,
  'colorBorder': lightBorder,
  'colorBorderLight': lightSurfaceAlt,
  // Accent colors remain the same
};
```

## Implementation Details

### File Structure

Create `lib/core/constants/app_colors.dart` with:

1. Raw palette section (commented as "Internal Use Only")
2. Dark mode semantic tokens section
3. Light mode token mapping (as Map for easy switching)
4. Export all tokens for use in theme system

### Key Constraints

- Raw colors MUST NOT be imported in any widget code
- All widget colors MUST use semantic tokens
- Semantic tokens MUST be defined as constants (not functions)
- Light mode remapping MUST be prepared but not active (Story 1.3 activates it)
- File MUST compile without errors

### Verification Steps

1. Create `lib/core/constants/app_colors.dart`
2. Define all raw palette colors
3. Define all semantic tokens for dark mode
4. Prepare light mode token mapping
5. Verify file compiles: `flutter analyze`
6. Verify all tokens are exported and accessible
7. Run `dart run build_runner build` (should succeed)

## Success Criteria

- ✓ Raw palette defined with all required colors
- ✓ Semantic tokens defined for dark mode
- ✓ Light mode token mapping prepared
- ✓ File compiles without errors
- ✓ All tokens are properly exported
- ✓ No hardcoded colors in the file (only Color() constructors)
- ✓ Comments clearly mark raw vs semantic layers
- ✓ Ready for theme system integration (Story 1.3)

## Dependencies

- Depends on: Story 1.1 (Project Setup)
- Blocks: Story 1.3 (Theme System)

## Notes

- This story establishes the foundation for consistent theming across the entire app
- The two-layer system prevents color inconsistencies and makes theme switching trivial
- Light mode tokens are prepared but not active until Story 1.3
- All future UI code must reference semantic tokens, never raw colors
