# Story 5.2: Glance Screen — Authentication

Status: ready-for-dev

## Story

As a user,
I want to unlock the Glance Screen with vocal password, typed password, or biometric,
so that OdO is private without being annoying.

## Acceptance Criteria

1. Three unlock paths: (a) vocal — speak "Hey OdO, unlock — [phrase]"; (b) typed — tap text input, type phrase, submit; (c) biometric — swipe up triggers `local_auth` prompt (if enabled in settings)
2. STT validates the spoken phrase against the stored unlock phrase (stored in `SharedPreferences` as a plain string)
3. Successful unlock: lock icon morphs to green (unlocked), `glanceLockStateProvider` set to false
4. Three consecutive vocal failures lock the vocal path for 5 minutes (typed becomes the only path during lockout)
5. Unlock phrase is set during first-launch Glance Screen onboarding (Story 6.7 integrates this into the full first-launch flow)
6. Unlock state persists for the app session; screen re-locks on app background after configurable timeout (default: 5 minutes, stored in `SharedPreferences`)
7. `local_auth` biometric: triggered by swipe-up gesture on the Glance Screen; uses `localAuth.authenticate(localizedReason: 'Unlock OdO')`
8. Biometric can be enabled/disabled in settings; if disabled, swipe-up shows the typed path instead
9. Widget tests: vocal 3 failures → vocal locked for 5 min; successful typed → unlocked state

## Tasks / Subtasks

- [ ] Task 1: `GlanceAuthNotifier` (AC: 1–6)
  - [ ] `lib/features/glance/presentation/glance_providers.dart`
  - [ ] `glanceAuthNotifier`: `AsyncNotifier<GlanceAuthState>`
  - [ ] `GlanceAuthState`: `sealed class` — `locked`, `unlocked`, `vocalLocked(DateTime until)`
  - [ ] `tryVocalUnlock(String transcript)`: compares transcript (lowercased, trimmed) to stored phrase
    - On match: set `glanceLockStateProvider` to false; reset failure count
    - On mismatch: increment failure count; if ≥3: set `vocalLocked(now + 5 min)`, persist to SharedPreferences
  - [ ] `tryTypedUnlock(String text)`: same comparison; no failure limit
  - [ ] `tryBiometricUnlock()`: calls `localAuth.authenticate(...)`, on success sets unlocked
  - [ ] `lockOnBackground()`: sets locked state + `glanceLockStateProvider` true
- [ ] Task 2: Re-lock on app background (AC: 6)
  - [ ] `AppLifecycleListener` in `app.dart` (or `GlancePage`): on `AppLifecycleState.paused`, start a 5-min timer; on `resumed`, if timer elapsed → call `lockOnBackground()`
- [ ] Task 3: Vocal lockout timer (AC: 4)
  - [ ] Persist `vocal_lock_until` epoch ms in SharedPreferences
  - [ ] On app restart: check if `vocal_lock_until > DateTime.now().ms` → restore `vocalLocked` state
- [ ] Task 4: Typed unlock UI (AC: 1b)
  - [ ] Tap text input in bottom bar → keyboard appears with a hidden text field for the passphrase
  - [ ] Submit → `tryTypedUnlock(text)` → feedback (success: green icon; fail: shake animation)
- [ ] Task 5: Biometric setup (AC: 7, 8)
  - [ ] Add `local_auth` check: `localAuth.isDeviceSupported()` before showing biometric option
  - [ ] Swipe-up `GestureDetector` on `SlideUpHandle` → if biometric enabled → `tryBiometricUnlock()`, else show typed input
- [ ] Task 6: Onboarding phrase setup (AC: 5)
  - [ ] `lib/features/glance/presentation/pages/unlock_phrase_setup_page.dart`
  - [ ] Simple form: enter phrase + confirm phrase → save to `SharedPreferences` key `unlock_phrase`
  - [ ] Called from first-launch flow (Story 6.7)
- [ ] Task 7: Widget tests (AC: 9)
- [ ] Task 8: Lint check

## Dev Notes

- **STT for vocal unlock:** Uses `VoiceService.startListening()` — same as Story 4.4. The transcript is compared against the stored phrase using `transcript.toLowerCase().contains(storedPhrase.toLowerCase())` (partial match accepted for robustness).
- **Phrase storage:** Plain text in `SharedPreferences` — this is acceptable for V1 (single-user, local). No hashing needed for V1.
- **`local_auth` API:** `LocalAuthentication().authenticate(localizedReason: 'string', options: AuthenticationOptions(biometricOnly: false))`.
- **5-min re-lock:** Use `AppLifecycleObserver` mixin. Timer precision is sufficient — ±30 seconds acceptable.
- **`vocalLocked` persistence:** Persist the `until` timestamp so lockout survives app restart (user can't bypass by killing the app).

### Project Structure Notes

```
lib/features/glance/presentation/
├── glance_providers.dart     # GlanceAuthNotifier, GlanceAuthState
└── pages/
    └── unlock_phrase_setup_page.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.2] — three unlock paths, 3-failure lockout
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Pattern-Glance-Screen] — auth flow

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List