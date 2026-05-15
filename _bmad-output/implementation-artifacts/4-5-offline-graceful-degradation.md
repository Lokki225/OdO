# Story 4.5: Offline Graceful Degradation

Status: ready-for-dev

## Story

As a developer,
I want all AI-dependent surfaces to degrade silently when offline,
so that the user never sees an error state.

## Acceptance Criteria

1. When offline, the chat preserves the user's message with *"Couldn't reach AI · Tap to retry"* — no error modals
2. The orb continues breathing at `OrbState.idle` when offline — no error overlay, no changed color
3. Voice capture still works offline; commands that don't require AI parsing (e.g. `"log 30 min Japanese"`) still commit via keyword/regex matching
4. The Agenda strip continues updating from local data when offline (it never calls AI directly)
5. The SuggestionEngine (on-device, Story 5.6) continues working offline
6. The evening session: if 8pm, opens with cached headline logic or a fallback template if AI is unreachable
7. `ConnectivityService.isOnline$` drives all offline state — single source of truth
8. No "offline mode" banner or label anywhere in the UI — degradation is invisible to the user
9. Unit tests: `ChatNotifier` offline flow → message preserved with retry flag; `VoiceService` offline → keyword matcher handles simple commands

## Tasks / Subtasks

- [ ] Task 1: Offline detection in `ChatNotifier` (AC: 1)
  - [ ] Already implemented in Story 4.3. Verify: `connectivityServiceProvider.isCurrentlyOnline` checked before AI call
  - [ ] If offline: append `ChatMessageViewModel` with `failedOffline: true`; user message stays in thread
- [ ] Task 2: Orb offline behavior (AC: 2)
  - [ ] `orbStateProvider` must not change to an error state when connectivity drops
  - [ ] Orb stays `OrbState.idle` regardless of connectivity — verify this is the default behavior
- [ ] Task 3: Keyword matcher for offline voice (AC: 3)
  - [ ] `lib/features/ai/domain/usecases/keyword_command_matcher.dart`
  - [ ] `KeywordCommandMatcher.match(String transcript) → ParsedIntent?`
  - [ ] Patterns: `"log [N] min [skill]"` → `LogSessionIntent`; `"add event [title]"` → `CreateEventIntent`; etc.
  - [ ] Called BEFORE AI parse in `VoicePipelineNotifier`; if match found, skip AI call
  - [ ] Returns null if no keyword match (caller then tries AI parse, which may fail offline)
- [ ] Task 4: Evening session fallback headline (AC: 6)
  - [ ] In `EveningSessionNotifier.start()` (Story 5.4): if offline, use fallback template string instead of AI headline
  - [ ] Fallback: `"Voici votre bilan du ${formatDate(today)}"` or a set of 5 rotating canned headlines
- [ ] Task 5: Verify agenda strip offline (AC: 4)
  - [ ] `AgendaStrip` watches `watchEventsForDay` (Drift stream — local only). No change needed. Document this as verified.
- [ ] Task 6: Integration test (AC: 9)
  - [ ] Mock `ConnectivityService` returning offline
  - [ ] Verify `ChatNotifier.sendMessage` sets `failedOffline: true`
  - [ ] Verify `KeywordCommandMatcher` handles "log 30 min Japanese" correctly
- [ ] Task 7: Lint check

## Dev Notes

- **Single source of truth:** `connectivityServiceProvider` is the only place connectivity is checked. Don't check `http` exception types to infer offline state — use `ConnectivityService` proactively.
- **"Invisible degradation" principle:** No offline banner, no mode label. The only visible signal of offline state is the retry message under a failed chat message.
- **Keyword matcher regex examples:**
  - Log session: `RegExp(r'log\s+(\d+)\s+min\s+(.+)', caseSensitive: false)`
  - Add event: `RegExp(r'add\s+event\s+(.+)', caseSensitive: false)`
  - Keep it simple — 3–5 patterns max; this is a fallback, not a full NLU engine.
- **`ConnectivityService.isCurrentlyOnline`:** Synchronous getter returning the last known state. Acceptable for pre-request check; the stream handles real-time state changes.

### Project Structure Notes

```
lib/features/ai/domain/usecases/
└── keyword_command_matcher.dart

(Other changes: ChatNotifier already in ai_providers.dart, EveningSessionNotifier in epic 5)
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-4.5] — six degradation scenarios
- [Source: _bmad-output/planning-artifacts/architecture.md#Critical-Technical-Risks] — background task fallback pattern

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List