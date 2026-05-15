---
projectName: OdO
date: 2026-05-13
sprintDuration: 4 weeks (28 days)
totalStories: 41
totalEpics: 6
---

# OdO Sprint Plan

**Project:** OdO — Personal AI Daily Companion
**Sprint Start:** 2026-05-13
**Duration:** 28 days (Days 1–28)
**Total Stories:** 41 across 6 epics
**Target Timeline:** 4–6 weeks solo
**Status:** Ready for implementation

---

## Sprint Overview

This plan organizes the 41 stories from `epics.md` into a day-based execution sequence. Epic execution is sequential — each epic depends on the prior. Within an epic, stories with no dependencies can proceed in parallel.

### Key Principles

- **Epic 1 first, always.** Nothing works without the Foundation.
- **Data before UI.** Repository/DAO stories unlock all feature stories above them.
- **Domain before data before presentation.** No exceptions per `CLAUDE.md`.
- **Offline-first throughout.** Every story must leave the feature working without connectivity.
- **Zero lint policy.** `flutter analyze` must show no issues before any story is marked done.

---

## Phase 1: Foundation (Epic 1) — Days 1–4

**Goal:** Project scaffold, design tokens, two-layer color system (7 themes), theme runtime swap, SQLite schema (6 tables), AiProvider abstraction (5 implementations), core services, Result type, router.

**Stories:** 8
**Deliverables:** Compilable project ready for all feature development.

### Story 1.1 — Project Setup and Dependency Configuration

- `flutter create --org com.odo odo`
- Add all dependencies: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `drift`, `drift_flutter`, `go_router`, `workmanager`, `flutter_local_notifications`, `speech_to_text`, `flutter_tts`, `local_auth`, `connectivity_plus`, `google_fonts`, `shared_preferences`, `http`, `build_runner`, `drift_dev`
- Android `AndroidManifest.xml`: `RECORD_AUDIO`, `USE_BIOMETRIC`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `WAKE_LOCK`, `VIBRATE`, `INTERNET`
- iOS `Info.plist`: `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`, `NSFaceIDUsageDescription`, `UIBackgroundModes`
- `.env.example` documents required API keys; real `.env` git-ignored
- `CONVENTIONS.md` in repo root with locked architectural decisions
- `flutter pub get` succeeds; project compiles on iOS and Android

### Story 1.2 — Design Tokens and Color System (Two-Layer, Seven Themes)

- Create `core/constants/app_colors.dart`
- **Raw palette** (never used directly in widgets):
  - `violetPrimary = #7C4DFF`, `cyanPrimary = #00C2D4`, `greenPrimary = #1D9E75`
  - `emberOrange = #FF6B35`, `cosmicMagenta = #C770FF`, `auroraTeal = #2DD4BF`
  - `darkBg = #0D0D0F`, `darkSurface = #1A1A1F`, `lightBg = #FDFBF7`, `lightSurface = #FFFFFF`
  - `mutedTextDark = #6B6B80`, `primaryTextDark = #E8E8F0`
  - `borderDark = #2A2A35`, `borderLight = #E6E1D7`
  - `categoryPersonal = #7C4DFF`, `categoryWork = #5B8BD4`, `categoryPractice = #1D9E75`
- **Semantic tokens** (used in all widgets): `colorAccent`, `colorAccentAgenda`, `colorAccentWork`, `colorAccentPractice`, `colorSurface`, `colorBackground`, `colorTextPrimary`, `colorTextMuted`, `colorBorder`, `colorOrbIdle`, `colorOrbActive`
- **Seven `OdoTheme` maps**: Violet Dark (default), Cyan Dark, Green Dark, Light Mode, Cosmic, Ember, Aurora
- Custom accent override supported as hex string in `SharedPreferences`
- Category colors fixed as semantic tokens (never remapped by theme)

### Story 1.3 — Theme System with Runtime Swap

- Create `app/theme.dart` + Riverpod `activeThemeProvider`
- Violet Dark hardcoded as default at first launch
- Active theme name + optional custom accent hex persisted via `SharedPreferences`
- `app_typography.dart`: `textDisplay` (28/400), `textTitle` (22/500), `textBody` (16/400), `textBodyMuted` (14/400), `textCaption` (12/500), `textMicro` (11/600); clock style uses `FontFeature.tabularFigures()`
- Fraunces serif for evening session headline + skill names; system sans-serif for body
- `app_spacing.dart`: `sp2`, `sp4`, `sp8`, `sp12`, `sp16`, `sp20`, `sp24`, `sp32`
- Animation durations: `durationFast = 150ms`, `durationDefault = 250ms`, `durationSlow = 400ms`
- Theme switching at runtime triggers `ProviderScope` rebuild without restart
- Semantic tokens correctly remap on dark ↔ light swap

### Story 1.4 — SQLite Database Schema with Drift (Six Tables)

- Create `core/database/app_database.dart`
- `skills`: `id`, `name`, `created_at`, `last_session_at`
- `sessions`: `id`, `skill_id` (FK CASCADE), `started_at`, `duration_minutes`, `notes`, `is_anchored`, `suggested_time`
- `events`: `id`, `title`, `start_time`, `end_time`, `category` (`personal`|`work`|`practice`), `notes`
- `suggestions`: `id`, `skill_id` (FK SET NULL), `slot_start`, `slot_duration`, `suggested_at`, `accepted_at`, `dismissed_at`, `thumbs_down_at`, `suppressed_until`
- `evening_sessions`: `id`, `session_date`, `started_at`, `completed_at`, `abandoned_at`, `headline`, `close_summary`
- `evening_highlights`: `id`, `evening_session_id` (FK CASCADE), `display_order`, `content`, `source_type`, `source_ref_id`, `user_tag`, `tagged_at`
- `dart run build_runner build` generates without errors
- Database opens, migrates from scratch, ready for DAO access

### Story 1.5 — AiProvider Abstraction with Five Implementations

- `features/ai/domain/ai_provider.dart`: abstract `AiProvider` with `String get name`, `Future<Result<AiResponse>> sendContext(AiContextPayload)`, `Future<Result<Stream<String>>> streamResponse(AiContextPayload)`
- `ClaudeAiProvider`: functional via `--dart-define=AI_API_KEY`
- `GeminiAiProvider`, `GroqAiProvider`, `OpenAiAiProvider`: stubs returning `Failure(AppError.aiUnavailable)` in V1
- `OfflineStubAiProvider`: deterministic response for testing
- `kActiveAiProvider` constant in `core/constants/ai_config.dart` selects active implementation
- Riverpod `aiProviderServiceProvider` injects active implementation
- API keys never in source control

### Story 1.6 — Core Services

- `ConnectivityService`: `Stream<bool> isOnline$` via `connectivity_plus`
- `NotificationService.initialize()`: configures `flutter_local_notifications` with timezone init
- `BackgroundTaskService.initialize()`: registers `workmanager` with 8pm task dispatcher
- `VoiceService`: wraps `speech_to_text` (STT) + `flutter_tts` (TTS); state machine: idle → listening → parsing → committing → committed
- `LocaleService`: XOF formatting (no decimals, thin-space thousands), DD/MM/YYYY, French/English string lookup
- All services injected via Riverpod providers
- Unit tests for `LocaleService.formatXof()` and `LocaleService.formatDate()` pass

### Story 1.7 — Result Type and Error Handling

- `core/domain/result.dart`: sealed `Result<T>` with `Success<T>` and `Failure<T>`
- `core/domain/app_error.dart`: `AppError` enum — `aiUnavailable`, `databaseWriteFailed`, `suggestionSuppressed`, `contextPayloadTooLarge`, `voiceCaptureFailed`, `voiceParseAmbiguous`, `slotNoLongerAvailable`, `authFailed`
- All services and repositories use `Result<T>` for fallible operations
- Widgets use `AsyncValue.when` at provider boundary
- `try/catch` reserved for third-party library calls only

### Story 1.8 — Router and Project Structure

- `app/router.dart` with all V1 routes:
  - Top-level: `/glance`, `/home`, `/home/agenda`, `/home/agenda/event/:id`, `/home/agenda/calendar`, `/home/practice`, `/home/practice/skill/:id`, `/evening`, `/settings`, `/settings/themes`
  - Bottom sheets: `/home/agenda/add-event`, `/home/practice/add-skill`, `/home/practice/log-session/:id`, `/confirm-suggestion/:id`
- Project structure matches spec: `features/{glance,home,agenda,practice,ai,evening_session,settings}/` each with `data/`, `domain/`, `presentation/`
- Import rules documented in `CONVENTIONS.md`: domain ← nothing; data ← domain; presentation ← domain + providers
- Placeholder screen at each top-level route confirms routing works

**Epic 1 Done When:**
- `flutter pub get` and `flutter analyze` pass clean
- Database schema generated and opens
- Theme system functional, Violet Dark default
- All 5 AI provider stubs compile
- All services inject via Riverpod
- Router renders placeholder at every route

---

## Phase 2: Agenda Module (Epic 2) — Days 5–9

**Goal:** Persistent strip (3 states), day timeline, event CRUD, three categories, monthly calendar.

**Stories:** 5
**Deliverables:** Fully functional Agenda with real-time event management.

### Story 2.1 — Agenda Repository and DAO

- `features/agenda/data/agenda_dao.dart`: `insertEvent`, `updateEvent`, `deleteEvent`, `getEventById`, `getEventsBetween(startMs, endMs)`, `watchEventsForDay(date)`
- `features/agenda/data/agenda_repository.dart` implements abstract `AgendaRepository` from `domain/`
- All methods return `Result<T, AppError>`
- Unit tests: insert, update, delete, range query

### Story 2.2 — Persistent Agenda Strip (Three States)

- **State 1** (events today): next 2 events, titles truncated at 20 chars — `9:00 Standup · 11:00 Design Review`
- **State 2** (no more today): first tomorrow event — `Tomorrow · 9:00 Standup`
- **State 3** (nothing scheduled): single muted line — *"Nothing scheduled — free day"*
- Never more than 2 events simultaneously
- Tap → Agenda slide; long-press → monthly calendar

### Story 2.3 — Day Timeline View

- Colored event blocks with category left-bar (violet = Personal, blue = Work, green = Practice)
- 30-min grid lines, 6am–11pm default
- Free slots ≥30 min: dashed border, muted green tint
- Tap event → event detail route
- Tap free slot → add-event sheet with slot pre-filled

### Story 2.4 — Event CRUD with Three Categories

- Add-event bottom sheet: title, start time, end time, category (Personal/Work/Practice radio, default Personal), optional notes
- Save commits optimistically; strip updates immediately
- Edit + delete available from event detail screen
- Delete: confirmation toast with undo (5s)
- 5-min pre-event reminder scheduled via `NotificationService` on create

### Story 2.5 — Monthly Calendar

- `table_calendar` renders with dots indicating event presence per day
- Dot color reflects highest-priority category (Work > Practice > Personal)
- Tap day → jumps timeline to that date
- Today highlighted with active theme accent

**Epic 2 Done When:**
- Event CRUD works end-to-end
- Strip reactive to event changes, all 3 states correct
- Timeline renders events with correct category colors
- Monthly calendar navigates dates
- 5-min reminders scheduled on event create

---

## Phase 3: Practice Module (Epic 3) — Days 10–13

**Goal:** Skill cards, session logging, streak computation, unanchored flagging, pattern detection.

**Stories:** 6
**Deliverables:** Fully functional Practice module with habit tracking.

### Story 3.1 — Practice Repository and DAO

- `features/practice/data/practice_dao.dart`: `insertSkill`, `deleteSkill`, `watchAllSkills`, `insertSession`, `getSessionsForSkill(skillId, sinceMs)`, `getLastSession(skillId)`, `getUnanchoredSessions(skillId, sinceMs)`
- `features/practice/data/practice_repository.dart` returns `Result<T>` for all writes
- Unit tests: skill CRUD, session insertion, unanchored query

### Story 3.2 — First-Launch Skill Prompt

- Home screen renders + `skills` is empty → single bottom sheet: *"What's one skill you're working on?"*
- One text field, one button "Add it"
- Submit creates skill, dismisses sheet
- Home shows skill card immediately
- Sheet never appears again after first skill created

### Story 3.3 — Skill Card

- **Top row:** skill name + streak badge (*"🔥 7"*)
- **Middle:** 7-day activity bar — 7 vertical bars, filled if session that day
- **Bottom:** last session — duration + relative date (*"35 min · 2 days ago"*)
- No XP, no levels, no goal bars
- Tap → skill detail screen; long-press → quick-log sheet

### Story 3.4 — Session Logging

- Log-session bottom sheet: duration chips (15/25/45/60 min + custom), optional note, `started_at` defaults to now (editable)
- `is_anchored = 0` if no overlapping practice event; `= 1` if overlap exists
- Completion animation: `durationSlow`, opacity + scale
- Streak updates immediately; skill card last-session line updates

### Story 3.5 — Streak Computation

- `StreakCalculator.compute(sessions, todayLocal)` in domain layer
- Consecutive days ending today (or yesterday — grace period until end-of-day) with ≥1 session
- UTC+0 storage, local-day boundary for display
- Unit tests: no sessions, single today, multi-day streak, broken streak, grace-period edge case

### Story 3.6 — Pattern Detection (Unanchored Sessions)

- `PatternDetector.detect(skillId)` in domain layer
- Last 3 unanchored sessions for skill; if all 3 start times within ±45-min window-of-day AND span ≥2 distinct calendar weeks → returns `PatternMatch`
- Otherwise returns `null`
- Once asked (yes or no), never asks again for that skill (suppression flag persisted)
- Unit tests: no sessions, 3 same window same week (no match), 3 same window 2+ weeks (match), 3 different windows (no match)

**Epic 3 Done When:**
- Skill CRUD works; cards render with streak + activity bar
- Session logging commits with correct `is_anchored` flag
- `StreakCalculator` passes all unit tests
- `PatternDetector` passes all unit tests
- First-launch prompt works and never repeats

---

## Phase 4: AI Layer (Epic 4) — Days 14–17

**Goal:** Context builder (4k cap), chat sheet, persistent bottom bar, voice tap-to-speak, offline degradation.

**Stories:** 5
**Deliverables:** AI fully integrated; voice functional; offline-tolerant.

### Story 4.1 — Context Builder (4k Cap, Priority-Ordered)

- `ContextBuilder.build()` in `features/ai/domain/`
- Priority order: (1) current datetime + active screen, (2) today's agenda + next 48h, (3) all skills + current streak, (4) last 7 days unanchored sessions, (5) last 3 suggestions + outcomes
- Total ≤4,000 characters; truncation drops lowest-priority sections first
- Built only inside `AiService`, never in widgets
- Unit tests: empty data, full data within cap, oversize data with truncation

### Story 4.2 — Persistent AI Bottom Bar

- Home screen bottom bar: quick-add (+) left, text input center, mic toggle right
- Tap text input → chat sheet (modal route)
- Tap mic → voice capture mode (Story 4.4)
- Tap quick-add → sheet with three options: Add event, Log session, Add skill
- Same layout shared with Glance Screen

### Story 4.3 — Chat Sheet

- Modal chat surface; prior session messages visible (scoped to current app launch in V1)
- Type + send; OdO responds via active `AiProvider`
- OdO never initiates inside the chat
- First-open starter chips: "What should I practice today?", "What's my next event?", "What's my Japanese streak?"
- Offline: message stays in thread with *"Couldn't reach AI · Tap to retry"*; retry sends without retyping

### Story 4.4 — Voice Tap-to-Speak Pipeline

- Tap mic → orb morphs to listening (waveform)
- `VoiceService` starts STT
- 1.5s silence → `parsing` state, orb pulses
- Transcript → `AiService.parseCommand(transcript)` → intent
- Clear intents commit immediately (create event, log session, add skill)
- Ambiguous intents → single-line follow-up question above bar
- STT failure → orb returns to idle silently (no error toast)
- Tap mic during listening → cancel without commit

### Story 4.5 — Offline Graceful Degradation

- Offline → chat shows *"Couldn't reach AI · Tap to retry"* with message preserved
- Orb continues breathing; no error overlay
- Voice capture proceeds to STT; literal commands (no AI parsing needed) still commit
- Agenda strip continues updating from local data
- `SuggestionEngine` (on-device) continues working
- Evening session: opens with cached headline or fallback template if 8pm

**Epic 4 Done When:**
- Context builder builds valid ≤4k payloads; unit tests pass
- Chat sends messages, receives responses, handles offline gracefully
- Bottom bar visible and tappable on home screen
- Voice pipeline: listen → parse → commit or follow-up
- All offline degradation paths verified manually

---

## Phase 5: Glance + Evening + Proactive (Epic 5) — Days 18–23

**Goal:** Glance Screen, Orb widget, Evening Session, SuggestionEngine, Confirmation Sheet, background tasks, suppression.

**Stories:** 9
**Deliverables:** OdO's defining surfaces fully functional.

### Story 5.1 — Glance Screen — Layout and States

- Route `/glance`
- Top row: lock icon (violet locked / green unlocked) + state label
- Center: orb (breathing idle / waveform listening)
- Below orb: ≤2 info cards — next event (always), latest suggestion (if within 18h)
- Sensitive data never on cards (no full event descriptions)
- Bottom bar matches home (quick-add, text input, mic)
- Subtle slide-up handle at bottom

### Story 5.2 — Glance Screen — Authentication

- Vocal: "Hey OdO, unlock — [phrase]" → STT validates → lock icon morphs to unlocked-green
- Typed: tap text input, type password, enter
- Biometric (settings opt-in): swipe-up triggers biometric prompt
- 3 consecutive vocal failures → vocal unlock locked for 5 min (typed only)
- Unlock phrase set during first-launch Glance onboarding
- Unlock state persists for app session; re-locks on background after configurable timeout (default 5 min)

### Story 5.3 — The Orb Widget

- Reusable `Orb` widget with all visual states:
  - `OrbState.idle` — breathing animation, `colorOrbIdle` (active accent low opacity)
  - `OrbState.listening` — waveform animation, `colorOrbActive` (active accent full)
  - `OrbState.parsing` — brief pulse (`durationFast`)
  - `OrbState.committed` — bright pulse + checkmark overlay (`durationDefault`)
- Size scales by surface: Glance = large, home = medium, watch (V2 prep) = small
- `MediaQuery.disableAnimations` → orb becomes static

### Story 5.4 — Evening Session — Orchestration

- `EveningSessionNotifier.start()` creates `evening_sessions` row with `session_date = today`, `started_at = now`
- `HeadlineGenerator` generates headline from today's data
- `HighlightRanker` selects 3–4 highlights from sessions, events, patterns of last 24h
- Cross-domain insight appended as last item if one exists
- Screen renders sequentially: headline → highlights → insight → close
- Each tag/expand/dismiss writes immediately to `evening_highlights`
- "Wrap up" visible at top; tap jumps to close phase
- Close phase writes `completed_at` + generates close summary

### Story 5.5 — Evening Session — Persistence Until Midnight

- Session started but not completed → resumes from current step on app reopen (same day)
- Previously tagged highlights remain tagged
- At local midnight: `abandoned_at = midnight_timestamp` if still incomplete (app-open check or background job)
- Tomorrow's session starts fresh
- Unit tests: start → background → resume same day; start → cross midnight → abandoned

### Story 5.6 — Suggestion Engine (On-Device)

- `SuggestionEngine.generate()` in `features/ai/domain/`
- Queries idle skills (`last_session_at` older than 24h); filters suppressed
- Computes free slots in next 48h (gaps ≥30 min)
- Ranks: longest-idle skill → shortest fitting slot → earliest available window
- Returns one suggestion max per call; persists to `suggestions` table
- Unit tests: no idle skills, all suppressed, multiple slots + skills (correct ranking)

### Story 5.7 — Confirmation Sheet (Four Elements, Stale Slot Guard)

- Route `/confirm-suggestion/:id`
- Four elements only: suggestion text, context line (*"45 min free · Japanese: 5 days idle"*), "Block it" primary button (theme accent), "Not now" secondary text button
- No close icon, no "remind me later", no why-field
- Long-press "Not now" → reveals "Don't suggest this again" → skill suppressed 7 days
- Stale slot check on open: slot gone → all four elements collapse to single line + "Close"
- "Block it" commits to both Agenda and Practice simultaneously; sheet dismisses

### Story 5.8 — Background Tasks (8pm + Pre-Event + Throughout-Day)

- 8pm local-time task fires: notification *"Your evening with OdO is ready"*
- 5-min pre-event reminders fire at `start_time - 5 min` for each event
- Throughout-day suggestion notifications on meaningful data shifts (event canceled, streak at risk, pattern threshold)
- "One AI voice per day" rule: if throughout-day suggestion fires → evening session cross-domain insight suppressed
- App-open fallback: if 8pm task missed, surface session inline on next app open after 8pm within 18h

### Story 5.9 — Suppression Algorithm

- Outcome recorded → `suppressed_until` set:
  - Accepted: `now + 1 day`
  - Dismissed: `now + 3 days`
  - Thumbs-down: `now + 7 days`
- `SuggestionEngine.generate()` filters any skill where `suppressed_until > now()`
- Unit tests verify each suppression window

**Epic 5 Done When:**
- Glance Screen renders and authenticates via all three paths
- Orb widget renders all 4 states; animations correct
- Evening Session orchestrates full ritual; persists tags to DB immediately
- Confirmation Sheet renders all 4 elements; stale slot guard works
- Background tasks fire; 8pm notification delivered
- Suggestion suppression filters correctly in all scenarios

---

## Phase 6: Polish & Resilience (Epic 6) — Days 24–28

**Goal:** All seven themes, light mode QA, animations, empty/error states, accessibility, locale QA, first-launch flow, performance.

**Stories:** 8
**Deliverables:** Production-ready app.

### Story 6.1 — All Seven Themes Render Correctly

- Settings theme picker: tap card → entire app rebuilds with new tokens (`durationDefault` crossfade)
- All 7 themes render orb, strip, cards, accents coherently
- WCAG AA contrast holds on all semantic tokens in all themes
- Custom accent picker: 24 swatches default; HSL picker behind "advanced"

### Story 6.2 — Light Mode — Outdoor Readability

- Light Mode active: all text ≥7:1 contrast (body text)
- Orb visible against light background
- Category colors distinguishable
- Strip and event blocks readable without squinting

### Story 6.3 — Empty States and Error States

- Empty Agenda: strip shows *"Nothing scheduled — free day"*; timeline shows illustration + *"Add your first event"*
- Empty Practice: *"No skills yet"* with quick-add CTA (after all skills deleted)
- Empty Chat: starter quick-command chips visible
- Offline AI: chat shows retry pattern, orb continues breathing
- Database error: silent fallback to in-memory state for screen; log to console
- No screen shows raw error stack traces or unstyled error widgets

### Story 6.4 — Animations and Motion

- Orb breathing: ~12 BPM (slow, calm)
- Session completion: `durationSlow` opacity + scale-down
- Bottom sheet open/close: `durationDefault`, custom curve
- Confirmation sheet: `durationSlow`
- `MediaQuery.disableAnimations` disables all non-essential motion; orb becomes static
- No animation looks like a loading state

### Story 6.5 — Accessibility Audit

- All interactive elements have semantic labels
- Orb announces state ("OdO is listening", "OdO is idle")
- All touch targets ≥44dp
- `MediaQuery.disableAnimations` respected throughout
- Voice fully equivalent to tap for all critical flows
- Color is never the only signal for state (icon + text label always paired)

### Story 6.6 — Locale QA — French and XOF

- All UI strings in French by default (English fallback in settings)
- XOF: `15 000 F` (no decimals, thin-space thousands)
- Dates: DD/MM/YYYY everywhere
- Times: 24-hour format
- AI responses English in V1 (French deferred to V1.5)

### Story 6.7 — First-Launch Flow

- Install → Glance Screen onboarding (set unlock phrase + optional biometric)
- Home screen renders with empty Agenda strip + empty Practice carousel
- First-launch skill prompt: "What's one skill you're working on?"
- Add first skill with one text entry
- Add first event via voice or quick-add
- At 8pm: first evening session opens
- Total: install → first useful state ≤5 minutes, no instruction

### Story 6.8 — Performance and Crash-Free Resilience

- Perceived latency for any local action <500ms (optimistic UI where appropriate)
- 2 consecutive weeks personal daily use: zero crashes
- Background tasks fire ≥70% of days; fallback covers the rest
- Cold-start <1.5s on mid-range Android

**Epic 6 Done When:**
- `flutter analyze` → "No issues found!"
- `flutter test` → ≥90% passing
- All 7 themes visually verified
- Light mode passes outdoor contrast test
- All empty/error states handled gracefully
- Accessibility audit complete
- French strings reviewed by francophone speaker
- App ready for beta testing

---

## Day-by-Day Schedule

| Days | Epic | Stories | Focus |
|------|------|---------|-------|
| 1–4 | Epic 1 | 1.1–1.8 | Foundation, tokens, schema, services |
| 5–9 | Epic 2 | 2.1–2.5 | Agenda module |
| 10–13 | Epic 3 | 3.1–3.6 | Practice module |
| 14–17 | Epic 4 | 4.1–4.5 | AI layer + voice |
| 18–23 | Epic 5 | 5.1–5.9 | Glance + Evening + Proactive |
| 24–28 | Epic 6 | 6.1–6.8 | Polish + resilience |

---

## Critical Path

1. **Epic 1** must complete before any other epic
2. **Story 2.1** (Agenda DAO) before Stories 2.2–2.5
3. **Story 3.1** (Practice DAO) before Stories 3.2–3.6
4. **Epics 2 & 3** can proceed in parallel after Epic 1 (if solo capacity allows)
5. **Epic 4** requires Epics 2 + 3 substantially complete (context builder needs real data)
6. **Story 5.6** (SuggestionEngine) before Story 5.7 (Confirmation Sheet)
7. **Epic 5** requires Epics 2, 3, 4 complete
8. **Epic 6** polish is independent and can start in parallel with Epic 5

## Within-Epic Parallelism

- **Epic 1:** Stories 1.2, 1.3, 1.6, 1.7 can run in parallel after 1.1
- **Epic 2:** Stories 2.2–2.5 can run in parallel after 2.1
- **Epic 3:** Stories 3.2–3.6 can run in parallel after 3.1
- **Epic 4:** Stories 4.3, 4.4, 4.5 can run in parallel after 4.1 + 4.2
- **Epic 5:** Stories 5.3, 5.4, 5.5, 5.7, 5.8, 5.9 after respective blockers

---

## Cross-Epic Definition of Done

For every story:

- [ ] Code follows import rules in `CONVENTIONS.md`
- [ ] Public APIs return `Result<T, AppError>` or `AsyncValue<T>` per rule
- [ ] Drift queries are typed; no raw SQL strings
- [ ] No hardcoded colors in widgets — semantic tokens only
- [ ] Unit tests for pure-logic components
- [ ] Widget tests for critical UI states
- [ ] `flutter analyze` → "No issues found!"
- [ ] `flutter test` for story passing
- [ ] No analytics, telemetry, or third-party SDKs added
- [ ] No API keys in source control
- [ ] French strings reviewed if user-facing
- [ ] Manual test on iOS and Android before marking done

---

## Story Count Summary

| Epic | Stories | Days |
|------|---------|------|
| 1 — Foundation | 8 | 1–4 |
| 2 — Agenda | 5 | 5–9 |
| 3 — Practice | 6 | 10–13 |
| 4 — AI Layer | 5 | 14–17 |
| 5 — Glance + Evening + Proactive | 9 | 18–23 |
| 6 — Polish & Resilience | 8 | 24–28 |
| **Total** | **41** | **28 days** |

---

**Sprint Plan Created:** 2026-05-13
**Supersedes:** sprint-plan-2026-03-29.md (TooXTips — deprecated)
**Total Estimated Duration:** 28 days (4 weeks core, up to 6 weeks with buffer)
**Next Step:** Begin Epic 1 — Story 1.1: Project Setup