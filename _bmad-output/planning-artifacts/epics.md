---
stepsCompleted: ["step-01-validate-prerequisites"]
inputDocuments: 
  - prd.md
  - architecture.md
  - ux-design-specification.md
projectName: TooXTips
userName: Lokki
date: 2026-03-29
---

# TooXTips - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for TooXTips, decomposing the requirements from the PRD, UX Design, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: Agenda module with calendar view (day/week modes)
FR2: Event CRUD operations (create, read, update, delete events)
FR3: Persistent Agenda strip showing next 2-3 events
FR4: Practice module with skill cards
FR5: Session logging with duration tracking
FR6: Streak tracking for each skill
FR7: Unanchored session flagging (sessions without calendar events)
FR8: AI chat interface with message history
FR9: Quick-command dropdown for AI interactions
FR10: Proactive 8pm notification with cross-module suggestions
FR11: Free-slot detection algorithm
FR12: Idle-skill detection algorithm
FR13: Pattern recognition for spontaneous practice sessions
FR14: Automatic Agenda event creation from AI suggestions
FR15: Offline-first architecture with complete local data storage
FR16: SQLite persistence for all data
FR17: Dark mode (primary) and light mode support
FR18: Claude API integration with context builder
FR19: Background task scheduling (8pm check-in)
FR20: Graceful AI degradation when offline
FR21: Single first-launch bottom sheet asking "What's one skill you're working on?" — free text, no categories, creates first skill card
FR22: Weekly Sunday reflection notification — locally-computed sentence from streak data and session counts, no API call
FR23: AI provider swappability — AiProvider abstract interface with Claude, Gemini, Groq, OpenAI, and OfflineProvider implementations
FR26: Settings screen with option to clear all local data

### NonFunctional Requirements

NFR1: Perceived responsiveness < 500ms for all core interactions
NFR2: Notification delivery reliability (8pm check-in within ±5 minutes)
NFR3: Claude API calls complete within 3 seconds
NFR4: SQLite handles 2+ years of typical user data (10,000+ events, 1,000+ sessions)
NFR5: 99%+ crash-free sessions
NFR6: Zero data loss on app restart or device reboot
NFR7: WCAG AA text contrast compliance
NFR8: Minimum 44dp touch targets for interactive elements
NFR9: XOF currency formatting (no decimal places)
NFR10: DD/MM/YYYY date format
NFR11: UTC+0 timezone handling
NFR12: High-brightness outdoor readability (light mode optimization)
NFR13: Sub-500ms perceived latency via optimistic UI and skeleton loaders
NFR14: Offline functionality 100% for core features
NFR15: No analytics, no telemetry, no third-party SDKs
NFR16: API keys passed via --dart-define at build time, never present in source code or version control

### Additional Requirements

- Riverpod state management with code-gen syntax (@riverpod)
- Drift ORM for type-safe SQLite access
- go_router for navigation with bottom sheets as routes
- flutter_local_notifications for notification delivery
- workmanager for background task scheduling
- connectivity_plus for offline state detection
- Two-layer colour token system (raw palette → semantic tokens)
- Selective AI context payload (48hr agenda, 7-day unanchored sessions, all skills)
- Context payload hard cap at 4000 characters
- Adaptive suppression algorithm (dismissed: 3d, thumbs-down: 7d, accepted: 1d)
- Offline fallback trigger when background task fails (18-hour window)
- Inline message + single pulse animation for offline fallback
- Pattern detection threshold: 3 sessions, 90-minute window, 2+ different weeks
- Claude model pinned to claude-sonnet-4-6
- AI provider abstraction with swappable implementations (Claude, Gemini, Groq, OpenAI, Offline)
- API key security via String.fromEnvironment (no hardcoding)
- Feature-based folder structure (agenda, practice, ai)
- Strict data → domain → presentation separation
- Single _providers.dart file per feature
- Database naming convention: snake_case columns
- Riverpod provider naming with suffix convention (Repository, Notifier, Service)
- Error handling: AsyncValue at UI boundaries, Result<T> in services
- Separate test/ tree mirroring lib/ structure

### UX Design Requirements

UX-DR1: Confirmation sheet with exactly four elements (suggestion, context, primary action "Block it", secondary action "Not now")
UX-DR2: Agenda strip information hierarchy with three states (events today, no events today, nothing scheduled)
UX-DR3: Agenda strip shows max 2 events simultaneously, truncated at 20 characters
UX-DR4: Offline state message for AI chat ("Couldn't reach AI · Tap to retry")
UX-DR5: One-line state summary at chat opening ("3 events today · Japanese idle 5 days · 2 free slots this week")
UX-DR6: Quick-command suggestions in chat to lower activation energy
UX-DR7: Proactive notification opens confirmation sheet directly (not app home screen)
UX-DR8: Session logging feels like completion, not a prompt for more
UX-DR9: Unanchored sessions flagged silently until pattern detected — 3 sessions within 90-minute time-of-day window across at least 2 different calendar weeks. AI asks once. If dismissed, never asks again for that skill.
UX-DR10: Thumbs-down or dismissal button on confirmation sheet (silent feedback, no explanation required)
UX-DR11: Stale slot guard - recheck Agenda before rendering confirmation sheet
UX-DR12: Completion animation 400ms (durationSlow) with scale-down effect
UX-DR13: Dark mode as hardcoded default with SharedPreferences toggle for light mode
UX-DR14: Streak indicator should feel emotionally significant and worth protecting
UX-DR15: Minimal UI with persistent Agenda strip, one-slide carousel, persistent AI component
UX-DR16: AI never initiates inside chat - only 8pm notification speaks first
UX-DR17: No close icon on confirmation sheet, no "remind me later" option
UX-DR18: Suggestion construction algorithm: longest idle skill first, then shortest available slot, then earliest free slot
UX-DR19: One AI voice per day - maximum one proactive notification per 24 hours
UX-DR20: Offline proactive logic - free-slot + idle-skill detection runs on-device
UX-DR21: Completion sheet dismisses with Navigator.pop() after 400ms animation
UX-DR22: Two-layer colour token system with semantic tokens (colorAccentAgenda, colorAccentPractice, colorAccentExpenses)
UX-DR23: System fonts (SF Pro / Roboto) with tabular figures for clock display
UX-DR24: Spacing scale (sp2, sp4, sp8, sp12, sp16, sp20, sp24)
UX-DR25: Three animation durations (durationFast: 150ms, durationDefault: 250ms, durationSlow: 400ms)
UX-DR26: Thumbs-down micro-action on confirmation sheet triggers suppressionThumbsDown (7 days). Dismissed via "Not now" triggers suppressionDismissed (3 days). Accepted triggers suppressionAccepted (1 day). Three distinct suppression windows.
UX-DR27: AI component pulse dot animates once on app open when fallback suggestion is queued (background task missed 18-hour window). Single slow pulse only — never continuous, never a badge count.
UX-DR28: Sunday 8pm notification is qualitatively different from weekday notifications — reflection line only, no "Block it" action, no confirmation sheet. Computed locally from session data.

### FR Coverage Map

| Requirement | Epic 1 | Epic 2 | Epic 3 | Epic 4 | Epic 5 | Epic 6 |
|-------------|--------|--------|--------|--------|--------|--------|
| FR1-3 (Agenda) | | ✓ | | | | |
| FR4-7 (Practice) | | | ✓ | | | |
| FR8-9 (AI Chat) | | | | ✓ | | |
| FR10-14 (Proactive) | | | | | ✓ | |
| FR15-20 (Offline, Dark/Light) | ✓ | | | ✓ | | ✓ |
| FR21-23 (First-launch, Reflection, Provider) | ✓ | | ✓ | ✓ | ✓ | |
| NFR1-16 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| UX-DR1-28 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

## Epic List

1. **Epic 1: Foundation** — Theme system, design tokens, database schema, project scaffold, AiProvider abstraction
2. **Epic 2: Agenda Module** — Persistent strip, calendar view, event CRUD, day timeline
3. **Epic 3: Practice Module** — Skill cards, session logging, streak computation, unanchored flagging, pattern detection
4. **Epic 4: AI Layer** — Context builder, chat interface, quick-command dropdown, offline degradation
5. **Epic 5: Proactive System** — SuggestionEngine, background tasks, confirmation sheet, suppression algorithm, Sunday reflection
6. **Epic 6: Polish & Resilience** — Light mode, animations, empty states, error states, fallback pulse, accessibility

---

## Epic 1: Foundation

**Goal:** Establish the architectural foundation with theme system, design tokens, database schema, project scaffold, and AI provider abstraction. This epic unblocks all other epics.

**Technical Foundation Rationale:** While this epic has no direct user-facing value, it is essential infrastructure that enables all subsequent user-facing epics (2-6). The database schema, theme system, and AI provider abstraction are foundational decisions that cannot be changed mid-implementation without breaking dependent features. This epic must be completed first to provide the technical substrate for all other work. Without this foundation, Epics 2-6 cannot be implemented.

### Story 1.1: Project Setup and Dependency Configuration

As a developer,
I want to initialize the Flutter project with all required dependencies configured,
So that the project compiles and is ready for feature development.

**Acceptance Criteria:**

**Given** a fresh Flutter project created with `flutter create --org com.tooxips tooxips`
**When** I add all dependencies from the architecture specification (Riverpod, Drift, go_router, etc.)
**Then** the project compiles without errors
**And** `flutter pub get` succeeds
**And** all platform-specific configurations (Android permissions, iOS setup) are in place

### Story 1.2: Design Tokens and Color System

As a developer,
I want to define the two-layer color token system (raw palette → semantic tokens),
So that all UI components use consistent colors and theme switching is centralized.

**Acceptance Criteria:**

**Given** the design system specification in the UX document
**When** I create `core/constants/app_colors.dart` with raw palette and semantic tokens
**Then** raw colors (violetPrimary, darkBg, etc.) are defined but never used directly in widgets
**And** semantic tokens (colorAccentAgenda, colorSurface, etc.) are defined for all UI usage
**And** light mode remapping is prepared (tokens only, no hardcoded colors in widgets)
**And** the file compiles and exports all tokens

### Story 1.3: Theme System with Dark Mode Default

As a developer,
I want to create a ThemeData configuration with dark mode as default and light mode toggle via SharedPreferences,
So that the app renders correctly in both themes and users can switch at runtime.

**Acceptance Criteria:**

**Given** the color tokens from Story 1.2
**When** I create `app/theme.dart` with ThemeData for dark and light modes
**Then** dark mode is hardcoded as default in main.dart
**And** light mode toggle is persisted via SharedPreferences
**And** typography includes tabular figures for clock display (FontFeature.tabularFigures())
**And** spacing scale (sp2-sp24) is defined as constants
**And** animation durations (durationFast, durationDefault, durationSlow) are defined
**And** theme switching works at runtime without app restart

### Story 1.4: SQLite Database Schema with Drift

As a developer,
I want to define the SQLite schema using Drift with critical tables (skills, sessions, events, suggestions),
So that all data is persisted locally with type-safe access.

**Acceptance Criteria:**

**Given** the architecture specification with schema decisions
**When** I create `core/database/app_database.dart` with Drift tables
**Then** `skills` table exists with id, name, createdAt, lastSessionAt
**And** `sessions` table exists with id, skillId, startedAt, durationMinutes, isAnchored, suggestedTime, notes
**And** `events` table exists with id, title, startTime, endTime, category
**And** `suggestions` table exists with id, skillId, slotStart, slotDuration, suggestedAt, acceptedAt, dismissedAt, thumbsDownAt, suppressedUntil
**And** `dart run build_runner build` generates all Drift code without errors
**And** the database compiles and is ready for data access

### Story 1.5: AiProvider Abstraction with Multiple Implementations

As a developer,
I want to create an AiProvider abstract interface with concrete implementations (Claude, Gemini, Groq, OpenAI, Offline),
So that the AI provider can be swapped via a single constant without touching feature code.

**Acceptance Criteria:**

**Given** the AI provider architecture specification
**When** I create `core/services/ai_provider.dart` with abstract AiProvider interface
**Then** the interface defines `complete()` method with systemPrompt, userMessage, maxTokens parameters
**And** `ClaudeProvider` implements the interface for claude-sonnet-4-6
**And** `GeminiProvider` implements the interface for Gemini 1.5 Flash
**And** `GroqProvider` implements the interface for Llama 3.1 8B
**And** `OpenAiProvider` implements the interface for GPT-4o mini
**And** `OfflineProvider` returns empty string (graceful offline fallback)
**And** `core/constants/ai_constants.dart` defines AiConfig with provider selection
**And** Riverpod provider wiring allows swapping with one-line change

### Story 1.6: CONVENTIONS.md Documentation

As a developer,
I want to document all architectural conventions and patterns in CONVENTIONS.md,
So that future code follows consistent patterns and decisions are transparent.

**Acceptance Criteria:**

**Given** all architectural decisions from the architecture document
**When** I create `CONVENTIONS.md` in project root
**Then** it documents database naming (snake_case), Riverpod provider naming, error handling patterns
**And** it specifies feature folder structure (data/domain/presentation)
**And** it lists import rules (domain imports nothing, data imports domain, presentation imports domain only)
**And** it documents AI payload limits (4000 char cap, 48hr agenda window)
**And** it specifies API key security (--dart-define only)
**And** it lists all confirmed architectural decisions (Riverpod, Drift, go_router, etc.)

### Story 1.7: Main.dart Initialization with Service Setup

As a developer,
I want to initialize main.dart with proper sequencing for WidgetsFlutterBinding, BackgroundTaskService, and NotificationService,
So that all services are ready before the app runs.

**Acceptance Criteria:**

**Given** all services from previous stories
**When** I create `main.dart` with initialization sequence
**Then** WidgetsFlutterBinding.ensureInitialized() is called first
**And** BackgroundTaskService.initialize() is called before runApp
**And** NotificationService.initialize() is called before runApp
**And** ProviderScope wraps the entire app
**And** ThemeMode.dark is hardcoded as default
**And** the app launches without errors

---

## Epic 2: Agenda Module

**Goal:** Build the Agenda module with persistent strip, calendar view, event CRUD, and day timeline. This epic provides the temporal anchor for all other features.

### Story 2.1: Event Data Access Layer

As a developer,
I want to create AgendaRepository and AgendaDAO for type-safe event access,
So that all event queries are centralized and testable.

**Acceptance Criteria:**

**Given** the Drift database from Epic 1
**When** I create `features/agenda/data/agenda_dao.dart` with Drift queries
**Then** queries exist for: getAllEvents(), getEventsForDate(), getEventsForWeek(), getNextEvents(count)
**And** I create `features/agenda/data/agenda_repository.dart` implementing domain interface
**And** repository methods: createEvent(), updateEvent(), deleteEvent(), getUpcomingEvents()
**And** all queries return Future<List<AgendaEvent>> or Future<AgendaEvent>
**And** repository is injected via Riverpod provider

### Story 2.2: Persistent Agenda Strip Widget

As a user,
I want to see the next 2-3 upcoming events in a persistent strip at the top of every screen,
So that I always know what's coming next without scrolling.

**Acceptance Criteria:**

**Given** the Agenda strip specification (UX-DR2, UX-DR3) and AgendaRepository from Story 2.1
**When** I create `features/agenda/presentation/widgets/agenda_strip.dart`
**Then** the strip shows next 2 events with time and title (truncated at 20 chars)
**And** if no events today, it shows first event tomorrow with "tomorrow" label
**And** if nothing scheduled, it shows "Nothing scheduled — free day"
**And** the strip is always visible above the main content
**And** tapping the strip opens the calendar modal
**And** the strip updates in real-time when events are added/deleted

### Story 2.3: Calendar View (Day and Week Modes)

As a user,
I want to view my calendar in day and week modes,
So that I can see my schedule at different time scales.

**Acceptance Criteria:**

**Given** the Agenda module requirements (FR1)
**When** I create `features/agenda/presentation/agenda_slide.dart` with calendar view
**Then** day mode shows hourly timeline with events positioned by time
**And** week mode shows 7-day grid with events
**And** user can swipe between day and week modes
**And** current day is highlighted
**And** tapping an event shows event details
**And** calendar uses table_calendar package for rendering

### Story 2.4: Event CRUD Operations

As a user,
I want to create, read, update, and delete calendar events,
So that I can manage my schedule.

**Acceptance Criteria:**

**Given** the calendar view from Story 2.3 and AgendaRepository from Story 2.1
**When** I create `features/agenda/presentation/widgets/add_event_sheet.dart` and event editing
**Then** tapping "+" or empty time slot opens add event bottom sheet
**And** the sheet has fields for title, start time, end time, category
**And** saving creates the event in Agenda and persists to SQLite
**And** tapping an event opens edit sheet with same fields
**And** saving updates the event in SQLite
**And** swiping left on event shows delete confirmation
**And** deleting removes event from SQLite and UI updates immediately

### Story 2.5: Agenda State Management with Riverpod

As a developer,
I want to manage Agenda state with Riverpod providers,
So that UI widgets reactively update when events change.

**Acceptance Criteria:**

**Given** AgendaRepository from Story 2.4
**When** I create `features/agenda/presentation/agenda_providers.dart`
**Then** `agendaRepositoryProvider` returns AgendaRepository instance
**And** `todayAgendaProvider` returns today's events (async)
**And** `weekAgendaProvider` returns week's events (async)
**And** `nextEventsProvider` returns next 2-3 events for strip (async)
**And** `agendaNotifierProvider` provides StateNotifier for add/update/delete actions
**And** all providers use @riverpod annotation for code generation

### Story 2.6: Agenda Strip Integration with Main App

As a user,
I want the Agenda strip to appear on every screen and update when events change,
So that temporal context is always available.

**Acceptance Criteria:**

**Given** AgendaStrip widget from Story 2.2 and Riverpod providers from Story 2.5
**When** I integrate the strip into the main app shell
**Then** the strip appears above the carousel on every screen
**And** it watches `nextEventsProvider` and updates reactively
**And** it handles loading state with skeleton loader
**And** it handles error state gracefully
**And** tapping the strip opens calendar modal without losing carousel position

---

## Epic 3: Practice Module

**Goal:** Build the Practice module with skill cards, session logging, streak computation, unanchored flagging, and pattern detection. This epic provides the skill development anchor.

### Story 3.1: Practice Data Access Layer

As a developer,
I want to create PracticeRepository and PracticeDAO for type-safe skill and session access,
So that all practice queries are centralized.

**Acceptance Criteria:**

**Given** the Drift database from Epic 1
**When** I create `features/practice/data/practice_dao.dart`
**Then** queries exist for: getAllSkills(), getSkillById(), getSessionsForSkill(), getUnanchoredSessions()
**And** I create `features/practice/data/practice_repository.dart`
**And** repository methods: createSkill(), logSession(), getSkillWithSessions(), getUnanchoredSessionsLastDays(days)
**And** all queries return properly typed Futures

### Story 3.2: Practice Module UI Shell and Skill Cards

As a user,
I want to see my skills as cards in the Practice module,
So that I can track and interact with each skill.

**Acceptance Criteria:**

**Given** the Practice module specification (FR4) and PracticeRepository from Story 3.1
**When** I create `features/practice/presentation/practice_slide.dart` and `features/practice/presentation/widgets/skill_card.dart`
**Then** each skill card shows: skill name, streak (7-day bar), last session date, session count
**And** the streak bar is visually significant and feels worth protecting (UX-DR14)
**And** tapping a card opens session logging sheet
**And** cards are displayed in a scrollable list
**And** the module handles empty state (no skills) with first-launch prompt

### Story 3.3: First-Launch Skill Prompt

As a new user,
I want to be asked "What's one skill you're working on?" on first launch,
So that I can create my first skill without friction.

**Acceptance Criteria:**

**Given** the app is launched for the first time
**When** the Practice module loads and no skills exist
**Then** a bottom sheet appears with the question "What's one skill you're working on?"
**And** the sheet has a free-text input field (no categories)
**Then** tapping "Create" creates the skill and dismisses the sheet
**And** the skill card appears immediately in the Practice module
**And** this prompt never appears again (flag in SharedPreferences)

### Story 3.4: Session Logging with Duration and Notes

As a user,
I want to log a practice session with duration and optional notes,
So that I can track my practice history.

**Acceptance Criteria:**

**Given** a skill card from Story 3.2 and PracticeRepository from Story 3.1
**When** I tap the card and open the session logging sheet
**Then** the sheet shows: duration input (minutes), optional notes field, "Log Session" button
**And** the sheet has quick-select buttons for common durations (15, 30, 45, 60 min)
**And** tapping "Log Session" creates the session in SQLite with isAnchored = false
**And** the sheet dismisses with completion animation (400ms, scale-down effect) (UX-DR12)
**And** the skill card updates immediately with new streak and last session date
**And** the session is logged without prompting for calendar event

### Story 3.5: Streak Computation and Display

As a user,
I want to see my streak for each skill (consecutive days practiced),
So that I'm motivated to maintain the streak.

**Acceptance Criteria:**

**Given** session data in SQLite
**When** I create `features/practice/domain/streak_calculator.dart`
**Then** it calculates consecutive days from most recent session backwards
**And** it handles timezone correctly (UTC+0)
**And** it returns current streak count and last session date
**And** the streak bar on skill cards updates reactively
**And** the bar fills proportionally (7-day max for MVP)

### Story 3.6: Unanchored Session Flagging

As a developer,
I want to flag sessions that don't have corresponding calendar events,
So that the system can detect patterns later.

**Acceptance Criteria:**

**Given** session logging from Story 3.4
**When** a session is logged without a calendar event
**Then** `isAnchored` is set to false in the sessions table
**And** no UI prompt appears (silent flagging) (UX-DR9)
**And** the flag is stored for pattern detection
**And** the user never sees the flag until pattern is detected

### Story 3.7: Pattern Detection for Unanchored Sessions

As a developer,
I want to detect when a user practices at similar times without calendar events,
So that the AI can suggest making it a recurring event.

**Acceptance Criteria:**

**Given** unanchored sessions from Story 3.6
**When** I create `features/practice/domain/pattern_detector.dart`
**Then** it detects pattern: 3+ unanchored sessions within 90-minute time window across 2+ different calendar weeks
**And** it returns skill_id and suggested_time if pattern detected
**And** it handles timezone correctly (UTC+0)
**And** the detector is called by SuggestionEngine (Epic 5)

### Story 3.8: Practice State Management with Riverpod

As a developer,
I want to manage Practice state with Riverpod providers,
So that UI widgets reactively update when skills and sessions change.

**Acceptance Criteria:**

**Given** PracticeRepository from Story 3.1
**When** I create `features/practice/presentation/practice_providers.dart`
**Then** `practiceRepositoryProvider` returns PracticeRepository
**And** `allSkillsProvider` returns all skills (async)
**And** `skillWithSessionsProvider(skillId)` returns skill with session history (async)
**And** `unanchoredSessionsProvider` returns unanchored sessions from last 7 days (async)
**And** `practiceNotifierProvider` provides StateNotifier for create/log actions
**And** all providers use @riverpod annotation

---

## Epic 4: AI Layer

**Goal:** Build the AI integration layer with context builder, chat interface, quick-command dropdown, and offline degradation. This epic provides the intelligence layer.

### Story 4.1: AI Context Builder

As a developer,
I want to construct the AI context payload from Agenda and Practice data,
So that the AI has the information needed to make suggestions.

**Acceptance Criteria:**

**Given** Agenda and Practice data from Epics 2 and 3
**When** I create `features/ai/domain/context_builder.dart`
**Then** it builds payload with: today + next 48 hours events, all skills with streak/last_session, last 7 days unanchored sessions, last 3 suggestions with status, current_datetime, timezone (UTC+0)
**And** it enforces 4000 character hard cap (contextMaxChars)
**And** if payload exceeds cap, it truncates session history first, then extends agenda window
**And** it logs warning locally if truncation occurs
**And** it returns structured context as JSON-serializable object

### Story 4.2: Claude API Client with Error Handling

As a developer,
I want to create a Claude API client that handles requests and responses,
So that the app can communicate with Claude API.

**Acceptance Criteria:**

**Given** the AiProvider abstraction from Epic 1
**When** I create `features/ai/data/claude_provider.dart` implementing AiProvider
**Then** it sends POST requests to Claude API with systemPrompt and userMessage
**And** it includes context payload from Story 4.1
**And** it handles API timeout (3 second max) gracefully
**And** it returns parsed response text
**And** it handles API errors without crashing (returns empty string or error message)
**And** API key is passed via String.fromEnvironment (NFR16)

### Story 4.3: AI Chat Interface

As a user,
I want to chat with the AI to ask questions and get suggestions,
So that I can interact with the system conversationally.

**Acceptance Criteria:**

**Given** the Claude API client from Story 4.2
**When** I create `features/ai/presentation/ai_chat_sheet.dart`
**Then** the chat opens with one-line state summary at top: "3 events today · Japanese idle 5 days · 2 free slots this week" (UX-DR5)
**And** below the summary are quick-command suggestions (UX-DR6)
**And** the message input is always at bottom, thumb-reachable
**And** user can type a message and tap send
**And** the message appears in chat thread immediately
**And** the AI response appears below with loading state
**And** chat history persists in SQLite
**And** offline message handling: "Couldn't reach AI · Tap to retry" (UX-DR4)

### Story 4.4: Quick-Command Dropdown

As a user,
I want to see quick-command suggestions when I open the chat,
So that I can interact with the AI without typing.

**Acceptance Criteria:**

**Given** the chat interface from Story 4.3
**When** the chat opens
**Then** quick-command suggestions appear below the state summary
**And** suggestions are context-aware (e.g., "When should I practice?", "Show my week")
**And** tapping a suggestion sends it as a message
**And** the AI responds to the command
**And** suggestions are generated locally (no API call)

### Story 4.5: Offline Degradation for AI

As a user,
I want the app to work when offline and gracefully degrade AI functionality,
So that I can still use Agenda and Practice without connectivity.

**Acceptance Criteria:**

**Given** the ConnectivityService from architecture
**When** the app detects offline state
**Then** the AI provider switches to OfflineProvider
**And** chat messages show: "Couldn't reach AI · Tap to retry"
**And** when connectivity returns, the message can be retried
**And** the user's message is preserved (not lost)
**And** the app never shows error states or spinners for AI unavailability

### Story 4.6: AI State Management with Riverpod

As a developer,
I want to manage AI state with Riverpod providers,
So that chat and suggestions update reactively.

**Acceptance Criteria:**

**Given** Claude API client from Story 4.2
**When** I create `features/ai/presentation/ai_providers.dart`
**Then** `aiProviderServiceProvider` returns AiProvider (swappable)
**And** `chatMessagesProvider` returns chat history (async)
**And** `aiResponseProvider(message)` sends message and returns response (async)
**And** `contextBuilderProvider` returns AI context payload (async)
**And** `aiNotifierProvider` provides StateNotifier for chat actions
**And** all providers use @riverpod annotation

---

## Epic 5: Proactive System

**Goal:** Build the proactive AI system with SuggestionEngine, background tasks, confirmation sheet, suppression algorithm, and Sunday reflection. This epic delivers the core value proposition.

### Story 5.1: Suggestion Storage and Suppression Algorithm

As a developer,
I want to store suggestions and track user feedback to suppress irrelevant suggestions,
So that the AI learns from user behavior.

**Acceptance Criteria:**

**Given** the suggestions table from Epic 1
**When** a suggestion is generated by SuggestionEngine
**Then** it's stored with suggestedAt timestamp
**And** when user taps "Block it", acceptedAt is set and suppressedUntil = now + 1 day (UX-DR26)
**And** when user taps "Not now", dismissedAt is set and suppressedUntil = now + 3 days (UX-DR26)
**And** when user taps thumbs-down, thumbsDownAt is set and suppressedUntil = now + 7 days (UX-DR26)
**And** SuggestionEngine filters out any skill where suppressedUntil > now()
**And** the suppression logic is the entire learning algorithm

### Story 5.2: SuggestionEngine with Slot Detection

As a developer,
I want to create the SuggestionEngine that detects free slots and idle skills,
So that the system can generate proactive suggestions.

**Acceptance Criteria:**

**Given** Agenda and Practice data from Epics 2 and 3, and Suggestion Storage from Story 5.1
**When** I create `features/ai/domain/suggestion_engine.dart`
**Then** it finds free slots in the next 48 hours (gaps between events)
**And** it identifies idle skills (longest days since last session)
**And** it applies suppression filters (dismissed: 3d, thumbs-down: 7d, accepted: 1d) (UX-DR26)
**And** it prioritizes: longest idle skill first, then shortest available slot, then earliest free slot (UX-DR18)
**And** it returns one suggestion per call (first match wins)
**And** it handles edge cases (no free slots, all skills suppressed, etc.)

### Story 5.3: Background Task Scheduling (8pm Check-in)

As a developer,
I want to schedule a background task that runs daily at 8pm,
So that the proactive notification is delivered reliably.

**Acceptance Criteria:**

**Given** the workmanager package from dependencies
**When** I create `core/services/background_task_service.dart`
**Then** it registers a periodic task via workmanager to run at 8pm daily
**And** the task is platform-specific (Android: AlarmManager, iOS: background fetch)
**And** the task runs even if app is closed
**And** it handles platform-specific constraints (battery optimization, OS throttling)
**And** it logs task execution for debugging

### Story 5.4: Confirmation Sheet with Stale Slot Guard

As a user,
I want to see a confirmation sheet when I tap the proactive notification,
So that I can quickly accept or dismiss the suggestion.

**Acceptance Criteria:**

**Given** the notification from Story 5.3
**When** I tap the notification
**Then** a confirmation sheet opens (not the app home screen) (UX-DR7)
**And** the sheet shows: suggestion text, context (slot duration + skill idle days), "Block it" button, "Not now" button (UX-DR1)
**And** before rendering, it rechecks the Agenda to verify the slot still exists (UX-DR11)
**And** if slot is gone, it shows: "This slot is no longer available" with "Close" button
**And** if slot exists, tapping "Block it" creates the event in both Agenda and Practice
**And** tapping "Not now" dismisses the sheet
**And** the sheet has a thumbs-down micro-action for silent feedback (UX-DR10, UX-DR26)
**And** after action, the sheet dismisses with 400ms completion animation (UX-DR12)

### Story 5.4: Proactive Notification Delivery

As a developer,
I want to send the proactive notification at 8pm with the suggestion text,
So that the user receives the suggestion at the right moment.

**Acceptance Criteria:**

**Given** the background task from Story 5.3 and SuggestionEngine from Story 5.2
**When** the 8pm task runs
**Then** it calls SuggestionEngine to generate a suggestion
**And** it constructs notification text: "You have 45 free minutes Thursday. Japanese is idle. Block it?"
**And** it sends the notification via flutter_local_notifications
**And** the notification is tagged so only one notification per day is shown (UX-DR19)
**And** tapping the notification opens the confirmation sheet directly
**And** the notification is best-effort (not guaranteed, but fallback exists)

### Story 5.6: Offline Fallback Trigger

As a developer,
I want to detect when the background task fails and surface a suggestion on app open,
So that the user still gets the proactive suggestion even if the background task missed.

**Acceptance Criteria:**

**Given** the background task from Story 5.3
**When** the app is opened and no suggestion was delivered in the last 18 hours
**Then** the fallback trigger runs SuggestionEngine synchronously
**And** if a suggestion is generated, it's queued in the AI component
**And** the AI component pulse dot animates once on app open (single slow pulse) (UX-DR27)
**And** if user taps the AI component, the suggestion appears as first message in chat
**And** the pulse never repeats (single pulse only, never continuous)

### Story 5.7: Sunday Reflection Notification

As a user,
I want to receive a weekly reflection on Sunday at 8pm,
So that I can see my practice progress without extra effort.

**Acceptance Criteria:**

**Given** the background task from Story 5.3
**When** Sunday 8pm arrives
**Then** the background task detects it's Sunday
**And** it generates a reflection line from session data: "This week: 4 Japanese sessions, 2 Chess. Best week yet for Japanese."
**And** it sends a notification with this text (no "Block it" action, no confirmation sheet) (UX-DR28)
**And** tapping the notification opens the app (no special handling)
**And** the reflection is computed locally (no API call)

### Story 5.8: AI Provider Swappability in Proactive System

As a developer,
I want the proactive system to use the swappable AI provider,
So that I can test with different providers without changing feature code.

**Acceptance Criteria:**

**Given** the AiProvider abstraction from Epic 1
**When** the SuggestionEngine needs to call the AI (for pattern detection or reflection generation)
**Then** it uses the injected AiProvider from Riverpod
**And** the provider is selected via single constant in ai_constants.dart
**And** changing the constant swaps the provider without touching feature code
**And** offline state automatically uses OfflineProvider

---

## Epic 6: Polish & Resilience

**Goal:** Complete the app with light mode, animations, empty states, error states, accessibility, and locale formatting. This epic ensures quality and resilience.

### Story 6.1: Light Mode Implementation

As a user,
I want to toggle between dark and light modes,
So that I can use the app in different lighting conditions.

**Acceptance Criteria:**

**Given** the theme system from Epic 1
**When** I create light mode ThemeData
**Then** semantic tokens are remapped for light mode (no hardcoded colors change)
**And** light mode is optimized for outdoor readability (high contrast, bright backgrounds)
**And** the toggle is in settings and persists via SharedPreferences
**And** switching modes updates the entire app without restart
**And** both modes render correctly on all screens

### Story 6.2: Completion Animations

As a user,
I want to see meaningful animations when I complete actions,
So that the app feels responsive and satisfying.

**Acceptance Criteria:**

**Given** the animation durations from Epic 1 (durationFast, durationDefault, durationSlow)
**When** I log a session
**Then** the logged duration text animates with scale-down effect over 400ms (durationSlow) (UX-DR12)
**And** the session card shows a checkmark-like completion feeling
**And** when I accept a suggestion in the confirmation sheet
**Then** the sheet animates out with 400ms duration before dismissing (UX-DR21)
**And** when I tap "Block it"
**Then** a brief success animation plays before the sheet closes

### Story 6.3: Empty States and Error States

As a user,
I want to see helpful empty states and error messages,
So that I understand what to do next.

**Acceptance Criteria:**

**Given** the modules from Epics 2, 3, 4
**When** the Agenda module has no events
**Then** it shows: "Nothing scheduled — free day" (not a blank screen)
**And** when the Practice module has no skills
**Then** the first-launch prompt appears (Story 3.2)
**And** when the chat fails to reach the AI
**Then** it shows: "Couldn't reach AI · Tap to retry" (not an error icon)
**And** when a database query fails
**Then** a graceful error message appears (not a crash)

### Story 6.4: Accessibility Compliance

As a user with accessibility needs,
I want the app to meet WCAG AA standards,
So that I can use it effectively.

**Acceptance Criteria:**

**Given** all UI components from Epics 2-5
**When** I check text contrast
**Then** all text meets WCAG AA standards (4.5:1 for normal text, 3:1 for large text)
**And** all interactive elements are at least 44dp (NFR8)
**And** semantic labels are provided for screen readers
**And** focus indicators are visible for keyboard navigation
**And** colour is not the only way to convey information

### Story 6.5: Locale Formatting (XOF, DD/MM/YYYY, UTC+0)

As a user in Abidjan,
I want the app to display dates, times, and currency in my locale,
So that the app feels native and respectful.

**Acceptance Criteria:**

**Given** the intl package from dependencies
**When** I create `core/utils/locale_service.dart`
**Then** dates are formatted as DD/MM/YYYY (not MM/DD/YYYY)
**And** times are formatted in 24-hour format
**And** timezone is UTC+0 (no daylight saving)
**And** currency is XOF with no decimal places (e.g., "1,500 XOF")
**And** the formatting is applied consistently across the app

### Story 6.6: Fallback Pulse Animation

As a user,
I want to see a subtle pulse on the AI component when a fallback suggestion is queued,
So that I know there's something waiting for me.

**Acceptance Criteria:**

**Given** the offline fallback trigger from Story 5.6
**When** a fallback suggestion is queued on app open
**Then** the AI component pulse dot animates once (single slow pulse) (UX-DR27)
**And** the pulse uses durationSlow (400ms)
**And** the pulse never repeats (single animation only)
**And** no badge count or persistent indicator is shown
**And** if user taps the AI component, the suggestion appears in chat

### Story 6.7: CONVENTIONS.md Enforcement and Code Review

As a developer,
I want to ensure all code follows the documented conventions,
So that the codebase remains maintainable.

**Acceptance Criteria:**

**Given** CONVENTIONS.md from Story 1.6
**When** I review code
**Then** all database columns use snake_case
**And** all Riverpod providers use suffix convention (Repository, Notifier, Service)
**And** all imports follow the rules (domain → nothing, data → domain, presentation → domain)
**And** all features have data/domain/presentation structure
**And** all features have single _providers.dart file
**And** all API keys use --dart-define (never hardcoded)

### Story 6.8: Light Mode Implementation (Continued)

(Placeholder for additional light mode work if needed)

### Story 6.9: Settings Screen with Data Clear Option

As a user,
I want to access a settings screen where I can clear all local data,
So that I can reset the app if needed.

**Acceptance Criteria:**

**Given** the app is running
**When** I access the settings screen (via menu or navigation)
**Then** the screen shows: theme toggle (dark/light), "Clear All Data" button
**And** tapping "Clear All Data" shows a confirmation dialog
**And** the dialog warns: "This will delete all events, skills, and sessions. This cannot be undone."
**And** the dialog has two buttons: "Cancel" and "Clear"
**And** tapping "Clear" deletes all data from SQLite (skills, sessions, events, suggestions, chat history)
**And** after clearing, the app resets to first-launch state (first-launch skill prompt appears)
**And** the app does not crash during or after data clearing

### Story 6.10: Performance Optimization and Testing

As a developer,
I want to optimize performance and test critical paths,
So that the app meets NFR targets (< 500ms perceived latency, 99%+ crash-free).

**Acceptance Criteria:**

**Given** all features from Epics 2-5
**When** I measure perceived latency
**Then** all core interactions complete in < 500ms (NFR1)
**And** I implement optimistic UI for event creation and session logging
**And** I implement skeleton loaders for async data
**And** I test offline functionality thoroughly (no silent failures)
**And** I test crash scenarios (database errors, API timeouts, etc.)
**And** I verify 99%+ crash-free sessions (NFR5)
**And** I verify zero data loss on restart (NFR6)
