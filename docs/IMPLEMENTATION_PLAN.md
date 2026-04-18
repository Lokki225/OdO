# TooXTips Implementation Plan

**Project:** TooXTips — Personal AI Productivity Hub  
**Date:** 2026-03-30  
**Status:** Ready for Implementation  
**Total Stories:** 48 across 6 epics

---

## Epic Sequence & Dependencies

### Epic 1: Foundation (Stories 1.1-1.7)
**Status:** PENDING  
**Dependencies:** None (prerequisite epic)  
**User Value:** Technical foundation enabling all subsequent epics  
**Estimated Scope:** Large (infrastructure setup, database schema, design system)

**Stories:**
- 1.1: Project Setup and Dependency Configuration
- 1.2: Design Tokens and Color System
- 1.3: Theme System with Dark Mode Default
- 1.4: Database Schema (Drift SQLite)
- 1.5: AiProvider Abstraction Interface
- 1.6: Riverpod Provider Organization
- 1.7: Error Handling & Result Types

**Blocking Criteria:** All stories must be complete before proceeding to Epic 2/3

---

### Epic 2: Agenda Module (Stories 2.1-2.8)
**Status:** PENDING  
**Dependencies:** Epic 1 (Foundation)  
**User Value:** Users can view calendar and manage events  
**Estimated Scope:** Large (calendar UI, event CRUD, persistent strip)

**Stories:**
- 2.1: Event Data Access Layer (DAO + Repository)
- 2.2: Persistent Agenda Strip UI
- 2.3: Calendar View (Day/Week modes)
- 2.4: Event CRUD Operations
- 2.5: Day Timeline View
- 2.6: Event Categories & Descriptions
- 2.7: Agenda Strip State Management
- 2.8: Agenda Integration Tests

**Blocking Criteria:** Story 2.1 must complete before 2.2-2.8

---

### Epic 3: Practice Module (Stories 3.1-3.8)
**Status:** PENDING  
**Dependencies:** Epic 1 (Foundation)  
**User Value:** Users can track skills and log practice sessions  
**Estimated Scope:** Large (skill cards, session logging, streak tracking)

**Stories:**
- 3.1: Practice Data Access Layer (DAO + Repository)
- 3.2: First-Launch Skill Prompt
- 3.3: Skill Cards UI
- 3.4: Session Logging Interface
- 3.5: Streak Computation & Display
- 3.6: Unanchored Session Flagging
- 3.7: Pattern Detection for Spontaneous Sessions
- 3.8: Practice Integration Tests

**Blocking Criteria:** Story 3.1 must complete before 3.2-3.8

---

### Epic 4: AI Layer (Stories 4.1-4.5)
**Status:** PENDING  
**Dependencies:** Epic 1 (Foundation), Epic 2 (Agenda), Epic 3 (Practice)  
**User Value:** Users can chat with AI and receive suggestions  
**Estimated Scope:** Large (Claude API integration, context builder, chat UI)

**Stories:**
- 4.1: Claude API Integration & Context Builder
- 4.2: Chat Interface & Message History
- 4.3: Quick-Command Dropdown
- 4.4: Offline AI Degradation
- 4.5: AI Layer Integration Tests

**Blocking Criteria:** Story 4.1 must complete before 4.2-4.5

---

### Epic 5: Proactive System (Stories 5.1-5.5)
**Status:** PENDING  
**Dependencies:** Epic 1 (Foundation), Epic 4 (AI Layer)  
**User Value:** Users receive proactive suggestions and weekly reflections  
**Estimated Scope:** Large (background tasks, suggestion engine, notifications)

**Stories:**
- 5.1: Suggestion Storage & Suppression Algorithm
- 5.2: SuggestionEngine Implementation
- 5.3: Background Task Scheduling (8pm check-in)
- 5.4: Confirmation Sheet UI
- 5.5: Proactive System Integration Tests

**Blocking Criteria:** Story 5.1 must complete before 5.2-5.5

---

### Epic 6: Polish & Resilience (Stories 6.1-6.9)
**Status:** PENDING  
**Dependencies:** All previous epics (1-5)  
**User Value:** App refinement, accessibility, settings  
**Estimated Scope:** Medium (polish, testing, accessibility, settings)

**Stories:**
- 6.1: Light Mode Implementation
- 6.2: Animations & Transitions
- 6.3: Empty States & Error States
- 6.4: Accessibility (WCAG AA)
- 6.5: Locale Formatting (XOF, DD/MM/YYYY)
- 6.6: Performance Optimization
- 6.7: Comprehensive Testing & Coverage
- 6.8: Sunday Reflection Notification
- 6.9: Settings Screen (Data Clearing, Theme Toggle)

**Blocking Criteria:** All stories must pass quality validation

---

## Dependency Matrix

| Epic | Depends On | Blocks |
|------|-----------|--------|
| 1 | None | 2, 3, 4, 5, 6 |
| 2 | 1 | 4, 6 |
| 3 | 1 | 4, 6 |
| 4 | 1, 2, 3 | 5, 6 |
| 5 | 1, 4 | 6 |
| 6 | 1, 2, 3, 4, 5 | None |

---

## Implementation Sequence

### Phase 1: Foundation (Epic 1)
Begin with Epic 1 to establish the technical substrate. All infrastructure, database schema, design system, and error handling patterns must be in place before feature implementation.

**Estimated Duration:** 3-4 days

### Phase 2: Core Modules (Epics 2 & 3 in parallel)
Once Epic 1 is complete, Epics 2 and 3 can proceed in parallel since they have no dependencies on each other.

**Estimated Duration:** 5-7 days each

### Phase 3: AI Integration (Epic 4)
Requires completion of Epics 1, 2, and 3. Implements Claude API integration and AI features.

**Estimated Duration:** 4-5 days

### Phase 4: Proactive System (Epic 5)
Requires completion of Epics 1 and 4. Implements background tasks and proactive notifications.

**Estimated Duration:** 3-4 days

### Phase 5: Polish & Resilience (Epic 6)
Final phase after all core epics complete. Implements accessibility, light mode, animations, and settings.

**Estimated Duration:** 3-4 days

---

## Verification Checkpoints

### After Each Epic
- [ ] All stories in epic have passing tests
- [ ] Code quality checks pass (flutter analyze)
- [ ] No forward dependencies introduced
- [ ] Integration tests pass
- [ ] Performance thresholds met

### Before Marking Story Complete
- [ ] All acceptance criteria implemented
- [ ] Tests written and passing
- [ ] Code reviewed for architecture compliance
- [ ] No simplifications or omissions
- [ ] Documentation updated

---

## Success Criteria

- ✅ All 48 stories implemented
- ✅ 100% acceptance criteria coverage
- ✅ 80%+ test coverage
- ✅ Zero forward dependencies
- ✅ All performance thresholds met
- ✅ flutter analyze: No issues
- ✅ All integration tests passing

---

## Notes

- **Platform:** Flutter (Mobile) with Riverpod state management
- **Database:** Drift ORM with SQLite
- **AI Provider:** Claude API (claude-sonnet-4-6)
- **Navigation:** go_router with bottom sheets as routes
- **Notifications:** flutter_local_notifications + workmanager
- **Architecture:** Clean Architecture with Domain → Data → Presentation layers
- **Testing:** Unit tests, integration tests, widget tests
- **Offline-First:** All core features work without connectivity

---

**Last Updated:** 2026-03-30  
**Next Step:** Begin Epic 1 (Foundation) implementation
