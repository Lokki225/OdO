# Story 5.6: Suggestion Engine (On-Device)

Status: ready-for-dev

## Story

As a developer,
I want a `SuggestionEngine` that produces proactive suggestions entirely on-device,
so that suggestions work offline.

## Acceptance Criteria

1. `lib/features/evening_session/domain/usecases/suggestion_engine.dart` (or `lib/features/proactive/domain/usecases/suggestion_engine.dart`) defines `SuggestionEngine`
2. `SuggestionEngine.generate(SuggestionEngineInput input) → Suggestion?` is the main method
3. Logic pipeline:
   - Query idle skills: `skills WHERE last_session_at < now - 24h` OR `last_session_at IS NULL`
   - Filter out suppressed skills: `suggestions WHERE suppressed_until > now` for those skill IDs
   - Compute free slots in next 48h: gaps ≥30 min between events
   - Rank: longest-idle skill first → shortest fitting free slot → earliest window
   - Return the first match as a `Suggestion` entity; return `null` if no match
4. Returns at most ONE suggestion per call
5. Persists the suggestion to `suggestions` table via repository
6. `SuggestionEngineInput` value class: `List<Skill> skills`, `List<Event> next48hEvents`, `List<Suggestion> existingSuggestions`, `DateTime now`
7. Unit tests cover: no idle skills → null; all skills suppressed → null; multiple slots + multiple skills → returns correct ranking (longest-idle skill, shortest slot, earliest window)
8. `SuggestionEngine` is pure Dart (no Flutter imports, no direct DB access)
9. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `Suggestion` domain entity (AC: 5)
  - [ ] `lib/features/proactive/domain/entities/suggestion.dart`
  - [ ] Fields mirror the `suggestions` table: `int? id`, `int? skillId`, `int slotStart`, `int slotDuration`, `int suggestedAt`, `int? acceptedAt`, `int? dismissedAt`, `int? thumbsDownAt`, `int? suppressedUntil`
- [ ] Task 2: `SuggestionEngineInput` value class (AC: 6)
  - [ ] Pure Dart, `@immutable`
- [ ] Task 3: Free slot detection helper (AC: 3)
  - [ ] `_freeSlots(List<Event> events, DateTime now, DateTime end) → List<TimeSlot>`
  - [ ] `TimeSlot`: `DateTime start`, `int durationMinutes`
  - [ ] Sort events by `startTime`; scan gaps; keep gaps ≥30 min
- [ ] Task 4: Ranking algorithm (AC: 3)
  - [ ] Sort idle skills by `lastSessionAt` ascending (longest idle first; null counts as very old)
  - [ ] For each idle skill: find shortest free slot that fits (durationMinutes >= some minimum, default 30 min)
  - [ ] Among same-score candidates: earliest slot wins
  - [ ] Return first match
- [ ] Task 5: `SuggestionEngine.generate()` (AC: 2–4, 8)
  - [ ] Apply suppression filter, call free slot detection, run ranking, return result
- [ ] Task 6: Repository + Drift DAO (AC: 5)
  - [ ] `lib/features/proactive/data/suggestion_dao.dart` — `insertSuggestion`, `getSuggestionsBySkill`, `getActiveSuggestions(DateTime now)`
  - [ ] `lib/features/proactive/data/repositories/suggestion_repository_impl.dart`
- [ ] Task 7: Unit tests (AC: 7)
  - [ ] `test/features/proactive/domain/usecases/suggestion_engine_test.dart`
  - [ ] All 3 test scenarios
- [ ] Task 8: Lint check (AC: 9)

## Dev Notes

- **Feature folder:** The `suggestions` table is referenced by both Glance Screen and background tasks. Put it in `lib/features/proactive/` or `lib/features/evening_session/` — pick one and be consistent. `proactive/` is recommended as its own feature.
- **Suppression filter:** Check `existing suggestions WHERE skill_id = skill.id AND suppressed_until > now.millisecondsSinceEpoch`. If any match found, skip that skill.
- **`last_session_at` is epoch ms:** Compare `skill.lastSessionAt < now - 24*3600*1000` (24h in ms). Null → treat as 0 (oldest possible).
- **Slot duration:** Use the skill's typical session duration from recent sessions, or default to 30 min if no history.
- **One suggestion per call:** `generate()` returns at most one. Caller decides when to call (evening check, app open, data shift). Multiple calls may return the same suggestion — avoid duplicate inserts by checking `existingSuggestions`.

### Project Structure Notes

```
lib/features/proactive/
├── domain/
│   ├── entities/suggestion.dart
│   └── usecases/suggestion_engine.dart
├── data/
│   ├── suggestion_dao.dart
│   └── repositories/suggestion_repository_impl.dart
└── presentation/
    └── proactive_providers.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.6] — ranking algorithm + suppression
- [Source: _bmad-output/planning-artifacts/architecture.md#SQLite-Schema] — suggestions table + suppressed_until logic

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List