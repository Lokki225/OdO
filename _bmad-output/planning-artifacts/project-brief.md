# OdO — Project Brief

**Project Name:** OdO — Personal AI Daily Companion
**Version:** 1.0 (V1 MVP)
**Date:** May 13, 2026
**Status:** Ready for Implementation
**Owner:** Lokki (Solo Developer, Abidjan)

---

## Executive Summary

OdO is a personal AI companion built natively for the Ivorian context. It is **not a productivity app**. It is a daily ritual — a five-minute evening conversation with an AI that learns what matters to the user across their time, their habits, and their life, and stays with them throughout the day through timely, voice-first interactions.

The product holds two design tensions in perfect balance: **minimal in surface, deep in substance.** The UI is intentionally restrained. The AI is intentionally proactive. Together they create something that feels less like an app and more like a presence.

**Key Differentiator:** The evening session is the moat. Most products optimize for daily active users, session count, and screen time. OdO optimizes for cumulative understanding. The longer the user uses it, the more it knows them — and that knowledge stays local, on their device, with no copy anywhere else.

---

## Problem Statement

The modern personal-productivity landscape is saturated with tools that optimize for the wrong thing:

1. **Tools demand attention.** Calendars, habit trackers, journaling apps each ask the user to come to them, fill in fields, manage state. Each is a new surface to maintain.
2. **AI assistants are reactive.** They wait for the user to ask. They do not observe, reflect, or surface what matters.
3. **Personal data leaves the device.** Most "smart" companions are smart precisely because they ship user data elsewhere to be processed and retained.
4. **Local cultural context is ignored.** Apps designed for North American or European defaults — USD, MM/DD/YYYY, English-first, glossy aesthetics — feel imported, never native.

There is no daily companion that is genuinely **proactive, local-first, voice-first, and contextually Ivorian**. OdO is built to occupy that gap.

---

## Target User

**Primary (V1):** Lokki — the builder. A knowledge worker in Abidjan with a full work calendar, ongoing skill practice commitments (Japanese, others), intermittent connectivity, and a preference for restraint over feature density. The product is built for one person first, and that constraint is a feature, not a limitation.

**Secondary (V1 Beta):** A small circle of testers in Côte d'Ivoire and the West African francophone region who:
- Use mobile as their primary computing device
- Value reflection over engagement metrics
- Have predictable but evolving daily patterns (work, learning, social)
- Manage multiple life domains and want a single trusted surface

**Explicitly not the target user:**
- Anyone wanting a feature-dense productivity suite
- Anyone wanting gamified habit streaks with XP, badges, and competition
- Anyone wanting a chatty AI that initiates throughout the day
- Anyone wanting cloud sync, multi-device handoff, or shared awareness in V1

OdO is not for everyone, and that is correct.

---

## Core Value Proposition

**For the User:**
- A five-minute evening ritual that compounds over weeks into a model of what they value
- Timely, voice-first nudges throughout the day — never noisy, never demanding
- Total local privacy — data lives on the device, with the only outbound traffic being the AI context payload over HTTPS when the user explicitly interacts with the AI layer
- Native Ivorian formatting and language — XOF currency without decimals, DD/MM/YYYY dates, French UI by default, English support
- Fully functional offline — the AI is an enhancement, not a dependency

**For the Builder (Solo Development):**
- Locked scope and architecture make a 4–6 week solo build realistic
- A single, internally coherent product — no committee compromises
- Architectural restraint (one feature owner per module, strict imports, single `_providers.dart` per feature) makes the codebase maintainable by one person for years

**The Compounding Moat:**
The evening session builds cumulative understanding. By month three, OdO is irreplaceable. By month twelve, it knows the user better than most humans in their life. This is not lock-in by trap — it is lock-in by genuine value compounded, all of it local.

---

## V1 MVP Scope

### The Three Time Horizons

OdO operates across three coordinated timescales. Understanding these is understanding the product.

1. **Moments** — Throughout the day, OdO delivers timely notifications. Five minutes before a meeting. A practice reminder. A proactive suggestion when the AI has detected something worth surfacing. Voice-first on the watch (V2), configurable on the phone. Always brief.
2. **The Evening Session** — At 8pm each day, OdO invites the user to a five-minute reflective conversation. Structured, predictable, never longer than five minutes, often shorter on quiet days. This is where OdO learns what the user values.
3. **Cumulative Understanding** — Over weeks and months, OdO accumulates a model of what matters. What the user highlights in evening sessions, what they dismiss, what patterns emerge. Stays local. Grows in value with every passing day.

### Included in V1

**1. Glance Screen**
- Ambient lock screen with privileged glance information, sits before the home screen
- Lock icon (violet locked / green unlocked) with state label
- Centered AI orb — idle breathing animation, active waveform when listening
- Minimal info cards — next event, OdO's latest suggestion, never sensitive data
- Bottom bar: quick-add (left), text input (center), microphone toggle (right)
- Authentication: vocal password ("Hey OdO, unlock — [phrase]"), typed password, optional biometric
- Slide-up unlock gesture
- Doubles as the watch face design language (V2)

**2. Home Screen with Persistent Agenda Strip**
- Agenda strip always visible at top — next two events, truncated at 20 characters, three states (events today / no more today / nothing scheduled), tappable to expand into monthly calendar
- One-slide carousel (Practice) for V1 — Expenses placeholder deferred to V1.5
- Persistent AI bottom bar — text input + microphone toggle, always thumb-reachable

**3. Agenda Module**
- Event CRUD with three categories — Personal (violet), Work (blue), Practice (green) — each with a colored left-bar in the timeline
- Day timeline view with 30-minute grid
- Monthly calendar accessible within the Agenda slide
- Persistent Agenda strip (see above)
- Recurring events deferred to V1.5

**4. Practice Module**
- User-defined skills (free text, no preset categories, no goal templates, no XP)
- Skill card: name, current streak badge, 7-day activity bar, last session duration + relative date
- Session logging with duration + optional note
- Automatic streak computation
- First-launch bottom sheet: "What's one skill you're working on?" — single question, free text
- Unanchored session silent flagging
- Pattern detection: after 3 sessions at similar times across ≥2 calendar weeks, OdO asks once during the evening session about anchoring

**5. AI Layer — OdO Itself**
- Persistent bottom bar on home screen + the Glance Screen orb
- Selective context payload, hard-capped at 4,000 characters: today's agenda + next 48 hours, all skills with streak data, last 7 days of unanchored sessions, last 3 suggestions with outcomes, current datetime, active screen
- Swappable AI provider via `AiProvider` interface — Claude, Gemini, Groq, OpenAI, or offline stub selected by changing one constant
- API keys via `--dart-define` build-time environment variables, never in source control
- Offline graceful degradation: chat shows "Couldn't reach AI — tap to retry" without losing the user's message. Orb breathes. Agenda updates. Product remains fully functional.

**6. Evening Session**
- 8pm notification invites the user to the session
- Five-minute structured ritual on the phone
- Opens with a brief headline ("Productive day. Two practice sessions, three events, on budget.")
- 3–4 highlight items, ranked by relevance from current data state
- Tag-or-speak interaction per item: significant / dismiss / expand — one tap each
- One cross-domain insight if available ("Third Japanese session at 7pm this week — want to anchor that time?")
- One-line learning summary at close
- "Wrap up" button always visible at top — jumps to close phase
- Session persists until midnight if interrupted; after midnight, today's session is gone

**7. Proactive Suggestion Engine**
- On-device, fully offline
- Suggestions emerge from current data state: Agenda gaps, idle skills, unanchored patterns, schedule density
- Ranking algorithm: longest-idle skill first → shortest fitting slot → earliest available window
- One suggestion per evening, non-negotiable
- Throughout-day notifications when data shifts meaningfully (meeting canceled, streak at risk, pattern threshold crossed)
- Suppression: soft dismiss = 3 days, explicit thumbs-down = 7 days, after acceptance = 1 day

**8. Voice Interaction (Phone V1)**
- Tap-to-speak as MVP wake mechanism (microphone button on Glance Screen and persistent bar)
- Voice commands commit in one shot when possible ("Hey OdO, rendez-vous at 7pm tonight")
- Voice output toggleable in settings, silent banners default on phone
- Wake-word detection ("Hey OdO" ambient) deferred to V2 alongside watch release

**9. Themes & Customization**
- Seven presets: Violet Dark (default), Cyan Dark, Green Dark, Light Mode, Cosmic, Ember, Aurora
- Custom color picker for personalized accent
- Theme selection in settings, post-unlock
- Dark mode hardcoded default at first launch; Light mode built for high-brightness outdoor Abidjan conditions
- Orb + active dot pill + cards inherit active theme accent — one system, themed coherently

**10. Background Tasks & Notifications**
- 8pm session invitation via `workmanager` with fallback trigger on app open
- 5-minute pre-event reminders via `flutter_local_notifications`
- Best-effort delivery; product never implies guaranteed timing

**11. Locale-Aware Throughout**
- XOF currency with no decimal places
- DD/MM/YYYY date format
- UTC+0 timezone
- French primary UI, English support
- AI responses in English in V1 (French AI responses deferred to V1.5)

---

## Deferred (V1.5)

- Expenses module (manual logging, receipt scanning, custom budget categories)
- Recurring events
- French AI responses
- Sunday weekly reflection notifications

## Deferred (V2)

- Apple Watch and Wear OS companion apps
- Wake-word detection ("Hey OdO" ambient phrase)
- Cross-device handoff for proactive notifications

## Deferred (V3)

- Family plan, shared awareness, per-event privacy controls
- Backend infrastructure, user accounts, sync, conflict resolution

## Deferred (V4)

- Enterprise / Organization plan
- Multi-tenant architecture, RBAC, admin dashboards, service integrations

---

## Architecture Decisions (Locked)

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart) — one codebase for iOS and Android |
| State management | Riverpod with code-gen syntax |
| Local database | SQLite via Drift ORM |
| Navigation | go_router with bottom sheets as routes |
| Background tasks | workmanager with fallback trigger on app open |
| Notifications | flutter_local_notifications |
| Connectivity | connectivity_plus for offline state detection |
| Theme | ThemeMode.dark hardcoded default, SharedPreferences toggle |
| AI abstraction | AiProvider interface, swappable implementations |
| API keys | --dart-define at build time, never in source control |

Full architectural detail lives in `architecture.md`.

---

## Key Architectural Principles

1. **Local-first, always.** All user data lives on-device. The only outbound traffic is the AI context payload to the active provider, over HTTPS, only when the user is online and explicitly interacts with the AI layer. No analytics, no telemetry, no third-party SDKs, no advertising identifiers, no behavioral tracking.
2. **Offline-tolerant by default.** Every feature works without connectivity. The AI is an enhancement layer, not a dependency. Offline state is never an error state.
3. **One AI voice per day.** The proactive notification is the AI's primary channel. The chat is the user's channel. The AI never initiates inside the chat. The 8pm session is the only moment the AI speaks first by default.
4. **The phone is the brain. The watch (V2) is a surface.** The phone owns all data, runs all logic, computes all suggestions, talks to the AI provider, manages the local database. The watch displays, captures, reports back. Never decides on its own.
5. **Voice as equal-priority input.** Tap-to-speak in V1, ambient wake-word in V2. Voice output configurable per surface — never speaks first on a device the user isn't wearing or holding.
6. **Restraint over feature density.** The product takes a position. The right user finds this freeing. The wrong user finds it odd. Designing for the right user is the only sustainable path.

---

## User Flows

### Primary Flow: The Evening Session

```
1. 8pm notification: "Your evening with OdO is ready."
2. User taps → session opens with a headline summary
3. OdO presents 3–4 highlight items, one at a time
4. User tags each — significant / dismiss / expand — one tap
5. OdO surfaces one cross-domain insight if one exists
6. Session closes with a one-line summary of what was learned
7. Session is gone at midnight; tomorrow is tomorrow's
```

### Secondary Flow: Throughout-Day Proactive Suggestion

```
1. User's 3pm meeting is canceled (event deleted/moved)
2. SuggestionEngine detects free slot, idle skill
3. Notification: "45 minutes just opened up. Japanese is 5 days idle. Block it?"
4. User taps → confirmation sheet pre-filled
5. User confirms → event added to Agenda, session pre-queued in Practice
```

### Tertiary Flow: Unanchored Pattern Detection

```
1. User logs a Japanese session at 7:12pm — no calendar event
2. Session flagged silently as unanchored
3. After 3 sessions at similar times (within 90 min) across ≥2 calendar weeks
4. During next evening session, OdO asks once: "Third Japanese session at 7pm this week — want to anchor that time?"
5. User says yes/no via tag — OdO never asks again for that skill
```

### Quaternary Flow: Glance Screen Quick Capture

```
1. Phone wakes — Glance Screen renders, orb breathing
2. User taps microphone → orb shifts to waveform
3. "Hey OdO, rendez-vous at 7pm tonight"
4. Event committed immediately to Agenda
5. Banner confirmation, optional enrichment offered ("add a note?") — never blocking
```

---

## Success Criteria

V1 is successful when, after three months of personal daily use:

1. The evening session is held at least **20 days out of every 30**.
2. The user can articulate, in one sentence, what OdO understands about them that no other app does.
3. A first-time user opens the app and reaches first useful state — at least one skill, at least one event, one evening session completed — within **5 minutes** of first launch with no instruction.
4. The app runs **without a crash for two consecutive weeks** of normal use.
5. A beta tester, given the app with no explanation, uses it for **seven consecutive days** without abandoning it.
6. The **proactive suggestion acceptance rate trends upward** week over week — indicating the learning loop is working.

When any of these fail, the failure points to a specific, fixable design or engineering problem — not a fundamental product flaw.

---

## Constraints & Assumptions

### Load-Bearing Constraints
- **Solo development:** one person, full responsibility, scope ruthlessly prioritized
- **Flutter cross-platform:** one codebase, iOS + Android from day one
- **Local-first data:** no backend, no sync, no user accounts in V1
- **Locale correctness:** XOF, DD/MM/YYYY, UTC+0, French-primary
- **Intermittent connectivity:** Abidjan reality — graceful degradation essential

### Assumptions About User Behavior
- Users consistently engage with the 8pm session (the entire moat depends on this)
- Users tag highlights honestly — this is how OdO learns
- Users prefer voice for on-the-go capture and tap for reflective tagging
- Users have predictable but evolving daily patterns

### Technical Assumptions
- Claude (or whichever AI provider is active) remains performant on a 4,000-character payload
- SQLite via Drift handles 2+ years of personal data without performance degradation
- `workmanager` 8pm trigger fires on Android ~80% of the time, on iOS ~70% — fallback on app open covers the rest
- Mobile connectivity is intermittent but not permanent

---

## Implementation Roadmap

The full epic breakdown lives in `epics.md`. Six epics in execution order:

| Phase | Epic | Days | Description |
|---|---|---|---|
| 1 | Foundation | 1–4 | Project scaffold, design tokens, theme system, DB schema, AiProvider abstraction |
| 2 | Agenda Module | 5–9 | Persistent strip, calendar view, event CRUD, day timeline, categories |
| 3 | Practice Module | 10–13 | Skill cards, session logging, streak computation, unanchored flagging, pattern detection |
| 4 | AI Layer | 14–17 | Context builder, chat sheet, voice tap-to-speak, offline degradation |
| 5 | Glance + Evening + Proactive | 18–23 | Glance Screen, evening session ritual, SuggestionEngine, background tasks, confirmation sheet |
| 6 | Polish & Resilience | 24–28 | All seven themes, light mode QA, animations, empty/error states, accessibility, locale QA |

Target: **4–6 weeks** end-to-end for a solo build.

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Context payload exceeds 4k characters | Medium | High | Hard cap enforced in `AiService`; selective context strategy with priority order; truncation rules documented |
| `workmanager` 8pm task killed by OS | High | Medium | Fallback trigger on app open: if no session delivered in last 18h, surface inline. UI never implies guaranteed timing |
| Voice commands fail on Ivorian French accent | Medium | Medium | Phone V1 uses platform STT (Apple/Google) — already accent-tolerant. AI parsing handles intent ambiguity |
| Notification fatigue erodes trust | Medium | High | "One AI voice per day" is non-negotiable. Suppression algorithm enforces it |
| User abandons evening session after week 1 | Medium | High | Session ceiling of 5 minutes, "wrap up" always visible, no penalty for skipping. Quiet-day collapse keeps it short |
| Solo timeline slips | High | Medium | Ruthless deferrals to V1.5/V2 already documented. Foundation epic locks architecture so no mid-build re-debate |
| API key leaks via source control | Low | Critical | `--dart-define` at build time enforced; `.env.example` in repo, real `.env` in `.gitignore`; key audit before each commit |

---

## Three Things Worth Stating Explicitly

**OdO is not for everyone, and that's correct.** The product is designed for someone who wants a daily companion, not a tool. Users wanting only calendaring will find OdO too involved. Users wanting gamified streaks will find it too quiet. The product takes a position — reflection over engagement metrics, restraint over feature density, depth over breadth.

**The evening session is the moat.** Switching costs grow with every evening session. By month three, OdO is irreplaceable — not by trap, but by genuine value compounded. All of it local. None of it copyable.

**Solo build is a feature, not a constraint.** Every decision is internally coherent. No committee compromises, no design-by-democracy. The product's restraint is the developer's restraint. The product's soul is the developer's soul. This is the rarest thing in software — a personal product that wasn't designed by a team trying to imagine a person.

---

## Next Steps

1. **Review & validate** this brief against the V1 MVP specification
2. **Lock architecture** — confirm `architecture.md` against this brief
3. **Sequence epics** — confirm `epics.md` ordering against this brief
4. **Begin Epic 1: Foundation** — Day 1 work starts with `pubspec.yaml`, `app_colors.dart`, `app/theme.dart`, and the Drift schema

---

**Document Status:** Ready for Implementation
**Last Updated:** May 13, 2026
**Owner:** Lokki (Solo Developer, Abidjan)
