# Story 3.6: Pattern Detection (Unanchored Sessions)

Status: ready-for-dev

## Story

As a developer,
I want a `PatternDetector` that identifies recurring unanchored session times,
so that the evening session can ask once about anchoring.

## Acceptance Criteria

1. `lib/features/practice/domain/usecases/pattern_detector.dart` defines `PatternDetector` pure Dart class
2. `PatternDetector.detect(List<Session> unanchoredSessions) → PatternMatch?` — takes the last 3 unanchored sessions (caller pre-filters)
3. Returns a `PatternMatch` if ALL three session `startedAt` times fall within a **±45-minute window-of-day** AND span **≥2 distinct calendar weeks**
4. `PatternMatch` data class: `int skillId`, `int windowStartMinute` (0–1439), `int windowEndMinute`, `List<Session> matchingSessions`
5. Returns `null` if fewer than 3 sessions, window exceeds 90 minutes, or sessions span < 2 calendar weeks
6. Once OdO has asked about a skill's pattern (accepted or declined), a suppression flag `pattern_asked_skill_{skillId}` is stored in `SharedPreferences` — `PatternDetector.detect` returns `null` if suppressed
7. Unit tests cover:
   - Fewer than 3 sessions → null
   - 3 sessions same window same calendar week → null
   - 3 sessions same window spanning ≥2 weeks → PatternMatch returned
   - 3 sessions at different times of day → null
   - Suppression flag set → null
8. `PatternDetector` is pure Dart (no Flutter imports)
9. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `PatternMatch` data class (AC: 4)
  - [ ] `lib/features/practice/domain/entities/pattern_match.dart`
  - [ ] `@immutable` class with `const` constructor
- [ ] Task 2: Implement `PatternDetector` (AC: 1–5, 8)
  - [ ] Window-of-day: `timeOfDay(session) = session.startedAt.toLocal().hour * 60 + session.startedAt.toLocal().minute`
  - [ ] Check `max(timeOfDay) - min(timeOfDay) <= 90`
  - [ ] Calendar week span: sessions span ≥14 calendar days (`max(startedAt) - min(startedAt) >= 14 days`) OR ≥2 distinct ISO week numbers
  - [ ] If both conditions pass: return `PatternMatch`
- [ ] Task 3: Suppression (AC: 6)
  - [ ] `PatternDetector` constructor accepts optional `Set<int> suppressedSkillIds`
  - [ ] If `suppressedSkillIds.contains(sessions.first.skillId)` → return null immediately
- [ ] Task 4: Unit tests (AC: 7)
  - [ ] `test/features/practice/domain/usecases/pattern_detector_test.dart`
- [ ] Task 5: Lint check (AC: 9)

## Dev Notes

- **±45 min = 90 min total window:** `max(timeOfDay) - min(timeOfDay) <= 90` in minutes.
- **Week span:** Simplest correct check — `max(startedAt).difference(min(startedAt)).inDays >= 14` (14 days covers ≥2 calendar weeks in all cases).
- **Pure PatternDetector:** Suppression logic belongs in the orchestration layer (evening session notifier). The `suppressedSkillIds` parameter keeps the detector pure without coupling to SharedPreferences.
- **Caller responsibility:** Evening session orchestrator fetches last 3 unanchored sessions via `practiceRepositoryProvider.getUnanchoredSessions(skillId, sinceMs: 0)` and passes them to `PatternDetector.detect`.

### Project Structure Notes

```
lib/features/practice/domain/
├── entities/pattern_match.dart
└── usecases/pattern_detector.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-3.6] — 90-min window, 2-week span spec
- [Source: _bmad-output/planning-artifacts/architecture.md#SQLite-Schema] — getUnanchoredSessions query

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List