# OdO — Epics & Stories

**Project:** OdO — Personal AI Daily Companion
**Author:** Lokki
**Date:** May 13, 2026
**Status:** Locked for V1 MVP Implementation

---

## Epic Overview

Six epics in execution order. Each epic depends on the previous one. Epic 1 unblocks everything else.

1. **Epic 1: Foundation** — Project scaffold, design tokens, theme system (7 presets), DB schema (6 tables), AiProvider abstraction, core services
2. **Epic 2: Agenda Module** — Persistent strip (3 states), day timeline, event CRUD, three categories, monthly calendar
3. **Epic 3: Practice Module** — Skill cards, session logging, streak computation, unanchored flagging, pattern detection
4. **Epic 4: AI Layer** — Context builder (4k cap), chat sheet, persistent bottom bar, voice tap-to-speak, offline degradation
5. **Epic 5: Glance + Evening + Proactive** — Glance Screen (lock, orb, info cards), Evening Session ritual, SuggestionEngine, background tasks, confirmation sheet
6. **Epic 6: Polish & Resilience** — All seven themes, light mode QA, animations, empty/error states, accessibility, locale QA, first-launch flow

**Target timeline:** 4–6 weeks solo.

---

## Epic 1: Foundation

**Goal:** Establish the architectural foundation — project scaffold, design tokens, theme system, database schema, core services, AI provider abstraction. This epic unblocks Epics 2–6.

**Technical Foundation Rationale:** This epic has no direct user-facing value but is essential infrastructure. The database schema, theme system, and AI provider abstraction are foundational decisions that cannot be changed mid-implementation without breaking dependent features. This epic must complete first.

**Duration:** Days 1–4

### Story 1.1: Project Setup and Dependency Configuration

As a developer,
I want to initialize the Flutter project with all required dependencies configured,
So that the project compiles and is ready for feature development.

**Acceptance Criteria:**

- **Given** a fresh Flutter project created with `flutter create --org com.odo odo`
- **When** I add all dependencies from `architecture.md` (Riverpod, Drift, go_router, workmanager, flutter_local_notifications, speech_to_text, flutter_tts, local_auth, connectivity_plus, etc.)
- **Then** the project compiles without errors on iOS and Android
- **And** `flutter pub get` succeeds
- **And** Android permissions (RECORD_AUDIO, USE_BIOMETRIC, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, WAKE_LOCK, VIBRATE, INTERNET) are in `AndroidManifest.xml`
- **And** iOS `Info.plist` includes `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`, `NSFaceIDUsageDescription`, `UIBackgroundModes`
- **And** `CONVENTIONS.md` is in the repo root documenting locked architectural decisions
- **And** `.env.example` documents required API keys; real `.env` is git-ignored

### Story 1.2: Design Tokens and Color System (Two-Layer, Seven Themes)

As a developer,
I want to define the two-layer color token system with seven theme presets,
So that all UI components use semantic tokens and theme switching is centralized.

**Acceptance Criteria:**

- **Given** the design system specification in `ux-design-specification.md`
- **When** I create `core/constants/app_colors.dart`
- **Then** the raw palette (violetPrimary, cyanPrimary, greenPrimary, emberOrange, cosmicMagenta, auroraTeal, darkBg, lightBg, etc.) is defined but never used directly in widgets
- **And** semantic tokens (`colorAccent`, `colorAccentAgenda`, `colorAccentWork`, `colorAccentPractice`, `colorSurface`, `colorBackground`, `colorTextPrimary`, `colorTextMuted`, `colorBorder`, `colorOrbIdle`, `colorOrbActive`) are defined for all UI usage
- **And** seven theme maps (Violet Dark, Cyan Dark, Green Dark, Light Mode, Cosmic, Ember, Aurora) are defined as `OdoTheme` data classes
- **And** custom accent override is supported as a hex string in `SharedPreferences`
- **And** category colors (Personal/Work/Practice) are defined as fixed semantic tokens
- **And** the file compiles and exports all tokens

### Story 1.3: Theme System with Runtime Swap

As a developer,
I want a `ThemeData` configuration for all seven presets with runtime swap and `SharedPreferences` persistence,
So that the user can pick a theme in settings and the app updates without restart.

**Acceptance Criteria:**

- **Given** the color tokens from Story 1.2
- **When** I create `app/theme.dart` and a Riverpod `activeThemeProvider`
- **Then** Violet Dark is hardcoded as default at first launch
- **And** the active theme name + optional custom accent hex are persisted via `SharedPreferences`
- **And** typography includes tabular figures for clock display (`FontFeature.tabularFigures()`)
- **And** `app_spacing.dart` defines the spacing scale (sp2–sp32)
- **And** `app_typography.dart` defines the type scale (textDisplay, textTitle, textBody, textBodyMuted, textCaption, textMicro)
- **And** animation durations (durationFast, durationDefault, durationSlow) are defined as constants
- **And** theme switching at runtime triggers a `ProviderScope` rebuild without app restart
- **And** semantic tokens correctly remap on dark↔light swap

### Story 1.4: SQLite Database Schema with Drift (Six Tables)

As a developer,
I want to define the complete V1 SQLite schema using Drift,
So that all data is persisted locally with type-safe access.

**Acceptance Criteria:**

- **Given** the schema in `architecture.md`
- **When** I create `core/database/app_database.dart` with Drift tables
- **Then** `skills` exists with `id`, `name`, `created_at`, `last_session_at`
- **And** `sessions` exists with `id`, `skill_id` (FK CASCADE), `started_at`, `duration_minutes`, `notes`, `is_anchored`, `suggested_time`
- **And** `events` exists with `id`, `title`, `start_time`, `end_time`, `category` (`personal`|`work`|`practice`), `notes`
- **And** `suggestions` exists with `id`, `skill_id` (FK SET NULL), `slot_start`, `slot_duration`, `suggested_at`, `accepted_at`, `dismissed_at`, `thumbs_down_at`, `suppressed_until`
- **And** `evening_sessions` exists with `id`, `session_date`, `started_at`, `completed_at`, `abandoned_at`, `headline`, `close_summary`
- **And** `evening_highlights` exists with `id`, `evening_session_id` (FK CASCADE), `display_order`, `content`, `source_type`, `source_ref_id`, `user_tag`, `tagged_at`
- **And** `dart run build_runner build` generates Drift code without errors
- **And** the database opens, migrates from scratch, and is ready for DAO access

### Story 1.5: AiProvider Abstraction with Five Implementations

As a developer,
I want an `AiProvider` abstract interface with concrete implementations,
So that the AI provider can be swapped via a single constant.

**Acceptance Criteria:**

- **Given** the abstraction design in `architecture.md`
- **When** I create `features/ai/domain/ai_provider.dart`
- **Then** `AiProvider` abstract class defines `String get name`, `Future<Result<AiResponse>> sendContext(AiContextPayload payload)`, `Future<Result<Stream<String>>> streamResponse(AiContextPayload payload)`
- **And** `ClaudeAiProvider` is implemented and functional via `--dart-define=AI_API_KEY`
- **And** `GeminiAiProvider`, `GroqAiProvider`, `OpenAiAiProvider` stubs exist with correct interfaces (can be empty bodies returning `Failure(AppError.aiUnavailable)` in V1)
- **And** `OfflineStubAiProvider` returns a deterministic response for testing
- **And** a single constant `kActiveAiProvider` in `core/constants/ai_config.dart` selects the active implementation
- **And** the Riverpod `aiProviderServiceProvider` injects the active implementation
- **And** API keys never appear in source control (`.env.example` documents; `.env` git-ignored)

### Story 1.6: Core Services

As a developer,
I want stateless supporting services for connectivity, notifications, background tasks, voice, and locale,
So that features can depend on them via Riverpod injection.

**Acceptance Criteria:**

- **Given** the supporting services in `architecture.md`
- **When** I create `core/services/`
- **Then** `ConnectivityService` exposes a `Stream<bool> isOnline$` via `connectivity_plus`
- **And** `NotificationService.initialize()` configures `flutter_local_notifications` with timezone init
- **And** `BackgroundTaskService.initialize()` registers `workmanager` with the 8pm task dispatcher
- **And** `VoiceService` wraps `speech_to_text` (STT) and `flutter_tts` (TTS) with a clean state machine (idle/listening/parsing/committing/committed)
- **And** `LocaleService` provides XOF formatting (no decimals, thin-space thousands), DD/MM/YYYY date formatting, and string lookup for French/English
- **And** all services are injected via Riverpod providers
- **And** unit tests for `LocaleService.formatXof()` and `LocaleService.formatDate()` pass

### Story 1.7: Result Type and Error Handling

As a developer,
I want a sealed `Result<T, AppError>` type and an `AppError` enum,
So that services and repositories communicate failures explicitly.

**Acceptance Criteria:**

- **Given** the error handling pattern in `architecture.md`
- **When** I create `core/domain/result.dart` and `core/domain/app_error.dart`
- **Then** `Result<T>` is sealed with `Success<T>` and `Failure<T>` subclasses
- **And** `AppError` enum includes `aiUnavailable`, `databaseWriteFailed`, `suggestionSuppressed`, `contextPayloadTooLarge`, `voiceCaptureFailed`, `voiceParseAmbiguous`, `slotNoLongerAvailable`, `authFailed`
- **And** all services and repositories use `Result<T>` for fallible operations
- **And** widgets use `AsyncValue.when` at the provider boundary
- **And** `try/catch` is reserved for third-party library calls only

### Story 1.8: Router and Project Structure

As a developer,
I want `go_router` configured with all V1 routes and bottom sheets as routes,
So that navigation is centralized and deep linking works.

**Acceptance Criteria:**

- **Given** the route map in `architecture.md`
- **When** I create `app/router.dart`
- **Then** top-level routes are defined: `/glance`, `/home`, `/home/agenda`, `/home/agenda/event/:id`, `/home/agenda/calendar`, `/home/practice`, `/home/practice/skill/:id`, `/evening`, `/settings`, `/settings/themes`
- **And** bottom sheet routes are defined: `/home/agenda/add-event`, `/home/practice/add-skill`, `/home/practice/log-session/:id`, `/confirm-suggestion/:id`
- **And** the project structure matches the spec: `features/{glance,home,agenda,practice,ai,evening_session,settings}/`, each with `data/`, `domain/`, `presentation/`
- **And** import rules are documented in `CONVENTIONS.md`: domain imports nothing from data/presentation; data imports only domain; presentation imports only domain entities and providers
- **And** a placeholder screen renders at each top-level route to confirm routing works

---

## Epic 2: Agenda Module

**Goal:** Build the temporal anchor of the entire product. The Agenda owns the data the AI reasons over. Without it, OdO has nothing to be proactive about.

**Duration:** Days 5–9

### Story 2.1: Agenda Repository and DAO

As a developer,
I want a repository and Drift DAO for the `events` table,
So that event CRUD is type-safe and centralized.

**Acceptance Criteria:**

- **Given** the `events` table from Epic 1
- **When** I create `features/agenda/data/agenda_dao.dart` and `features/agenda/data/agenda_repository.dart`
- **Then** the DAO exposes `insertEvent`, `updateEvent`, `deleteEvent`, `getEventById`, `getEventsBetween(startMs, endMs)`, `watchEventsForDay(date)`
- **And** the repository implements the abstract `AgendaRepository` from `domain/`
- **And** all methods return `Result<T, AppError>`
- **And** unit tests cover insert, update, delete, range query

### Story 2.2: Persistent Agenda Strip (Three States)

As a user,
I want a strip at the top of the home screen that shows what's next at all times,
So that I always know my temporal context without opening anything.

**Acceptance Criteria:**

- **Given** events stored locally
- **When** the strip renders
- **Then** State 1 (events today): shows next 2 events with time + title, titles truncated at 20 chars, format `9:00 Standup · 11:00 Design Review`
- **And** State 2 (no more today): shows first event tomorrow with muted "Tomorrow" label, format `Tomorrow · 9:00 Standup`
- **And** State 3 (nothing scheduled): single muted line *"Nothing scheduled — free day"*
- **And** the strip never shows more than 2 events simultaneously
- **And** tap expands into the Agenda slide
- **And** long-press opens the monthly calendar

### Story 2.3: Day Timeline View

As a user,
I want a vertical timeline of my day with 30-min grid lines and category colors,
So that I can see my day at a glance.

**Acceptance Criteria:**

- **Given** events for a selected date
- **When** I open the Agenda slide
- **Then** events render as colored blocks with a category left-bar (violet/blue/green)
- **And** the timeline shows 30-min grid lines from 6am to 11pm by default
- **And** free slots ≥30 min are visually distinct (dashed border, muted green tint)
- **And** tapping an event opens the event detail route
- **And** tapping a free slot opens the add-event bottom sheet with the slot pre-filled

### Story 2.4: Event CRUD with Three Categories

As a user,
I want to create, read, update, and delete events with a category,
So that I can manage my schedule.

**Acceptance Criteria:**

- **Given** the add-event bottom sheet
- **When** I open it
- **Then** fields are: title, start time, end time, category (Personal/Work/Practice radio), optional notes
- **And** category defaults to Personal
- **And** save commits to the `events` table and updates the strip immediately (optimistic UI)
- **And** edit and delete are available from the event detail screen
- **And** delete shows a confirmation toast with undo (5s)
- **And** voice command "rendez-vous at 7pm tonight" parses correctly via AI Layer (Epic 4)
- **And** 5-min pre-event reminder is scheduled via `NotificationService` on event create

### Story 2.5: Monthly Calendar

As a user,
I want a monthly calendar inside the Agenda slide,
So that I can navigate to other dates and see density at a glance.

**Acceptance Criteria:**

- **Given** events stored locally
- **When** I long-press the strip or tap the calendar icon
- **Then** a monthly view (`table_calendar`) renders with dots indicating event presence per day
- **And** dot color reflects the highest-priority category that day (Work > Practice > Personal, or design-driven mix)
- **And** tapping a day jumps the timeline to that date
- **And** today is highlighted with the active theme accent

---

## Epic 3: Practice Module

**Goal:** Build the habit-tracking surface. Skill cards, session logging, streak math, and the silent pattern detection that fuels the evening session's cross-domain insight.

**Duration:** Days 10–13

### Story 3.1: Practice Repository and DAO

As a developer,
I want a repository and DAO for `skills` and `sessions`,
So that practice data is type-safe and centralized.

**Acceptance Criteria:**

- **Given** the `skills` and `sessions` tables from Epic 1
- **When** I create `features/practice/data/practice_dao.dart` and `features/practice/data/practice_repository.dart`
- **Then** the DAO exposes `insertSkill`, `deleteSkill`, `watchAllSkills`, `insertSession`, `getSessionsForSkill(skillId, sinceMs)`, `getLastSession(skillId)`, `getUnanchoredSessions(skillId, sinceMs)`
- **And** the repository returns `Result<T>` for all writes
- **And** unit tests cover skill CRUD, session insertion, and unanchored query

### Story 3.2: First-Launch Skill Prompt

As a first-time user,
I want OdO to ask me one question on first launch,
So that I feel useful from minute one.

**Acceptance Criteria:**

- **Given** the user has just unlocked the Glance Screen for the first time
- **When** the home screen renders and `skills` is empty
- **Then** a single bottom sheet appears: *"What's one skill you're working on?"*
- **And** there is one text field and one button labeled "Add it"
- **And** submitting creates a skill and dismisses the sheet
- **And** the home screen now shows the skill card
- **And** the sheet never appears again after the first skill is created

### Story 3.3: Skill Card

As a user,
I want each skill to render as a card with my current streak and recent activity,
So that I can see progress without opening anything.

**Acceptance Criteria:**

- **Given** a skill with sessions
- **When** the skill card renders
- **Then** the top row shows skill name + current streak badge (e.g. "🔥 7")
- **And** the middle shows a 7-day activity bar — 7 vertical bars, filled if a session that day, muted if not
- **And** the bottom shows last session: duration + relative date (*"35 min · 2 days ago"*)
- **And** there are no XP indicators, no levels, no goal progress bars
- **And** tap opens the skill detail screen
- **And** long-press opens the quick-log session sheet

### Story 3.4: Session Logging

As a user,
I want to log a session with a duration and optional note,
So that the system records my practice.

**Acceptance Criteria:**

- **Given** the log-session bottom sheet
- **When** I open it
- **Then** fields are: duration (preset chips: 15/25/45/60 min + custom), optional note (text)
- **And** the `started_at` defaults to "now" (editable)
- **And** save commits to the `sessions` table with `is_anchored = 0` if no overlapping practice event exists, else `is_anchored = 1`
- **And** the completion animation runs (durationSlow, opacity + scale)
- **And** the streak updates immediately
- **And** the skill card's last-session line updates

### Story 3.5: Streak Computation

As a developer,
I want a `StreakCalculator` that computes the current streak for a skill,
So that the card always shows correct numbers.

**Acceptance Criteria:**

- **Given** a list of sessions for a skill
- **When** `StreakCalculator.compute(sessions, todayLocal)` is called
- **Then** the current streak equals the number of consecutive days ending today (or yesterday — grace period until end-of-day) with at least one session
- **And** the algorithm handles timezone correctly (UTC+0 storage, local-day boundary for display)
- **And** unit tests cover: no sessions, single session today, multi-day streak, broken streak, grace-period edge case at end-of-day

### Story 3.6: Pattern Detection (Unanchored Sessions)

As a developer,
I want a `PatternDetector` that identifies recurring unanchored session times,
So that the evening session can ask once about anchoring.

**Acceptance Criteria:**

- **Given** unanchored sessions for a skill
- **When** `PatternDetector.detect(skillId)` runs
- **Then** it queries the last 3 unanchored sessions for the skill
- **And** if all 3 start times fall within a ±45-minute window-of-day AND span ≥2 distinct calendar weeks, it returns a `PatternMatch`
- **And** otherwise returns `null`
- **And** unit tests cover: no sessions, 3 sessions same window same week (no match), 3 sessions same window 2+ weeks (match), 3 sessions different windows (no match)
- **And** once OdO has asked about a skill's pattern (yes or no), it never asks again for that skill (suppression flag persisted)

---

## Epic 4: AI Layer

**Goal:** Build OdO itself. The persistent bottom bar, the chat sheet, the context builder, voice tap-to-speak, and graceful offline degradation.

**Duration:** Days 14–17

### Story 4.1: Context Builder (4k Cap, Priority-Ordered)

As a developer,
I want a `ContextBuilder` that produces an AI context payload ≤4,000 characters,
So that the AI provider receives a focused, defensible payload.

**Acceptance Criteria:**

- **Given** local data (events, skills, sessions, suggestions)
- **When** `ContextBuilder.build()` is called
- **Then** the payload includes, in priority order: (1) current datetime + active screen, (2) today's agenda + next 48h, (3) all skills with current streak, (4) last 7 days unanchored sessions, (5) last 3 suggestions with outcomes
- **And** the total character count is ≤4,000
- **And** truncation drops lowest-priority sections first
- **And** the payload is built only in `AiService`, never in widgets
- **And** unit tests cover: empty data, full data within cap, oversize data with truncation

### Story 4.2: Persistent AI Bottom Bar

As a user,
I want a bottom bar on the home screen with quick-add, text input, and mic toggle,
So that OdO is always one tap away.

**Acceptance Criteria:**

- **Given** the home screen
- **When** the bottom bar renders
- **Then** three elements are visible: quick-add (+) on left, text input center, microphone toggle on right
- **And** tapping the text input expands into the chat sheet (modal route)
- **And** tapping the mic enters voice capture mode (Story 4.4)
- **And** tapping quick-add opens a sheet with three options: Add event, Log session, Add skill
- **And** the bottom bar is also the layout shared with the Glance Screen

### Story 4.3: Chat Sheet

As a user,
I want a modal chat surface where I can ask OdO questions,
So that I have a reactive channel to the AI.

**Acceptance Criteria:**

- **Given** I tap the text input in the bottom bar
- **When** the chat sheet opens
- **Then** previous messages from this session are visible (chat is scoped to the current app launch in V1)
- **And** I can type and send messages
- **And** OdO responds via the active `AiProvider`
- **And** OdO never initiates inside the chat — only the user sends first
- **And** quick commands ("What should I practice today?", "What's my next event?", "What's my Japanese streak?") are visible on first open as starter chips
- **And** when offline, my message stays in the thread with *"Couldn't reach AI · Tap to retry"* underneath
- **And** retry sends without retyping

### Story 4.4: Voice Tap-to-Speak Pipeline

As a user,
I want to tap the mic and speak to OdO,
So that voice is a first-class input.

**Acceptance Criteria:**

- **Given** I tap the mic toggle
- **When** the voice pipeline runs
- **Then** the orb morphs to the listening (waveform) state
- **And** `VoiceService` starts STT
- **And** 1.5 seconds of silence triggers `parsing` state — orb pulses
- **And** the transcript is sent to `AiService.parseCommand(transcript)` which returns an intent
- **And** clear intents commit immediately (create event, log session, add skill)
- **And** ambiguous intents show a single-line follow-up question above the bar
- **And** STT failure returns the orb to idle silently — no error toast
- **And** tapping the mic during listening cancels without committing

### Story 4.5: Offline Graceful Degradation

As a developer,
I want all AI-dependent surfaces to degrade silently when offline,
So that the user never sees an error state.

**Acceptance Criteria:**

- **Given** the device is offline
- **When** the user interacts with any AI surface
- **Then** the chat preserves the message with *"Couldn't reach AI · Tap to retry"*
- **And** the orb continues breathing (no error overlay)
- **And** voice capture proceeds to STT; commands that don't require AI parsing (e.g. literal "log 30 min Japanese") still commit
- **And** the Agenda strip continues updating from local data
- **And** the SuggestionEngine (on-device) continues working
- **And** the evening session, if 8pm, opens with cached headline logic running locally on the last-cached `AiResponse` template (or a fallback template)

---

## Epic 5: Glance + Evening + Proactive

**Goal:** Build the three defining surfaces — the Glance Screen, the Evening Session, and the proactive suggestion engine. This is where OdO becomes OdO.

**Duration:** Days 18–23

### Story 5.1: Glance Screen — Layout and States

As a user,
I want a Glance Screen that shows lock state, the orb, my next event, and the latest suggestion,
So that one look tells me what I need to know.

**Acceptance Criteria:**

- **Given** the app is on the Glance route
- **When** the screen renders
- **Then** top row shows the lock icon (violet locked, green unlocked) + state label
- **And** the orb is centered, breathing animation idle, waveform when listening
- **And** below the orb, up to 2 info cards render: next event (always) and OdO's latest suggestion (if one exists in the last 18h)
- **And** sensitive data never appears on the cards (no full event descriptions, no expense amounts)
- **And** the bottom bar matches the home screen bottom bar (quick-add, text input, mic)
- **And** a subtle slide-up handle is visible at the bottom

### Story 5.2: Glance Screen — Authentication

As a user,
I want to unlock the Glance Screen with vocal password, typed password, or biometric,
So that OdO is private without being annoying.

**Acceptance Criteria:**

- **Given** the Glance Screen is locked
- **When** I attempt unlock
- **Then** I can say "Hey OdO, unlock — [my phrase]" — STT validates against the stored phrase, lock icon morphs to unlocked-green on success
- **And** I can tap the text input and type the password, enter to submit
- **And** if biometric is enabled in settings, swiping up triggers biometric prompt
- **And** three consecutive vocal failures lock vocal unlock for 5 minutes (typed becomes only path)
- **And** the unlock phrase is set during Glance Screen onboarding (first launch)
- **And** unlock state persists for the app session; the screen re-locks on app background after a configurable timeout (default: 5 min)

### Story 5.3: The Orb Widget

As a developer,
I want a reusable `Orb` widget with all visual states,
So that the same widget renders on Glance and home and (V2) watch.

**Acceptance Criteria:**

- **Given** the orb widget
- **When** rendered in different states
- **Then** `OrbState.idle` shows a breathing animation in `colorOrbIdle` (active accent at low opacity)
- **And** `OrbState.listening` shows a waveform animation in `colorOrbActive` (active accent at full)
- **And** `OrbState.parsing` shows a brief pulse (durationFast)
- **And** `OrbState.committed` shows a single bright pulse + checkmark overlay (durationDefault)
- **And** the orb size scales correctly across surfaces (Glance: large, home: medium, watch V2: small)
- **And** `MediaQuery.disableAnimations` disables breathing/waveform; orb becomes static

### Story 5.4: Evening Session — Orchestration

As a developer,
I want an `EveningSessionNotifier` that orchestrates the 5-minute ritual,
So that the session has correct state at every step.

**Acceptance Criteria:**

- **Given** an evening session is started
- **When** `EveningSessionNotifier.start()` runs
- **Then** a row is created in `evening_sessions` with `session_date = today`, `started_at = now`
- **And** the headline is generated from today's data via `HeadlineGenerator`
- **And** `HighlightRanker` selects 3–4 highlights from sessions, events, and patterns of the last 24h
- **And** the cross-domain insight (if any) is appended as the last item
- **And** the session screen renders sequentially: headline → highlights → insight → close
- **And** each tag/expand/dismiss writes immediately to `evening_highlights`
- **And** "Wrap up" is always visible at the top — tapping jumps to the close phase
- **And** the close phase writes `completed_at` and generates the close summary

### Story 5.5: Evening Session — Persistence Until Midnight

As a user,
I want my evening session to survive interruption until midnight,
So that I can return to it after a phone call or distraction.

**Acceptance Criteria:**

- **Given** a session was started but not completed
- **When** I reopen the app between 8pm and midnight
- **Then** the session resumes from the current step (next un-tagged highlight)
- **And** all previously tagged highlights remain tagged
- **And** at local midnight, an app-open check (or background job) marks the session `abandoned_at = midnight_timestamp` if still incomplete
- **And** tomorrow's session starts fresh
- **And** unit tests cover: start → background → resume same day, start → cross midnight → abandoned

### Story 5.6: Suggestion Engine (On-Device)

As a developer,
I want a `SuggestionEngine` that produces proactive suggestions entirely on-device,
So that suggestions work offline.

**Acceptance Criteria:**

- **Given** local data (skills, sessions, events, suggestions)
- **When** `SuggestionEngine.generate()` runs
- **Then** it queries idle skills (last_session_at older than 24h), filters out suppressed skills
- **And** computes free slots in the next 48h (gaps ≥30 min in the agenda)
- **And** ranks: longest-idle skill → shortest fitting slot → earliest available window
- **And** returns the first match (one suggestion at most per call)
- **And** persists the suggestion to `suggestions` table
- **And** unit tests cover: no idle skills, all skills suppressed, multiple slots multiple skills (correct ranking)

### Story 5.7: Confirmation Sheet (Four Elements, Stale Slot Guard)

As a user,
I want a clear, four-element confirmation sheet when OdO suggests something,
So that I can act or dismiss in seconds.

**Acceptance Criteria:**

- **Given** a suggestion is delivered
- **When** I tap the notification
- **Then** the confirmation sheet renders four elements only: suggestion text, context line, "Block it" primary button (theme accent), "Not now" secondary text button
- **And** there is no close icon, no "remind me later", no why-field
- **And** long-press on "Not now" reveals a single option: "Don't suggest this again" — tapping suppresses the skill for 7 days
- **And** the sheet runs a stale-slot check on open: if the slot is gone, all four elements collapse to a single line *"This slot is no longer available"* with one button "Close"
- **And** "Block it" commits the session/event to both Agenda and Practice simultaneously and dismisses the sheet

### Story 5.8: Background Tasks (8pm + Pre-Event + Throughout-Day)

As a user,
I want OdO to nudge me at the right moments without me opening the app,
So that the daily rhythm runs on its own.

**Acceptance Criteria:**

- **Given** workmanager + flutter_local_notifications are configured
- **When** background tasks run
- **Then** an 8pm local-time task fires a notification "Your evening with OdO is ready"
- **And** 5-min pre-event reminders fire for each event with `start_time - 5 min`
- **And** throughout-day suggestion notifications fire on meaningful data shift (event canceled, streak at risk, pattern threshold crossed)
- **And** the "one AI voice per day" rule is enforced: if a throughout-day suggestion fires, the evening session's cross-domain insight is suppressed
- **And** if the 8pm task doesn't fire (OS killed), the app-open fallback after 8pm same day, within 18h, surfaces the session inline

### Story 5.9: Suppression Algorithm

As a developer,
I want `SuggestionEngine` to respect suppression windows,
So that the user is never re-suggested something they just dismissed.

**Acceptance Criteria:**

- **Given** a suggestion outcome (accepted, dismissed, thumbs-down)
- **When** outcome is recorded
- **Then** `suppressed_until` for that skill is set: accepted = now + 1 day, dismissed = now + 3 days, thumbs-down = now + 7 days
- **And** `SuggestionEngine.generate()` filters out any skill where `suppressed_until > now()`
- **And** unit tests verify each window

---

## Epic 6: Polish & Resilience

**Goal:** Make it feel like a finished product. Light mode QA, all seven themes, animations, empty/error states, accessibility, locale QA, first-launch flow.

**Duration:** Days 24–28

### Story 6.1: All Seven Themes Render Correctly

As a user,
I want to switch between all seven themes,
So that I can match OdO to my taste.

**Acceptance Criteria:**

- **Given** the theme picker in settings
- **When** I tap each theme card
- **Then** the entire app rebuilds with the new tokens (durationDefault crossfade)
- **And** all seven themes render the orb, strip, cards, accents coherently
- **And** WCAG AA contrast holds on all semantic tokens in all themes
- **And** custom accent picker is functional (24 swatches default; HSL picker behind "advanced")

### Story 6.2: Light Mode — Outdoor Readability

As a user in direct Abidjan sunlight,
I want light mode to be genuinely readable outdoors,
So that OdO works wherever I am.

**Acceptance Criteria:**

- **Given** Light Mode is active
- **When** I test the app in direct sunlight
- **Then** all text remains legible (contrast ≥7:1 for body text)
- **And** the orb is visible against the light background
- **And** category colors remain distinguishable
- **And** the agenda strip and event blocks are readable without squinting
- **And** the user can confirm "yes, I can read this in the sun"

### Story 6.3: Empty States and Error States

As a user,
I want every screen to handle empty and error states gracefully,
So that I never see a broken-looking app.

**Acceptance Criteria:**

- **Given** any screen
- **When** there's no data or an error occurs
- **Then** Empty Agenda: persistent strip shows *"Nothing scheduled — free day"*, timeline shows a calm illustration + "Add your first event"
- **And** Empty Practice: first-launch skill prompt covers this; if user deletes all skills, show *"No skills yet"* with quick-add CTA
- **And** Empty Chat: starter quick-command chips visible
- **And** Offline AI: chat shows retry pattern, orb continues breathing
- **And** Database error: silent fallback to in-memory state for the screen, log to console
- **And** No screen shows raw error stack traces or unstyled error widgets

### Story 6.4: Animations and Motion

As a user,
I want OdO to feel alive but never frantic,
So that interactions feel intentional.

**Acceptance Criteria:**

- **Given** any animated surface
- **When** animations play
- **Then** orb breathing is at ~12 BPM (slow, calm)
- **And** session completion uses durationSlow opacity + scale-down
- **And** bottom sheet open/close uses durationDefault with custom curve
- **And** confirmation sheet uses durationSlow
- **And** `MediaQuery.disableAnimations` disables all non-essential motion; orb becomes static
- **And** no animation feels like a loading state

### Story 6.5: Accessibility Audit

As a user with accessibility needs,
I want OdO to work with screen readers and respect motion preferences,
So that I'm not excluded.

**Acceptance Criteria:**

- **Given** an accessibility audit
- **When** I run through key flows with TalkBack/VoiceOver
- **Then** all interactive elements have semantic labels
- **And** the orb announces its state ("OdO is listening", "OdO is idle")
- **And** all touch targets are ≥44dp
- **And** `MediaQuery.disableAnimations` is respected throughout
- **And** voice is fully equivalent to tap for all critical flows (add event, log session, dismiss suggestion)
- **And** color is never the only signal for state (icon + text label always paired)

### Story 6.6: Locale QA — French and XOF

As a francophone user,
I want OdO to feel native in French and Ivorian context,
So that nothing feels imported.

**Acceptance Criteria:**

- **Given** French-primary UI
- **When** I use the app
- **Then** all UI strings are in French by default (English fallback in settings)
- **And** XOF currency renders as `15 000 F` (no decimals, thin-space thousands)
- **And** dates render as DD/MM/YYYY everywhere
- **And** times render in 24-hour format
- **And** a francophone reviewer confirms naturalness of the French strings
- **And** AI responses are English in V1 (French deferred to V1.5)

### Story 6.7: First-Launch Flow

As a first-time user,
I want OdO to be useful within 5 minutes of install,
So that I don't have to learn anything.

**Acceptance Criteria:**

- **Given** I install and open the app for the first time
- **When** I complete the first-launch sequence
- **Then** I see the Glance Screen onboarding (set unlock phrase + optional biometric)
- **And** the home screen renders with empty Agenda strip and empty Practice carousel
- **And** the first-launch skill prompt appears: "What's one skill you're working on?"
- **And** I can add my first skill with one text entry
- **And** I can add my first event via voice or quick-add
- **And** at 8pm, my first evening session opens with whatever data I've added
- **And** the total time from install to first useful state is ≤5 minutes with no instruction

### Story 6.8: Performance and Crash-Free Resilience

As a developer,
I want OdO to feel fast and never crash,
So that the user trusts it daily.

**Acceptance Criteria:**

- **Given** normal use
- **When** I measure
- **Then** perceived latency for any local action is <500ms (optimistic UI where appropriate)
- **And** 2 consecutive weeks of personal daily use produce zero crashes
- **And** background tasks (8pm session) fire successfully ≥70% of days; fallback covers the rest
- **And** the app cold-starts in <1.5s on a mid-range Android device

---

## Cross-Epic Definition of Done

For every story:

- [ ] Code follows the import rules in `CONVENTIONS.md`
- [ ] Public APIs return `Result<T, AppError>` or `AsyncValue<T>` per the rule
- [ ] Drift queries are typed; no raw SQL strings
- [ ] No hardcoded colors in widgets — only semantic tokens
- [ ] Unit tests written for pure-logic components (calculators, builders, engines)
- [ ] Widget tests for critical UI states
- [ ] No analytics, telemetry, or third-party SDK additions
- [ ] No API keys in source control
- [ ] French strings reviewed by a francophone speaker (if user-facing)
- [ ] Manual test on iOS and Android before marking done

---

## Out of Scope for V1

Documented here so the build never re-debates them.

**V1.5:** Expenses module, recurring events, French AI responses, Sunday weekly reflection, receipt scanning, custom budget categories
**V2:** Apple Watch + Wear OS, "Hey OdO" wake-word, cross-device handoff
**V3:** Family plan, shared awareness, per-event privacy, backend, sync
**V4:** Enterprise plan, multi-tenant, RBAC, admin dashboards

---

**Document Status:** Locked for V1 MVP Implementation
**Last Updated:** May 13, 2026
**Owner:** Lokki (Solo Developer, Abidjan)
