# Practice Module — Spec

## Problem Statement

Most habit trackers treat all skills identically: you either did it or you didn't, here's your streak. This fails completely for skills with real depth — "learn Japanese" has sub-dimensions (speaking, vocabulary, reading), a measurable level (N5 → N4), and a logarithmic improvement curve. OdO solves this by giving each skill type its own tracking template with the dimensions that actually matter.

## Goals

1. Support 6 distinct skill types, each with a pre-built metric configuration the user never has to configure
2. Auto-detect skill type from the skill name (offline, < 100ms, no API call)
3. Session logging takes under 15 seconds for a standard session (pre-filled form, mode chips retain last selection)
4. Skill cards show three states: Active Streak, Idle (≥3 days), Milestone Recent (≤7 days)
5. Evolution view shows longitudinal data adapted to skill type (charts, timelines, mode distributions)
6. Level check-in system prompts every 10 sessions for Language and Strategy skills
7. Unanchored session detection: 3 sessions in same 90-min time window spanning ≥2 calendar weeks → ask once to anchor

## Non-Goals

- Cross-device sync (V3)
- Social or collaborative features (V3)
- Gamification beyond streaks and milestones (by design)
- AI-powered session quality analysis requiring network (offline-first)
- Recurring events from the Agenda module (deferred to v1.5)

## User Flow

### New Skill
1. User taps "+" on Practice tab
2. Auto-detection runs on typed name → type assigned with confirmation chip OR selector shown
3. Skill card created immediately, session can be logged at once

### First Launch (Story 3.2)
1. Bottom sheet: "What's one skill you're working on?" — free text only
2. Auto-detection assigns type silently
3. No onboarding tutorial, no goal-setting, no duration targets

### Session Logging
1. User taps "Log Session" on skill card
2. Adaptive form opens (pre-filled from last session)
3. User changes only what changed (mode chips retain last selection)
4. Tap "Log Session" — done in < 15 seconds for routine sessions

### Evolution View
1. User taps skill card (not the Log Session button)
2. Full-screen view with type-adapted charts
3. Milestone timeline, mode distribution, level timeline (for qualifying types)

## Technical Constraints

- Drift ORM (SQLite) for all persistence — schema must be versioned (v1 → v2 migration required)
- Riverpod 3.x — `StreamProvider`, `AsyncNotifier`, `NotifierProvider`
- Clean Architecture: domain ← data ← presentation (no violations)
- All entities are pure Dart (`@immutable`), no Drift or Flutter imports in domain/
- JSON stored as text columns in SQLite (mode_tags, metric_config)
- SkillType stored as text in DB, converted to enum in mapper
- Feel scores stored as int: 1=Hard, 2=Normal, 3=Easy (Physical: 1=Exhausted, 2=Normal, 3=Strong)

## Dependencies

- Epic 1 complete: `AppDatabase` with `Skills` and `Sessions` tables (schemaVersion 1 → 2 migration needed)
- `Result<T>` / `AppError` from `core/types/result.dart`
- `core/database/app_database.dart` and `database_providers.dart`

## Success Metrics

- Session logging form opens pre-filled in < 300ms
- Standard session log completes in < 15 seconds (design contract)
- `watchAllSkills` emits within 50ms on insert
- Evolution view renders without jank on 200+ sessions
- Streak computation takes < 10ms for any skill
- All 46 unit/integration tests passing before Story 3.2 begins
