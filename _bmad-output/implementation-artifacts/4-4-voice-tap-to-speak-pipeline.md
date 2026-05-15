# Story 4.4: Voice Tap-to-Speak Pipeline

Status: ready-for-dev

## Story

As a user,
I want to tap the mic and speak to OdO,
so that voice is a first-class input.

## Acceptance Criteria

1. Tapping the mic toggle in the AI bottom bar starts the voice pipeline
2. The orb morphs to `OrbState.listening` (waveform animation)
3. `VoiceService.startListening()` is called; transcript accumulates in real time
4. 1.5 seconds of silence triggers `OrbState.parsing` — orb pulses
5. Transcript is sent to `AiService.parseCommand(String transcript) → ParsedIntent`
6. **Clear intents** commit immediately: "create event at 7pm tonight" → opens add-event sheet pre-filled; "log 30 min Japanese" → logs session; "add skill guitar" → adds skill
7. **Ambiguous intents** show a single-line follow-up question above the bottom bar (not a full sheet)
8. STT failure silently returns the orb to idle — no error toast, no error banner
9. Tapping the mic during listening cancels the pipeline and returns to idle
10. After commit, the orb transitions to `OrbState.committed` (bright pulse + checkmark) then returns to `OrbState.idle`
11. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `ParsedIntent` types (AC: 5, 6, 7)
  - [ ] `lib/features/ai/domain/entities/parsed_intent.dart`
  - [ ] Sealed class: `CreateEventIntent(String title, DateTime? startTime)`, `LogSessionIntent(String skillName, int? durationMinutes)`, `AddSkillIntent(String name)`, `AmbiguousIntent(String followUpQuestion)`, `UnrecognizedIntent()`
- [ ] Task 2: `AiService.parseCommand` (AC: 5)
  - [ ] Sends transcript + system prompt to AI: *"Parse this voice command into a structured action: {transcript}"*
  - [ ] System prompt defines the output format (JSON with `intent_type` and fields)
  - [ ] Parse JSON response → `ParsedIntent`
  - [ ] On AI failure → return `UnrecognizedIntent()`
- [ ] Task 3: Voice pipeline orchestration in `AiBottomBar` / new `VoicePipelineNotifier` (AC: 1–10)
  - [ ] `lib/features/ai/presentation/ai_providers.dart`
  - [ ] `voicePipelineNotifier`: `AsyncNotifier<VoicePipelineState>`
  - [ ] States: `idle`, `listening`, `parsing`, `committed`, `ambiguous(question)`
  - [ ] `startListening()`: calls `voiceService.startListening()` → watch state stream → on `parsing` trigger → call `parseCommand(transcript)`
  - [ ] `cancelListening()`: calls `voiceService.cancelListening()` → return to idle
  - [ ] On clear intent: dispatch to appropriate notifier (AgendaNotifier, PracticeNotifier)
  - [ ] On ambiguous: update state to `ambiguous(question)` — UI shows follow-up line
  - [ ] On committed: orb → `OrbState.committed` for `durationDefault` → then idle
- [ ] Task 4: Ambiguous intent follow-up UI (AC: 7)
  - [ ] Thin `AnimatedContainer` above the bottom bar showing the follow-up question
  - [ ] Second STT trigger can answer the follow-up (same pipeline)
- [ ] Task 5: Orb state wiring (AC: 2, 4, 10)
  - [ ] `orbStateProvider`: `Provider<OrbState>` derived from `voicePipelineNotifier` state
  - [ ] Passed to `Orb` widget (Story 5.3)
- [ ] Task 6: Lint check (AC: 11)

## Dev Notes

- **STT → AI parse flow:** The transcript from `VoiceService` is a plain string. `AiService.parseCommand` sends it to Claude with a structured system prompt asking for JSON output. Parse the JSON response to determine the intent type.
- **System prompt for parsing:** Keep it small (under 200 chars) to avoid consuming too much of the 4k context cap. Example: `"Parse: {transcript}\nOutput JSON: {intent_type, title?, skill_name?, duration_min?, start_time?, question?}"`
- **Offline voice commands:** Simple commands that don't need AI parsing (literally "log 30 min Japanese") should be handled by a regex/keyword matcher before calling AI. This is the offline path mentioned in Story 4.5.
- **`VoiceService` 1.5s timer:** Implemented in Story 1.6. The timer fires a state transition from `listening` → `parsing`. `VoicePipelineNotifier` listens to `voiceService.stateStream$` to detect this.
- **Error handling:** STT permission denied → silent fail, orb returns to idle. Network error during AI parse → `UnrecognizedIntent()` → orb idle.

### Project Structure Notes

```
lib/features/ai/
├── domain/entities/parsed_intent.dart
└── presentation/ai_providers.dart   # VoicePipelineNotifier, orbStateProvider
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-4.4] — state machine spec
- [Source: _bmad-output/planning-artifacts/architecture.md#Voice-Failure-Modes] — silent fail on STT failure

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List