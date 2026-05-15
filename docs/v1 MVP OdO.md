# OdO — V1 MVP Specification Summary
*Personal AI Daily Companion — Mobile Application*

---

## Executive Statement

OdO is a personal AI companion built natively for the Ivorian context. It is not a productivity app. It is a daily ritual — a five-minute evening conversation with an AI that learns what matters to you across your time, your habits, and your life, and stays with you all day through timely, voice-first interactions.

The product holds two design tensions in perfect balance: **minimal in surface, deep in substance.** The UI is intentionally restrained. The AI is intentionally proactive. Together they create something that feels less like an app and more like a presence.

---

## Part 1 — Product Architecture

### The Three Time Horizons

OdO operates across three coordinated timescales. Understanding these is understanding the product.

**Moments** — Throughout the day, OdO delivers timely notifications. Five minutes before a meeting. A reminder that a practice session is starting. A proactive suggestion when the AI has detected something worth surfacing. These are voice-first on the watch, configurable on the phone, and always brief.

**The Evening Session** — At 8pm each day, OdO invites the user to a five-minute reflective conversation on the phone. This is the deep moment. Structured, predictable, never longer than five minutes, often shorter on quiet days. The session is where OdO learns what the user values.

**Cumulative Understanding** — Over weeks and months, OdO accumulates a model of what matters to the user. What they highlight in evening sessions, what they dismiss, what patterns emerge. This stays local, on the device, and grows in value with every passing day.

### The Two-Device Model

The phone is the brain. The watch is a surface. The phone owns all data, runs all logic, computes all suggestions, talks to the AI provider, and manages the local database. The watch displays what the phone tells it to display, captures voice and taps, and reports back. The watch never decides anything on its own.

When the phone is unreachable, the watch shows last-cached state and queues voice commands for later sync. No new intelligence is computed off-phone. This is acceptable for MVP because the use case it serves — "phone unavailable but watch alive" — is rare and survivable.

The Glance Screen is the shared design language across both devices. The same widget, scaled. Users learn one interaction model.

---

## Part 2 — Core Features

### Agenda Module

The anchor of the entire product. Provides temporal awareness to the AI system. Without the Agenda, OdO has nothing to reason about.

The Agenda persists as a strip always visible at the top of the home screen. It shows the next two upcoming events, truncated at twenty characters, with three states handled gracefully — events today, no more events today, nothing scheduled. A monthly calendar view is accessible within the Agenda slide itself.

Events have three categories — Personal, Work, Practice — each with a colored left-bar in the timeline view. The MVP supports create, read, update, delete. Recurring events are deferred to v1.5.

### Practice Module

Tracks skill progression and habit consistency. Users define their own skills — no preset categories, no goal templates, no XP system. The user types "Japanese" and the card exists.

Each skill card shows a name, a current streak badge, a seven-day activity bar, and the last session's duration and relative date. Sessions are logged with a duration and an optional note. The streak updates automatically.

The first launch presents a single bottom sheet asking "What's one skill you're working on?" — free text, no further setup. This single question is the difference between an app that feels empty on day one and an app that feels alive.

Unanchored sessions are flagged silently. After three sessions at similar times across at least two different calendar weeks, OdO asks once during the evening session whether to anchor the time as recurring. The user says yes or no and OdO never asks again for that skill.

### The Glance Screen

The most-used surface in the entire app. Sits before the home screen as an ambient lock screen with privileged glance information.

Top of screen shows a lock icon — locked in violet, unlocked in green — with a state label. Center holds the AI orb with two states: idle breathing animation, active waveform when listening. Below the orb sit minimal info cards — next event, OdO's latest suggestion, never sensitive data.

The bottom bar holds a quick-add button on the left, a text input center, and a microphone toggle on the right. Authentication happens via vocal password ("Hey OdO, unlock — and the user's chosen phrase") or typed password in the bottom input. Biometric is configurable in settings as a third option. Sliding up triggers the unlock flow.

The Glance Screen is also the watch face design language. Same orb. Same info structure. Smaller scale.

### The AI Layer — OdO Itself

OdO is the assistant, not just a feature. Always accessible through the persistent bottom bar on the home screen and the orb on the Glance Screen.

The AI has selective context — today's agenda plus the next 48 hours, all skills with streak data, the last seven days of unanchored sessions, the last three suggestions with their outcomes, the current datetime, and the active screen. The payload is hard-capped at four thousand characters. The full agenda week, full session history, and complete suggestion log stay on-device for the evening session's local reasoning.

The AI provider is swappable. An abstract interface allows Claude, Gemini, Groq, OpenAI, or an offline stub to be selected by changing one constant. API keys pass via build-time environment variables and never touch source control.

When offline, OdO degrades gracefully. The chat shows "Couldn't reach AI — tap to retry" without losing the user's message. The orb still breathes. The Agenda strip still updates. The product remains fully functional. Only the AI's conversational responses pause until connectivity returns.

### The Evening Session — OdO's Defining Surface

This is what OdO actually *is*. Everything else is infrastructure.

At 8pm each day, a notification invites the user to their evening review. Tapping it opens the session screen. The session has a five-minute ceiling and a flexible structure that collapses naturally on quiet days.

The session opens with a brief headline — *"Productive day. Two practice sessions, three events, on budget."* Then OdO presents three to four highlight items, ranked by relevance from the current data state. For each item the user can tag — significant, dismiss, or expand. Tagging is fast — one tap each. Voice responses are accepted but never required.

After the highlights, OdO surfaces one cross-domain insight if one exists — *"Third Japanese session at 7pm this week — want to anchor that time?"* — and the user responds with the same tag-or-speak pattern.

The session closes with a one-line summary of what was learned, and queues tomorrow's nudge. A "wrap up" button is always visible at the top — tapping it jumps directly to the close phase, completing the session in seconds when the user is tired or rushed.

Sessions persist until midnight if interrupted. After midnight, today's session is gone. The session is *today's reflection*, not a task to complete.

The user tags what matters. The system learns from those tags. Over weeks, OdO's understanding of what the user values becomes the product's deepest moat.

### Proactive Suggestions

Suggestions originate from OdO and emerge from the current data state — Agenda gaps, idle skills, unanchored patterns, schedule density. The suggestion engine runs on-device, fully offline.

Suggestions are not random and not noise. The selection algorithm ranks candidates by relevance — longest-idle skill first, then shortest fitting slot, then earliest available window. One suggestion at most per evening, never more. The "one AI voice per day" principle is non-negotiable.

Suggestions can also arrive throughout the day as timely notifications when the data shifts meaningfully — a meeting is canceled and a free slot opens, a streak is about to break, an unanchored pattern crosses the detection threshold. These arrive on the watch (or phone) as brief, voice-readable alerts the user can act on in seconds.

When a suggestion is acted on, the action commits immediately to both Agenda and Practice. When dismissed, the suggestion is suppressed — three days for a soft dismiss, seven days for an explicit thumbs-down, one day after acceptance to avoid immediate repetition.

---

## Part 3 — Voice Interaction Model

Voice is the primary input on the watch and an equal-priority input on the phone. Tap-to-speak is the MVP wake mechanism — the microphone button on the Glance Screen or the watch face initiates listening. Custom wake-word detection ("Hey OdO" as ambient phrase) is deferred to v2 alongside the watch release.

Voice commands commit in one shot when possible. *"Hey OdO, rendez-vous at 7pm tonight"* creates the event immediately. Follow-up questions only appear when the original command is genuinely ambiguous or incomplete. Optional enrichments are offered after the action is already saved — never blocking on them.

Voice output is configurable per surface. On the watch, voice is on by default — OdO reads notifications aloud. On the phone, the default is silent banners with voice toggleable in settings. The principle: OdO never speaks first on a device the user isn't wearing or holding.

User responses to voice notifications are voluntary. The user can speak back to confirm, dismiss, or extend — or they can simply ignore the notification and act later. The watch never demands a response.

---

## Part 4 — Customization & Themes

OdO ships with seven theme presets — Violet Dark (default), Cyan Dark, Green Dark, Light Mode, Cosmic, Ember, Aurora. Plus a custom color picker for users who want a fully personalized accent. Theme selection lives in settings post-unlock.

Dark mode is the hardcoded default at first launch. The toggle persists via local storage. Light mode is built to be genuinely usable in high-brightness outdoor conditions — common in Abidjan — not retrofitted later.

The orb adopts the active theme's accent. The active dot pill on the home carousel adopts the active screen's color. Cards inherit subtle tint from the active accent. The whole UI feels like one system, themed coherently end-to-end.

---

## Part 5 — Technical Architecture

The complete decision stack, locked:

| Layer | Choice |
|-------|--------|
| Framework | Flutter (Dart) — one codebase for iOS and Android |
| State management | Riverpod with code-gen syntax |
| Local database | SQLite via Drift ORM |
| Navigation | go_router with bottom sheets as routes |
| Background tasks | workmanager with fallback trigger on app open |
| Notifications | flutter_local_notifications |
| Connectivity | connectivity_plus for offline state detection |
| Theme | ThemeMode.dark hardcoded default, SharedPreferences toggle |
| AI abstraction | AiProvider interface, swappable implementations |
| API keys | --dart-define at build time, never in source |

All user data lives on-device. The only outbound traffic is the AI context payload to the active provider, over HTTPS, only when the user is online and explicitly interacts with the AI layer. No analytics, no telemetry, no third-party SDKs, no advertising identifiers, no behavioral tracking.

Locale-aware throughout — XOF currency with no decimal places, DD/MM/YYYY date format, UTC+0 timezone, French as the primary language with English support.

Folder structure follows feature-based separation with strict imports — domain layers import nothing, data layers import only domain, presentation layers import only domain entities and Riverpod providers. Tests live in a parallel `test/` tree mirroring `lib/`. A single `_providers.dart` file per feature holds all Riverpod definitions for that feature. A `CONVENTIONS.md` in the project root codifies every decision so they're never re-debated.

---

## Part 6 — What's In MVP, What's Not

**In MVP (V1):**

Glance Screen with lock and unlock states, theme presets and color picker. Home screen with persistent Agenda strip and one-slide carousel for Practice. Agenda module with calendar, event CRUD, three categories. Practice module with skill cards, session logging, streak computation, unanchored detection. First-launch skill prompt. AI Component as persistent bottom bar with chat sheet and quick commands. Evening Session screen with five-minute structured ritual. Proactive suggestion engine running on-device. Background task scheduler for the 8pm invitation. Voice input via tap-to-speak. Voice output on phone with configurable toggle. Offline-tolerant architecture across all features. Dark mode by default, light mode toggle, theme customization. Local notifications with five-minute pre-event reminders. Local SQLite persistence for all data. Locale-aware formatting for XOF, dates, and French.

**Deferred to V1.5:**

Expenses module. Recurring events. French AI responses (English-only AI in MVP, French UI throughout). Receipt scanning. Custom budget categories. Sunday weekly reflection notifications.

**Deferred to V2:**

Apple Watch and Wear OS companion apps. Wake-word detection for "Hey OdO". Cross-device handoff for proactive notifications.

**Deferred to V3:**

The Family plan. Shared awareness between household members. Per-event privacy controls. Backend infrastructure, user accounts, sync, conflict resolution.

**Deferred to V4:**

Enterprise / Organization plan. Multi-tenant architecture. Role-based permissions. Admin dashboards. Service-level integrations.

---

## Part 7 — Success Criteria

V1 is successful when, after three months of personal daily use:

The evening session is held at least twenty days out of every thirty.

The user can articulate, in one sentence, what OdO understands about them that no other app does.

A first-time user opens the app and reaches the first useful state — at least one skill, at least one event, one evening session completed — within five minutes of first launch with no instruction.

The app runs without a crash for two consecutive weeks of normal use.

A beta tester, given the app with no explanation, uses it for seven consecutive days without abandoning it.

The proactive suggestion acceptance rate trends upward week over week, indicating the learning loop is working.

When any of these fail, the failure points to a specific, fixable design or engineering problem — not to a fundamental product flaw.

---

## Part 8 — Three Things Worth Stating Explicitly

**OdO is not for everyone, and that's correct.** The product is designed for someone who wants a daily companion, not a tool. Users who want a calendar that does only calendaring will find OdO too involved. Users who want gamified habit streaks will find it too quiet. The product takes a position — it values reflection over engagement metrics, restraint over feature density, depth over breadth. The right user finds this freeing. The wrong user finds it odd. Designing for the right user is the only sustainable path.

**The evening session is the moat.** Most products optimize for daily active users, session count, screen time. OdO optimizes for cumulative understanding. The longer you use it, the more it knows you — and that knowledge stays local, on your device, with no copy anywhere else. Switching costs grow with every evening session. By month three, OdO is irreplaceable. By month twelve, it knows you better than most humans in your life. This isn't lock-in by trap. It's lock-in by genuine value compounded.

**Solo build is a feature, not a constraint.** OdO is being built by one person from Abidjan. That fact shapes every decision — feature scope, technology choices, architectural simplicity, conventions enforcement. A team of five would have built something different and probably worse. Solo means every decision is internally coherent, no committee compromises, no design-by-democracy. The product's restraint is the developer's restraint. The product's opinionation is the developer's opinionation. The product's soul is the developer's soul.

This is the rarest thing in software — a personal product that wasn't designed by a team trying to imagine a person.
