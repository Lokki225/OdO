---
stepsCompleted: [1, 2]
inputDocuments: ["TooXTips_MVP_Spec_v1.0.md"]
session_topic: "Solidifying TooXTips MVP — validating architecture, identifying gaps, and surfacing opportunities"
session_goals: "Validate integration strategy, identify UX friction, explore edge cases, refine AI context model, ensure MVP scope is complete"
selected_approach: "ai-recommended"
techniques_used: ["Assumption Reversal", "Constraint Mapping", "Ecosystem Thinking"]
context_file: ""
---

# TooXTips MVP Brainstorming Session

**Date:** March 29, 2026  
**Facilitator:** Cascade AI  
**User:** Lokki  
**Project:** TooXTips — Personal AI Productivity Hub

## Session Overview

**Topic:** Solidifying TooXTips MVP — validating architecture, identifying gaps, and surfacing opportunities

**Goals:**
- Validate the three-module integration strategy
- Identify potential UX friction points or missing interactions
- Explore edge cases the spec might not have covered
- Refine the AI context model and voice command patterns
- Ensure the MVP scope is truly minimal but complete

## Technique Selection

**Approach:** AI-Recommended Techniques

**Recommended Techniques:**
1. **Assumption Reversal** — Challenge core assumptions to rebuild from new foundations
2. **Constraint Mapping** — Identify and visualize all constraints to find promising pathways
3. **Ecosystem Thinking** — Analyze the three-module system as an interconnected ecosystem

---

## Phase 1: Foundation Setting — Assumption Reversal

**Duration:** ~15 minutes | **Energy Level:** Medium

### How This Works

Assumption Reversal challenges the core beliefs embedded in your spec. We'll identify what you're assuming to be true, flip each assumption, and explore what breaks — and what might actually improve.

**Your Role:** Answer questions about what you're assuming, then explore what happens when we flip those assumptions.

---

### Let's Begin: Core Assumptions in TooXTips

I'm going to surface the key assumptions I see in your spec, then we'll flip each one:

**Assumption 1: The AI should have full context of all three modules at all times**
- *Current belief:* The AI's power comes from seeing Agenda + Expenses + Practice simultaneously
- *Flip:* What if the AI only had access to one module at a time? What if it had to ask permission to access data?
- **Questions for you:**
  - How much of the AI's value actually depends on cross-module context vs. single-module intelligence?
  - Are there scenarios where less context would actually be better (e.g., privacy, performance, focus)?
  - What if users could toggle which modules the AI can see?

**Assumption 2: The carousel navigation is the right UX pattern**
- *Current belief:* Horizontal swiping between three slides is intuitive and minimal
- *Flip:* What if there were no carousel? What if each module had its own dedicated screen with a tab bar?
- **Questions for you:**
  - How often do users actually need to context-switch between modules in a single session?
  - Does the carousel force artificial unity, or does it genuinely reflect how users think about their day?
  - What if the "home" was actually the AI chat, and modules were accessed from there?

**Assumption 3: All three modules are equally important in MVP**
- *Current belief:* Agenda, Expenses, and Practice are co-equal pillars
- *Flip:* What if one module is actually the anchor and the others are secondary?
- **Questions for you:**
  - Which module would you cut first if you had to reduce scope?
  - Which module generates the most AI value?
  - Is there a natural hierarchy, or are they truly equal?

**Assumption 4: Voice commands should be conversational and free-form**
- *Current belief:* Users can say anything and the AI interprets intent
- *Flip:* What if voice commands were structured and templated instead?
- **Questions for you:**
  - How much complexity does free-form voice add vs. structured templates?
  - Would users actually prefer saying "Add event: Design Review, tomorrow, 3pm" vs. natural language?
  - Where does free-form voice break down?

**Assumption 5: Local-only data storage is non-negotiable for MVP**
- *Current belief:* All data stays on-device; only AI context leaves the phone
- *Flip:* What if you synced to a backend? What if you used cloud storage?
- **Questions for you:**
  - How much of your MVP complexity comes from local-only constraints?
  - Would cloud sync unlock features that are currently impossible?
  - Is local-only a feature or a limitation?

---

### Your Turn

**Pick one or more of these assumptions and tell me:**

1. **Which assumption surprises you most when flipped?**
2. **Which flip reveals a real gap in your thinking?**
3. **Are there other core assumptions I missed?**

Share your thoughts, and we'll dig deeper into the ones that matter most.

## Phase 1 Results: Critical Insights from Assumption Reversal

### Flip #3 — Equal Module Importance (Surprise)

**The Insight:** Agenda is already the anchor — it's the only module that gives the AI temporal reasoning. Without knowing *when* things happen, the AI can't suggest practice slots or correlate spending with busy weeks.

**The Contradiction:** The spec states "Agenda is the anchor feature" once, then gives all three modules equal screen real estate, equal FAB treatment, and equal roadmap time.

**The Product Question:** Should Agenda be always-visible rather than a slide? A persistent mini-timeline instead of the clock would make time-awareness constant.

---

### Flip #1 — AI Full Context (Real Gap)

**Three Failure Modes Not Modeled:**

1. **Latency** — If the AI needs 2–3 seconds to respond to "what's my next free slot," that's broken on mobile. No loading state strategy, no optimistic UI, no cached-response layer.

2. **Offline** — The spec proudly says all data is local, then sends every AI interaction to an external API. The app silently breaks without connectivity.

3. **Context Size Creep** — A user with 2 years of practice sessions, hundreds of expenses, and a dense agenda will eventually exceed what fits in a single prompt. The context payload was assumed to stay small forever.

**The Real Gap:** The AI layer has no degradation strategy. There's no "dumb mode" where the app functions fully without the AI, which undermines the "local-first" positioning.

---

### Flip #4 — Structured Voice Templates (Rejected)

Structured templates would make this feel like an IVR system from 2008. The entire value of Claude is handling ambiguity gracefully. "Add dinner with mum sometime next week, probably evening" should just work. This flip is worth stress-testing but would be rejected quickly — it trades the product's best differentiator for marginal reliability gains.

---

### Hidden Assumptions Not in the Spec (Critical)

**The AI is neutral.** The spec assumes the AI observes and suggests. But a system that knows you've been idle on Chess for 5 days and overspent on food has enough context to reinforce or erode habits in ways you didn't consciously choose. There's no ethics layer — no way to tune how assertive the AI is, no "quiet mode," no acknowledgment that constant AI commentary could become exhausting or manipulative.

**Sessions are the unit of practice.** The Practice module measures streaks and session duration. But skill development isn't linear time — 20 minutes of deep focus beats 90 minutes of distracted practice. The spec has no quality signal, only quantity. This assumption is load-bearing for the entire gamification logic and it's never questioned.

**The user always remembers to log expenses.** The Expenses module is entirely manual. The spec treats this as a scope decision but it's actually a behaviour assumption — that you'll remember to log 3,500 XOF for food *today* rather than in three days from memory. Manual expense logging has a well-documented abandonment problem. The AI voice command helps, but there's no friction-reduction strategy beyond that.

**Dark mode is a preference.** It's listed as a toggle. But for Abidjan context — mobile-first, likely outdoor use — high-brightness outdoor readability is a genuine UX constraint, not just an aesthetic one. Light mode may need to be the more carefully designed theme, not the afterthought.

---

### The Honest Foundation Question

The spec is architecturally sound but **assumes ideal conditions throughout** — good connectivity, consistent logging, manageable context payloads, always-available AI.

**The most interesting product work is in the degradation cases, not the happy path.**

The foundational question: *What does this app do well when the AI is completely unavailable?* If the answer is "not much," the foundation needs rethinking before the AI layer goes on top.

---

## Phase 2: Constraint Mapping Results

### The Non-Negotiables (Truly Load-Bearing)

**Flutter.** Cross-platform output and existing decision are sound. No flexibility needed.

**Solo build.** The most constraining factor in the entire map. Every feature added costs maintenance surface indefinitely. This should filter every other constraint first.

**Sub-500ms perceived responsiveness.** Not negotiable as a *feeling*. The distinction matters — you can fake it with optimistic UI, skeleton loaders, and local-first rendering. The constraint isn't "AI must respond in 500ms," it's "the user must never feel the app is waiting."

### Constraints Held Out of Habit (Flexible)

**"All three modules must launch together."**

This is actually three products sharing a shell. The core thesis — *AI that reasons across your life domains* — only needs **two** modules to prove it works: Agenda + Practice.

- Agenda gives temporal context
- Practice gives something to act on with that context
- The cross-domain insight ("you have 45 free minutes, you haven't practised Japanese in 4 days") is fully demonstrated

Expenses can arrive in v1.1. You'd ship faster, debug less, and the constraint map simplifies significantly.

**"The AI needs to be always-on."**

The real constraint is: **the app must be fully functional offline, and AI is an enhancement layer, not a dependency.** Build the three modules to work completely without AI first. The AI component becomes a read-only observer that surfaces insights when available. That's the right architecture for a personal-use app you'll rely on daily.

**"Voice commands are MVP-critical."**

They aren't. They solve the logging abandonment problem partially but introduce `speech_to_text` dependency, accent/language variability (relevant in Abidjan), microphone permissions, and feedback loop design. Text input proves the concept. Voice is Phase 2 dressed up as Phase 1.

### The Constraint That Changes Everything If Removed

**"The carousel treats all three modules as peers."**

Make Agenda the persistent anchor — an always-visible strip at the top showing your next 2–3 events. The entire UX constraint map shifts:

- The carousel becomes two slides, not three (Expenses and Practice)
- Agenda context is always visually present, reinforcing the AI's temporal awareness
- Navigation dots simplify
- Cognitive load of "which screen am I on" drops because time is always your anchor

This solves a real UX problem: right now the Home Screen has no persistent identity. If Agenda is always visible as a strip, you always know where you are in your day.

**Visual structure:** A compact "today strip" below the clock (2–3 upcoming events, scrollable) that never disappears, with the carousel below it showing only Expenses and Practice. The calendar collapses into the strip rather than living as a full card.

### The Expense Logging Problem — Honest Answer

Accept that manual logging will fail and design around the failure. The path from "I just spent money" to "it's logged" must be under 3 seconds and require under 3 taps.

**Constraint shift:** Voice command isn't a bonus feature for Expenses — it's the *primary* input method, and the form is the fallback. You design the voice path first ("log 2000 XOF food") and make it work perfectly, then the form becomes the edge case for corrections.

Receipt scanning is out of scope for MVP but worth noting: it's the only mechanism that removes the *intention to log* from the equation entirely.

### The Constraint You Didn't List That Matters Most

**Language and locale are a technical constraint, not a preference.**

XOF (West African CFA franc) has no decimal places. Dates in Côte d'Ivoire are typically written DD/MM/YYYY. If you ever add French-language AI responses, the prompt engineering changes substantially. The `intl` package handles most of this — but none of it appears in the spec as a constraint. Getting currency formatting wrong on your own money app will break the personal-use trust immediately.

### The Revised Constraint Hierarchy

**Tier 1 — Truly immovable:** Solo build time budget, Flutter, perceived 500ms responsiveness, local-first data, XOF/locale correctness.

**Tier 2 — Strong defaults with flex:** Dark mode first, carousel navigation, Claude as AI layer, SQLite.

**Tier 3 — Defer without loss:** Voice commands, Expenses module (launch after Agenda + Practice), cloud sync, equal module prominence.

**Tier 4 — Rethink the assumption:** AI as always-on dependency → AI as enhancement layer. Three equal carousel slides → Agenda as persistent anchor. Full context payload → selective context with graceful degradation.

### The Buildable Product That Emerges

**Agenda always visible, Practice as the first carousel feature, AI as an offline-tolerant enhancement layer, voice as v1.1, Expenses as v1.1.**

That's something one person can build, test, and actually trust with their daily life in 3–4 weeks.

---

## Phase 3: Ecosystem Thinking — Cross-Module Symbiosis Results

### The Load-Bearing Relationship

**Time as a Practice Resource is the only relationship truly essential for MVP.**

"You have 45 free minutes Thursday. Japanese is idle. Block it?" — that's a complete product in one sentence. It requires only two data points: agenda gaps and practice idle state. Both exist on day one. It works with a single week of usage.

The secondary relationship worth building: **Overcommitment Detection — inverted.** Not "you're overcommitted, adjust" (demoralising), but "you only have 3 realistic practice windows this week — which skills matter most?" That's a *prioritisation* prompt, not a failure warning. The reframe changes the emotional valence entirely.

### The Bidirectional Relationship That Matters

**Practice → Agenda:** When a user logs a spontaneous practice session without a calendar event, the AI should notice patterns and offer to formalise them.

Flow:
```
Practice observes pattern → AI surfaces suggestion → User confirms → Agenda creates event
```

After two unanchored sessions at similar times, the AI asks once: *"You've practised Japanese twice around 7pm this week without it being scheduled. Want to add a recurring block?"* Never more than once per pattern.

This is more valuable than overcommitment detection for MVP because it's the difference between a tracker and a system that learns.

### Edge Cases That Break Trust

**Scenario 4 — Cancelled calendar event — is the dangerous one.**

If the AI recommends a practice slot that no longer exists, the entire "AI understands my life" premise collapses. The fix is architectural: the AI context payload needs a `last_modified` timestamp per module, and the AI prompt needs explicit instruction — *"if calendar events you've previously referenced no longer exist in the current payload, acknowledge the change rather than continuing prior suggestions."*

**Scenario 1 — Overcommitment nagging — is the character question.**

An AI that constantly flags overcommitment becomes demoralising. The line between "helpful signal" and "nag" is entirely in framing and frequency. Rule: surface overcommitment *once* per planning horizon, lead with opportunity ("here are your 3 best windows") not the problem ("you're overcommitted").

**Scenario 2 — Offline for a week — is low risk.**

The AI catches up from a complete local dataset. Simple rule: the AI reasons about the data it has, never comments on the data it didn't receive.

### Minimum Viable Symbiosis: Three Triggers, Three Responses

**Worth implementing for MVP:**
1. **Free slot detection** (Agenda gap analysis) — one function, high value
2. **Idle skill detection** (last session timestamp comparison) — trivial to implement
3. **Unanchored session detection** — one flag per session, one AI prompt pattern
4. **Single overcommitment alert per week** — one computed metric

**Not worth it for MVP:**
- Habit anchoring to existing recurring events (requires recurring event support, out of scope)
- Streak fragility warnings (user can see their own streak bar; redundant)
- Retroactively catching up after offline periods (adds complexity for edge case)

### The Critical Insight Phase 3 Revealed

**The AI's job isn't to be smart, it's to be timely.**

Symbiotic relationships only work if the AI surfaces them at the right moment — not in response to a question, but proactively, at the moment the insight is actionable. "You have 45 free minutes Thursday" is useful on Wednesday evening. It's useless Saturday morning.

The spec has no model of *when* the AI proactively speaks, only *what* it says when asked.

**This means the notification system is architecturally more important than the spec treated it.** `flutter_local_notifications` isn't just for calendar reminders — it's the delivery mechanism for the AI's most valuable output. A scheduled background check (every evening at 8pm) that runs the free-slot + idle-skill logic and surfaces one suggestion is worth more than an AI that answers questions perfectly on demand.

**Phase 2 build consideration that should be in the spec now:** Proactive AI notifications are the primary value delivery mechanism, not reactive chat.

---

## Session Summary & Deliverables

### What This Brainstorming Session Accomplished

This three-phase brainstorming session transformed the TooXTips MVP from a well-intentioned but over-scoped specification into a buildable, focused product that one person can ship in 3–4 weeks.

**Phase 1 (Assumption Reversal)** exposed hidden contradictions:
- Agenda is the anchor, but was treated as a peer module
- The AI layer had no degradation strategy for offline/latency failures
- Hidden assumptions about user behaviour (consistent logging, ethics, quality signals) were never questioned

**Phase 2 (Constraint Mapping)** revealed what's truly immovable vs. what's held out of habit:
- Expenses module deferred to v1.1 (saves ~40% complexity)
- Voice commands deferred to v1.1 (removes accent/language/permission complexity)
- AI as enhancement layer, not dependency (enables offline-first architecture)
- Agenda as persistent anchor instead of carousel peer (solves UX identity problem)

**Phase 3 (Ecosystem Thinking)** identified the minimum viable symbiosis:
- One load-bearing relationship: free slots + idle skills → proactive suggestion
- One bidirectional relationship: spontaneous practice patterns → calendar anchoring
- Proactive notifications (8pm daily check-in) are the primary value delivery mechanism
- Three triggers, three responses — everything else is v1.1

### Key Decisions Made

1. **MVP Scope:** Agenda + Practice only (Expenses deferred)
2. **Architecture:** Offline-first, AI as enhancement layer
3. **UX:** Persistent Agenda strip + two-slide carousel (Practice + Expenses in v1.1)
4. **AI Delivery:** Proactive notifications (8pm) > reactive chat
5. **Voice:** Deferred to v1.1 (text input proves concept)
6. **Build Order:** Modules work offline first, then AI layer added on top

### Deliverables Created

1. **Brainstorming Session Document** — Complete record of all three phases, insights, and decisions
2. **TooXTips MVP Spec v2.0 (Revised)** — Updated specification reflecting all brainstorming insights
   - Reduced scope (Agenda + Practice for MVP)
   - Offline-first architecture
   - Proactive AI notifications as primary value
   - Realistic 19–27 day solo development timeline
   - Locale/internationalization constraints documented

### What's Ready to Build

The revised spec is now a buildable product specification. The next phase is implementation:

1. **Phase 1 (Foundation):** Flutter setup, theme system, persistent Agenda strip + carousel shell
2. **Phase 2 (Agenda):** Calendar, timeline, event CRUD, SQLite schema
3. **Phase 3 (Practice):** Skill cards, streak tracking, session logging, unanchored flagging
4. **Phase 4 (AI Layer):** Claude integration, context builder, chat interface
5. **Phase 5 (Proactive AI):** Background task scheduling, free-slot detection, 8pm notification logic
6. **Phase 6 (Polish):** Edge cases, error handling, offline testing, dark/light QA

### The Honest Assessment

The product that emerges from this brainstorming is narrower and more honest than v1.0:

- **Narrower:** Two modules instead of three, text input instead of voice, no cloud sync
- **Honest:** Acknowledges offline failures, degradation modes, behaviour assumptions, locale constraints
- **Buildable:** Realistic timeline for solo development, clear priority hierarchy, minimal scope creep

This is a product you can actually ship, test, and trust with your daily life in 3–4 weeks.

---

**Session Complete.** Ready to move to implementation or refine further before building.
