# Story 1.3: Theme System with Runtime Swap

Status: ready-for-dev

## Story

As a developer,
I want a `ThemeData` configuration for all seven presets with runtime swap and `SharedPreferences` persistence,
so that the user can pick a theme in settings and the app updates without restart.

## Acceptance Criteria

1. `lib/app/theme.dart` exists and builds a `ThemeData` from any `OdoTheme` instance
2. `activeThemeProvider` Riverpod provider (type: `Notifier<OdoTheme>`) manages the active theme; persists chosen theme name to `SharedPreferences` key `active_theme_name`
3. Violet Dark is hardcoded as the default at first launch (OLED-optimized, non-negotiable)
4. Typography uses **Fraunces** (serif, display/titles) + **DM Sans** (body/UI) via `google_fonts` package
5. `FontFeature.tabularFigures()` applied on all clock/number display text styles
6. `lib/core/constants/app_spacing.dart` defines spacing scale constants: `sp2`, `sp4`, `sp8`, `sp12`, `sp16`, `sp20`, `sp24`, `sp32`
7. `lib/core/constants/app_typography.dart` defines type scale: `textDisplay`, `textTitle`, `textBody`, `textBodyMuted`, `textCaption`, `textMicro` — all referencing `google_fonts` styles
8. Animation duration constants defined in `lib/core/constants/app_durations.dart`: `durationFast` (150ms), `durationDefault` (300ms), `durationSlow` (500ms)
9. `radiusLg` (20.0) and other border radius constants defined in `lib/core/constants/app_spacing.dart`
10. Theme switching at runtime: `ref.read(activeThemeProvider.notifier).setTheme(theme)` triggers `ProviderScope` rebuild; no app restart required
11. Semantic tokens correctly remap when switching between dark and light themes
12. `app/app.dart` wraps `MaterialApp` in `Consumer` (or uses `ConsumerWidget`) to watch `activeThemeProvider` and pass `ThemeData` dynamically
13. All files pass `flutter analyze` with no issues

## Tasks / Subtasks

- [ ] Task 1: Create `app_spacing.dart` (AC: 6, 9)
  - [ ] Define `sp2`–`sp32` as `const double` values
  - [ ] Define `radiusSm` (8.0), `radiusMd` (12.0), `radiusLg` (20.0), `radiusXl` (28.0)
- [ ] Task 2: Create `app_typography.dart` (AC: 4, 5, 7)
  - [ ] Add `google_fonts` dependency (already in pubspec from 1.1)
  - [ ] Define `textDisplay`, `textTitle`, `textBody`, `textBodyMuted`, `textCaption`, `textMicro` using `GoogleFonts.fraunces` and `GoogleFonts.dmSans`
  - [ ] Apply `FontFeature.tabularFigures()` to display/clock styles
- [ ] Task 3: Create `app_durations.dart` (AC: 8)
  - [ ] `durationFast = const Duration(milliseconds: 150)`
  - [ ] `durationDefault = const Duration(milliseconds: 300)`
  - [ ] `durationSlow = const Duration(milliseconds: 500)`
- [ ] Task 4: Create `app/theme.dart` (AC: 1, 11)
  - [ ] `AppTheme.fromOdoTheme(OdoTheme theme) → ThemeData` static method
  - [ ] Maps `OdoTheme` fields → Material3 color scheme
  - [ ] Sets `ColorScheme.brightness` based on `theme.isDark`
  - [ ] Wires typography from `app_typography.dart`
  - [ ] Sets card theme, bottom sheet theme, input decoration theme using semantic tokens
- [ ] Task 5: Create `activeThemeProvider` (AC: 2, 3, 10)
  - [ ] `lib/features/settings/presentation/theme_provider.dart`
  - [ ] `@riverpod` class `ActiveTheme extends _$ActiveTheme implements Notifier<OdoTheme>`
  - [ ] `build()`: reads `SharedPreferences` for saved theme name; defaults to Violet Dark
  - [ ] `setTheme(OdoTheme)`: updates state + persists to SharedPreferences
- [ ] Task 6: Wire into `app/app.dart` (AC: 12)
  - [ ] `ConsumerWidget` wraps `MaterialApp`
  - [ ] Watches `activeThemeProvider` and passes `AppTheme.fromOdoTheme(theme)` to `MaterialApp.theme`
- [ ] Task 7: Lint check (AC: 13)
  - [ ] `flutter analyze` on all new files — zero issues

## Dev Notes

- **`google_fonts` offline caching:** The fonts are bundled; no network required at runtime. Add `GoogleFonts.config.allowRuntimeFetching = false` in `main.dart` to enforce offline-only font loading.
- **Material 3:** Use Material 3 (`useMaterial3: true`). Map `colorAccent` → `ColorScheme.primary`, `colorSurface` → `ColorScheme.surface`, `colorBackground` → `ColorScheme.background`.
- **Theme rebuild:** `ProviderScope` at the top of widget tree is set in `main.dart` (Story 1.7). The `Consumer`/`ConsumerWidget` in `app.dart` watches `activeThemeProvider` — this is the only place `ThemeData` is constructed.
- **Custom accent:** When `OdoTheme.customAccentHex` is set, `AppTheme.fromOdoTheme` substitutes the accent color before constructing `ThemeData`.
- **Fraunces** is a variable-weight serif — use `FontWeight.w600` for titles, `FontWeight.w400` for display body.

### Project Structure Notes

```
lib/
├── app/
│   ├── app.dart               # ConsumerWidget, watches activeThemeProvider
│   └── theme.dart             # AppTheme.fromOdoTheme()
├── core/constants/
│   ├── app_colors.dart        # from Story 1.2
│   ├── app_spacing.dart       # sp2-sp32, radius constants (this story)
│   ├── app_typography.dart    # textDisplay...textMicro (this story)
│   └── app_durations.dart     # durationFast/Default/Slow (this story)
└── features/settings/presentation/
    └── theme_provider.dart    # activeThemeProvider (this story)
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.3] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#Theme-System] — runtime swap pattern
- [Source: CLAUDE.md#UI-Design] — typography spec: Fraunces + DM Sans

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
