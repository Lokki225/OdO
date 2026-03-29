---
projectName: TooXTips
date: 2026-03-29
sprintDuration: 2 weeks
totalStories: 48
totalEpics: 6
---

# TooXTips Sprint Plan

**Project:** TooXTips  
**Sprint Start:** 2026-03-29  
**Sprint Duration:** 2 weeks  
**Total Stories:** 48 across 6 epics  
**Status:** Ready for implementation

---

## Sprint Overview

This sprint plan organizes the 48 stories from the epic breakdown into a phased implementation sequence. The plan follows a dependency-aware approach where foundational work (Epic 1) enables all subsequent feature development (Epics 2-6).

### Key Principles

- **Sequential Epic Execution:** Complete Epic 1 (Foundation) before starting Epics 2-6
- **Parallel Story Development:** Within each epic, stories with no dependencies can be developed in parallel
- **Dependency Awareness:** Data access layers (Stories 2.1, 3.1, 5.1) are completed before feature stories that depend on them
- **Incremental Value:** Each epic delivers user-facing value upon completion (except Epic 1, which is foundational infrastructure)

---

## Epic Execution Sequence

### Phase 1: Foundation (Epic 1) — Weeks 1-2

**Goal:** Establish the architectural foundation with theme system, design tokens, database schema, project scaffold, and AI provider abstraction.

**Stories:** 7 stories  
**Estimated Duration:** 2 weeks  
**Deliverables:** Compilable Flutter project with all infrastructure in place

#### Story 1.1: Project Setup and Dependency Configuration
- Initialize Flutter project with `flutter create --org com.tooxips tooxips`
- Add all dependencies (Riverpod, Drift, go_router, flutter_local_notifications, workmanager, connectivity_plus, table_calendar, etc.)
- Configure Android and iOS platform-specific settings
- Verify `flutter pub get` succeeds and project compiles

#### Story 1.2: Design Tokens and Color System
- Create `core/constants/app_colors.dart` with two-layer color system
- Define raw palette (violetPrimary, darkBg, etc.)
- Define semantic tokens (colorAccentAgenda, colorAccentPractice, colorAccentExpenses, colorSurface, etc.)
- Ensure all tokens are exported and ready for theme system

#### Story 1.3: Theme System with Dark Mode Default
- Create `app/theme.dart` with ThemeData for dark and light modes
- Hardcode dark mode as default in main.dart
- Implement light mode toggle via SharedPreferences
- Add tabular figures for clock display (FontFeature.tabularFigures())
- Define spacing scale (sp2, sp4, sp8, sp12, sp16, sp20, sp24)
- Define animation durations (durationFast: 150ms, durationDefault: 250ms, durationSlow: 400ms)

#### Story 1.4: SQLite Database Schema with Drift
- Create `core/database/app_database.dart` with Drift tables
- Implement `skills` table (id, name, createdAt, lastSessionAt)
- Implement `sessions` table (id, skillId, startedAt, durationMinutes, isAnchored, suggestedTime, notes)
- Implement `events` table (id, title, startTime, endTime, category)
- Implement `suggestions` table (id, skillId, slotStart, slotDuration, suggestedAt, acceptedAt, dismissedAt, thumbsDownAt, suppressedUntil)
- Run `dart run build_runner build` and verify code generation

#### Story 1.5: AiProvider Abstraction with Multiple Implementations
- Create `core/services/ai_provider.dart` with abstract AiProvider interface
- Implement `ClaudeProvider` for claude-sonnet-4-6
- Implement `GeminiProvider` for Gemini 1.5 Flash
- Implement `GroqProvider` for Llama 3.1 8B
- Implement `OpenAiProvider` for GPT-4o mini
- Implement `OfflineProvider` for graceful offline fallback
- Create `core/constants/ai_constants.dart` with AiConfig for provider selection
- Wire up Riverpod provider for swappable AI implementation

#### Story 1.6: CONVENTIONS.md Documentation
- Create `CONVENTIONS.md` in project root
- Document database naming conventions (snake_case)
- Document Riverpod provider naming (suffix convention: Repository, Notifier, Service)
- Document error handling patterns (AsyncValue at UI boundaries, Result<T> in services)
- Document feature folder structure (data/domain/presentation)
- Document import rules (domain imports nothing, data imports domain, presentation imports domain only)
- Document AI payload limits (4000 char cap, 48hr agenda window)
- Document API key security (--dart-define only, no hardcoding)
- List all confirmed architectural decisions

#### Story 1.7: Main.dart Initialization with Service Setup
- Create `main.dart` with proper initialization sequence
- Call WidgetsFlutterBinding.ensureInitialized() first
- Call BackgroundTaskService.initialize() before runApp
- Call NotificationService.initialize() before runApp
- Wrap app with ProviderScope
- Hardcode ThemeMode.dark as default
- Verify app launches without errors

**Completion Criteria:**
- ✓ Flutter project compiles without errors
- ✓ All dependencies installed and configured
- ✓ Database schema generated and ready
- ✓ Theme system functional with dark mode default
- ✓ AI provider abstraction in place and swappable
- ✓ CONVENTIONS.md documented
- ✓ Main.dart initialization complete

---

### Phase 2: Agenda Module (Epic 2) — Weeks 3-4

**Goal:** Build the Agenda module with persistent strip, calendar view, event CRUD, and day timeline.

**Stories:** 6 stories  
**Estimated Duration:** 2 weeks  
**Deliverables:** Fully functional Agenda module with event management

#### Story 2.1: Event Data Access Layer
- Create `features/agenda/data/agenda_dao.dart` with Drift queries
- Implement getAllEvents(), getEventsForDate(), getEventsForWeek(), getNextEvents(count)
- Create `features/agenda/data/agenda_repository.dart` implementing domain interface
- Implement createEvent(), updateEvent(), deleteEvent(), getUpcomingEvents()
- Inject repository via Riverpod provider

#### Story 2.2: Persistent Agenda Strip Widget
- Create `features/agenda/presentation/widgets/agenda_strip.dart`
- Display next 2 events with time and title (truncated at 20 chars)
- Show "tomorrow" label if no events today
- Show "Nothing scheduled — free day" if nothing scheduled
- Make strip always visible above main content
- Implement tap to open calendar modal
- Ensure real-time updates when events change

#### Story 2.3: Calendar View (Day and Week Modes)
- Create `features/agenda/presentation/agenda_slide.dart`
- Implement day mode with hourly timeline and event positioning
- Implement week mode with 7-day grid
- Enable swiping between day and week modes
- Highlight current day
- Implement event detail view on tap
- Use table_calendar package for rendering

#### Story 2.4: Event CRUD Operations
- Create `features/agenda/presentation/widgets/add_event_sheet.dart`
- Implement add event bottom sheet with title, start time, end time, category fields
- Implement quick-select buttons for common durations
- Implement event editing with same fields
- Implement delete confirmation with swipe gesture
- Ensure immediate UI updates after create/update/delete

#### Story 2.5: Agenda State Management with Riverpod
- Create `features/agenda/presentation/agenda_providers.dart`
- Implement agendaRepositoryProvider
- Implement todayAgendaProvider (async)
- Implement weekAgendaProvider (async)
- Implement nextEventsProvider for strip (async)
- Implement agendaNotifierProvider for add/update/delete actions
- Use @riverpod annotation for code generation

#### Story 2.6: Agenda Strip Integration with Main App
- Integrate AgendaStrip into main app shell
- Display strip above carousel on every screen
- Watch nextEventsProvider for reactive updates
- Implement skeleton loader for loading state
- Implement error state handling
- Ensure carousel position preserved when opening calendar modal

**Completion Criteria:**
- ✓ Agenda module fully functional
- ✓ Event CRUD operations working
- ✓ Persistent strip visible on all screens
- ✓ Calendar view with day/week modes
- ✓ Real-time updates with Riverpod
- ✓ No data loss on app restart

---

### Phase 3: Practice Module (Epic 3) — Weeks 5-6

**Goal:** Build the Practice module with skill cards, session logging, streak computation, unanchored flagging, and pattern detection.

**Stories:** 8 stories  
**Estimated Duration:** 2 weeks  
**Deliverables:** Fully functional Practice module with skill tracking and session logging

#### Story 3.1: Practice Data Access Layer
- Create `features/practice/data/practice_dao.dart` with Drift queries
- Implement getAllSkills(), getSkillById(), getSessionsForSkill(), getUnanchoredSessions()
- Create `features/practice/data/practice_repository.dart`
- Implement createSkill(), logSession(), getSkillWithSessions(), getUnanchoredSessionsLastDays(days)
- Inject repository via Riverpod provider

#### Story 3.2: Practice Module UI Shell and Skill Cards
- Create `features/practice/presentation/practice_slide.dart`
- Create `features/practice/presentation/widgets/skill_card.dart`
- Display skill name, streak (7-day bar), last session date, session count
- Make streak bar visually significant and emotionally compelling
- Implement tap to open session logging sheet
- Display cards in scrollable list
- Handle empty state with first-launch prompt

#### Story 3.3: First-Launch Skill Prompt
- Detect first launch via SharedPreferences flag
- Show bottom sheet with "What's one skill you're working on?" prompt
- Implement free-text input field (no categories)
- Create skill on "Create" button tap
- Dismiss sheet and show skill card immediately
- Set first-launch flag to prevent re-showing

#### Story 3.4: Session Logging with Duration and Notes
- Create `features/practice/presentation/widgets/session_logging_sheet.dart`
- Implement duration input (minutes) with quick-select buttons (15, 30, 45, 60 min)
- Implement optional notes field
- Create session in SQLite with isAnchored = false
- Dismiss sheet with 400ms completion animation (scale-down effect)
- Update skill card immediately with new streak and last session date

#### Story 3.5: Streak Computation and Display
- Create `features/practice/domain/streak_calculator.dart`
- Calculate consecutive days from most recent session backwards
- Handle UTC+0 timezone correctly
- Return current streak count and last session date
- Update streak bar reactively on skill cards
- Fill bar proportionally (7-day max for MVP)

#### Story 3.6: Unanchored Session Flagging
- Flag sessions without corresponding calendar events as isAnchored = false
- Implement silent flagging (no UI prompt)
- Store flag for pattern detection
- Never show flag to user until pattern is detected

#### Story 3.7: Pattern Detection for Unanchored Sessions
- Create `features/practice/domain/pattern_detector.dart`
- Detect pattern: 3+ unanchored sessions within 90-minute time window across 2+ different calendar weeks
- Return skill_id and suggested_time if pattern detected
- Handle UTC+0 timezone correctly
- Integrate with SuggestionEngine (Epic 5)

#### Story 3.8: Practice State Management with Riverpod
- Create `features/practice/presentation/practice_providers.dart`
- Implement practiceRepositoryProvider
- Implement allSkillsProvider (async)
- Implement skillWithSessionsProvider(skillId) (async)
- Implement unanchoredSessionsProvider (last 7 days, async)
- Implement practiceNotifierProvider for create/log actions
- Use @riverpod annotation

**Completion Criteria:**
- ✓ Practice module fully functional
- ✓ Skill cards displaying with streak tracking
- ✓ Session logging working with completion animation
- ✓ First-launch prompt working
- ✓ Pattern detection ready for AI integration
- ✓ Real-time updates with Riverpod

---

### Phase 4: AI Layer (Epic 4) — Weeks 7-8

**Goal:** Build the AI integration layer with context builder, chat interface, quick-command dropdown, and offline degradation.

**Stories:** 6 stories  
**Estimated Duration:** 2 weeks  
**Deliverables:** Fully functional AI chat with offline support

#### Story 4.1: AI Context Builder
- Create `features/ai/domain/context_builder.dart`
- Build payload with: today + next 48 hours events, all skills with streak/last_session, last 7 days unanchored sessions, last 3 suggestions with status, current_datetime, timezone (UTC+0)
- Enforce 4000 character hard cap
- Truncate session history first if over cap, then extend agenda window
- Log warning locally if truncation occurs
- Return structured context as JSON-serializable object

#### Story 4.2: Claude API Client with Error Handling
- Create `features/ai/data/claude_provider.dart` implementing AiProvider
- Send POST requests to Claude API with systemPrompt and userMessage
- Include context payload from Story 4.1
- Handle API timeout (3 second max) gracefully
- Return parsed response text
- Handle API errors without crashing
- Pass API key via String.fromEnvironment (no hardcoding)

#### Story 4.3: AI Chat Interface
- Create `features/ai/presentation/ai_chat_sheet.dart`
- Display one-line state summary at top: "3 events today · Japanese idle 5 days · 2 free slots this week"
- Show quick-command suggestions below summary
- Keep message input at bottom (thumb-reachable)
- Implement message sending and display
- Show AI response with loading state
- Persist chat history in SQLite
- Handle offline: "Couldn't reach AI · Tap to retry"

#### Story 4.4: Quick-Command Dropdown
- Generate context-aware quick-command suggestions
- Suggestions appear below state summary when chat opens
- Examples: "When should I practice?", "Show my week"
- Generate suggestions locally (no API call)
- Implement tap to send as message
- AI responds to command

#### Story 4.5: Offline Degradation for AI
- Detect offline state via ConnectivityService
- Switch AI provider to OfflineProvider when offline
- Show "Couldn't reach AI · Tap to retry" in chat
- Preserve user's message (not lost)
- Enable retry when connectivity returns
- Never show error states or spinners for AI unavailability

#### Story 4.6: AI State Management with Riverpod
- Create `features/ai/presentation/ai_providers.dart`
- Implement aiProviderServiceProvider (swappable)
- Implement chatMessagesProvider (async)
- Implement aiResponseProvider(message) (async)
- Implement contextBuilderProvider (async)
- Implement aiNotifierProvider for chat actions
- Use @riverpod annotation

**Completion Criteria:**
- ✓ AI chat fully functional
- ✓ Context builder working with 4000 char cap
- ✓ Claude API integration complete
- ✓ Offline degradation working
- ✓ Quick-command suggestions functional
- ✓ Chat history persisted

---

### Phase 5: Proactive System (Epic 5) — Weeks 9-10

**Goal:** Build the proactive AI system with SuggestionEngine, background tasks, confirmation sheet, suppression algorithm, and Sunday reflection.

**Stories:** 6 stories  
**Estimated Duration:** 2 weeks  
**Deliverables:** Fully functional proactive notification system

#### Story 5.1: Suggestion Storage and Suppression Algorithm
- Store suggestions with suggestedAt timestamp
- Track user feedback: acceptedAt, dismissedAt, thumbsDownAt
- Implement suppression windows: accepted (1d), dismissed (3d), thumbs-down (7d)
- Filter out suppressed suggestions in SuggestionEngine
- Suppression logic is the entire learning algorithm

#### Story 5.2: SuggestionEngine with Slot Detection
- Create `features/ai/domain/suggestion_engine.dart`
- Find free slots in next 48 hours (gaps between events)
- Identify idle skills (longest days since last session)
- Apply suppression filters (dismissed: 3d, thumbs-down: 7d, accepted: 1d)
- Prioritize: longest idle skill first, then shortest available slot, then earliest free slot
- Return one suggestion per call (first match wins)
- Handle edge cases (no free slots, all skills suppressed)

#### Story 5.3: Background Task Scheduling (8pm Check-in)
- Create `core/services/background_task_service.dart`
- Register periodic task via workmanager to run at 8pm daily
- Implement platform-specific (Android: AlarmManager, iOS: background fetch)
- Ensure task runs even if app is closed
- Handle platform constraints (battery optimization, OS throttling)
- Log task execution for debugging

#### Story 5.4: Confirmation Sheet with Stale Slot Guard
- Create `features/ai/presentation/widgets/confirmation_sheet.dart`
- Show suggestion text, context (slot duration + skill idle days), "Block it" button, "Not now" button
- Recheck Agenda before rendering to verify slot still exists
- Show "This slot is no longer available" if slot is gone
- Create event in both Agenda and Practice if "Block it" tapped
- Implement thumbs-down micro-action for silent feedback
- Dismiss with 400ms completion animation after action

#### Story 5.5: Proactive Notification Delivery
- Create `core/services/notification_service.dart`
- Send proactive notification at 8pm with suggestion text
- Open confirmation sheet directly on notification tap (not app home screen)
- Implement one AI voice per day (max one proactive notification per 24 hours)
- Handle offline proactive logic: free-slot + idle-skill detection runs on-device

#### Story 5.6: Sunday Reflection Notification
- Implement Sunday 8pm reflection notification
- Compute reflection sentence locally from streak data and session counts
- No API call required
- Different from weekday notifications: reflection line only, no "Block it" action, no confirmation sheet
- Dismiss with simple close button

**Completion Criteria:**
- ✓ Proactive notification system fully functional
- ✓ SuggestionEngine working with slot and skill detection
- ✓ Background task scheduling at 8pm
- ✓ Confirmation sheet with stale slot guard
- ✓ Suppression algorithm tracking user feedback
- ✓ Sunday reflection notification working
- ✓ Offline proactive logic functional

---

### Phase 6: Polish & Resilience (Epic 6) — Weeks 11-12

**Goal:** Complete the app with light mode, animations, empty states, error states, accessibility, and locale formatting.

**Stories:** 8 stories  
**Estimated Duration:** 2 weeks  
**Deliverables:** Production-ready app with full polish and resilience

#### Story 6.1: Light Mode Implementation
- Implement light mode theme remapping via SharedPreferences toggle
- Ensure all semantic tokens work in light mode
- Test contrast ratios (WCAG AA compliance)
- Implement smooth theme transition animation

#### Story 6.2: Completion Animation (400ms Scale-Down)
- Implement 400ms scale-down animation for session logging completion
- Apply durationSlow (400ms) animation duration
- Ensure smooth dismissal after animation completes

#### Story 6.3: Empty States and Placeholder UI
- Implement empty state for no skills (first-launch prompt)
- Implement empty state for no events (Agenda strip: "Nothing scheduled — free day")
- Implement empty state for no chat history
- Create skeleton loaders for loading states (Agenda strip, chat, skills)

#### Story 6.4: Error State Handling
- Implement error state for failed API calls
- Implement error state for database failures
- Implement error state for notification delivery failures
- Show user-friendly error messages (no technical jargon)

#### Story 6.5: Offline Fallback Pulse Animation
- Implement pulse dot animation on AI component when fallback suggestion is queued
- Single slow pulse only (never continuous, never badge count)
- Animate once on app open when background task missed 18-hour window

#### Story 6.6: Accessibility Compliance
- Ensure WCAG AA text contrast compliance across all screens
- Implement minimum 44dp touch targets for all interactive elements
- Add semantic labels for screen readers
- Test with accessibility tools

#### Story 6.7: Locale Formatting (XOF, DD/MM/YYYY, UTC+0)
- Implement XOF currency formatting (no decimal places)
- Implement DD/MM/YYYY date format throughout app
- Ensure UTC+0 timezone handling in all date/time calculations
- Test with locale-specific data

#### Story 6.8: Settings Screen with Data Clearing
- Create `features/settings/presentation/settings_slide.dart`
- Implement theme toggle (dark/light mode)
- Implement "Clear all local data" button with confirmation
- Implement about/version information
- Ensure data clearing removes all SQLite data and resets app state

#### Story 6.9: Performance Optimization and Testing
- Profile app for performance bottlenecks
- Optimize database queries with proper indexing
- Implement caching strategies for frequently accessed data
- Create unit tests for critical business logic (streak calculation, pattern detection, suggestion engine)
- Create integration tests for key user flows (event CRUD, session logging, notification delivery)

**Completion Criteria:**
- ✓ Light mode fully functional and tested
- ✓ All animations smooth and performant
- ✓ Empty states and error states handled gracefully
- ✓ Accessibility compliance verified (WCAG AA)
- ✓ Locale formatting correct (XOF, DD/MM/YYYY, UTC+0)
- ✓ Settings screen functional with data clearing
- ✓ Performance optimized and tested
- ✓ App ready for production release

---

## Sprint Tracking

### Week-by-Week Breakdown

| Week | Epic | Stories | Focus |
|------|------|---------|-------|
| 1-2 | Epic 1 | 1.1-1.7 | Foundation & Infrastructure |
| 3-4 | Epic 2 | 2.1-2.6 | Agenda Module |
| 5-6 | Epic 3 | 3.1-3.8 | Practice Module |
| 7-8 | Epic 4 | 4.1-4.6 | AI Layer |
| 9-10 | Epic 5 | 5.1-5.6 | Proactive System |
| 11-12 | Epic 6 | 6.1-6.9 | Polish & Resilience |

### Story Status Tracking Template

For each story, track:
- **Status:** Not Started → In Progress → Code Review → Testing → Completed
- **Blockers:** Any dependencies or issues preventing progress
- **Notes:** Implementation details, decisions, or challenges

---

## Dependencies and Sequencing

### Critical Path

1. **Epic 1 (Foundation)** must complete before any other epic starts
2. **Story 2.1 (Agenda Data Access)** must complete before Stories 2.2-2.6
3. **Story 3.1 (Practice Data Access)** must complete before Stories 3.2-3.8
4. **Story 5.1 (Suggestion Storage)** must complete before Story 5.2 (SuggestionEngine)
5. **Epics 2 & 3** can run in parallel after Epic 1 completes
6. **Epic 4** requires Epics 2 & 3 to be substantially complete (for context building)
7. **Epic 5** requires Epics 2, 3, & 4 to be substantially complete
8. **Epic 6** can start after Epic 5 begins (polish work is independent)

### Parallel Development Opportunities

- **Within Epic 1:** Stories 1.2, 1.3, 1.5, 1.6 can run in parallel after 1.1 completes
- **Within Epic 2:** Stories 2.2, 2.3, 2.4 can run in parallel after 2.1 completes
- **Within Epic 3:** Stories 3.2, 3.3, 3.4, 3.5 can run in parallel after 3.1 completes
- **Within Epic 4:** Stories 4.3, 4.4, 4.5 can run in parallel after 4.1 & 4.2 complete
- **Within Epic 5:** Stories 5.4, 5.5, 5.6 can run in parallel after 5.1, 5.2, 5.3 complete

---

## Success Criteria

### Per-Epic Completion

- **Epic 1:** Project compiles, all infrastructure in place, CONVENTIONS.md documented
- **Epic 2:** Agenda module fully functional, event CRUD working, persistent strip visible
- **Epic 3:** Practice module fully functional, skill tracking working, session logging complete
- **Epic 4:** AI chat functional, context builder working, offline degradation implemented
- **Epic 5:** Proactive notifications working, SuggestionEngine functional, suppression algorithm tracking feedback
- **Epic 6:** App polished, accessible, locale-aware, production-ready

### Overall Project Completion

- ✓ 100% FR coverage (26 of 26 FRs implemented)
- ✓ 100% NFR coverage (20 of 20 NFRs met)
- ✓ 100% UX-Architecture alignment
- ✓ All 48 stories completed with acceptance criteria met
- ✓ Zero forward dependencies
- ✓ App compiles and runs without errors
- ✓ All critical user flows tested and working
- ✓ Ready for beta testing with real users

---

## Notes

- This sprint plan assumes solo development with ruthless feature prioritization
- Each epic builds upon the previous one; maintain dependency awareness
- Use the CONVENTIONS.md document as the source of truth for architectural patterns
- Track blockers and dependencies actively to prevent rework
- Prioritize user-facing features (Epics 2-5) over polish (Epic 6) if time becomes constrained
- Consider parallel development within epics to accelerate timeline

---

**Sprint Plan Created:** 2026-03-29  
**Total Estimated Duration:** 12 weeks (3 months)  
**Status:** Ready for implementation  
**Next Step:** Begin Epic 1 (Foundation)

