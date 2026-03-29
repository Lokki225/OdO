# TooXTips
## Personal AI Productivity Hub — Enterprise MVP Specification
**Version 1.0 · March 2026**
Platform: Flutter (Mobile) · AI-Orchestrated · Personal Use First

| Agenda | Expenses | Practice |
|--------|----------|----------|
| `#7C4DFF Violet` | `#00C2D4 Cyan` | `#1D9E75 Green` |

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Product Vision & Strategy](#2-product-vision--strategy)
3. [UX Architecture](#3-ux-architecture)
4. [Feature Specifications](#4-feature-specifications)
5. [AI Component](#5-ai-component)
6. [Design System](#6-design-system)
7. [Technical Stack](#7-technical-stack)
8. [MVP Scope & Boundaries](#8-mvp-scope--boundaries)
9. [Development Roadmap](#9-development-roadmap)
10. [Post-MVP Opportunities](#10-post-mvp-opportunities)
11. [Appendix](#11-appendix)

---

## 1. Executive Summary

TooXTips is a personal AI-orchestrated productivity mobile application built with Flutter. It unifies three core pillars of daily life — time (Agenda), money (Expenses), and growth (Practice) — under a single coherent interface coordinated by an embedded AI assistant.

Unlike conventional all-in-one apps that aggregate disconnected features, TooXTips treats the AI layer as its central nervous system. The three feature modules are instruments the AI reads from and acts upon, surfacing contextual insights, cross-domain correlations, and proactive suggestions via an always-accessible chat and voice interface.

### Core Value Proposition

- One app that knows your schedule, your budget, and your skills — simultaneously
- An AI that reasons across all three domains without manual context-switching
- Minimal UI surface with maximum functional depth — complexity lives in the AI layer
- Built personal-first: no onboarding friction, no generic defaults, no bloat

---

## 2. Product Vision & Strategy

### 2.1 Problem Statement

Most productivity systems require users to maintain and context-switch between 3–5 separate applications daily: a calendar, a budget tracker, a habit or learning tracker, and often a note-taking tool. These tools do not communicate with each other, creating blind spots:

- Overspending occurs on weeks of high scheduling pressure — no tool connects both
- Skill practice is abandoned when calendars fill up — no tool redistributes time automatically
- Budget behaviour correlates with emotional and energy states that only a unified AI can observe across domains

### 2.2 Vision Statement

> **TooXTips acts as a personal chief of staff** — an AI that manages your time, money, and personal growth as a single interconnected system, not three separate lists.

### 2.3 Strategic Pillars

| Pillar | Principle | MVP Expression |
|--------|-----------|----------------|
| Integration | The AI reads all three modules simultaneously | AI chat has full context of agenda, expenses, and practice at all times |
| Minimalism | UI complexity is zero; AI complexity is infinite | One primary action per screen; all edge cases delegated to AI |
| Personalism | Built for one user before scaling to many | No generic defaults — the app learns your habits, currency, and goals |
| Extensibility | MVP proves viability; architecture enables growth | Feature modules are independent and pluggable; AI layer is the glue |

---

## 3. UX Architecture

### 3.1 Global Layout Structure

The app follows a carousel-based single-screen architecture. There is one Home Screen that contains all content, and users navigate between the three feature modules by swiping horizontally or tapping the navigation dots. No traditional bottom navigation bar is used — dots replace it for a cleaner, more minimal feel.

| Layer | Description |
|-------|-------------|
| Top Bar (Static) | Theme toggle (left) · Live numeric clock (centre) · Settings icon (right) |
| Navigation Dots (Static) | Three dots representing Agenda · Expenses · Practice — active dot stretches into a pill and adopts the screen's accent colour |
| Carousel Content Area | Slides horizontally between the three feature screens — each is independently scrollable if needed |
| AI Component (Static) | Always-visible at the bottom — text input (left) + microphone button (right) — expands upward into a command dropdown on tap |

### 3.2 Screen Hierarchy

```
Home Screen (carousel container)
├── Agenda Slide
│   ├── Monthly calendar (Agenda only)
│   ├── Event timeline
│   └── Add Event FAB
├── Expenses Slide
│   ├── Budget summary card
│   ├── Category breakdown
│   └── Log Expense FAB
├── Practice Slide
│   ├── Skill cards
│   ├── Streak bars
│   └── Add Skill button
└── AI Component (persistent)
    ├── Text input bar → command dropdown / chat sheet
    └── Microphone FAB → voice command
```

### 3.3 Navigation Principles

- Swipe left/right on the content area to switch slides
- Tap a dot to jump to a specific slide
- Active dot pill colour matches the active screen accent (violet → cyan → green)
- The AI component accent dot also shifts colour to match the active screen
- No back button needed — the carousel is always reachable from anywhere

### 3.4 Static vs Dynamic Elements

| Element Type | Components |
|--------------|------------|
| Always Static (never moves) | Top bar, live clock, theme toggle, navigation dots, AI input bar, microphone button |
| Dynamic (changes per screen) | Slide content, FAB colour, accent dot colour, AI command suggestions |
| Expandable | AI command dropdown, event detail sheets, add-item bottom sheets |

---

## 4. Feature Specifications

---

### 4.1 Agenda Module — `#7C4DFF`

The Agenda module is the anchor feature. It provides time awareness to the AI system, enabling it to reason about free slots, upcoming events, and scheduling conflicts across the other modules.

#### Screen Layout

- Monthly calendar view — compact, displayed at top of Agenda slide **only**
- Day strip — seven-day horizontal scroll with today highlighted (violet pill)
- Event timeline — time-blocked list with coloured left-bar per event category
- FAB (bottom right) — opens Add Event bottom sheet

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
- No recurring events in MVP — add manually or via AI voice command

#### AI Integration Points

- AI can read all events and their times when answering schedule questions
- AI can suggest free slots for practice sessions based on agenda gaps
- AI voice command: *"Add a meeting tomorrow at 3pm called Design Review"*

---

### 4.2 Expenses Module — `#00C2D4`

The Expenses module provides financial awareness. It enables the AI to correlate spending behaviour with scheduling and practice consistency, identifying patterns the user would never see manually.

#### Screen Layout

- Budget summary card — total spent, progress bar, percentage of monthly budget
- Category breakdown — colour-dotted list of spend categories with amounts
- FAB (bottom right) — opens Log Expense bottom sheet

#### MVP Data Fields

| Field | Details |
|-------|---------|
| Amount | Numeric input with local currency (XOF default, configurable in settings) |
| Category | Food · Transport · Shopping · Health · Entertainment · Other |
| Date | Defaults to today, manually adjustable |
| Note | Optional free-text annotation |
| Monthly Budget | Set once in settings, displayed as the progress bar ceiling |

#### AI Integration Points

- AI can query total spent, remaining budget, and per-category breakdown
- AI proactively flags overspending: *"You've used 68% of your budget by week 2"*
- AI correlates with agenda: *"Your busiest work weeks tend to be your highest spend weeks"*
- AI voice command: *"Log 3,500 XOF for food today"*

---

### 4.3 Practice Module — `#1D9E75`

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

#### AI Integration Points

- AI tracks idle skills and prompts: *"You haven't practised Chess in 5 days — free slot at 5pm today"*
- AI suggests session duration based on available agenda time
- AI voice command: *"Log 30 minutes of Japanese"*
- AI can suggest adding a new skill based on conversation context

---

## 5. AI Component

### 5.1 Component Anatomy

The AI Component is a persistent bottom bar that never scrolls away. It consists of two interactive zones:

- **Text input bar** — tapping expands a quick-command dropdown above it; typing opens a full chat interface
- **Microphone button** (violet FAB) — initiates voice command capture with visual waveform feedback

### 5.2 Quick Command Dropdown

Tapping the text input bar (without typing) expands a contextual command list above the AI bar. These commands are pre-built shortcuts for the most common AI actions, reducing typing friction:

- Add event to agenda
- Log an expense
- Start a practice session
- Weekly summary

The dropdown is screen-context-aware — when on the Expenses slide, "Log an expense" appears first.

### 5.3 Chat Interface

Typing in the input bar transitions the dropdown into a full bottom sheet chat interface. The AI has access to the full state of all three modules and responds conversationally. Chat history persists within a session.

### 5.4 Voice Commands

The microphone button triggers on-device or API-based speech recognition. The captured transcript is passed directly to the AI as a text prompt. The AI interprets intent and executes the appropriate action.

**Example voice commands:**
```
"Add a dentist appointment on Friday at 10am"
"Log 2,000 XOF for transport today"
"How much have I spent on food this month?"
"When is my next free afternoon this week?"
"Start a 30-minute Japanese session"
```

### 5.5 AI Context Model

At every interaction, the AI receives a structured context payload containing the current state of all three modules:

| Context Key | Content |
|-------------|---------|
| `agenda_today` | List of today's events with times and categories |
| `agenda_week` | Full week view — used for free slot detection |
| `expenses_month` | Total spent, budget ceiling, per-category breakdown |
| `practice_skills` | All skills with streak, last session date, and session history |
| `active_screen` | Which slide is currently visible — used to prioritise command suggestions |
| `current_datetime` | Timestamp — enables relative date parsing ("tomorrow", "next Monday") |

---

## 6. Design System

### 6.1 Design Philosophy

- **Minimal dark-first** — the UI recedes; content and AI surface foreground
- **One primary action per screen** — no decision paralysis, no submenus
- **Colour encodes meaning** — each module has a dedicated accent; never decorative
- **Static beats animated** — transitions are subtle; no loading spinners in core flows
- **The AI handles complexity** — the UI never needs to

### 6.2 Colour Palette

| Role | Hex | Usage |
|------|-----|-------|
| Violet (Primary / Agenda) | `#7C4DFF` | Main accent, AI dot, active dot pill, FAB, primary CTA |
| Cyan (Expenses) | `#00C2D4` | Expenses screen accent, work event bars, budget progress bar |
| Green (Practice) | `#1D9E75` | Practice screen accent, active streak bars, streak badge |
| Dark Background | `#0D0D0F` | App background — near-black, OLED optimised |
| Surface | `#1A1A1F` | Cards, input fields, elevated elements |
| Surface Violet | `#1A1A2E` | Agenda-tinted card backgrounds |
| Surface Cyan | `#001A1F` | Expenses-tinted card backgrounds |
| Surface Green | `#041A10` | Practice-tinted card backgrounds |
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

### 6.5 Screen-Specific Accent Usage

| Screen | Accent | Applied To |
|--------|--------|------------|
| Agenda | `#7C4DFF` Violet | Active dot, event bar (personal), FAB, calendar today pill, screen label |
| Expenses | `#00C2D4` Cyan | Active dot, budget bar fill, event bar (work), FAB ring, screen label |
| Practice | `#1D9E75` Green | Active dot, streak bars, FAB ring, screen label, streak badge |

---

## 7. Technical Stack

### 7.1 Core Framework

| Layer | Technology |
|-------|------------|
| Mobile Framework | Flutter (Dart) — single codebase for iOS and Android |
| State Management | Riverpod — reactive, testable, minimal boilerplate |
| Local Storage | SQLite via Drift (type-safe ORM) — all data stored locally in MVP |
| AI Integration | Anthropic Claude API (`claude-sonnet-4-6`) — via HTTP, context built per request |
| Voice Input | `speech_to_text` Flutter package — on-device speech recognition |
| Notifications | `flutter_local_notifications` — agenda event reminders |

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
│   │   └── presentation/     # AgendaSlide, EventCard, AddEventSheet
│   ├── expenses/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/     # ExpensesSlide, BudgetCard, LogExpenseSheet
│   ├── practice/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/     # PracticeSlide, SkillCard, SessionSheet
│   └── ai/
│       ├── ai_service.dart   # Claude API calls, context builder
│       ├── ai_component.dart # persistent bottom bar widget
│       └── voice_service.dart
└── shared/
    ├── widgets/              # reusable UI components
    ├── constants/            # colour tokens, spacing, typography
    └── utils/                # date helpers, currency formatting
```

### 7.3 AI Context Builder

Each AI request constructs a structured system prompt assembled in `ai_service.dart` from Riverpod providers watching each feature module. The payload includes agenda events, expense totals, practice sessions, active screen, and current datetime.

### 7.4 Data & Privacy

- All user data (events, expenses, sessions) stored locally on-device via SQLite
- Only the AI context payload is transmitted externally — to the Claude API over HTTPS
- No analytics, no telemetry, no third-party SDKs in MVP
- Settings screen provides an option to clear all local data

---

## 8. MVP Scope & Boundaries

### 8.1 In Scope for MVP

- Home screen with carousel navigation (Agenda · Expenses · Practice)
- Static top bar: live clock, theme toggle (dark/light), settings icon
- Agenda: monthly calendar, day timeline, add/edit/delete events, 3 categories
- Expenses: monthly budget card, category breakdown, log expense, budget ceiling setting
- Practice: skill cards with streak and session history, add/remove skills, log sessions
- AI Component: persistent bottom bar, quick-command dropdown, chat bottom sheet, voice input
- Claude API integration with full cross-module context
- Dark mode (default) and light mode toggle
- Local data persistence (SQLite)
- Local notifications for agenda events

### 8.2 Explicitly Out of Scope for MVP

- Cloud sync or multi-device support
- User accounts or authentication
- Recurring events
- Budget categories customisation (fixed list in MVP)
- Charts or graphs (text summaries via AI instead)
- Export or sharing features
- Home screen glanceable widget
- Apple Watch / Wear OS support
- Multi-user or collaboration features

### 8.3 Success Criteria

> MVP is considered **successful** when:
>
> 1. All three feature modules function independently with local data persistence
> 2. The AI can answer cross-module questions with accurate context
> 3. Voice commands successfully add events, log expenses, and log practice sessions
> 4. The carousel UX feels fluid and intuitive with no navigational confusion
> 5. Dark and light themes render correctly across all screens
> 6. The app runs without crashes on both iOS and Android in debug mode

---

## 9. Development Roadmap

> Estimated for a solo developer working part-time. Phases are sequential.

| Phase | Focus | Deliverables | Est. Time |
|-------|-------|--------------|-----------|
| 1 | Foundation | Flutter setup, folder structure, theme system, colour tokens, static home screen shell with carousel and dots | 3–4 days |
| 2 | Agenda | Calendar widget, day timeline, add/edit/delete events, SQLite schema, local notifications | 5–7 days |
| 3 | Expenses | Budget card, category list, log expense sheet, monthly budget setting, SQLite integration | 3–4 days |
| 4 | Practice | Skill cards, streak calculation, session logging, add/remove skills, SQLite integration | 3–4 days |
| 5 | AI Layer | Claude API integration, context builder, chat bottom sheet, quick command dropdown, accent dot sync | 4–5 days |
| 6 | Voice | `speech_to_text` integration, microphone button, visual feedback, transcript → AI pipeline | 2–3 days |
| 7 | Polish | Animations, edge cases, error handling, empty states, settings screen, full dark/light QA | 3–5 days |

**Total estimated duration: 23–32 working days (solo, part-time)**

---

## 10. Post-MVP Opportunities

Features intentionally excluded from MVP, ranked by expected impact:

### High Impact
- Cloud sync — iCloud / Firebase for multi-device continuity
- Home screen widget — glanceable agenda + AI tip without opening the app
- Recurring events — weekly, daily, and custom recurrence rules
- Expense charts — monthly trend visualisations (bar / donut charts)

### Medium Impact
- AI-generated weekly review — auto-composed Sunday summary across all three modules
- Smart scheduling — AI proposes practice blocks in agenda free slots automatically
- Budget categories customisation — user-defined categories beyond the fixed MVP list
- Skill difficulty / level progression — XP system for the practice module

### Exploratory
- Natural language event creation from any text — parse pasted meeting invites
- Multi-language AI — full interface and AI responses in French for Abidjan context
- Apple Watch / Wear OS companion — glanceable mode + voice commands on wrist
- Multi-user mode — shared agenda between two people (e.g. couple or co-founder)

---

## 11. Appendix

### A. Key Terminology

| Term | Definition |
|------|------------|
| Carousel | The horizontal swipe navigation between the three feature slides on the Home Screen |
| Slide | One of the three content panels: Agenda, Expenses, or Practice |
| AI Component | The persistent bottom bar containing the chat input and microphone button |
| Command Dropdown | The list of pre-built AI shortcuts that expands above the AI Component on tap |
| Accent Colour | The per-screen colour (violet / cyan / green) applied to active UI elements |
| Streak | Consecutive days on which at least one practice session was logged for a given skill |
| Context Payload | The structured data sent to Claude at each AI request, including all module states |
| FAB | Floating Action Button — the circular button for the primary action on each slide |
| Bottom Sheet | A panel that slides up from the bottom of the screen for add/edit flows |

### B. Colour Hex Quick Reference

| Role | Hex |
|------|-----|
| Violet (Primary / Agenda) | `#7C4DFF` |
| Cyan (Expenses) | `#00C2D4` |
| Green (Practice) | `#1D9E75` |
| Dark Background | `#0D0D0F` |
| Surface | `#1A1A1F` |
| Surface Violet tint | `#1A1A2E` |
| Surface Cyan tint | `#001A1F` |
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
| `speech_to_text` | On-device voice recognition for AI commands |
| `flutter_local_notifications` | Agenda event reminders |
| `http` | Claude API HTTP requests |
| `intl` | Date formatting and localisation |
| `table_calendar` | Calendar widget for Agenda slide |

---

*TooXTips MVP Specification v1.0 · Confidential · Personal Use Build · March 2026*
