# Story 6.7: First-Launch Flow

Status: ready-for-dev

## Story

As a first-time user,
I want OdO to be useful within 5 minutes of install,
so that I don't have to learn anything.

## Acceptance Criteria

1. On very first app open (no `SharedPreferences` key `onboarding_complete`), the Glance Screen onboarding runs
2. Glance Screen onboarding: step 1 — set unlock phrase (required), step 2 — optional biometric enrollment
3. After onboarding, the home screen renders with empty Agenda strip and empty Practice list
4. The first-launch skill prompt appears automatically: "What's one skill you're working on?" (already in Story 3.2)
5. The user can add their first event via voice (`"add event"` via mic) or quick-add (`+` button)
6. At 8pm, the first evening session opens (via notification or app-open fallback)
7. Total time from install to "first useful state" is ≤5 minutes with no written instructions needed
8. `onboarding_complete` flag set to `true` in `SharedPreferences` after onboarding finishes — never shows again
9. Widget test: first launch → onboarding screen shows; post-onboarding → home screen shows

## Tasks / Subtasks

- [ ] Task 1: `onboardingCompleteProvider` (AC: 1, 8)
  - [ ] `lib/features/settings/presentation/settings_providers.dart`
  - [ ] `onboardingCompleteProvider`: `FutureProvider<bool>` — reads `prefs.getBool('onboarding_complete') ?? false`
  - [ ] `markOnboardingComplete()`: sets `prefs.setBool('onboarding_complete', true)`
- [ ] Task 2: Onboarding routing (AC: 1, 3)
  - [ ] In `GoRouter.redirect`: if `onboardingCompleteProvider` is false → redirect to `/onboarding`
  - [ ] Route `/onboarding`: renders `OnboardingPage`
- [ ] Task 3: `OnboardingPage` (AC: 2)
  - [ ] `lib/features/settings/presentation/pages/onboarding_page.dart`
  - [ ] Step 1: Unlock phrase setup — `UnlockPhraseSetupPage` (already created in Story 5.2)
  - [ ] Step 2: Biometric prompt — `local_auth.isDeviceSupported()` → if yes, show biometric toggle; if no, skip
  - [ ] Final step: "OdO est prêt !" confirmation screen → button → `markOnboardingComplete()` → `context.go('/glance')`
  - [ ] `PageView` or `Stepper` for multi-step flow
- [ ] Task 4: Skip biometric option (AC: 2)
  - [ ] Step 2 has "Use biometric" toggle (default off) and "Skip" button
  - [ ] Skip → proceed to confirmation step
- [ ] Task 5: Post-onboarding state (AC: 3, 4)
  - [ ] After `context.go('/glance')`, the Glance Screen shows; home screen shows empty states
  - [ ] First-launch skill prompt auto-shows (Story 3.2 handles this)
- [ ] Task 6: Widget tests (AC: 9)
- [ ] Task 7: Lint check

## Dev Notes

- **Router redirect timing:** `GoRouter.redirect` fires on every navigation. Cache `onboardingComplete` value to avoid re-reading SharedPreferences on every route change. Use `ref.read` not `ref.watch` in the redirect function.
- **Onboarding page skip protection:** The `/onboarding` route must not be navigable-away-from via back button. Use `PopScope(canPop: false)` on `OnboardingPage`.
- **5-minute target:** The entire onboarding is 2 steps + 1 confirmation. Should take under 60 seconds. The first-launch skill prompt adds another 30 seconds. First event via voice: 30 seconds. Total ≈ 2 minutes to first useful state.
- **Biometric enrollment:** OdO does not enroll the biometric — it just checks if the device has biometrics configured (`isDeviceSupported() && getAvailableBiometrics().isNotEmpty`). If not enrolled, skip biometric step entirely.

### Project Structure Notes

```
lib/features/settings/presentation/
├── pages/onboarding_page.dart
└── settings_providers.dart    # onboardingCompleteProvider
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-6.7] — 5-minute onboarding spec
- [Source: 5-2-glance-screen-authentication.md] — UnlockPhraseSetupPage

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List