# Story 6.2: Light Mode — Outdoor Readability

Status: ready-for-dev

## Story

As a user in direct Abidjan sunlight,
I want light mode to be genuinely readable outdoors,
so that OdO works wherever I am.

## Acceptance Criteria

1. Light Mode theme (`OdoTheme` with `isDark: false`) is complete with all semantic tokens correctly set for light backgrounds
2. All text in Light Mode has contrast ≥7:1 against its background (enhanced AA, targeting AAA for body text given outdoor use case)
3. The orb is visible against the light background (`colorOrbIdle` uses a warm/amber tint at sufficient opacity)
4. Category colors (Personal/Work/Practice) remain visually distinguishable in light mode
5. The agenda strip and event blocks in the timeline are readable without color alone (icon or label always paired)
6. The Light Mode palette: `colorBackground = #FDF8F2`, `colorSurface = #F5EDE0`, `colorAccent = #8B6C4F` (warm brown), `colorTextPrimary = #1A1208`, `colorTextMuted = #6B5744`
7. Manual readability test confirmed by Lokki in direct sunlight (acceptance by user, not automated test)
8. `flutter analyze` passes on all light mode token files

## Tasks / Subtasks

- [ ] Task 1: Verify Light Mode `OdoTheme` instance (AC: 1, 6)
  - [ ] In `app_colors.dart`, confirm Light Mode `OdoTheme` uses the exact palette from AC 6
  - [ ] All semantic tokens have correct values: text on surface, text on background, border contrast
- [ ] Task 2: Contrast audit (AC: 2)
  - [ ] Check each text/background combination: `colorTextPrimary (#1A1208)` on `colorBackground (#FDF8F2)` → compute ratio
  - [ ] Check `colorTextMuted (#6B5744)` on `#FDF8F2` → must be ≥4.5:1
  - [ ] Check event block text on category-colored backgrounds
  - [ ] Fix any failing combinations by adjusting token values
- [ ] Task 3: Orb visibility (AC: 3)
  - [ ] Light mode `colorOrbIdle`: use `colorAccent.withOpacity(0.3)` (30% opacity) — darker orb visible on light bg
  - [ ] `colorOrbActive`: full `colorAccent` opacity — warm brown orb when listening
- [ ] Task 4: Category color check (AC: 4)
  - [ ] In light mode, category colors may need a darker variant for text legibility
  - [ ] Left-bar color: keep original saturated colors for the border (visual marker, not text)
  - [ ] Text inside event blocks: always `colorTextPrimary` (never category color for text)
- [ ] Task 5: Agenda strip light mode review (AC: 5)
  - [ ] Verify strip background contrasts against both light and dark themes
  - [ ] Event titles always use `colorTextPrimary` — never category color for text
- [ ] Task 6: Lint check (AC: 8)

## Dev Notes

- **Contrast ratio formula:** `ratio = (L1 + 0.05) / (L2 + 0.05)` where `L = 0.2126*R + 0.7152*G + 0.0722*B` (linearized). For `#1A1208` on `#FDF8F2`: L_dark ≈ 0.009, L_light ≈ 0.960, ratio ≈ 20:1 — excellent.
- **Warm outdoor palette:** `#FDF8F2` (ivory) base was specifically chosen for reduced glare vs. pure white `#FFFFFF`. Pure white causes glare outdoors; the ivory tint helps.
- **`colorTextMuted #6B5744`:** At 4.5:1 against `#FDF8F2` — must verify. If below 4.5:1, darken to `#5A4535`.
- **Manual test:** This story is complete only when Lokki tests it outdoors and confirms. Document the result in the Dev Agent Record after manual confirmation.

### Project Structure Notes

Light mode is defined in `lib/core/constants/app_colors.dart` — no new files needed.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-6.2] — 7:1 contrast, outdoor readability
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md] — light mode palette

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List