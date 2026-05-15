# Story 3.3: Skill Card

Status: ready-for-dev

## Story

As a user,
I want each skill to render as a card with my current streak and recent activity,
so that I can see progress without opening anything.

## Acceptance Criteria

1. Each skill renders as a card with: top row (skill name + streak badge), middle (7-day activity bar), bottom (last session: duration + relative date)
2. Streak badge shows a 🔥 emoji and the streak count (e.g., `🔥 7`)
3. 7-day activity bar: 7 vertical bars, filled (accent color) if a session occurred that day, muted (`colorBorder`) if not; days ordered Mon→Sun or today-6→today
4. Last session row: `'35 min · 2 days ago'` format; shows `'No sessions yet'` if no sessions
5. No XP indicators, no levels, no goal progress bars — these are out of scope
6. Tapping the card navigates to skill detail (`/home/practice/skill/:id`)
7. Long-pressing the card opens the quick-log session sheet (`/home/practice/log-session/:id`)
8. Cards use `surfaceVariant` background, 1px `colorBorder` border, `radiusLg` (20px) corner radius
9. `PracticeNotifier` exposes `AsyncValue<List<SkillWithStats>>` where `SkillWithStats` pairs `Skill` with computed streak and last session
10. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `SkillWithStats` value type (AC: 9)
  - [ ] `lib/features/practice/domain/entities/skill_with_stats.dart`
  - [ ] Fields: `Skill skill`, `int currentStreak`, `Session? lastSession`, `List<bool> activityLast7Days`
- [ ] Task 2: `PracticeNotifier` (AC: 9)
  - [ ] `lib/features/practice/presentation/practice_providers.dart`
  - [ ] `@riverpod` class `PracticeNotifier extends _$PracticeNotifier implements AsyncNotifier<List<SkillWithStats>>`
  - [ ] `build()`: watches `practiceRepositoryProvider.watchAllSkills()`, maps each skill to `SkillWithStats`
  - [ ] For each skill: call `StreakCalculator.compute(sessions, today)` and compute 7-day activity
  - [ ] `addSkill(String name)`: repository insert → invalidate state
  - [ ] `deleteSkill(int id)`: repository delete → invalidate state
- [ ] Task 3: `SkillCard` widget (AC: 1–8)
  - [ ] `lib/features/practice/presentation/widgets/skill_card.dart`
  - [ ] Card container: `Card` or `Container` with `colorSurface` bg, `radiusLg` radius, 1px `colorBorder` border
  - [ ] Top row: `Text(skill.name, style: textTitle)` + streak badge `'🔥 $streak'` right-aligned
  - [ ] Activity bar: `Row` of 7 `AnimatedContainer` (width: fixed, height: `sp24`, gap: `sp4`), color based on `activityLast7Days[i]`
  - [ ] Bottom row: last session text with `textCaption` + `colorTextMuted`
  - [ ] `GestureDetector`: `onTap` → `context.go('/home/practice/skill/${skill.id}')`, `onLongPress` → `context.go('/home/practice/log-session/${skill.id}')`
- [ ] Task 4: Practice page (AC: 1)
  - [ ] `lib/features/practice/presentation/pages/practice_page.dart`
  - [ ] `ConsumerWidget` watching `practiceNotifierProvider`
  - [ ] `AsyncValue.when(data: (skills) => ListView(children: skills.map((s) => SkillCard(s)).toList()), loading: ..., error: ...)`
- [ ] Task 5: Widget tests (AC: 1–7)
  - [ ] `test/features/practice/presentation/widgets/skill_card_test.dart`
  - [ ] Test: streak badge shows correct count; activity bar has 7 items; last session text correct
- [ ] Task 6: Lint check (AC: 10)

## Dev Notes

- **Emoji in Flutter:** `'🔥'` renders via the system emoji font. No additional package needed. Wrap in `Text` with no explicit `fontFamily`.
- **7-day activity:** Compute in `PracticeNotifier`: for each of the last 7 days (today - 6 days to today), check if any session `startedAt` falls within that local calendar day.
- **Relative date:** `'2 days ago'` — compute `DateTime.now().difference(lastSession.startedAt).inDays` and format as: 0 = 'today', 1 = 'yesterday', N = '$N days ago'.
- **`StreakCalculator`:** Implemented in Story 3.5. PracticeNotifier depends on it — create a stub returning 0 for this story; update when 3.5 ships.
- **CLAUDE.md card spec:** `surfaceVariant` background, 1px `outline` border, `radiusLg` (20px). In Material 3 terms: `Theme.of(context).colorScheme.surfaceVariant`.

### Project Structure Notes

```
lib/features/practice/
├── domain/entities/
│   ├── skill.dart            # from 3.1
│   ├── session.dart          # from 3.1
│   └── skill_with_stats.dart # this story
└── presentation/
    ├── practice_providers.dart   # PracticeNotifier
    ├── pages/practice_page.dart
    └── widgets/skill_card.dart
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-3.3] — acceptance criteria
- [Source: CLAUDE.md#UI-Design] — card design tokens
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md] — skill card layout

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List