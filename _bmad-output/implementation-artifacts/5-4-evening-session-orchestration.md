# Story 5.4: Evening Session — Orchestration

Status: ready-for-dev

## Story

As a developer,
I want an `EveningSessionNotifier` that orchestrates the 5-minute ritual,
so that the session has correct state at every step.

## Acceptance Criteria

1. `EveningSessionNotifier.start()` creates a row in `evening_sessions` with `session_date = today`, `started_at = now`
2. `HeadlineGenerator.generate(List<Event> todayEvents, List<Session> todaySessions) → String` generates the headline; falls back to a canned string if AI is unreachable
3. `HighlightRanker.rank(...)` selects 3–4 highlights from sessions, events, and patterns of the last 24 hours
4. If a `PatternMatch` exists for any skill, a cross-domain insight highlight is appended as the last item
5. Evening session screen renders sequentially: headline → highlights (with tag/expand/dismiss) → optional insight → close phase
6. Each user action (tag significant / dismiss / expand) writes immediately to `evening_highlights` table
7. "Wrap up" button is always visible — tapping jumps to the close phase
8. Close phase: `completedAt` written to `evening_sessions`; `HeadlineGenerator` generates `closeSummary` from tagged highlights
9. `EveningSessionNotifier` state: sealed class with `idle`, `loading`, `headline(text)`, `highlights(List<EveningHighlight>, currentIndex)`, `insight(EveningHighlight)`, `closing(String summary)`, `done`
10. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: Domain types (AC: 9)
  - [ ] `lib/features/evening_session/domain/entities/evening_highlight_entity.dart`
  - [ ] `EveningSessionViewState` sealed class in domain
- [ ] Task 2: `HeadlineGenerator` (AC: 2)
  - [ ] `lib/features/evening_session/domain/usecases/headline_generator.dart`
  - [ ] Calls `AiService.buildAndSendContext` with a prompt: *"Generate a one-sentence evening headline for today based on: {summary}"*
  - [ ] If AI fails (offline or error): returns one of 5 rotating fallback strings (e.g., "Voici votre bilan du {date}")
  - [ ] Fallback index: `DateTime.now().day % 5` for rotation
- [ ] Task 3: `HighlightRanker` (AC: 3, 4)
  - [ ] `lib/features/evening_session/domain/usecases/highlight_ranker.dart`
  - [ ] Input: today's sessions, today's events, pattern matches
  - [ ] Rules: max 4 highlights total; sessions first, then events; pattern insight last
  - [ ] Returns `List<EveningHighlightEntity>` ordered by display priority
- [ ] Task 4: `EveningSessionNotifier` (AC: 1, 5–9)
  - [ ] `lib/features/evening_session/presentation/evening_session_providers.dart`
  - [ ] `start()`: DB insert → fetch data → call `HeadlineGenerator` → call `HighlightRanker` → transition to `headline` state
  - [ ] `tagHighlight(int highlightId, String tag)`: writes `user_tag` + `tagged_at` to DB
  - [ ] `nextHighlight()`: advances `currentIndex`; when all done, transitions to `insight` or `closing`
  - [ ] `wrapUp()`: jumps directly to `closing` state; writes `completed_at`
  - [ ] `finish()`: generates close summary → state `done` → navigate to home
- [ ] Task 5: Evening session screen (AC: 5–7)
  - [ ] `lib/features/evening_session/presentation/pages/evening_session_page.dart`
  - [ ] `AnimatedSwitcher` between state phases
  - [ ] "Wrap up" `TextButton` pinned at top right
  - [ ] Tag row: "Significant" chip, "Dismiss" chip, "Expand" chip
- [ ] Task 6: Lint check (AC: 10)

## Dev Notes

- **Pattern suppression:** After asking about a `PatternMatch`, call `prefs.setBool('pattern_asked_skill_{id}', true)`. Pass suppressed IDs to `PatternDetector` on future runs.
- **`HighlightRanker` data:** Query last 24h: `sessions WHERE started_at > now - 24h`, `events WHERE start_time > now - 24h`. Max 4 highlights — prioritize: sessions > events > pattern.
- **Cross-domain insight generation:** If `PatternMatch` found, the insight text is: *"I've noticed you often practice {skillName} around {windowTime}. Want to block that time in your Agenda?"* — this is the only moment the AI makes a cross-feature connection visible.
- **`closeSummary` generation:** Prompt: *"In one sentence, summarize today based on these highlights: {tagged highlights}"*. Fallback: *"Bonne nuit — à demain."*

### Project Structure Notes

```
lib/features/evening_session/
├── domain/
│   ├── entities/evening_highlight_entity.dart
│   └── usecases/
│       ├── headline_generator.dart
│       └── highlight_ranker.dart
└── presentation/
    ├── evening_session_providers.dart   # EveningSessionNotifier
    └── pages/evening_session_page.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.4] — orchestration steps
- [Source: _bmad-output/planning-artifacts/architecture.md#EveningSession] — sequential phase design

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List