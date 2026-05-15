# Story 6.1: All Seven Themes Render Correctly

Status: ready-for-dev

## Story

As a user,
I want to switch between all seven themes,
so that I can match OdO to my taste.

## Acceptance Criteria

1. The theme picker in settings (`/settings/themes`) shows all seven theme cards: Violet Dark, Cyan Dark, Green Dark, Light Mode, Cosmic, Ember, Aurora
2. Tapping a theme card calls `activeThemeProvider.notifier.setTheme(theme)` — the entire app rebuilds with new tokens using a `durationDefault` crossfade
3. All seven themes render the orb, strip, cards, and accents coherently — no hardcoded colors survive theme switching
4. WCAG AA contrast (4.5:1 for normal text, 3:1 for large text) holds on all semantic tokens in all seven themes
5. Custom accent picker is accessible via a "Custom" option in the theme picker: shows 24 color swatches as default choices; "Advanced" option behind the swatches opens a `ColorPicker` HSL dialog
6. Selected custom accent updates only `colorAccent`, `colorOrbIdle`, `colorOrbActive` in the active theme
7. Current selected theme has a checkmark indicator on its card
8. Theme selection persists via `SharedPreferences` (already implemented in Story 1.3)
9. Widget tests: selecting each theme → verify app theme changes; custom accent → verify only accent tokens update

## Tasks / Subtasks

- [ ] Task 1: Settings themes page (AC: 1, 7)
  - [ ] `lib/features/settings/presentation/pages/themes_page.dart`
  - [ ] `GridView` of `ThemeCard` widgets (2 columns)
  - [ ] Each card: preview swatch (small circles of accent + surface colors), theme name, checkmark if selected
- [ ] Task 2: `ThemeCard` widget (AC: 1, 7)
  - [ ] `lib/features/settings/presentation/widgets/theme_card.dart`
  - [ ] Shows: `colorAccent` circle + `colorBackground` circle + theme name
  - [ ] Selected state: `colorAccent` border + `Icons.check_circle` overlay
  - [ ] `onTap`: `ref.read(activeThemeProvider.notifier).setTheme(theme)`
- [ ] Task 3: Theme crossfade animation (AC: 2)
  - [ ] Wrap app content in `AnimatedSwitcher(duration: durationDefault)` keyed by `activeTheme.name`
  - [ ] Or: `AnimatedTheme` widget around `MaterialApp` content for smooth color interpolation
- [ ] Task 4: WCAG contrast check (AC: 4)
  - [ ] Manual check: for each theme, verify `colorTextPrimary` vs `colorBackground` ratio ≥4.5:1
  - [ ] Use contrast ratio formula: `(L1 + 0.05) / (L2 + 0.05)` where L = relative luminance
  - [ ] Document results in a comment block in `app_colors.dart`
- [ ] Task 5: Custom accent picker (AC: 5, 6)
  - [ ] 24 hardcoded swatch colors in `lib/core/constants/app_colors.dart`
  - [ ] `ColorPickerDialog`: `showDialog` with `GridView` of 24 `InkWell` circles
  - [ ] "Advanced" opens Flutter's `showColorPickerDialog` or a custom HSL slider
  - [ ] On select: `ref.read(activeThemeProvider.notifier).setCustomAccent(hexString)`
- [ ] Task 6: No hardcoded colors audit (AC: 3)
  - [ ] `grep -r "Color(0x" lib/features/ lib/core/widgets/` — must return zero results (only constants)
  - [ ] `grep -r "Colors\." lib/features/ lib/core/widgets/` — review each hit; replace with semantic tokens
- [ ] Task 7: Widget tests (AC: 9)
- [ ] Task 8: Lint check

## Dev Notes

- **`AnimatedTheme`:** Flutter's built-in `AnimatedTheme` widget smoothly interpolates between `ThemeData` values when the theme changes. Wrap the `MaterialApp` builder output in `AnimatedTheme(data: theme, child: child)`.
- **WCAG AA minimum:** Body text needs 4.5:1. For all dark themes with `colorTextPrimary ~ #E8E4DC` on `colorBackground ~ #0D0D0F`, contrast is ~14:1 — well above minimum. Light mode needs attention.
- **Custom accent HSL picker:** No third-party package needed if a simple hue slider is acceptable. `Slider(min: 0, max: 360)` for hue + fixed saturation/lightness = 24 preset swatches from a predefined palette.
- **"Advanced" picker:** Optional for V1. If time-constrained, ship with 24 swatches only and defer HSL slider to V1.5.

### Project Structure Notes

```
lib/features/settings/presentation/
├── pages/themes_page.dart
└── widgets/theme_card.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-6.1] — seven themes + custom accent
- [Source: 1-2-design-tokens-and-color-system.md] — OdoTheme instances
- [Source: 1-3-theme-system-with-runtime-swap.md] — activeThemeProvider.setTheme()

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
