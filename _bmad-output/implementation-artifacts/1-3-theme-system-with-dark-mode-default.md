---
storyId: 1.3
storyKey: 1-3-theme-system-with-dark-mode-default
epicId: 1
projectName: TooXTips
date: 2026-03-29
status: ready-for-dev
---

# Story 1.3: Theme System with Dark Mode Default

## Story Statement

As a developer,
I want to create a ThemeData configuration with dark mode as default and light mode toggle via SharedPreferences,
So that the app renders correctly in both themes and users can switch at runtime.

## Acceptance Criteria

**Given** the color tokens from Story 1.2
**When** I create `app/theme.dart` with ThemeData for dark and light modes
**Then** dark mode is hardcoded as default in main.dart
**And** light mode toggle is persisted via SharedPreferences
**And** typography includes tabular figures for clock display (FontFeature.tabularFigures())
**And** spacing scale (sp2-sp24) is defined as constants
**And** animation durations (durationFast, durationDefault, durationSlow) are defined
**And** theme switching works at runtime without app restart

## Technical Requirements

### Spacing Scale Constants

```dart
const double sp2 = 2.0;
const double sp4 = 4.0;
const double sp8 = 8.0;
const double sp12 = 12.0;
const double sp16 = 16.0;
const double sp20 = 20.0;
const double sp24 = 24.0;
```

### Animation Duration Constants

```dart
const Duration durationFast = Duration(milliseconds: 150);
const Duration durationDefault = Duration(milliseconds: 250);
const Duration durationSlow = Duration(milliseconds: 400);
```

### Typography Configuration

- Use system fonts: SF Pro (iOS) / Roboto (Android)
- Apply tabular figures for all clock/time displays
- Ensure WCAG AA contrast compliance (minimum 4.5:1 for text)

### Dark Mode ThemeData

```dart
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: colorBackground,
  
  // Color scheme
  colorScheme: ColorScheme.dark(
    primary: colorInteractive,
    secondary: colorAccentAgenda,
    surface: colorSurface,
    background: colorBackground,
    error: colorAccentError,
  ),
  
  // Text themes with tabular figures
  textTheme: TextTheme(
    // Define all text styles with tabular figures for time displays
  ),
  
  // App bar theme
  appBarTheme: AppBarTheme(
    backgroundColor: colorSurface,
    foregroundColor: colorText,
  ),
  
  // Bottom sheet theme
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: colorSurface,
  ),
);
```

### Light Mode ThemeData

```dart
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightBg,
  
  // Color scheme with light mode colors
  colorScheme: ColorScheme.light(
    primary: colorInteractive,
    secondary: colorAccentAgenda,
    surface: lightSurface,
    background: lightBg,
    error: colorAccentError,
  ),
  
  // Text themes with tabular figures
  textTheme: TextTheme(
    // Define all text styles with tabular figures for time displays
  ),
  
  // App bar theme
  appBarTheme: AppBarTheme(
    backgroundColor: lightSurface,
    foregroundColor: lightText,
  ),
  
  // Bottom sheet theme
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: lightSurface,
  ),
);
```

### Theme Notifier for Runtime Switching

Create a Riverpod provider to manage theme state:

```dart
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('lightModeEnabled') ?? false;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isLight = state.value ?? false;
    await prefs.setBool('lightModeEnabled', !isLight);
    state = AsyncValue.data(!isLight);
  }
}
```

## Implementation Details

### File Structure

Create `lib/app/theme.dart` with:

1. Spacing scale constants section
2. Animation duration constants section
3. Dark mode ThemeData definition
4. Light mode ThemeData definition
5. Theme notifier provider for runtime switching
6. Export all for use in main.dart

### Key Constraints

- Dark mode MUST be hardcoded as default in main.dart (not via SharedPreferences)
- Light mode toggle MUST persist via SharedPreferences
- Typography MUST include tabular figures for clock displays
- All colors MUST reference semantic tokens from Story 1.2
- Theme switching MUST work at runtime without app restart
- Spacing and animation constants MUST be used throughout the app

### Verification Steps

1. Create `lib/app/theme.dart`
2. Define spacing scale and animation constants
3. Create dark mode ThemeData
4. Create light mode ThemeData
5. Create theme notifier provider
6. Verify file compiles: `flutter analyze`
7. Verify all constants are exported
8. Test theme switching in main.dart (Story 1.7)

## Success Criteria

- ✓ Spacing scale defined (sp2-sp24)
- ✓ Animation durations defined (durationFast, durationDefault, durationSlow)
- ✓ Dark mode ThemeData created with all required properties
- ✓ Light mode ThemeData created with all required properties
- ✓ Typography includes tabular figures for time displays
- ✓ Theme notifier provider created for runtime switching
- ✓ SharedPreferences integration for light mode persistence
- ✓ File compiles without errors
- ✓ All constants properly exported
- ✓ Ready for main.dart integration (Story 1.7)

## Dependencies

- Depends on: Story 1.2 (Design Tokens)
- Blocks: Story 1.7 (Main.dart Initialization)

## Notes

- Dark mode is hardcoded as default; light mode is opt-in via toggle
- Theme switching uses Riverpod for reactive UI updates
- All UI code must use spacing constants (sp2-sp24) instead of hardcoded values
- All animations must use duration constants instead of hardcoded milliseconds
- Tabular figures ensure consistent clock/time display across all screens
