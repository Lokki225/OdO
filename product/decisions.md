# TooXTips — Architecture Decision Records

> Last updated: 2026-04-28

---

## ADR-001: Flutter for cross-platform mobile

**Status:** Accepted  
**Context:** App needs to run on Android and iOS from a single codebase. Franklin uses Android primarily.  
**Decision:** Flutter + Dart.  
**Consequences:** Single codebase, fast UI, strong ecosystem. Dart code generation (Drift, Riverpod) requires `build_runner` step.

---

## ADR-002: Riverpod for state management

**Status:** Accepted  
**Context:** Needed a state solution that supports code generation, is testable, and avoids boilerplate.  
**Decision:** `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`. All providers for a feature live in `{feature}_providers.dart`.  
**Alternatives considered:** BLoC (too verbose), Provider (superseded by Riverpod), GetX (poor testability).  
**Consequences:** `build_runner` required for provider generation. `AsyncNotifier` replaces BLoC event/state classes. `StreamProvider` enables reactive Drift queries.

---

## ADR-003: Drift (SQLite) for local persistence

**Status:** Accepted  
**Context:** App is offline-first. Data must persist locally without a server.  
**Decision:** `drift` + `drift_flutter` + `sqlite3_flutter_libs`. All tables defined in `AppDatabase` (`core/database/app_database.dart`). Column names are snake_case; Drift generates camelCase Dart accessors.  
**Alternatives considered:** Hive (no relational queries), Isar (less mature), ObjectBox (licence concerns).  
**Consequences:** Code generation required for DAO and table classes. Migrations needed for schema changes.

---

## ADR-004: Claude API for AI features

**Status:** Accepted  
**Context:** AI suggestions, chat interface, and proactive notifications require an LLM.  
**Decision:** Claude API (`claude-sonnet-4-6`) called via `http` package. No Anthropic SDK — raw HTTP keeps the dependency minimal.  
**AI context payload (capped at 4000 chars):**
- Today's agenda events
- Agenda events for the next 48 hours
- All active Wills with last session date
- Last 7 days of unanchored sessions
- Last 3 AI suggestions
- Current datetime and active screen  
**Offline behaviour:** AI features degrade gracefully. Core app (agenda, wills, expenses) works fully offline.  
**API key:** injected at build time via `--dart-define=CLAUDE_API_KEY=...`. Never hardcoded.

---

## ADR-005: Offline-first architecture

**Status:** Accepted  
**Context:** Franklin uses the app throughout the day, including in low-connectivity situations.  
**Decision:** All reads and writes go to local SQLite first. The Claude API is the only networked dependency. If offline, AI features show a degraded state; all other features work normally.  
**Consequences:** No server, no sync (until v1.1 optional cloud sync). Data lives only on the device.

---

## ADR-006: Clean Architecture (data / domain / presentation)

**Status:** Accepted  
**Context:** Need clear separation to keep the codebase testable and prevent feature coupling.  
**Decision:** Three-layer architecture per feature. Dependency direction: `presentation -> domain <- data`. Domain has zero external imports.  
**Enforcement:** CLAUDE.md workflow blocks implementation if layers are violated. `CONVENTIONS.md` documents the rules.

---

## ADR-007: Dark mode default

**Status:** Accepted  
**Context:** Franklin prefers OLED-friendly dark UI. Dark mode is the designed experience.  
**Decision:** Default theme is dark (`#0D0D0F` background, `#7C4DFF` violet accent for agenda, `#1D9E75` green accent for wills). Light mode toggle available via SharedPreferences.  
**Consequences:** All widgets and design tokens must be designed dark-first and tested in dark mode.

---

## ADR-008: workmanager + flutter_local_notifications for proactive AI

**Status:** Accepted  
**Context:** The AI needs to send a proactive suggestion at 8pm daily, even when the app is not open.  
**Decision:** `workmanager` schedules a background task that builds the AI context, calls the Claude API, and uses `flutter_local_notifications` to deliver the result as a notification.  
**Consequences:** Android `SCHEDULE_EXACT_ALARM` and `POST_NOTIFICATIONS` permissions required. iOS background modes must be enabled.

---

## ADR-009: go_router for navigation

**Status:** Accepted  
**Context:** App uses a carousel shell (persistent agenda strip + swipeable slides) with modal bottom sheets.  
**Decision:** `go_router` handles named routes and bottom sheet navigation. The main shell is a `PageController`-based carousel, not tab bars.  
**Consequences:** Deep linking is supported via go_router. Bottom sheets use `showModalBottomSheet` triggered from providers.

---

## ADR-010: Expenses deferred to v1.1

**Status:** Accepted  
**Context:** MVP scope must be kept manageable. Agenda + Wills + AI is the core value loop.  
**Decision:** Expenses module is not in MVP. v1.1 target is Q3 2026.  
**Consequences:** Database schema should not include expense tables in MVP. Expense-related UI placeholders are out of scope.
