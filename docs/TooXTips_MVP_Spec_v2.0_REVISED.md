# TooXTips
## Personal AI Productivity Hub — Enterprise MVP Specification (Revised)
**Version 2.0 · March 2026 · Post-Brainstorming Refinement**

Platform: Flutter (Mobile) · AI-Orchestrated · Personal Use First

| Agenda | Practice |
|--------|----------|
| `#7C4DFF Violet` | `#1D9E75 Green` |

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Product Vision & Strategy](#2-product-vision--strategy)
3. [UX Architecture](#3-ux-architecture)
4. [Feature Specifications](#4-feature-specifications)
5. [AI Component — Revised](#5-ai-component--revised)
6. [Design System](#6-design-system)
7. [Technical Stack](#7-technical-stack)
8. [MVP Scope & Boundaries](#8-mvp-scope--boundaries)
9. [Development Roadmap](#9-development-roadmap)
10. [Post-MVP Opportunities](#10-post-mvp-opportunities)
11. [Appendix](#11-appendix)

---

## 1. Executive Summary

**REVISED SCOPE:** TooXTips is a personal AI-orchestrated productivity mobile application built with Flutter. The MVP unifies two core pillars of daily life — time (Agenda) and growth (Practice) — under a single coherent interface coordinated by an embedded AI assistant.

**Key Change from v1.0:** Expenses module deferred to v1.1. The core thesis — *AI that reasons across your life domains* — is fully demonstrated with Agenda + Practice alone, and shipping with two modules instead of three reduces complexity by ~40% while maintaining the product's core value.

### Core Value Proposition

- One app that knows your schedule and your skill development simultaneously
- An AI that proactively surfaces the intersection: *"You have 45 free minutes Thursday. Japanese is idle. Block it?"*
- Minimal UI surface with maximum functional depth — complexity lives in the AI layer
- Built personal-first: no onboarding friction, no generic defaults, no bloat
- **Fully functional offline** — AI is an enhancement layer, not a dependency

---

## 2. Product Vision & Strategy

### 2.1 Problem Statement

Most productivity systems require users to maintain and context-switch between 2–4 separate applications daily: a calendar, a habit or learning tracker, and often a note-taking tool. These tools do not communicate with each other, creating blind spots:

- Skill practice is abandoned when calendars fill up — no tool redistributes time automatically
- Habit consistency is invisible until streaks break — no tool surfaces risk before failure
- Spontaneous practice sessions are logged but never anchored to recurring time blocks — no tool learns from behaviour

### 2.2 Vision Statement

> **TooXTips acts as a personal chief of staff** — an AI that manages your time and personal growth as a single interconnected system, not two separate lists.

### 2.3 Strategic Pillars

| Pillar | Principle | MVP Expression |
|--------|-----------|----------------|
| Integration | The AI reads all modules simultaneously | AI chat has full context of agenda and practice at all times |
| Minimalism | UI complexity is zero; AI complexity is infinite | One primary action per screen; all edge cases delegated to AI |
| Personalism | Built for one user before scaling to many | No generic defaults — the app learns your habits and goals |
| Extensibility | MVP proves viability; architecture enables growth | Feature modules are independent and pluggable; AI layer is the glue |
| Offline-First | All data local; AI is enhancement not dependency | App functions fully without connectivity; AI surfaces insights when available |

---

## 3. UX Architecture

### 3.1 Global Layout Structure — REVISED

The app follows a **persistent anchor + carousel** architecture. The Agenda strip is always visible at the top, showing your next 2–3 events. Below it, a two-slide carousel contains Expenses (deferred to v1.1) and Practice.

| Layer | Description |
|-------|-------------|
| Top Bar (Static) | Theme toggle (left) · Live numeric clock (centre) · Settings icon (right) |
| Agenda Strip (Static) | Compact "today strip" showing next 2–3 upcoming events, scrollable, never disappears |
| Navigation Dots (Static) | Two dots representing Practice · (Expenses in v1.1) — active dot stretches into a pill and adopts the screen's accent colour |
| Carousel Content Area | Slides horizontally between Practice (and Expenses in v1.1) — independently scrollable if needed |
| AI Component (Static) | Always-visible at the bottom — text input (left) + microphone button (right) — expands upward into a command dropdown on tap |

### 3.2 Screen Hierarchy

```
Home Screen (carousel container)
├── Agenda Strip (persistent)
│   ├── Next 2–3 events (scrollable)
│   └── Tap to expand calendar view
├── Practice Slide
│   ├── Skill cards
│   ├── Streak bars
│   └── Add Skill button
├── (Expenses Slide — v1.1)
└── AI Component (persistent)
    ├── Text input bar → command dropdown / chat sheet
    └── Microphone FAB → voice command
```

### 3.3 Navigation Principles

- Swipe left/right on the content area to switch slides
- Tap a dot to jump to a specific slide
- Active dot pill colour matches the active screen accent (violet for Agenda context, green for Practice)
- The AI component accent dot also shifts colour to match the active screen
- Tap the Agenda strip to expand full calendar view (modal overlay)
- No back button needed — the carousel is always reachable from anywhere

### 3.4 Static vs Dynamic Elements

| Element Type | Components |
|--------------|------------|
| Always Static (never moves) | Top bar, live clock, theme toggle, navigation dots, Agenda strip, AI input bar, microphone button |
| Dynamic (changes per screen) | Slide content, FAB colour, accent dot colour, AI command suggestions |
| Expandable | AI command dropdown, calendar modal, event detail sheets, add-item bottom sheets |

---

## 4. Feature Specifications

---

### 4.1 Agenda Module — `#7C4DFF` (Persistent Strip)

The Agenda module is the anchor feature. It provides time awareness to the AI system, enabling it to reason about free slots and upcoming events.

#### Screen Layout

- **Agenda Strip (always visible)** — Compact display of next 2–3 upcoming events, scrollable horizontally
- **Calendar Modal (on-demand)** — Tap the strip to expand full monthly calendar view
- **Event Timeline (in modal)** — Time-blocked list with coloured left-bar per event category
- **FAB (in modal)** — Opens Add Event bottom sheet

#### Event Categories & Colours

| Category | Colour | Use Case |
|----------|--------|----------|
| Personal | `#7C4DFF` Violet | Morning routines, personal appointments, general tasks |
| Work | `#00C2D4` Cyan | Professional meetings, deadlines, calls |
| Practice | `#1D9E75` Green | Study sessions, skill practice blocks, workouts |

#### MVP Interactions

- **Add event:** title, date, time, duration, category — bottom sheet, no page navigation
- **Tap event:** expand inline to show notes, edit and delete actions
- **Day navigation:** tap any calendar day to filter timeline to that day
- **No recurring events in MVP** — add manually or via AI voice command

#### AI Integration Points

- AI can read all events and their times when answering schedule questions
- AI can suggest free slots for practice sessions based on agenda gaps
- AI voice command: *"Add a meeting tomorrow at 3pm called Design Review"*
- **AI proactively surfaces free slots:** Evening check-in (8pm) identifies gaps and idle skills

---

### 4.2 Practice Module — `#1D9E75`

The Practice module tracks skill progression and habit consistency. It is the most personalised module — users define their own skills and the AI tracks their engagement patterns over time.

#### Screen Layout

- Skill cards — one card per skill, showing name, streak badge, 7-day activity bar, last session info
- Add skill button — dashed card at bottom of list, opens name + goal bottom sheet
- No global FAB — actions live inside each skill card (tap to start session)

#### Skill Card Data

| Data Point | Details |
|------------|---------|
| Skill Name | User-defined — e.g. Japanese, Chess, Guitar, Running |
| Current Streak | Consecutive days with at least one logged session |
| 7-day Bar | Visual fill per day — green if session logged, dark if idle |
| Last Session | Duration + relative date — e.g. *"45 min · yesterday"* |
| Status Badge | Active streak (green) or idle warning (violet) — auto-computed |

#### Session Logging

- Tap a skill card to start a session timer or log a completed session manually
- Inputs: duration (minutes), optional note, timestamp
- Sessions are stored locally and surfaced to the AI context
- **Unanchored session flag:** If a session is logged without a corresponding calendar event, it's flagged as "unanchored"

#### AI Integration Points

- AI tracks idle skills and proactively suggests: *"You haven't practised Chess in 5 days — you have 45 free minutes Thursday evening"*
- AI suggests session duration based on available agenda time
- AI voice command: *"Log 30 minutes of Japanese"*
- **AI pattern detection:** After two unanchored sessions at similar times, AI suggests: *"You've practised Japanese twice around 7pm this week without it being scheduled. Want to add a recurring block?"*

---

## 5. AI Component — Revised

### 5.1 Architecture: Offline-First Enhancement Layer

**CRITICAL CHANGE FROM v1.0:** The AI is no longer a required dependency. The app functions fully without connectivity. The AI layer is a read-only observer that surfaces insights when available.

**Build order:** Implement all three modules (Agenda, Practice, and Expenses in v1.1) to work completely offline first. The AI component becomes an enhancement layer that reads local state and surfaces suggestions.

### 5.2 Component Anatomy

The AI Component is a persistent bottom bar that never scrolls away. It consists of two interactive zones:

- **Text input bar** — tapping expands a quick-command dropdown above it; typing opens a full chat interface
- **Microphone button** (violet FAB) — initiates voice command capture with visual waveform feedback (v1.1)

### 5.3 Quick Command Dropdown

Tapping the text input bar (without typing) expands a contextual command list above the AI bar. These commands are pre-built shortcuts for the most common AI actions:

- Add event to agenda
- Start a practice session
- Weekly summary

The dropdown is screen-context-aware — when on the Practice slide, "Start a practice session" appears first.

### 5.4 Chat Interface

Typing in the input bar transitions the dropdown into a full bottom sheet chat interface. The AI has access to the full state of all modules and responds conversationally. Chat history persists within a session.

### 5.5 Proactive AI Notifications — PRIMARY VALUE DELIVERY

**This is the most important change from v1.0.** The AI's primary value isn't in answering questions on demand — it's in surfacing insights at the moment they're actionable.

#### Proactive Notification System

A scheduled background check (every evening at 8pm) runs the following logic:

1. **Free Slot Detection:** Identify gaps in tomorrow's agenda (30+ minutes)
2. **Idle Skill Detection:** Find skills with no session in the last 3+ days
3. **Unanchored Pattern Detection:** Identify spontaneous practice sessions at similar times
4. **Overcommitment Check:** Calculate total practice time vs. available time for the week

**Output:** Surface *one* proactive suggestion via notification:

- *"You have 45 free minutes Thursday evening. Japanese is idle. Want to block a session?"*
- *"You've practised Japanese twice around 7pm this week without scheduling it. Want to make it recurring?"*
- *"You have 3 realistic practice windows this week. Which skills matter most?"*

**Rules:**
- Never more than one notification per day
- Lead with opportunity, not problem
- Overcommitment alert only once per planning horizon
- Never comment on data the AI didn't receive (offline periods)

### 5.6 Voice Commands — Deferred to v1.1

Voice commands are out of scope for MVP. Text input proves the concept. Voice introduces `speech_to_text` dependency, accent/language variability (relevant in Abidjan), microphone permissions, and feedback loop design complexity that can wait.

### 5.7 AI Context Model

At every interaction, the AI receives a structured context payload containing the current state of all modules:

| Context Key | Content |
|-------------|---------|
| `agenda_today` | List of today's events with times and categories |
| `agenda_week` | Full week view — used for free slot detection |
| `practice_skills` | All skills with streak, last session date, and session history |
| `unanchored_sessions` | Sessions logged without calendar events (last 7 days) |
| `active_screen` | Which slide is currently visible — used to prioritise command suggestions |
| `current_datetime` | Timestamp — enables relative date parsing ("tomorrow", "next Monday") |
| `last_modified` | Timestamp per module — AI uses this to detect stale state |

---

## 6. Design System

### 6.1 Design Philosophy

- **Minimal dark-first** — the UI recedes; content and AI surface foreground
- **One primary action per screen** — no decision paralysis, no submenus
- **Colour encodes meaning** — each module has a dedicated accent; never decorative
- **Static beats animated** — transitions are subtle; no loading spinners in core flows
- **The AI handles complexity** — the UI never needs to
- **Agenda is always visible** — time is the anchor for all other decisions

### 6.2 Colour Palette

| Role | Hex | Usage |
|------|-----|-------|
| Violet (Primary / Agenda) | `#7C4DFF` | Main accent, AI dot, active dot pill, FAB, primary CTA |
| Green (Practice) | `#1D9E75` | Practice screen accent, active streak bars, streak badge |
| Dark Background | `#0D0D0F` | App background — near-black, OLED optimised |
| Surface | `#1A1A1F` | Cards, input fields, elevated elements |
| Surface Violet tint | `#1A1A2E` | Agenda-tinted card backgrounds |
| Surface Green tint | `#041A10` | Practice-tinted card backgrounds |
| Muted Text | `#6B6B80` | Secondary labels, timestamps, hints |
| Primary Text | `#E8E8F0` | Main readable text on dark surfaces |
| Border Default | `#2a2a35` | Card borders, dividers |

### 6.3 Typography

| Role | Specification |
|------|---------------|
| App Font | System default — SF Pro on iOS, Roboto on Android |
| Clock Display | Tabular-nums, weight 500, 22pt |
| Screen Labels | 10–11pt, letter-spacing 0.08em, all-caps, muted colour |
| Card Titles | 13–14pt, weight 500, off-white `#E8E8F0` |
| Body / Values | 12–13pt, weight 400, off-white or muted |
| Metadata | 10–11pt, weight 400, muted `#6B6B80` |

### 6.4 Component Tokens

| Token | Value |
|-------|-------|
| Background (app) | `#0D0D0F` — near-black, OLED optimised |
| Surface (cards) | `#1A1A1F` — subtle lift from background |
| Border (default) | `0.5px solid #2a2a35` |
| Border radius (cards) | `12–14px` |
| Border radius (pills) | `20px` |
| Border radius (FAB) | `50%` — full circle |
| FAB size | `38–42dp` |
| Active dot | Stretches to `20px` wide pill, adopts screen accent colour |
| Inactive dot | `7px` circle, `#2a2a35` |
| Agenda strip height | `60–70dp` — compact but readable |

---

## 7. Technical Stack

### 7.1 Core Framework

| Layer | Technology |
|-------|------------|
| Mobile Framework | Flutter (Dart) — single codebase for iOS and Android |
| State Management | Riverpod — reactive, testable, minimal boilerplate |
| Local Storage | SQLite via Drift (type-safe ORM) — all data stored locally in MVP |
| AI Integration | Anthropic Claude API (`claude-sonnet-4-6`) — via HTTP, context built per request |
| Voice Input | Deferred to v1.1 |
| Notifications | `flutter_local_notifications` — agenda event reminders + proactive AI suggestions |
| Background Tasks | `workmanager` — scheduled proactive AI check-in (8pm daily) |

### 7.2 Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart              # MaterialApp, theme, routing
│   └── theme.dart            # TooXTips ThemeData (dark + light)
├── features/
│   ├── agenda/
│   │   ├── data/             # local DB models, DAO
│   │   ├── domain/           # entities, repository interfaces
│   │   └── presentation/     # AgendaStrip, CalendarModal, EventCard, AddEventSheet
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

### 7.3 AI Context Builder

Each AI request constructs a structured system prompt assembled in `ai_service.dart` from Riverpod providers watching each feature module. The payload includes agenda events, practice sessions, active screen, and current datetime. **Critical:** Include `last_modified` timestamps per module to enable stale-state detection.

### 7.4 Proactive AI Service

A separate service (`proactive_service.dart`) runs on a scheduled background check (8pm daily via `workmanager`). It:

1. Builds the AI context payload
2. Runs free-slot + idle-skill detection logic
3. Constructs one proactive suggestion
4. Triggers a local notification with the suggestion

This service is the primary value delivery mechanism for the AI layer.

### 7.5 Data & Privacy

- All user data (events, practice sessions) stored locally on-device via SQLite
- Only the AI context payload is transmitted externally — to the Claude API over HTTPS
- No analytics, no telemetry, no third-party SDKs in MVP
- Settings screen provides an option to clear all local data
- **Offline-first:** App functions fully without connectivity; AI features gracefully degrade

---

## 8. MVP Scope & Boundaries

### 8.1 In Scope for MVP

- Home screen with persistent Agenda strip + single carousel slide (Practice)
- Static top bar: live clock, theme toggle (dark/light), settings icon
- Agenda: compact strip showing next 2–3 events, expandable calendar modal, add/edit/delete events, 3 categories
- Practice: skill cards with streak and session history, add/remove skills, log sessions, unanchored session flagging
- AI Component: persistent bottom bar, quick-command dropdown, chat bottom sheet
- Claude API integration with cross-module context
- **Proactive AI notifications:** Scheduled 8pm check-in surfacing one actionable suggestion
- Dark mode (default) and light mode toggle
- Local data persistence (SQLite)
- Local notifications for agenda events + proactive AI suggestions
- Offline-first architecture — app fully functional without connectivity

### 8.2 Explicitly Out of Scope for MVP

- Expenses module (v1.1)
- Voice commands (v1.1)
- Cloud sync or multi-device support
- User accounts or authentication
- Recurring events
- Charts or graphs (text summaries via AI instead)
- Export or sharing features
- Home screen glanceable widget
- Apple Watch / Wear OS support
- Multi-user or collaboration features

### 8.3 Success Criteria

> MVP is considered **successful** when:
>
> 1. Agenda and Practice modules function independently with local data persistence
> 2. The AI can answer cross-module questions with accurate context
> 3. Proactive AI notifications surface actionable suggestions at the right time (8pm)
> 4. The persistent Agenda strip makes time-awareness constant
> 5. The app functions fully without connectivity
> 6. Dark and light themes render correctly across all screens
> 7. The app runs without crashes on both iOS and Android in debug mode

---

## 9. Development Roadmap

> Estimated for a solo developer working part-time. Phases are sequential.

| Phase | Focus | Deliverables | Est. Time |
|-------|-------|--------------|-----------|
| 1 | Foundation | Flutter setup, folder structure, theme system, colour tokens, static home screen shell with persistent Agenda strip and carousel | 3–4 days |
| 2 | Agenda | Calendar widget, day timeline, add/edit/delete events, SQLite schema, local notifications | 5–7 days |
| 3 | Practice | Skill cards, streak calculation, session logging, add/remove skills, SQLite integration, unanchored session flagging | 3–4 days |
| 4 | AI Layer | Claude API integration, context builder, chat bottom sheet, quick command dropdown | 3–4 days |
| 5 | Proactive AI | Background task scheduling, free-slot + idle-skill detection, proactive notification logic, 8pm check-in | 2–3 days |
| 6 | Polish | Animations, edge cases, error handling, empty states, settings screen, full dark/light QA, offline testing | 3–5 days |

**Total estimated duration: 19–27 working days (solo, part-time)**

---

## 10. Post-MVP Opportunities

Features intentionally excluded from MVP, ranked by expected impact:

### High Impact
- Expenses module — budget tracking, category breakdown, spending patterns
- Voice commands — natural language event/session creation
- Cloud sync — iCloud / Firebase for multi-device continuity
- Home screen widget — glanceable agenda + AI tip without opening the app

### Medium Impact
- Recurring events — weekly, daily, and custom recurrence rules
- AI-generated weekly review — auto-composed Sunday summary across all modules
- Smart scheduling — AI proposes practice blocks in agenda free slots automatically
- Skill difficulty / level progression — quality signals beyond session duration

### Exploratory
- Natural language event creation from any text — parse pasted meeting invites
- Multi-language AI — full interface and AI responses in French for Abidjan context
- Apple Watch / Wear OS companion — glanceable mode + voice commands on wrist
- Receipt scanning — automatic expense logging from photos

---

## 11. Appendix

### A. Key Terminology

| Term | Definition |
|------|------------|
| Agenda Strip | The persistent top section showing next 2–3 upcoming events |
| Carousel | The horizontal swipe navigation between Practice (and Expenses in v1.1) |
| Slide | One of the content panels: Practice or Expenses |
| AI Component | The persistent bottom bar containing the chat input and microphone button |
| Command Dropdown | The list of pre-built AI shortcuts that expands above the AI Component on tap |
| Accent Colour | The per-screen colour (violet / green) applied to active UI elements |
| Streak | Consecutive days on which at least one practice session was logged for a given skill |
| Context Payload | The structured data sent to Claude at each AI request, including all module states |
| FAB | Floating Action Button — the circular button for the primary action on each slide |
| Bottom Sheet | A panel that slides up from the bottom of the screen for add/edit flows |
| Unanchored Session | A practice session logged without a corresponding calendar event |
| Proactive Notification | An AI-generated suggestion surfaced at a scheduled time (8pm) based on free slots and idle skills |

### B. Colour Hex Quick Reference

| Role | Hex |
|------|-----|
| Violet (Primary / Agenda) | `#7C4DFF` |
| Green (Practice) | `#1D9E75` |
| Dark Background | `#0D0D0F` |
| Surface | `#1A1A1F` |
| Surface Violet tint | `#1A1A2E` |
| Surface Green tint | `#041A10` |
| Muted Text | `#6B6B80` |
| Primary Text | `#E8E8F0` |
| Border Default | `#2a2a35` |

### C. Flutter Package Recommendations

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management across all modules |
| `drift` | Type-safe SQLite ORM for local data |
| `go_router` | Declarative routing (bottom sheets, settings) |
| `flutter_local_notifications` | Agenda event reminders + proactive AI notifications |
| `workmanager` | Scheduled background tasks (8pm proactive check-in) |
| `http` | Claude API HTTP requests |
| `intl` | Date formatting and localisation (XOF, DD/MM/YYYY) |
| `table_calendar` | Calendar widget for Agenda modal |

### D. Locale & Internationalization

**Critical constraints for Abidjan context:**

- **Currency:** XOF (West African CFA franc) — no decimal places
- **Date format:** DD/MM/YYYY (not MM/DD/YYYY)
- **Language:** English for MVP; French support planned for v1.1
- **Timezone:** UTC+0 (no daylight saving)
- **Font support:** Ensure system fonts render correctly for French accents

---

*TooXTips MVP Specification v2.0 · Revised Post-Brainstorming · March 2026 · Personal Use Build*

