# OdO Implementation Plan

**Project:** OdO — Personal AI Daily Companion  
**Date:** 2026-05-13  
**Status:** Ready for Implementation  
**Total Stories:** 41 across 6 epics

---

## Epic Sequence & Dependencies

### Epic 1: Foundation (Stories 1.1–1.8) — 8 stories
**Status:** PENDING  
**Dependencies:** None (prerequisite epic)  
**User Value:** Technical foundation enabling all subsequent epics  
**Estimated Scope:** Large (project scaffold, design tokens, SQLite schema, AiProvider abstraction, core services, router)

**Stories:**
- 1.1: Project Setup and Dependency Configuration
- 1.2: Design Tokens and Color System
- 1.3: Theme System with Runtime Swap
- 1.4: SQLite Database Schema with Drift
- 1.5: AiProvider Abstraction with Five Implementations
- 1.6: Core Services
- 1.7: Result Type and Error Handling
- 1.8: Router and Project Structure

**Blocking Criteria:** All stories must be complete before proceeding to Epics 2, 3

---

### Epic 2: Agenda Module (Stories 2.1–2.5) — 5 stories
**Status:** PENDING  
**Dependencies:** Epic 1 (Foundation)  
**User Value:** Users can view and manage their daily schedule  
**Estimated Scope:** Large (persistent strip with 3 states, day timeline, event CRUD, monthly calendar)

**Stories:**
- 2.1: Agenda Repository and DAO
- 2.2: Persistent Agenda Strip (Three States)
- 2.3: Day Timeline View
- 2.4: Event CRUD with Three Categories
- 2.5: Monthly Calendar

**Blocking Criteria:** Story 2.1 must complete before 2.2–2.5

---

### Epic 3: Practice Module (Stories 3.1–3.6) — 6 stories
**Status:** PENDING  
**Dependencies:** Epic 1 (Foundation)  
**User Value:** Users can track skills and log practice sessions  
**Estimated Scope:** Large (skill cards, first-launch prompt, session logging, streak computation, pattern detection)

**Stories:**
- 3.1: Practice Repository and DAO
- 3.2: First-Launch Skill Prompt
- 3.3: Skill Card
- 3.4: Session Logging
- 3.5: Streak Computation
- 3.6: Pattern Detection / Unanchored Sessions

**Blocking Criteria:** Story 3.1 must complete before 3.2–3.6

---

### Epic 4: AI Layer (Stories 4.1–4.5) — 5 stories
**Status:** PENDING  
**Dependencies:** Epics 1, 2, 3  
**User Value:** Users can chat with AI and receive suggestions; voice input available  
**Estimated Scope:** Large (context builder ≤4k, persistent bottom bar, chat sheet, voice STT pipeline, offline degradation)

**Stories:**
- 4.1: Context Builder
- 4.2: Persistent AI Bottom Bar
- 4.3: Chat Sheet
- 4.4: Voice Tap-to-Speak Pipeline
- 4.5: Offline Graceful Degradation

**Blocking Criteria:** Story 4.1 must complete before 4.2–4.5

---

### Epic 5: Glance + Evening + Proactive (Stories 5.1–5.9) — 9 stories
**Status:** PENDING  
**Dependencies:** Epics 1, 2, 3, 4  
**User Value:** App-locked Glance Screen, Orb widget, evening session, proactive suggestions with suppression  
**Estimated Scope:** Very Large (Glance Screen auth, Orb, evening orchestration, on-device suggestion engine, background tasks)

**Stories:**
- 5.1: Glance Screen Layout and States
- 5.2: Glance Screen Authentication
- 5.3: Orb Widget
- 5.4: Evening Session Orchestration
- 5.5: Evening Session Persistence Until Midnight
- 5.6: Suggestion Engine (On-Device)
- 5.7: Confirmation Sheet
- 5.8: Background Tasks
- 5.9: Suppression Algorithm

**Blocking Criteria:** Story 5.1 must complete before 5.2; Stories 5.6, 5.8 must complete before 5.7, 5.9

---

### Epic 6: Polish & Resilience (Stories 6.1–6.8) — 8 stories
**Status:** PENDING  
**Dependencies:** Epics 1–5 (all previous epics)  
**User Value:** All 7 themes, French locale, accessibility, animations, first-launch flow, zero-crash performance  
**Estimated Scope:** Medium (QA, polish, resilience — no new features)

**Stories:**
- 6.1: All Seven Themes
- 6.2: Light Mode Outdoor Readability
- 6.3: Empty States and Error States
- 6.4: Animations and Motion
- 6.5: Accessibility Audit
- 6.6: Locale QA — French and XOF
- 6.7: First-Launch Flow
- 6.8: Performance and Crash-Free Resilience

**Blocking Criteria:** All stories must pass quality validation before release

---

## Dependency Matrix

| Epic | Depends On | Blocks |
|------|-----------|--------|
| 1 | None | 2, 3, 4, 5, 6 |
| 2 | 1 | 4, 5, 6 |
| 3 | 1 | 4, 5, 6 |
| 4 | 1, 2, 3 | 5, 6 |
| 5 | 1, 2, 3, 4 | 6 |
| 6 | 1, 2, 3, 4, 5 | None |

---

## Implementation Sequence

### Phase 1: Foundation (Epic 1) — 8 stories
Establish the technical substrate: project scaffold, design system, SQLite schema (6 tables), AiProvider abstraction (5 impls), core services (LocaleService, NotificationService, BackgroundTaskService), Result type, and go_router shell.

**Estimated Duration:** 3–4 days

### Phase 2: Core Modules (Epics 2 & 3 in parallel) — 11 stories
Once Epic 1 is complete, Epics 2 and 3 can proceed in parallel — no dependency between them.

**Estimated Duration:** 5–7 days each

### Phase 3: AI Integration (Epic 4) — 5 stories
Requires completion of Epics 1, 2, and 3. Implements Claude API integration, context builder, persistent bottom bar, chat sheet, voice pipeline, and offline degradation.

**Estimated Duration:** 4–5 days

### Phase 4: Glance + Evening + Proactive (Epic 5) — 9 stories
Requires completion of Epics 1, 2, 3, and 4. Implements the locked Glance Screen, authentication, Orb widget, evening session, on-device suggestion engine, and background task scheduling.

**Estimated Duration:** 5–7 days

### Phase 5: Polish & Resilience (Epic 6) — 8 stories
Final phase after all core epics complete. Implements all 7 themes, French locale QA, accessibility audit, animations, empty/error states, first-launch flow, and performance profiling.

**Estimated Duration:** 3–4 days

---

## Verification Checkpoints

### After Each Epic
- [ ] All stories in epic have passing tests
- [ ] `flutter analyze` reports no issues
- [ ] No forward dependencies introduced
- [ ] Performance thresholds met (see IMPLEMENTATION_STATUS.json)
- [ ] IMPLEMENTATION_STATUS.json updated with epic completion

### Before Marking Any Story Complete
- [ ] All acceptance criteria implemented
- [ ] Tests written and passing (≥90% pass rate)
- [ ] Code reviewed for Clean Architecture compliance
- [ ] No simplifications or omissions
- [ ] `flutter analyze` clean on all changed files

---

## Success Criteria

- All 41 stories implemented
- 100% acceptance criteria coverage
- `flutter analyze`: No issues found
- `flutter test`: ≥90% passing
- Cold start <1.5s on mid-range Android
- All local actions <500ms (optimistic UI)
- Zero crashes across 14 consecutive days of personal use
- Background task fires successfully ≥70% of days

---

## Notes

- **Platform:** Flutter (Android + iOS) with Riverpod state management
- **Database:** Drift ORM with SQLite (6 tables: skills, sessions, events, suggestions, evening_sessions, evening_highlights)
- **AI Provider:** Claude API (`claude-sonnet-4-6`); Gemini/Groq/OpenAI/OfflineStub as V1 stubs
- **Navigation:** go_router with shell route + 5-tab bottom nav (Home, Agenda, Practice, Insights, Profile)
- **Notifications:** flutter_local_notifications + workmanager (8pm evening session trigger)
- **Architecture:** Clean Architecture — Domain → Data → Presentation (see `docs/contracts.md`)
- **Themes:** 7 OdoTheme presets (Violet Dark default/OLED, Cyan Dark, Green Dark, Light Mode, Cosmic, Ember, Aurora)
- **Locale:** French default, English fallback; XOF currency, DD/MM/YYYY dates, 24h HH:mm times
- **Offline-First:** All Agenda and Practice features work without connectivity; AI degrades gracefully
- **Voice:** STT → 1.5s silence → parseCommand → intent → commit (Story 4.4, V1)

---

**Last Updated:** 2026-05-13  
**Next Step:** Begin Epic 1 (Foundation) implementation starting with Story 1.1
