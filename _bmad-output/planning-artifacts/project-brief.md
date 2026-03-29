# TooXTips Project Brief

**Project Name:** TooXTips — Personal AI Productivity Hub  
**Version:** 1.0 (MVP)  
**Date Created:** March 29, 2026  
**Status:** Ready for Implementation  

---

## Executive Summary

TooXTips is a personal AI productivity app that helps users optimize their time, practice habits, and spending through intelligent cross-domain insights. The MVP focuses on two core modules — **Agenda** and **Practice** — with AI as an enhancement layer that proactively suggests how to use free time for skill development.

**Key Differentiator:** The AI understands your schedule and practice patterns, surfacing actionable suggestions at the right moment (e.g., "You have 45 free minutes Thursday. Japanese is idle. Block it?").

---

## Problem Statement

Users struggle to:
1. **Find time for skill development** amid busy schedules
2. **Maintain consistent practice habits** without external structure
3. **Understand spending patterns** in relation to their time and priorities

Current solutions (calendar apps, habit trackers, expense apps) operate in silos. TooXTips unifies these domains so the AI can reason across them.

---

## Target User

**Primary:** Knowledge workers and students in West Africa (Côte d'Ivoire focus) who:
- Use mobile as primary computing device
- Value time optimization and skill development
- Have inconsistent connectivity
- Manage multiple life domains (work, learning, finances)

**Secondary:** Anyone building personal productivity systems who wants AI-powered cross-domain insights.

---

## Core Value Proposition

**For the User:**
- One app to see your day, track practice, and understand spending
- AI that learns your patterns and suggests the best time to practice
- Works offline; AI enhances but doesn't require connectivity
- Respects privacy — all data stays on your device

**For the Builder (Solo Development):**
- Minimal scope (two modules + AI layer)
- Realistic 3–4 week solo development timeline
- Clear priority hierarchy
- Offline-first architecture reduces complexity

---

## MVP Scope

### Included in MVP

**1. Agenda Module**
- Calendar view (day/week)
- Event creation, editing, deletion
- Time-based event display
- Persistent "today strip" showing next 2–3 upcoming events
- SQLite persistence

**2. Practice Module**
- Skill cards (add/edit/delete skills)
- Session logging (duration, date, notes)
- Streak tracking
- Idle skill detection (last session timestamp)
- Unanchored session flagging (sessions without calendar events)

**3. AI Layer (Claude Integration)**
- Context builder (aggregates Agenda + Practice data)
- Proactive notifications (8pm daily check-in)
- Free-slot detection (gaps in calendar)
- Idle-skill matching (suggest practice for available time)
- Chat interface for questions
- Offline graceful degradation

**4. Core UX**
- Persistent Agenda strip (always visible)
- Two-slide carousel (Practice + Expenses placeholder)
- Dark mode first, light mode support
- Responsive design for mobile

### Deferred to v1.1

- Expenses module (manual logging, complex for MVP)
- Voice commands (accent/language variability, permission complexity)
- Cloud sync (local-first MVP)
- Habit anchoring to recurring events
- Receipt scanning

---

## Architecture Decisions

### Technology Stack
- **Framework:** Flutter (cross-platform, solo-friendly)
- **Database:** SQLite (local-first, no backend required)
- **AI:** Claude API (context-aware, handles ambiguity)
- **Notifications:** flutter_local_notifications (proactive AI delivery)
- **Internationalization:** intl package (XOF currency, DD/MM/YYYY dates)

### Key Architectural Principles

1. **Offline-First:** All modules function completely without AI. AI is an enhancement layer, not a dependency.
2. **Perceived Responsiveness:** Sub-500ms perceived latency via optimistic UI, skeleton loaders, local-first rendering.
3. **Graceful Degradation:** If AI is unavailable, the app remains fully functional.
4. **Proactive > Reactive:** AI's primary value is proactive notifications (8pm check-in), not reactive chat.
5. **Locale Awareness:** XOF currency, DD/MM/YYYY dates, French language support (future).

---

## User Flows

### Primary Flow: Free-Slot Suggestion

```
1. User opens app (evening, 8pm)
2. Background task runs: analyzes Agenda gaps + idle skills
3. Notification: "You have 45 free minutes Thursday. Japanese is idle. Block it?"
4. User taps → Practice module opens with suggestion pre-filled
5. User confirms → Event added to Agenda
```

### Secondary Flow: Unanchored Session Detection

```
1. User logs practice session (no calendar event)
2. After 2nd unanchored session at similar time, AI surfaces suggestion
3. "You've practised Japanese twice around 7pm without scheduling. Add recurring block?"
4. User confirms → Recurring event created in Agenda
```

### Tertiary Flow: Manual Queries

```
1. User opens chat interface
2. Asks: "When should I practice this week?"
3. AI analyzes Agenda + Practice, returns prioritized time slots
4. User can tap to add events
```

---

## Success Metrics

### MVP Success Criteria
- App launches and functions offline
- Agenda + Practice modules work without AI
- AI context builder correctly aggregates data
- Proactive notification triggers at 8pm
- Free-slot detection accuracy > 90%
- Idle-skill matching works for 2+ skills
- No crashes on typical usage patterns
- Perceived latency < 500ms

### User Engagement (Post-Launch)
- Daily active users (DAU)
- Notification engagement rate (% who tap proactive suggestions)
- Practice session consistency (week-over-week)
- Feature adoption (% using AI vs. manual-only)

---

## Constraints & Assumptions

### Load-Bearing Constraints
- **Solo development:** One person, full responsibility
- **Flutter:** Cross-platform requirement
- **Perceived responsiveness:** Must feel instant, even if AI is slow
- **Local-first data:** All user data stays on device
- **Locale correctness:** XOF currency, DD/MM/YYYY dates, Abidjan context

### Assumptions About User Behavior
- Users will consistently log practice sessions (or use voice in v1.1)
- Users check their phone daily (notification delivery assumption)
- Users have predictable schedule patterns (AI learning assumption)
- Users value time optimization over feature breadth

### Technical Assumptions
- Claude API remains available and performant
- SQLite is sufficient for 2+ years of data
- Context payload stays under token limits (selective context strategy for degradation)
- Mobile connectivity is intermittent but not permanent

---

## Implementation Roadmap

### Phase 1: Foundation (Days 1–3)
- Flutter project setup
- Theme system (dark/light)
- Persistent Agenda strip + carousel shell
- SQLite schema design

### Phase 2: Agenda Module (Days 4–7)
- Calendar view (day/week)
- Event CRUD operations
- Time-based display
- Persistence

### Phase 3: Practice Module (Days 8–11)
- Skill cards
- Session logging
- Streak tracking
- Unanchored flagging

### Phase 4: AI Layer (Days 12–16)
- Claude API integration
- Context builder
- Chat interface
- Graceful offline handling

### Phase 5: Proactive AI (Days 17–20)
- Background task scheduling
- Free-slot detection
- Idle-skill matching
- 8pm notification logic

### Phase 6: Polish & Testing (Days 21–27)
- Edge case handling
- Error states
- Offline testing
- Dark/light mode QA
- Performance optimization

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Context payload exceeds token limits | Medium | High | Implement selective context strategy; defer to v1.1 if needed |
| Offline connectivity breaks AI | High | Medium | Design app to function fully without AI; graceful degradation |
| Voice commands (v1.1) fail on accents | High | Low | Defer to v1.1; test with Ivorian French speakers |
| Manual expense logging abandoned | High | Medium | Defer Expenses to v1.1; focus on Agenda + Practice |
| Notification fatigue | Medium | Medium | Limit to one suggestion per day; user can disable |
| Solo development timeline slips | Medium | High | Prioritize ruthlessly; defer features to v1.1 |

---

## Success Definition

**MVP is successful when:**
1. App launches, functions offline, and doesn't crash
2. Agenda + Practice modules work without AI
3. AI proactive notification triggers and surfaces relevant suggestions
4. One user (you) uses it daily for 2+ weeks without abandoning it
5. The product is honest about its constraints (offline-first, no voice, no expenses)

**This is not about perfection. It's about shipping a focused product that solves one problem well: helping you find time to practice.**

---

## Next Steps

1. **Review & Validate:** Confirm this brief aligns with your vision
2. **Refine Scope:** Adjust MVP scope if needed before implementation
3. **Design System:** Create wireframes for Agenda strip + carousel
4. **Begin Implementation:** Start Phase 1 (Foundation)

---

**Document Status:** Ready for Implementation  
**Last Updated:** March 29, 2026  
**Owner:** Lokki (Solo Developer)
