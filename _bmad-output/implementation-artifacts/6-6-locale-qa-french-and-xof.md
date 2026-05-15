# Story 6.6: Locale QA — French and XOF

Status: ready-for-dev

## Story

As a francophone user,
I want OdO to feel native in French and Ivorian context,
so that nothing feels imported.

## Acceptance Criteria

1. All UI strings are in French by default — button labels, placeholder text, empty states, error messages, snackbars, bottom sheet titles
2. An English fallback is available in Settings under "Language" — switching to English re-renders all strings
3. XOF currency renders as `15 000 F` (thin-space U+202F thousands separator, no decimals, space + F suffix)
4. Dates render as DD/MM/YYYY everywhere (agenda strip, event detail, session log, evening session)
5. Times render in 24-hour format HH:mm everywhere
6. `LocaleService.formatXof`, `formatDate`, `formatTime` tests pass (written in Story 1.6)
7. A francophone speaker (Lokki) reviews and confirms natural French in all UI strings
8. AI responses remain in English in V1 (French AI deferred to V1.5) — this is documented, not a bug
9. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: String audit — French (AC: 1)
  - [ ] Search all widget files for English strings: `grep -rn '"[A-Z]' lib/features/` — list all hardcoded English strings
  - [ ] Create string constants or l10n file: `lib/core/constants/app_strings.dart` with `static const` string maps
  - [ ] Replace all hardcoded English strings with French equivalents
  - [ ] Key strings to translate:
    - "Nothing scheduled — free day" → "Rien de prévu — journée libre"
    - "Add your first event" → "Ajouter votre premier événement"
    - "No skills yet" → "Aucune compétence pour l'instant"
    - "What's one skill you're working on?" → "Sur quelle compétence travaillez-vous en ce moment ?"
    - "Add it" → "Ajouter"
    - "Block it" → "Bloquer"
    - "Not now" → "Pas maintenant"
    - "Don't suggest this again" → "Ne plus suggérer"
    - "Your evening with OdO is ready" → "Votre soirée avec OdO est prête"
    - "Wrap up" → "Terminer"
- [ ] Task 2: Language toggle in settings (AC: 2)
  - [ ] `lib/features/settings/presentation/pages/settings_page.dart`
  - [ ] `activeLocaleProvider`: `StateProvider<Locale>` defaulting to `Locale('fr')`
  - [ ] `MaterialApp.locale: ref.watch(activeLocaleProvider)`
  - [ ] `app_strings.dart` keys resolve to French or English based on active locale
- [ ] Task 3: XOF formatting verification (AC: 3)
  - [ ] `LocaleService.formatXof(15000)` → `'15 000 F'` (thin space is U+202F)
  - [ ] Verify thin-space renders correctly on Android and iOS
  - [ ] If thin-space causes layout issues: fall back to regular space and document the trade-off
- [ ] Task 4: Date/time format verification (AC: 4, 5)
  - [ ] Audit all date/time display in the app — all must go through `LocaleService.formatDate` and `LocaleService.formatTime`
  - [ ] `grep -rn "DateFormat\|DateTime\|toString" lib/features/` — review each; replace any direct formatting with `LocaleService`
- [ ] Task 5: Francophone review (AC: 7)
  - [ ] Lokki reviews all French strings — mark complete after review
  - [ ] Document any corrections in Dev Agent Record
- [ ] Task 6: Lint check (AC: 9)

## Dev Notes

- **No `intl` l10n infrastructure needed for V1:** Given it's a single-user app with 2 languages, a simple `app_strings.dart` with an `activeLocale` check is sufficient. No `.arb` files, no `flutter gen-l10n`, no localization delegates.
- **String approach:** `AppStrings.get(key, locale)` or `AppStrings.nothingScheduled(locale)` static methods. Simple, no dependencies.
- **Thin-space U+202F:** In Dart string: `' '`. Test on device — some fonts render it as zero-width on certain Android versions. Test on API 30+ Android and iOS 16+.
- **AI in English:** When OdO responds in the chat or generates headlines/summaries, it does so in English in V1. Add a visible label *"OdO responds in English"* (small, `textCaption`, `colorTextMuted`) in the chat sheet header.

### Project Structure Notes

```
lib/core/constants/app_strings.dart   # all UI strings, French + English
lib/features/settings/presentation/pages/settings_page.dart  # locale toggle
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-6.6] — locale requirements
- [Source: 1-6-core-services.md] — LocaleService.formatXof/formatDate/formatTime

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List