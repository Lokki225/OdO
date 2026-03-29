---
stepsCompleted: ["step-01-init", "step-02-discovery", "step-02b-vision"]
inputDocuments: ["project-brief.md", "TooXTips_MVP_Spec_v2.0_REVISED.md", "brainstorming-session-2026-03-29-1304.md"]
workflowType: 'prd'
projectName: 'TooXTips'
userName: 'Lokki'
date: '2026-03-29'
classification:
  projectType: "Mobile Application"
  domain: "Personal Productivity / AI-Enhanced Time Management"
  complexity: "Medium-High"
  projectContext: "Brownfield with refined MVP scope"
---

# Product Requirements Document - TooXTips

**Author:** Lokki  
**Date:** March 29, 2026  
**Project:** TooXTips — Personal AI Productivity Hub  
**Status:** MVP Development  
**Version:** 1.0

---

## Executive Summary

TooXTips is a personal AI productivity app built in Flutter that treats time, money, and skill development as a single interconnected system rather than three separate lists.

The core problem it solves is not organisation — it's *connection*. Existing tools track your calendar, your budget, and your habits in isolation. None of them know that your busiest work weeks are your worst spending weeks. None of them notice that you have 45 free minutes Thursday and haven't practised Japanese in five days. You do — but only if you manually check three apps, synthesise the information yourself, and then act. Most of the time, you don't.

TooXTips eliminates that synthesis step. An embedded AI reads across your Agenda and Practice modules simultaneously and surfaces the connection at the moment it's actionable — not in response to a question, but proactively, when the insight is still useful.

### Core Principles

**Local-first, AI-enhanced.** All data lives on-device. The app works fully offline. The AI is an enhancement layer, not a dependency — its absence degrades the experience gracefully rather than breaking it.

**Timely over smart.** The AI's value is not in answering questions correctly on demand. It's in surfacing the right insight at the right moment — a free slot notification Wednesday evening is useful; the same insight Saturday morning is noise. Proactive, scheduled reasoning beats reactive query-response.

**One anchor, two instruments.** Agenda is the persistent anchor — always visible, always providing temporal context. Practice is the primary instrument the AI acts on. The relationship is bidirectional: Agenda creates opportunities for Practice, and spontaneous Practice sessions inform Agenda over time.

### MVP Scope

- Agenda + Practice modules (Expenses deferred to v1.1)
- Persistent AI component with chat and command dropdown
- Offline-tolerant architecture
- Proactive evening notification with one cross-module suggestion
- Local SQLite storage
- Dark mode first, light mode support

### Success Condition

Used daily for two weeks without manually checking a separate calendar or habit tracker. The aha moment is the first time the AI surfaces a connection you would have missed — and acts on it before you thought to ask.

---

## Success Criteria

### User Success

Users achieve the core value proposition when they:
- Stop context-switching between separate calendar, habit tracker, and expense apps
- Experience at least one proactive AI suggestion that surfaces a connection they would have missed
- Use the app daily without manual data entry friction
- Feel that the AI understands their schedule and practice patterns

**Measurable outcomes:**
- Daily active usage for 2+ weeks without abandonment
- Proactive notification engagement rate > 50% (users tap suggestions)
- Session duration > 2 minutes per day (indicating meaningful interaction)
- Zero manual context-switching to other productivity apps for core use cases

### Business Success

For a personal-first product shared with beta testers and collaborators:
- MVP ships with zero crashes on typical usage patterns
- Offline functionality works reliably (no silent failures)
- AI context builder correctly aggregates cross-module data
- Perceived latency < 500ms on all core interactions

**Post-launch metrics (beta phase):**
- Beta tester retention: 80%+ continue using after 2 weeks
- Feature adoption: 100% of beta testers use Agenda + Practice; 70%+ engage with AI
- Feedback quality: Actionable bug reports and feature requests from testers

### Technical Success

- App launches and functions completely offline
- Agenda + Practice modules work independently without AI
- SQLite persistence handles 2+ years of typical user data
- Claude API integration handles context payloads within token limits
- Background task scheduling (8pm proactive check-in) executes reliably
- Dark and light themes render correctly across all screens

### Measurable Outcomes

| Metric | Target | Measurement |
|--------|--------|-------------|
| Daily Active Usage | 14+ consecutive days | User opens app daily |
| Proactive Notification Engagement | > 50% | Users tap AI suggestions |
| Perceived Responsiveness | < 500ms | All core interactions feel instant |
| Offline Functionality | 100% | App works without connectivity |
| Crash-Free Sessions | 99%+ | No crashes on typical usage |
| Feature Adoption (AI) | 70%+ beta testers | Engage with chat or commands |

## Product Scope

### MVP - Minimum Viable Product

**Included:**
- Agenda module: calendar view (day/week), event CRUD, persistent strip showing next 2-3 events
- Practice module: skill cards, session logging, streak tracking, unanchored session flagging
- AI component: chat interface, quick-command dropdown, proactive 8pm notification
- Offline-first architecture: all data local, AI gracefully degrades without connectivity
- Dark mode (primary), light mode support
- SQLite persistence
- Claude API integration with context builder

**Explicitly excluded:**
- Expenses module (deferred to v1.1)
- Voice commands (deferred to v1.1)
- Cloud sync or multi-device support
- Recurring events
- Receipt scanning
- Home screen widget

### Growth Features (Post-MVP)

- Expenses module with budget tracking and spending patterns
- Voice commands for natural language event/session creation
- Cloud sync (iCloud/Firebase) for multi-device continuity
- Recurring event support
- AI-generated weekly review summaries
- Smart scheduling (AI proposes practice blocks in free slots)
- Home screen widget for glanceable agenda + AI tip

### Vision (Future)

- Multi-language support (French for Abidjan context)
- Receipt scanning for automatic expense logging
- Apple Watch / Wear OS companion app
- Natural language event creation from pasted meeting invites
- Skill difficulty/level progression tracking
- Community features (shared practice challenges, habit groups)

---

## User Journeys

### Journey 1: Lokki — The Busy Knowledge Worker (Primary User - Success Path)

**Persona:** Lokki, 28, knowledge worker in Abidjan. Manages a full work calendar, wants to maintain Japanese language practice, and tracks spending to understand financial patterns. Uses mobile as primary device. Struggles to find time for practice amid work commitments.

**Opening Scene:**
Lokki opens TooXTips on Wednesday evening. The Agenda strip shows tomorrow's schedule: 9am standup, 11am design review, 2pm client call, 5pm team sync. The Practice slide shows Japanese with a 5-day idle streak. The AI component sits at the bottom, ready.

**Rising Action:**
- At 8pm, a notification arrives: "You have 45 free minutes Thursday morning before your 11am. Japanese is idle. Block it?"
- Lokki taps the notification. The Practice module opens with a suggestion pre-filled.
- Lokki confirms: "30 minutes, 7am, before standup."
- The Agenda updates automatically. Thursday's strip now shows the new practice block.

**Climax:**
The next morning, Lokki sees the practice block in the persistent Agenda strip. Without opening a separate calendar app, without manual synthesis, the system had already connected the dots: free time + idle skill = actionable suggestion. Lokki practices Japanese for 30 minutes, logs the session, and the streak resets to 1.

**Resolution:**
By Friday, Lokki has logged three practice sessions without manually checking a calendar or habit tracker. The app has become the single source of truth for time + growth. The aha moment: "The AI actually understands my life."

**Journey Requirements:**
- Persistent Agenda strip that's always visible
- Proactive notification system that triggers at 8pm
- Free-slot detection algorithm
- Idle-skill detection
- Seamless Practice module integration
- Automatic Agenda event creation from Practice suggestions

---

### Journey 2: Lokki — The Spontaneous Practitioner (Primary User - Edge Case)

**Opening Scene:**
It's Tuesday evening. Lokki finishes work early and has unexpected free time. Opens TooXTips and manually logs a 45-minute Japanese practice session without creating a calendar event (unanchored).

**Rising Action:**
- Thursday evening, same thing happens: Lokki logs another 45-minute session around 7pm, again without a calendar event.
- At 8pm Friday, the AI surfaces a pattern: "You've practised Japanese twice around 7pm this week without scheduling it. Want to add a recurring block?"
- Lokki confirms. A recurring Thursday 7pm practice block is created in Agenda.

**Climax:**
The system learned from spontaneous behavior and formalized it. Lokki didn't have to manually create the recurring event — the AI observed the pattern and suggested the structure.

**Resolution:**
Going forward, Thursday 7pm is protected for practice. The bidirectional relationship between Practice and Agenda is now active: spontaneous sessions inform calendar structure.

**Journey Requirements:**
- Unanchored session detection and flagging
- Pattern recognition (same time, multiple sessions)
- Suggestion UI for creating recurring events
- Automatic Agenda event creation from AI suggestions

---

### Journey 3: Beta Tester — The Skeptical Collaborator (Secondary User)

**Opening Scene:**
A beta tester receives TooXTips from Lokki with a brief: "This is a personal AI productivity app. It connects your schedule and practice habits." Skeptical but curious, they install it.

**Rising Action:**
- First session: They add three skills (Guitar, Spanish, Running) and create a few calendar events.
- They see the persistent Agenda strip and understand the "always visible" anchor immediately.
- They tap the AI component and ask: "When should I practice this week?"
- The AI responds with a prioritized list of free slots, considering their schedule and idle skills.

**Climax:**
The beta tester experiences the core differentiator: the AI reads across modules and surfaces a connection they would have missed. They tap to add a practice block, and it's automatically created in Agenda. No context-switching. No manual synthesis.

**Resolution:**
The beta tester uses the app daily for two weeks. They report: "It's not just a calendar or a habit tracker. It actually understands how they're connected."

**Journey Requirements:**
- Intuitive onboarding (no friction for new users)
- AI chat interface that's accessible and responsive
- Cross-module context in AI responses
- Seamless event creation from AI suggestions
- Reliable offline functionality (no silent failures)

---

### Journey 4: Lokki — The Offline Commuter (Edge Case - Degradation)

**Opening Scene:**
Lokki is commuting to work on a Friday morning with no connectivity. Opens TooXTips to check the day's schedule and log a morning run.

**Rising Action:**
- The Agenda strip loads instantly (cached from last sync).
- Lokki logs a 30-minute running session.
- The AI component is unavailable (no connectivity), but the app doesn't break.
- Lokki can still see the schedule, add events, and log practice sessions.

**Climax:**
By afternoon, connectivity returns. The app syncs silently. The AI catches up and surfaces insights based on the full local dataset.

**Resolution:**
The app worked perfectly offline. The user never felt the absence of AI — it was an enhancement, not a dependency.

**Journey Requirements:**
- Complete offline functionality for Agenda + Practice
- Graceful AI degradation (no error states, no broken UI)
- Silent sync when connectivity returns
- No data loss during offline periods

---

## Journey Requirements Summary

Across all journeys, the following capabilities emerge as essential:

| Capability | Journeys | Priority |
|------------|----------|----------|
| Persistent Agenda strip | 1, 2, 3, 4 | Critical |
| Proactive notification system (8pm) | 1, 2 | Critical |
| Free-slot detection | 1, 3 | Critical |
| Idle-skill detection | 1, 3 | Critical |
| Unanchored session flagging | 2 | High |
| Pattern recognition (spontaneous sessions) | 2 | High |
| AI chat interface | 3 | High |
| Cross-module context aggregation | 1, 3 | Critical |
| Offline-first architecture | 4 | Critical |
| Graceful AI degradation | 4 | High |
| Automatic event creation from suggestions | 1, 2, 3 | High |
| Dark/light mode support | 3, 4 | Medium |

---

## Domain Requirements

### Personal Productivity Domain Constraints

**Time-sensitive reasoning:** The AI's value depends on surfacing insights at the right moment. A free-slot suggestion Wednesday evening is useful; the same suggestion Saturday morning is noise. This requires:
- Scheduled background tasks (8pm daily check-in)
- Temporal context in every AI interaction
- Notification delivery reliability

**Offline-first architecture:** Users in Abidjan may have intermittent connectivity. The app must function completely without AI:
- All data stored locally (SQLite)
- No external dependencies for core features
- Graceful degradation when AI is unavailable
- Silent sync when connectivity returns

**Locale and internationalization constraints:**
- Currency: XOF (West African CFA franc) — no decimal places
- Date format: DD/MM/YYYY (not MM/DD/YYYY)
- Timezone: UTC+0 (no daylight saving)
- Language: English for MVP; French support planned for v1.1
- Font support: Ensure system fonts render correctly for French accents

**Mobile-first design:**
- Primary device: mobile (Flutter)
- High-brightness outdoor readability (light mode must be carefully designed, not an afterthought)
- Sub-500ms perceived responsiveness (optimistic UI, skeleton loaders, local-first rendering)
- Minimal data usage (offline-first reduces API calls)

**Solo development constraints:**
- One person, full responsibility
- Feature scope must be ruthlessly prioritized
- Maintenance surface must be minimal
- Clear priority hierarchy (MVP, Growth, Vision)

---

## Innovation & Differentiation

### What Makes TooXTips Unique

**1. Cross-domain reasoning at the right moment**
Most productivity apps are reactive: you ask them a question, they answer. TooXTips is proactive: it observes your patterns and surfaces insights when they're actionable. "You have 45 free minutes Thursday. Japanese is idle. Block it?" — that's a complete product in one sentence.

**2. Bidirectional module relationships**
Agenda doesn't just inform Practice; Practice informs Agenda. When you log spontaneous practice sessions at similar times, the AI notices and suggests formalizing them into recurring blocks. The system learns from behavior.

**3. Offline-first with AI as enhancement**
The app works completely without connectivity. The AI is a read-only observer that surfaces insights when available. This inverts the typical dependency: instead of "AI is required," it's "AI is a bonus."

**4. Timely over smart**
The AI doesn't need to be perfect at answering questions. It needs to be perfect at knowing when to speak. A scheduled 8pm check-in that surfaces one relevant suggestion beats an always-on AI that answers questions perfectly but at the wrong moment.

**5. Minimal UI, maximum AI**
The interface is intentionally simple: persistent Agenda strip, two-slide carousel, persistent AI component. All complexity lives in the AI layer. This reduces maintenance surface and keeps the user's cognitive load low.

---

## Technical Architecture

### Core Technology Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Mobile Framework | Flutter (Dart) | Cross-platform, solo-friendly, fast iteration |
| State Management | Riverpod | Reactive, testable, minimal boilerplate |
| Local Storage | SQLite via Drift | Type-safe ORM, all data local, no backend required |
| AI Integration | Claude API (claude-sonnet-4-6) | Context-aware, handles ambiguity, cost-effective |
| Notifications | flutter_local_notifications | Agenda reminders + proactive AI suggestions |
| Background Tasks | workmanager | Scheduled 8pm proactive check-in |
| Internationalization | intl package | XOF currency, DD/MM/YYYY dates, future French support |

### Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart              # MaterialApp, theme, routing
│   └── theme.dart            # TooXTips ThemeData (dark + light)
├── features/
│   ├── agenda/
│   │   ├── data/             # SQLite models, DAO
│   │   ├── domain/           # entities, repository interfaces
│   │   └── presentation/     # AgendaStrip, CalendarModal, EventCard
│   ├── practice/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/     # PracticeSlide, SkillCard, SessionSheet
│   ├── ai/
│   │   ├── ai_service.dart   # Claude API calls, context builder
│   │   ├── ai_component.dart # persistent bottom bar widget
│   │   ├── proactive_service.dart # background check-in logic
│   │   └── notification_service.dart
│   └── expenses/             # Deferred to v1.1
└── shared/
    ├── widgets/              # reusable UI components
    ├── constants/            # colour tokens, spacing, typography
    └── utils/                # date helpers, currency formatting
```

### AI Context Model

At every interaction, the AI receives a structured context payload:

```yaml
agenda_today: [list of today's events with times and categories]
agenda_week: [full week view for free slot detection]
practice_skills: [all skills with streak, last session, history]
unanchored_sessions: [sessions without calendar events, last 7 days]
active_screen: [which slide is currently visible]
current_datetime: [timestamp for relative date parsing]
last_modified: [timestamp per module for stale-state detection]
```

### Proactive AI Service

A scheduled background check (8pm daily via workmanager):
1. Builds the AI context payload
2. Runs free-slot + idle-skill detection logic
3. Constructs one proactive suggestion
4. Triggers a local notification

This is the primary value delivery mechanism for the AI layer.

---

## Non-Functional Requirements

### Performance

- **Perceived responsiveness:** < 500ms for all core interactions (optimistic UI, skeleton loaders, local-first rendering)
- **Notification delivery:** 8pm check-in must execute reliably within ±5 minutes
- **API latency:** Claude API calls should complete within 3 seconds; graceful timeout if slower
- **Storage:** SQLite should handle 2+ years of typical user data (estimated 10,000+ events, 1,000+ practice sessions)

### Reliability

- **Offline functionality:** 100% of core features work without connectivity
- **Crash-free sessions:** 99%+ of sessions complete without crashes
- **Data persistence:** No data loss on app restart or device reboot
- **Graceful degradation:** AI unavailability doesn't break the app

### Security & Privacy

- **Local-first data:** All user data stored on-device via SQLite
- **No analytics:** No telemetry, no third-party SDKs in MVP
- **API security:** Claude context payload transmitted over HTTPS only
- **Data clearing:** Settings screen provides option to clear all local data

### Accessibility

- **Dark/light mode:** Both themes render correctly, light mode optimized for outdoor readability
- **Text contrast:** WCAG AA compliance for all text
- **Touch targets:** Minimum 44dp for interactive elements
- **Font support:** System fonts render correctly for French accents (future)

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

**Total estimated duration: 19–27 working days (solo, part-time)**

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Context payload exceeds token limits | Medium | High | Implement selective context strategy; defer to v1.1 if needed |
| Offline connectivity breaks AI | High | Medium | Design app to function fully without AI; graceful degradation |
| Voice commands fail on accents | High | Low | Defer to v1.1; test with Ivorian French speakers |
| Manual expense logging abandoned | High | Medium | Defer Expenses to v1.1; focus on Agenda + Practice |
| Notification fatigue | Medium | Medium | Limit to one suggestion per day; user can disable |
| Solo development timeline slips | Medium | High | Prioritize ruthlessly; defer features to v1.1 |

---

## Success Definition

**MVP is successful when:**

1. App launches, functions offline, and doesn't crash
2. Agenda + Practice modules work without AI
3. AI proactive notification triggers and surfaces relevant suggestions
4. One user (Lokki) uses it daily for 2+ weeks without abandoning it
5. The product is honest about its constraints (offline-first, no voice, no expenses)

**This is not about perfection. It's about shipping a focused product that solves one problem well: helping users find time to practice.**

---

**Document Status:** Complete - Ready for Implementation  
**Last Updated:** March 29, 2026  
**Version:** 1.0 MVP

