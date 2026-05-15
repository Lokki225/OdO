# TooXTips — Product Roadmap

**Vision:** A personal AI chief of staff — one app that connects your schedule, your long-term goals, and your spending, so the AI always has the context to give useful, specific guidance.

**Target user:** Franklin Ouattara (sole user, personal app)  
**Last updated:** 2026-04-28

---

## MVP — v1.0 (Current)

**Theme:** The core loop — Agenda + Wills + AI

### What's in scope
| Module | Status |
|---|---|
| Foundation (project setup, theme, DB, core services) | Not started |
| Agenda module (events, calendar, CRUD, categories) | Not started |
| Practice / Wills module (skills, sessions, streaks, pattern detection) | Not started |
| AI Layer (Claude API, context builder, chat UI, quick commands, offline degradation) | Not started |
| Proactive system (suggestion engine, background tasks, 8pm notification, confirmation UI) | Not started |
| Polish & resilience (light mode, animations, empty states, accessibility, performance) | Not started |

### Success criteria for v1.0
- Agenda and Wills work fully offline
- AI has cross-module context (agenda + wills + sessions)
- Proactive 8pm notification fires reliably
- Persistent agenda strip visible on all slides
- Dark and light themes work
- No crashes on normal usage flows
- `flutter analyze` clean, >= 90% test pass rate

### What's explicitly out of scope for v1.0
- Expenses module
- Voice input
- Cloud sync
- Recurring events
- Export / sharing
- Home screen widget
- Watch support
- Multi-user

---

## v1.1 — Post-MVP (Target: Q3 2026)

**Theme:** Expand the context — money and voice

| Feature | Priority | Estimated effort |
|---|---|---|
| Expenses module (manual logging, categories, budget alerts, AI analysis) | High | 5-7 days |
| Voice commands (voice-to-text for events / sessions / expenses) | High | 4-5 days |
| Weekly AI review (Sunday reflection, week summary, next week prep) | High | 2-3 days |
| Optional cloud sync (Firebase, bidirectional, conflict resolution) | Medium | 6-8 days |
| Smart scheduling (AI suggests when to work on a Will based on agenda gaps) | Medium | 3-4 days |
| Habit anchoring (link a Will session to a recurring time slot) | Medium | 4-5 days |
| Receipt scanning (photo to expense entry via Claude vision) | Lower | 5-7 days |
| Home screen widget (next event + AI tip) | Lower | 3-4 days |
| French language support | Lower | 4-5 days |
| Watch companion (quick session log from wrist) | Lower | 6-8 days |

---

## v1.2 and beyond (Exploratory)

- NLP natural language event / expense entry
- Skill progression system (levels, milestones for Wills)
- Advanced analytics (session frequency trends, spending patterns, goal velocity)
- Calendar integrations (Google Calendar import/export)
- Overcommitment alerts (AI warns when schedule + wills are unrealistic)

---

## Guiding principles for roadmap decisions

1. Does it serve Franklin's daily workflow? If not, it's a nice-to-have.
2. Offline first. No feature should break the app when there's no internet.
3. AI must have real context. Features are only useful if the AI can reference them.
4. Minimal surface area. Fewer, better features over a long list of half-finished ones.
