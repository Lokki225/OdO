# Story 4.1: Context Builder (4k Cap, Priority-Ordered)

Status: ready-for-dev

## Story

As a developer,
I want a `ContextBuilder` that produces an AI context payload ≤4,000 characters,
so that the AI provider receives a focused, defensible payload.

## Acceptance Criteria

1. `lib/features/ai/domain/usecases/context_builder.dart` defines `ContextBuilder` class
2. `ContextBuilder.build(ContextBuilderInput input) → AiContextPayload` builds the payload from local data
3. Payload sections included in priority order:
   - P1: current datetime + active screen name
   - P2: today's events + next 48h events (titles, times, categories)
   - P3: all skills with current streak only
   - P4: last 7 days unanchored sessions (skill name, date, duration)
   - P5: last 3 suggestions with their outcomes (accepted/dismissed/thumbs-down)
4. Total character count of `payload.contextText` is ≤4,000 characters
5. Truncation drops P5 first, then P4, then P3 — never truncates P1 or P2
6. The payload is built only inside `AiService` — never constructed in widget code
7. `ContextBuilderInput` is a pure Dart value class with all required data pre-fetched
8. Unit tests cover: empty data → valid payload; full data within 4k; oversize data → truncation drops lowest priority; character count exactly at boundary
9. `ContextBuilder` is pure Dart — no Flutter imports, no database access
10. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `ContextBuilderInput` value class (AC: 7)
  - [ ] `lib/features/ai/domain/entities/context_builder_input.dart`
  - [ ] Fields: `DateTime now`, `String activeScreen`, `List<Event> next48hEvents`, `List<SkillWithStats> skills`, `List<Session> unanchoredLast7Days`, `List<SuggestionOutcome> last3Suggestions`
  - [ ] `SuggestionOutcome` mini-type: `int skillId`, `String skillName`, `String outcome` (`'accepted'|'dismissed'|'thumbs_down'`)
- [ ] Task 2: `ContextBuilder.build()` (AC: 2–6)
  - [ ] Build each section as a string:
    - P1: `"Date: DD/MM/YYYY HH:mm | Screen: {activeScreen}"`
    - P2: Events formatted as `"HH:mm–HH:mm Title [category]"`, one per line
    - P3: Skills formatted as `"Skill: {name} | Streak: {n} days"`
    - P4: Unanchored sessions: `"Session: {skillName} {duration}min {DD/MM}"`
    - P5: Suggestions: `"Suggestion: {skillName} → {outcome}"`
  - [ ] Assemble: join sections with `\n---\n` separator
  - [ ] If total length > 4000: remove P5 and retry; if still > 4000: remove P4; etc.
  - [ ] Final `contextText` must be ≤4000 chars
- [ ] Task 3: `AiService` wrapper (AC: 6)
  - [ ] `lib/features/ai/domain/usecases/ai_service.dart`
  - [ ] `buildAndSendContext(...)`: fetches data via injected repositories, builds `ContextBuilderInput`, calls `ContextBuilder.build()`, then calls `aiProvider.sendContext(payload)`
- [ ] Task 4: Unit tests (AC: 8)
  - [ ] `test/features/ai/domain/usecases/context_builder_test.dart`
  - [ ] All 4 test scenarios
- [ ] Task 5: Lint check (AC: 10)

## Dev Notes

- **Character count, not token count:** The 4k cap is on `String.length` (characters), not tokens. Simple and predictable.
- **Truncation algorithm:** Build all sections first, measure total. If over 4000, drop P5 entirely, re-measure. Continue dropping until ≤4000. Never partial-drop a section.
- **`ContextBuilder` is pure Dart:** It accepts a pre-built `ContextBuilderInput` — all DB fetching happens in `AiService.buildAndSendContext`, not in `ContextBuilder`.
- **Section separators:** `\n---\n` between sections adds ~5 chars per section — account for this in the budget.
- **Locale formatting:** Use `LocaleService` for date/time formatting in context text (French user, so DD/MM/YYYY, HH:mm 24h).

### Project Structure Notes

```
lib/features/ai/domain/
├── entities/context_builder_input.dart
└── usecases/
    ├── context_builder.dart
    └── ai_service.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-4.1] — priority order and 4k cap
- [Source: _bmad-output/planning-artifacts/architecture.md#Context-Payload-Overflow] — truncation priority order

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List