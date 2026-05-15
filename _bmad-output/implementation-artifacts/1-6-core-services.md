# Story 1.6: Core Services

Status: ready-for-dev

## Story

As a developer,
I want stateless supporting services for connectivity, notifications, background tasks, voice, and locale,
so that features can depend on them via Riverpod injection.

## Acceptance Criteria

1. `ConnectivityService` in `lib/core/services/connectivity_service.dart` exposes `Stream<bool> isOnline$` via `connectivity_plus`
2. `NotificationService.initialize()` in `lib/core/services/notification_service.dart` configures `flutter_local_notifications` with timezone init via the `timezone` package
3. `BackgroundTaskService.initialize()` in `lib/core/services/background_task_service.dart` registers `workmanager` with the `callbackDispatcher` function and the 8pm task name constant
4. `VoiceService` in `lib/core/services/voice_service.dart` wraps `speech_to_text` (STT) and `flutter_tts` (TTS) with a clean state machine: `idle → listening → parsing → committing → committed`
5. `LocaleService` in `lib/core/services/locale_service.dart` provides: `formatXof(int amount) → String` (no decimals, thin-space thousands: `15 000 F`), `formatDate(DateTime dt) → String` (DD/MM/YYYY), `formatTime(DateTime dt) → String` (24-hour HH:mm)
6. All five services are exposed via Riverpod providers in `lib/core/services/service_providers.dart`
7. Unit tests for `LocaleService.formatXof(15000)` returns `'15 000 F'`, `formatXof(0)` returns `'0 F'`, `formatDate(DateTime(2026,5,13))` returns `'13/05/2026'`
8. Unit tests for `VoiceService` state machine transitions: idle→listening, listening→parsing (on silence), parsing→committed (on result), any→idle (on cancel)
9. All files pass `flutter analyze` with no issues

## Tasks / Subtasks

- [ ] Task 1: `ConnectivityService` (AC: 1)
  - [ ] Constructor accepts `Connectivity` instance (injectable for tests)
  - [ ] `Stream<bool> isOnline$` maps `ConnectivityResult` to bool
  - [ ] `bool get isCurrentlyOnline` for synchronous check
- [ ] Task 2: `NotificationService` (AC: 2)
  - [ ] `Future<void> initialize()`: sets up Android channel (`odo_channel`, high importance) and iOS permissions
  - [ ] `Future<void> scheduleEventReminder({required int eventId, required DateTime eventStart, required String title})`: schedules notification at `eventStart - 5 min`
  - [ ] `Future<void> cancelReminder(int eventId)`: cancels by event ID
  - [ ] `Future<void> showEveningSessionNotification()`: shows "Your evening with OdO is ready" at 8pm
  - [ ] Timezone init: `tz.initializeTimeZones()` + `tz.setLocalLocation(tz.getLocation('Africa/Abidjan'))`
- [ ] Task 3: `BackgroundTaskService` (AC: 3)
  - [ ] Top-level `@pragma('vm:entry-point') void callbackDispatcher()` function (must be top-level, not a class method)
  - [ ] Registers two tasks: `'odo.evening_check'` (periodic, daily at 8pm best-effort), `'odo.data_shift_check'` (one-shot on demand)
  - [ ] `initialize()`: calls `Workmanager().initialize(callbackDispatcher)`
  - [ ] `scheduleEveningCheck()`: registers periodic task with initial delay calculated to next 8pm
- [ ] Task 4: `VoiceService` (AC: 4)
  - [ ] `VoiceState` enum: `idle, listening, parsing, committing, committed`
  - [ ] `startListening()`: calls `SpeechToText.listen()`, updates state to `listening`
  - [ ] `stopListening()`: triggers `parsing` state after 1.5s silence (use `Timer` in the speech callback)
  - [ ] `cancelListening()`: returns to `idle`, discards transcript
  - [ ] `speak(String text)`: calls `FlutterTts.speak(text)`
  - [ ] `Stream<VoiceState> stateStream$` exposed via `StreamController`
- [ ] Task 5: `LocaleService` (AC: 5)
  - [ ] `formatXof(int amount)`: use `intl` `NumberFormat` with grouping separator = thin-space (U+202F), no decimals, suffix ` F`
  - [ ] `formatDate(DateTime dt)`: `DateFormat('dd/MM/yyyy').format(dt)`
  - [ ] `formatTime(DateTime dt)`: `DateFormat('HH:mm').format(dt)`
  - [ ] All methods are pure functions (no state)
- [ ] Task 6: Riverpod providers (AC: 6)
  - [ ] `connectivityServiceProvider`: `Provider<ConnectivityService>`
  - [ ] `notificationServiceProvider`: `Provider<NotificationService>`
  - [ ] `backgroundTaskServiceProvider`: `Provider<BackgroundTaskService>`
  - [ ] `voiceServiceProvider`: `Provider<VoiceService>`
  - [ ] `localeServiceProvider`: `Provider<LocaleService>`
- [ ] Task 7: Unit tests (AC: 7, 8)
  - [ ] `test/core/services/locale_service_test.dart` — formatXof and formatDate tests
  - [ ] `test/core/services/voice_service_test.dart` — state machine transition tests
- [ ] Task 8: Lint check (AC: 9)
  - [ ] `flutter analyze lib/core/services/` — zero issues

## Dev Notes

- **`callbackDispatcher` MUST be top-level** — `workmanager` uses platform channels to invoke it from the background isolate. Class methods will not work.
- **Thin-space for XOF:** Unicode thin space is U+202F (` `). Use it as the grouping separator in `NumberFormat`. `NumberFormat('#,##0', 'fr_FR')` uses normal space; override grouping separator manually.
- **Timezone:** `Africa/Abidjan` is UTC+0 year-round (no DST). Use this for all notification scheduling.
- **`SpeechToText` init:** `initialize()` is async; must be called before `listen()`. Keep state as `SpeechToTextStatus.available` check.
- **VoiceService state machine:** The 1.5s silence timer starts inside `SpeechToText.onStatus` callback when status transitions to `'notListening'`. Cancel the timer on `cancelListening()`.
- **`FlutterTts` on Android:** Set language `'fr-FR'` for French, `'en-US'` fallback. Speed rate 0.5 (calm pace).
- **Service initialization order in `main.dart`** (Story 1.7): NotificationService → BackgroundTaskService → ProviderScope.

### Project Structure Notes

```
lib/core/services/
├── connectivity_service.dart
├── notification_service.dart
├── background_task_service.dart
├── voice_service.dart
├── locale_service.dart
└── service_providers.dart     # all Riverpod providers for services
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.6] — acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#Supporting-Services] — service design
- [Source: _bmad-output/planning-artifacts/architecture.md#Background-Task-Reliability] — workmanager pattern + callbackDispatcher

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
