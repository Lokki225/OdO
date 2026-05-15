# Story 1.2: Design Tokens and Color System (Two-Layer, Seven Themes)

Status: ready-for-dev

## Story

As a developer,
I want to define the two-layer color token system with seven theme presets,
so that all UI components use semantic tokens and theme switching is centralized.

## Acceptance Criteria

1. `lib/core/constants/app_colors.dart` exists and defines the raw palette: `violetPrimary`, `cyanPrimary`, `greenPrimary`, `emberOrange`, `cosmicMagenta`, `auroraTeal`, `darkBg` (`#0D0D0F`), `lightBg` (`#FDF8F2`)
2. Raw palette constants are never used directly in widgets — only in `AppTheme` builder
3. Semantic tokens defined as named constants (not hardcoded values in widgets): `colorAccent`, `colorAccentAgenda`, `colorAccentWork`, `colorAccentPractice`, `colorSurface`, `colorBackground`, `colorTextPrimary`, `colorTextMuted`, `colorBorder`, `colorOrbIdle`, `colorOrbActive`
4. Seven theme maps defined as `OdoTheme` data class instances: Violet Dark, Cyan Dark, Green Dark, Light Mode, Cosmic, Ember, Aurora
5. Custom accent override is supported: stored as hex string in `SharedPreferences` key `custom_accent_hex`; overrides only `colorAccent`, `colorOrbIdle`, `colorOrbActive` in the active theme
6. Category colors defined as fixed semantic tokens: `colorCategoryPersonal` (violet), `colorCategoryWork` (blue), `colorCategoryPractice` (green)
7. `app_colors.dart` compiles, passes `flutter analyze`, and exports all tokens via top-level constants
8. No widget file anywhere in `lib/` imports raw palette values directly — all go through semantic tokens

## Tasks / Subtasks

- [ ] Task 1: Define raw palette (AC: 1, 2)
  - [ ] Create `lib/core/constants/app_colors.dart`
  - [ ] Add raw `Color` constants for all palette entries
  - [ ] Mark palette class/namespace as `@visibleForTesting` or document "only for AppTheme use"
- [ ] Task 2: Define `OdoTheme` data class (AC: 4)
  - [ ] Create `lib/core/constants/odo_theme.dart` with `OdoTheme` immutable class
  - [ ] Fields: `name`, `colorAccent`, `colorBackground`, `colorSurface`, `colorTextPrimary`, `colorTextMuted`, `colorBorder`, `colorOrbIdle`, `colorOrbActive`, `isDark`
- [ ] Task 3: Define seven theme instances (AC: 4)
  - [ ] Violet Dark: accent `#7C4DFF`, bg `#0D0D0F`, surface `#1A1A1F`
  - [ ] Cyan Dark: accent `#00BCD4`, bg `#0D0D0F`, surface `#1A1A1F`
  - [ ] Green Dark: accent `#1D9E75`, bg `#0D0D0F`, surface `#1A1A1F`
  - [ ] Light Mode: accent `#8B6C4F`, bg `#FDF8F2`, surface `#F5EDE0`
  - [ ] Cosmic: accent `#E040FB`, bg `#0A0014`, surface `#120025`
  - [ ] Ember: accent `#FF6E40`, bg `#0F0A00`, surface `#1A1200`
  - [ ] Aurora: accent `#00BFA5`, bg `#001A14`, surface `#00261C`
- [ ] Task 4: Define semantic token accessors (AC: 3, 6)
  - [ ] Semantic tokens derived from active `OdoTheme` — exposed via extension or static helpers
  - [ ] Category colors: Personal=`violetPrimary`, Work=`#2196F3`, Practice=`greenPrimary` (fixed, not theme-dependent)
- [ ] Task 5: Custom accent support (AC: 5)
  - [ ] Add `customAccentHex` field to `OdoTheme` (nullable)
  - [ ] When non-null, override accent, orbIdle, orbActive tokens
- [ ] Task 6: Lint & compile check (AC: 7, 8)
  - [ ] Run `flutter analyze lib/core/constants/`
  - [ ] Grep for raw hex color literals in `lib/features/` — zero allowed

## Dev Notes

- **Two-layer rule:** Layer 1 = raw palette (`AppColors._violetPrimary`). Layer 2 = semantic tokens (from `OdoTheme` fields). Widgets only ever reference Layer 2.
- **`OdoTheme` is pure Dart** — no Flutter imports needed for data class; `Color` from `dart:ui`
- **Immutability:** Use `@immutable` + `const` constructors on `OdoTheme`
- **google_fonts:** NOT imported in this file — fonts are part of theme.dart in Story 1.3
- **Dark bg `#0D0D0F`** is OLED-optimized black — this is a non-negotiable from the product brief
- **Semantic token naming:** prefix `color` on all tokens to distinguish from spacing/radius tokens

### Project Structure Notes

```
lib/core/constants/
├── app_colors.dart     # raw palette + OdoTheme data class + 7 instances
├── app_spacing.dart    # Story 1.3
└── app_typography.dart # Story 1.3
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.2] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#Theme-System] — two-layer color token system
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md] — visual palette values

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
