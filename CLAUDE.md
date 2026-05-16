# OdO — Claude Code Workflow

## What this app is

OdO is a personal AI daily companion for Franklin (single user, no auth, no multi-user).
It manages three domains:
- **Agenda** — events, schedule, calendar
- **Wills** — long-term goals with sessions and notes (e.g. "learn Japanese", "get better at chess"). Referred to as "Practice" in code.
- **Expenses** — spending tracking (v1.1, not yet implemented)

The AI (Claude API, model `claude-sonnet-4-6`) ties all three together with proactive suggestions and a persistent chat interface.

**Non-negotiables:**
- Offline-first. Everything works without internet. AI degrades gracefully.
- Dark mode default (OLED-optimized, `#0D0D0F` background).
- Single user. No login screen. No accounts.
- Flutter mobile (Android + iOS).

---

## UI Design

Full design reference: `docs/ui_design_reference.md` — read this before implementing any UI.

Key points:
- **Typography:** Fraunces (serif, display/titles) + DM Sans (body/UI). Both via `google_fonts`.
- **Navigation:** 5-tab bottom nav bar (Home, Agenda, Practice, Insights, Profile). NOT a carousel.
- **Dark mode tokens:** warm amber `#C4956A` as primary accent. Violet `#7C4DFF` agenda-specific. Green `#1D9E75` wills-specific.
- **Light mode:** direct from prototype palette (`#FDF8F2` base, `#8B6C4F` accent, warm browns).
- **Cards:** `surfaceVariant` background, 1px `outline` border, `radiusLg` (20px).
- **AI card:** always uses `aiSurface` (dark contrasted bg) — stands out from all other cards.
- The prototype (`odo_prototype.html`) is the visual reference for all screens.

---

## Tech stack

| Layer | Technology |
|---|---|
| UI framework | Flutter + Dart |
| State management | Riverpod (flutter_riverpod, riverpod_annotation, riverpod_generator) |
| Local database | Drift (SQLite ORM) + drift_flutter |
| Navigation | go_router — shell route with bottom nav |
| AI | Claude API via `http` package — model `claude-sonnet-4-6` |
| Background tasks | workmanager |
| Notifications | flutter_local_notifications |
| Persistence (prefs) | shared_preferences |
| Fonts | google_fonts (Fraunces + DM Sans) |
| Code generation | build_runner, drift_dev, riverpod_generator |

**Clean Architecture layers (strict, in this order):**
```
domain/     — pure Dart, no Flutter, no external imports
  entities/
  repositories/   (abstract interfaces only)
  usecases/

data/       — imports domain only
  models/         (Drift table rows / DTOs)
  datasources/    (Drift DAOs, http calls)
  repositories/   (implements domain contracts)
  mappers/        (entity <-> model)

presentation/   — imports domain only (never data directly)
  pages/
  widgets/
  providers/      (all Riverpod providers for this feature live here)
```

**Riverpod patterns in use:**
- `@riverpod` annotation + code generation for providers
- `AsyncNotifier` / `Notifier` for stateful feature logic
- `StreamProvider` for reactive DB queries (Drift returns `Stream<List<T>>`)
- `FutureProvider` for one-shot async reads
- `AsyncValue<T>` for loading/data/error states in UI
- All providers for a feature live in `lib/features/[feature]/presentation/[feature]_providers.dart`

---

## Project file layout

```
_bmad-output/
  implementation-artifacts/     <- story files (one per story, source of truth)

lib/
  product/
    features/
      _TEMPLATE/                <- never edit directly
      [feature]/                <- created per epic before any code
        spec.md
        acceptance-criteria.md
        risks.md
        test-scenarios.md
        1-data-implementation-plan.md
        2-domain-implementation-plan.md
        3-ui-implementation-plan.md
  features/
    [feature]/
      data/
      domain/
      presentation/
  core/
    constants/      (app_colors.dart, app_spacing.dart, ai_constants.dart)
    database/       (app_database.dart, database_providers.dart)
    services/       (ai_provider.dart, background_task_service.dart, notification_service.dart)
    types/          (result.dart)
    widgets/        (shared widgets)
  app/
    app.dart        (MaterialApp + go_router shell)
    theme.dart      (ThemeData dark + light, using tokens from ui_design_reference.md)
  main.dart

test/               <- mirrors lib/ structure exactly
  features/[feature]/data/
  features/[feature]/domain/
  features/[feature]/presentation/

product/            <- project-level strategy (roadmap, personas, decisions)
docs/
  IMPLEMENTATION_PLAN.md        <- 6 epics, 41 stories, dependency order
  ui_design_reference.md        <- full design token + component spec
```

---

## The implementation workflow

> Follow this exactly for every story. No exceptions.

### How to start a story

When told "implement story X.Y", do this:

1. Read `_bmad-output/implementation-artifacts/[X]-[Y]-*.md` — this is the artifact
2. Read `docs/IMPLEMENTATION_PLAN.md` — confirm story prerequisites are COMPLETE in `IMPLEMENTATION_STATUS.json`
3. Read `CONVENTIONS.md` — refresh on naming rules
4. Read `docs/ui_design_reference.md` if the story touches UI
5. Enter Phase 1

---

### Phase 1 — Product Layer (BLOCKING GATE)

**Nothing is written to `lib/features/` until this phase is approved.**

Check if `lib/product/features/[epic-slug]/` already exists and is populated:
- If yes and all 7 files have real content -> skip to Phase 2
- If no or files are template stubs -> create/populate now

**Create these 7 files for the epic:**

```
lib/product/features/[epic-slug]/
  spec.md
  acceptance-criteria.md
  risks.md
  test-scenarios.md
  1-data-implementation-plan.md
  2-domain-implementation-plan.md
  3-ui-implementation-plan.md
```

**Rules for each file:**
- Must be real content derived from the story artifact. Blanks or "[placeholder]" = fail.
- `spec.md` — problem statement, goals, non-goals, user flow, technical constraints, dependencies, success metrics
- `acceptance-criteria.md` — group by: Functional (FR), Integration (IR), Edge Cases (EC), Error Handling (EH), Quality (QR), Security (SR). Every item must be independently testable.
- `risks.md` — for each risk: description, probability, impact, severity, mitigation, contingency
- `test-scenarios.md` — each scenario: ID (TS-NNN), title, preconditions, input, expected output, validation rule, test type (unit / integration / E2E / security / perf)
- `1-data-implementation-plan.md` — field-by-field model table, DAO method table with SQL operations, repository impl delegation table, all mapped to story IDs
- `2-domain-implementation-plan.md` — entity property list with validation rules, usecase input/output/business logic, repository contract methods, all failure types
- `3-ui-implementation-plan.md` — screen list with file paths, widget list with responsibilities, provider list with types and dependencies, all UI states (loading / loaded / empty / error), navigation flow

**After writing the 7 files, STOP.**

Output this message:
```
===================================================
PRODUCT LAYER COMPLETE — AWAITING REVIEW
===================================================

Epic:  [epic name]
Story: [story ID and title]

Files written:
  lib/product/features/[slug]/spec.md
  lib/product/features/[slug]/acceptance-criteria.md
  lib/product/features/[slug]/risks.md
  lib/product/features/[slug]/test-scenarios.md
  lib/product/features/[slug]/1-data-implementation-plan.md
  lib/product/features/[slug]/2-domain-implementation-plan.md
  lib/product/features/[slug]/3-ui-implementation-plan.md

Total acceptance criteria: [N]
Total test scenarios: [N]
Risks identified: [N]

Please review the files above.
Reply "proceed" to start implementation, or give feedback to adjust.
===================================================
```

**Do not write any code until Franklin replies "proceed".**

---

### Phase 2 — Implementation

**Order is always: Domain -> Data -> Presentation. No exceptions.**

Before writing any code, build the Acceptance Criteria matrix from `acceptance-criteria.md`:

```
ID  | Requirement                  | Implementation plan   | Status
FR1 | [text]                       | [how]                 | TODO
```

**Per-file discipline (zero-lint policy):**
1. Write file
2. Run `flutter analyze [file path]`
3. Fix ALL lint errors — zero warnings allowed
4. Only then move to the next file

**Per-acceptance-criterion discipline:**
1. Implement the criterion
2. Write the test that validates it
3. Run `flutter test [test file]` — it must pass
4. Update the matrix to done
5. Only then move to the next criterion

**Layer-specific rules:**

_Domain layer_ (`lib/features/[feature]/domain/`):
- Entities are pure Dart — no Flutter imports, no Drift imports
- Validation lives in entities, returns `Result<T>` from `core/types/result.dart`
- Repository interfaces are abstract classes only — no implementation
- Usecases hold all business logic

_Data layer_ (`lib/features/[feature]/data/`):
- Drift DAOs extend `DatabaseAccessor<AppDatabase>`
- Repository impls implement domain contracts, inject the DAO
- Mappers handle entity <-> Drift row conversion
- Error mapping: database exceptions -> typed `AppFailure`

_Presentation layer_ (`lib/features/[feature]/presentation/`):
- All Riverpod providers for a feature live in `[feature]_providers.dart`
- Use `AsyncNotifier` for CRUD operations
- UI widgets consume `AsyncValue<T>` — always handle loading / data / error states
- Widgets never import from `data/` — only `domain/` entities and presentation providers
- All UI must match `docs/ui_design_reference.md` — tokens, typography, components
- Use `ref.watch` for reactive state, `ref.read` inside event handlers only

**Blocked conditions — never proceed if:**
- Current file has lint errors
- Any test for a completed criterion is failing
- A requirement is being skipped or deferred

---

### Phase 3 — Test Gate

Run the full test suite:
```
flutter test
flutter analyze
```

**Pass criteria:**
- `flutter analyze` -> "No issues found!"
- `flutter test` -> >= 90% of tests pass

If below 90%: fix failing tests, re-run. Repeat until gate passes.

Report:
```
TEST GATE RESULT
----------------
flutter analyze:  CLEAN / [N issues]
flutter test:     [X]/[Y] passing ([Z]%)
Gate:             PASS / FAIL
```

---

### Phase 4 — CodeRabbit Review

> CodeRabbit MCP must be configured in `.claude/settings.json` for this phase to run.
> If not configured, skip to Phase 5 and note it was skipped.

After tests pass, invoke CodeRabbit on the changed files.
Address every comment rated critical or major before proceeding.
If code is changed, re-run Phase 3 before Phase 5.

---

### Phase 5 — Done

1. Update `IMPLEMENTATION_STATUS.json` — mark story complete with date
2. Update `product/FEATURE_STATUS.json` if the full epic is now done
3. Write the post-story explanation:

```
STORY EXPLANATION — [STORY_ID]

1. Purpose — why this story exists and what problem it solves
2. What was implemented — domain logic, data flow, UI behaviour, side effects
3. File-by-file breakdown — file name -> responsibility -> how it connects to others
4. Architectural alignment — Clean Architecture layer, dependency direction check
5. AC mapping — for each AC: which code implements it, which test validates it
6. What was NOT simplified — shortcuts explicitly avoided and why
7. Future impact — what would break if this was done incorrectly
8. Confidence score — current value and what could reduce it next
```

---

## Anti-simplification rules

- Never propose a "simplified" or "minimal" version of a documented requirement
- Never skip acceptance criteria claiming they're optional
- Never omit edge cases or error handling
- Never skip test scenarios from the product layer
- Never suggest "implementing this later" for a documented requirement
- Never mark a story complete with any acceptance criterion unimplemented

---

## Escalation — when to stop and ask Franklin

Stop immediately and ask if:
- Acceptance criteria are contradictory or ambiguous
- A requirement conflicts between two product layer files
- A requirement is technically impossible on Flutter/Dart
- Tests keep failing after 3 fix attempts with no clear root cause
- A platform limitation prevents compliance with a stated requirement

---

## Code quality standards

- `flutter analyze` must show "No issues found!" before any story is marked done
- Use `super.parameter` constructors (not explicit `super(param)` calls)
- Use `const` constructors everywhere possible
- Never use `print()` — use `debugPrint()` or a logger
- Remove all unused imports before moving to the next file
- No TODOs or "implement later" comments in committed code

---

## Confidence scoring

| Dimension | Weight |
|---|---|
| Acceptance criteria coverage | 30% |
| Test coverage and quality | 25% |
| Architectural integrity | 15% |
| Error and edge case handling | 15% |
| Performance compliance | 10% |
| Code readability | 5% |

- 90-100: Exceptional
- 75-89: Acceptable, safe to proceed
- 60-74: Warning — flag issues
- < 60: STOP, escalate to Franklin

---

## Dev Journal

> Updated after every completed story. Most recent entry first.

---

### UI Redesign — Agenda Module (Prototype v2)
**Date:** 2026-05-16

**Scope:** Visual-only redesign of all 5 Agenda screens to match the HTML prototype. No logic or data layer changes. 153/153 tests pass.

**Files modified:**
- `lib/core/constants/app_colors.dart` — `colorCategoryWork` changed from `#5B8BD4` (blue) to `#00C2D4` (cyan) per new spec
- `lib/core/constants/app_typography.dart` — Removed Google Fonts (Fraunces + DM Sans); switched to system defaults (SF Pro/Roboto) using plain `const TextStyle()`
- `lib/main.dart` — Removed `GoogleFonts.config.allowRuntimeFetching = false` (no longer needed)
- `lib/features/agenda/presentation/pages/add_event_sheet.dart` — Replaced drag handle + RadioGroup with: Scaffold AppBar with back button, ALL-CAPS French section labels (TITRE/DURÉE/CATÉGORIE/NOTE), animated category chip row (GestureDetector + AnimatedContainer), French action buttons (Enregistrer/Annuler)
- `lib/features/agenda/presentation/pages/agenda_page.dart` — Added 7-day horizontal strip (Mon–Sun of selected week, today/selected = violet circle, category dots per day from `monthEventsProvider`); French header (full day name + "16 mai 2026" format); FAB with violet background
- `lib/features/agenda/presentation/widgets/event_block.dart` — Tinted backgrounds per category (`catColor.withValues(alpha: 0.15)`); 3px accent bar (down from 4px); removed border
- `lib/features/agenda/presentation/pages/event_detail_page.dart` — Full-width 3px color bar at content top; French strings throughout; category badge (tinted chip with dot + label); Notes section always visible ("Aucune note" when empty); Edit/Delete as tinted action buttons
- `lib/features/agenda/presentation/pages/calendar_page.dart` — Title changed to "Calendrier"

**Tests updated:**
- `test/core/constants/app_typography_test.dart` — Removed google_fonts, converted to synchronous tests
- `test/core/constants/app_colors_test.dart` — Updated `colorCategoryWork` expectation to cyan `#00C2D4`
- `test/widget_test.dart` — Removed google_fonts import and `allowRuntimeFetching` setup
- `test/features/agenda/presentation/pages/add_event_sheet_test.dart` — Updated all string finders to French, replaced RadioGroup finder with behavior-based category test

---

### Hotfix — Notification blocking event save + blank initial screen
**Date:** 2026-05-16

**Problem 1:** Saving new events silently failed. `AgendaNotifier.addEvent()` called `NotificationService.scheduleEventReminder()` inside the `success:` callback with no try/catch. On Android, `zonedSchedule` with `AndroidScheduleMode.exactAllowWhileIdle` requires `SCHEDULE_EXACT_ALARM` permission — if missing, it throws a `PlatformException`. The exception propagated past `state = AsyncData(null)` and past `context.pop()`, leaving the sheet open and the user unable to save.

**Fix:** Wrapped both `scheduleEventReminder` (in `addEvent`) and `cancelReminder` (in `deleteEvent`) in try/catch with empty catch bodies. Notifications are best-effort — a scheduling failure must never block a database write.

**Problem 2:** App launched to blank Glance placeholder (Epic 5, not yet built). Changed `initialLocation` from `/glance` to `/home` in `lib/app/router.dart`.

**Files changed:**
- `lib/features/agenda/presentation/agenda_providers.dart` — try/catch around notification calls in `addEvent` and `deleteEvent`
- `lib/app/router.dart` — `initialLocation: '/home'`

**Rule going forward:** Any call to `NotificationService` inside a Notifier must be wrapped in try/catch. Notification permission/scheduling is always best-effort.

---

### Story 2-5 — Monthly Calendar
**Completed:** 2026-05-16 | **Confidence:** 93/100

**Files created/modified:**
- `lib/features/agenda/presentation/pages/calendar_page.dart` — `TableCalendar<Event>`, custom `markerBuilder` (coloured dots, max 3, work > practice > personal priority), day-tap navigates to `/home/agenda` via `go_router` with selected day/time
- `lib/features/agenda/presentation/agenda_providers.dart` (extended) — `focusedDayProvider` (`NotifierProvider<_FocusedDayNotifier, DateTime>`), `monthEventsProvider` (`FutureProvider.family<Map<DateTime, List<Event>>, DateTime>`) grouping by `_stripTime` key

**Key decisions:**
- `AsyncValue.valueOrNull` removed in Riverpod 3.x — replaced with pattern matching: `switch (monthEventsAsync) { AsyncData(:final value) => value, _ => <DateTime, List<Event>>{} }`
- `ref.invalidate(monthEventsProvider(focused))` on page-change instead of holding an open stream per month (avoids unbounded stream subscriptions)
- `rowHeight: 52, daysOfWeekHeight: AppSpacing.sp32` for comfortable touch targets

---

### Story 2-4 — Event CRUD with Three Categories
**Completed:** 2026-05-16 | **Confidence:** 95/100

**Files created/modified:**
- `lib/features/agenda/presentation/pages/add_event_sheet.dart` — `ConsumerStatefulWidget`; `RadioGroup<EventCategory>` wrapping `RadioListTile` values (Flutter 3.32+ API, replacing removed `groupValue`/`onChanged` on `RadioListTile`); `context.canPop()` guard before `context.pop()` prevents `GoError` in single-route test contexts
- `lib/features/agenda/presentation/pages/event_detail_page.dart` — `FutureProvider.family` loading, delete with 5-s undo snackbar, re-insert via `event.copyWith(clearId: true)` on undo
- `lib/features/agenda/presentation/agenda_providers.dart` (extended) — `AgendaNotifier` (`AsyncNotifier<void>`): add/update/delete with `NotificationService` scheduling/cancellation

**Key gotcha:** `RadioGroup<T>` requires Flutter ≥ 3.32. Wrap the column of `RadioListTile` values inside a single `RadioGroup` widget providing `groupValue` and `onChanged` — the `RadioListTile` no longer accepts those at the tile level.

---

### Story 2-3 — Day Timeline View
**Completed:** 2026-05-16 | **Confidence:** 92/100

**Files created/modified:**
- `lib/features/agenda/presentation/pages/agenda_page.dart` — Scaffold with `_DayHeader`, swipe GestureDetector (`HorizontalDragEnd` → `notifier.setDay()`), `AgendaStrip` at top of home, FAB opens `AddEventSheet`
- `lib/features/agenda/presentation/widgets/day_timeline.dart` — `StatefulWidget`, 34 slots (6am–11pm, 32dp each, 1088dp total), `ScrollController` auto-scrolling to current hour, `Stack` with positioned `EventBlock`/`FreeSlotBlock`/`CurrentTimeIndicator`
- `lib/features/agenda/presentation/widgets/event_block.dart` — `Positioned`, 4dp left border by category colour, min-height 32dp, `InkWell` tap → event detail push
- `lib/features/agenda/presentation/widgets/free_slot_block.dart` — dashed border, muted tint, tap → `AddEventSheet` with `prefillStartTime`
- `lib/features/agenda/presentation/widgets/current_time_indicator.dart` — `Timer.periodic(const Duration(minutes: 1))` refresh, accent dot+line
- `lib/features/agenda/presentation/agenda_providers.dart` (extended) — `selectedDayProvider` (`NotifierProvider` with `setDay` method), `dayEventsProvider` (`StreamProvider<List<Event>>`)

**Timeline math:** `pixelsPerMinute = 32.0/30.0` (32dp per 30-min slot); `topOffset = (startMin - 360) * pixelsPerMinute` where 360 = 6am in minutes.

**Free-slot detection:** boundary-pair algorithm — collect `[dayStart, …event starts/ends…, dayEnd]`, iterate adjacent pairs, emit slot if gap ≥ 30 min.

**Key gotcha:** `Notifier.state` is a protected setter — never access it from outside the notifier. All day-selection mutations go through `notifier.setDay(day)`.

---

### Story 2-2 — Persistent Agenda Strip
**Completed:** 2026-05-16 | **Confidence:** 94/100

**Files created/modified:**
- `lib/features/agenda/presentation/widgets/agenda_strip.dart` — `ConsumerWidget`, `GestureDetector` (tap → `/home/agenda`, longPress → `/home/agenda/calendar`), 3-state rendering, 20-char title truncation with `…`, loading skeleton `Container`
- `lib/features/agenda/presentation/agenda_providers.dart` (extended) — `AgendaStripState` sealed class (`EventsToday`, `NextTomorrow`, `NothingScheduled`); `agendaStripProvider` (`StreamProvider`) async* body wrapped in try/catch

**Critical Riverpod 3.x discovery:** `StreamProvider` does NOT propagate stream errors as `AsyncError`. Instead errors cause `AsyncLoading` (with or without embedded previous value). The `when()` error callback is never reached via stream errors. Fix: wrap the `async*` body in try/catch and yield `NothingScheduled()` — stream errors become `AsyncData(NothingScheduled())`. Test for this uses `agendaRepositoryProvider` override (not `agendaStripProvider` override) so the real provider's error handling is exercised.

---

### Story 2-1 — Agenda Repository and DAO
**Completed:** 2026-05-16 | **Confidence:** 97/100

**Files created/modified:**
- `lib/features/agenda/domain/entities/event.dart` — `Event` immutable entity, `EventCategory` enum (personal/work/practice with `.value` getter), `validate()` returning `Result<Event>`, `copyWith({..., bool clearId = false})`
- `lib/features/agenda/domain/repositories/agenda_repository.dart` — abstract interface (6 methods; `watchEventsForDay` returns raw `Stream<List<Event>>`, NOT wrapped in `Result`)
- `lib/features/agenda/data/mappers/event_mapper.dart` — `abstract final class EventMapper`; `fromRow` → throws `ArgumentError` on unknown category; `toCompanion` maps epoch ms correctly
- `lib/features/agenda/data/agenda_dao.dart` — `@DriftAccessor(tables: [Events])`, UTC epoch ms storage, `watchEventsForDay` day-boundary query using `.isBiggerOrEqualValue` / `.isSmallerThanValue`
- `lib/features/agenda/data/repositories/agenda_repository_impl.dart` — all DAO calls wrapped in try/catch → `Failure(AppError.databaseWriteFailed)`; stream NOT wrapped (caller receives raw stream)
- `lib/core/database/app_database.dart` — `AgendaDao` added to `@DriftDatabase(daos: [...])`

**Key gotcha:** `AgendaDao` getter must be added to both the `@DriftDatabase` annotation and the `AppDatabase` class body — missing either causes a code-gen mismatch at runtime.

---

### Story 1-8 — Router and Project Structure
**Completed:** 2026-05-15 | **Confidence:** 95/100

**Files created/modified:**
- `lib/app/router.dart` — GoRouter, initialLocation=/glance, ShellRoute wrapping /home, all 10 routes + 4 bottom-sheet routes (slide-up `CustomTransitionPage`), `routerProvider` for Riverpod injection
- `lib/features/home/presentation/scaffold_with_nav_bar.dart` — 5-tab `NavigationBar` (French labels), tab selection via `GoRouterState.of(context).uri`, tabs: Accueil/Agenda/Pratique/Insights/Profil
- `lib/features/home/presentation/placeholder_screen.dart` — reusable title + route path placeholder
- `lib/app/app.dart` — migrated to `MaterialApp.router(routerConfig: router)`
- `CONVENTIONS.md` — added Import Rules table + Navigation section

**Key decisions:**
- `_selectedIndex` iterates tabs from last to first to correctly match sub-routes (e.g., `/home/agenda/event/1` matches Agenda tab)
- Router defined as module-level constant (not inside a class) for simple import + `routerProvider` wrapping
- `ModalRoute.of` not needed for go_router — tabs use `GoRouterState.of` uri parsing

---

### Story 1-7 — Result Type and Error Handling
**Completed:** 2026-05-15 | **Confidence:** 97/100

**Files created/modified:**
- `lib/core/domain/app_error.dart` — `AppError` enum, 8 variants, `.message` getter
- `lib/core/types/result.dart` — sealed `Result<T>` with `.when()`, `.getOrNull()`, `.isSuccess`, `.isFailure`; re-exports `app_error.dart`
- Migrated `AppFailure` → `AppError`, `.failure` → `.error` across all AI provider files and tests

**Key gotcha:** `Failure<T>` field was renamed from `failure` to `error` — any new code referencing old field name will fail at compile time, which is the intended enforcement.

---

### Story 1-6 — Core Services
**Completed:** 2026-05-15 | **Confidence:** 93/100

**Files created:**
- `ConnectivityService` — maps `connectivity_plus` results to `Stream<bool>`
- `NotificationService` — flutter_local_notifications, Africa/Abidjan timezone, event reminders at -5min, evening show notification
- `BackgroundTaskService` — top-level `callbackDispatcher()` (required by workmanager), periodic `odo.evening_check` task scheduling
- `VoiceService` — 5-state machine (idle/listening/parsing/committing/committed), `StreamController.broadcast(sync: true)` for synchronous state delivery, `@visibleForTesting simulateTransition()`
- `LocaleService` — `formatXof` with thin-space thousands separator, `formatDate`/`formatTime`
- `service_providers.dart` — all 5 Riverpod providers

**Key gotcha:** `StreamController.broadcast()` delivers events asynchronously — use `sync: true` for state machines where tests need to assert state immediately after transitions.

---

### Story 1-5 — AiProvider Abstraction
**Completed:** 2026-05-15 | **Confidence:** 95/100

**Files created:**
- `lib/features/ai/domain/ai_provider.dart` — `AiProvider` abstract + `ChatMessage`, `AiContextPayload`, `AiResponse` value types
- `lib/features/ai/data/claude_ai_provider.dart` — injectable `http.Client`, SSE streaming, API key via `dart-define`
- Stubs: `GeminiAiProvider`, `GroqAiProvider`, `OpenAiAiProvider` (all return `aiUnavailable`), `OfflineStubAiProvider` (canned response)
- `lib/core/constants/ai_config.dart` — `const kActiveAiProvider = 'claude'`
- `lib/features/ai/presentation/ai_providers.dart` — switch-based provider factory

**Key gotcha:** `http.MockClient` from `package:http/testing.dart` — clean injection approach; no mockito needed for HTTP layer.

---

### Story 1-4 — SQLite Database Schema with Drift
**Completed:** 2026-05-15 | **Confidence:** 96/100

**Files created:**
- 6 table files in `lib/core/database/tables/` — `@DataClassName` annotations for typed row classes (`SkillRow`, `SessionRow`, etc.)
- `lib/core/database/app_database.dart` — `@DriftDatabase`, `schemaVersion = 1`, `MigrationStrategy(onCreate: createAll + 5 indexes)`, `AppDatabase.forTesting(super.executor)` for in-memory tests
- `lib/core/database/database_providers.dart` — `appDatabaseProvider` singleton

**Critical gotcha:** SQLite FK constraints are OFF by default — must add `setup: (db) => db.execute('PRAGMA foreign_keys = ON')` to BOTH production `NativeDatabase.createInBackground` AND test `NativeDatabase.memory`. Without this, CASCADE DELETE silently does nothing.

---

### Story 1-3 — Theme System with Runtime Swap
**Completed:** 2026-05-15 | **Confidence:** 96/100

**Files created:**
- `lib/core/constants/app_spacing.dart` — spacing scale sp2-sp32, radius scale (sm/md/lg/xl/full)
- `lib/core/constants/app_durations.dart` — fast/default/slow duration constants
- `lib/core/constants/app_typography.dart` — 7 getters: Fraunces for display, DM Sans for all others; `tabularFigures` on textDisplay + clockStyle
- `lib/app/theme.dart` — `AppTheme.fromOdoTheme(OdoTheme, {TextTheme? textThemeOverride})` builds Material3 ThemeData; textThemeOverride param allows tests to bypass google_fonts
- `lib/core/services/shared_preferences_provider.dart` — `@Riverpod(keepAlive: true)` provider that throws if not overridden; overridden in `main()` after `SharedPreferences.getInstance()` resolves
- `lib/features/settings/presentation/theme_provider.dart` — `ActiveTheme` Notifier; reads saved name from SharedPreferences on build, persists on `setTheme()`
- `lib/app/app.dart` — `OdoApp` extended to `ConsumerWidget`, watches `activeThemeProvider`, passes theme to MaterialApp
- `lib/main.dart` — added SharedPreferences init + `ProviderScope` override
- Tests: `test/app/theme_test.dart` (12), `test/core/constants/app_typography_test.dart` (10), `test/core/constants/app_spacing_test.dart` (13), `test/core/constants/app_durations_test.dart` (4), `test/features/settings/presentation/theme_provider_test.dart` (6), `test/widget_test.dart` (2) — **88/88 total pass**

**Key decisions:**
- `CardThemeData` not `CardTheme` — Flutter renamed the data class; analyzer catches it
- `ColorScheme.fromSeed().copyWith()` avoids deprecated `background` named parameter
- `sharedPreferencesProvider` throws `UnimplementedError` by design — prevents silent null fallbacks; must be overridden before `ProviderScope` mounts

**Gotchas:**
- google_fonts async font loading fires after test assertions complete → `runZonedGuarded` in typography tests absorbs the trailing async error while keeping sync assertions valid
- `BorderRadius.vertical()` returns `BorderRadius`, not `BorderRadiusDirectional` — theme_test cast fixed to match
- Widget tests need `SharedPreferences.setMockInitialValues({})` + provider override before pumping `OdoApp`

---

### Story 1-2 — Design Tokens and Color System
**Completed:** 2026-05-15 | **Confidence:** 95/100

**Files created:**
- `lib/core/constants/odo_theme.dart` — `OdoTheme` immutable data class with 10 semantic token fields, `withCustomAccent(String)` for runtime accent override, `_parseHex` helper (handles with/without `#`)
- `lib/core/constants/app_colors.dart` — 8 raw palette constants (`@visibleForTesting`), 3 fixed category tokens, 3 `colorAccent*` semantic aliases, 7 const `OdoTheme` presets, `allThemes` list
- `test/core/constants/app_colors_test.dart` — 41 tests, 100% pass

**Key decisions:**
- Two-file split (`odo_theme.dart` / `app_colors.dart`) matches story task spec; `OdoTheme` stays pure-Dart (`dart:ui` only)
- `orbIdle` baked as `0x4D` alpha in const instances (30% of 255); `withCustomAccent` uses `withValues(alpha: 0.30)` for runtime path
- `@visibleForTesting` on raw palette enforces the two-layer rule at analysis time from the start

**Gotchas for Story 1-3:**
- `OdoTheme` has no `ThemeData` — that bridge is Story 1-3's job (`app/theme.dart`)
- `Color.alpha` / `Color.red` are deprecated in Flutter 3.27+ — use `(color.a * 255.0).round()` / `(color.r * 255.0).round()` in any new code or tests

---

### Story 1-1 — Project Setup and Dependency Configuration
**Completed:** 2026-05-15 | **Confidence:** 90/100

**Files created/modified:** `pubspec.yaml`, `android/app/build.gradle.kts`, `android/AndroidManifest.xml`, `ios/Runner/Info.plist`, `main.dart`, `app/app.dart`, full `lib/` folder structure, `CONVENTIONS.md`

**Key decisions:**
- `GoogleFonts.config.allowRuntimeFetching = false` set in `main()` before `runApp` to prevent startup latency
- Android NDK pinned to 28.2.13676358 (required by `speech_to_text`)
- `minSdk = 24` (required by `sqlite3_flutter_libs`)

**Gotchas fixed later (build fixes on 2026-05-15):**
- AGP upgraded 8.7.0 → 8.9.1 (androidx.core:core-ktx 1.18.0 required AGP ≥ 8.9.1)
- Kotlin upgraded 1.8.22 → 2.1.0 (Flutter required ≥ 2.1.0)
- Gradle wrapper upgraded 8.10.2 → 8.11.1 (AGP 8.9.1 required Gradle ≥ 8.11.1)
