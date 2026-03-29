---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7]
inputDocuments: 
  - project-brief.md
  - prd.md
  - TooXTips_MVP_Spec_v2.0_REVISED.md
projectName: TooXTips
userName: Lokki
date: 2026-03-29
---

# UX Design Specification TooXTips

**Author:** Lokki  
**Date:** 2026-03-29

---

## Executive Summary

### Project Vision

TooXTips is a personal AI productivity app that unifies time management (Agenda) and skill development (Practice) into a single system. The core differentiator is proactive AI that surfaces cross-domain insights at the right moment — e.g., "You have 45 free minutes Thursday. Japanese is idle. Block it?" — rather than waiting for users to ask questions.

The app treats time, money, and skill development as a single interconnected system. The MVP focuses on Agenda + Practice with AI as an enhancement layer that proactively suggests how to use free time for skill development.

### Target Users

**Primary:** Lokki (the builder) — knowledge worker in Abidjan, manages a full work calendar, wants to maintain Japanese language practice, tracks spending to understand financial patterns. Uses mobile as primary device, values time optimization and skill development.

**Secondary:** Beta testers and collaborators who value time optimization and skill development, manage multiple life domains (work, learning, finances), and have inconsistent connectivity.

**User Context:** Mobile-first, intermittent connectivity, XOF currency, DD/MM/YYYY dates, Abidjan timezone (UTC+0), future French language support.

### Key Design Challenges

1. **Persistent visibility paradox** — The Agenda strip must always be visible without consuming excessive space or creating cognitive overload. It's the anchor for all temporal reasoning.

2. **Cross-module context in AI** — The AI must reason across Agenda + Practice simultaneously. The UI must make this relationship clear without overwhelming the user. The AI's value is in surfacing connections users would miss.

3. **Offline-first perception** — Users must never feel the absence of AI. Graceful degradation must be invisible, not an error state. The app works fully offline; AI is a bonus.

4. **Proactive notification timing and friction** — One suggestion per day at 8pm must feel relevant and actionable. Tapping it must require under three seconds to act on, with no navigation or form friction.

5. **Unanchored session pattern detection** — Logging a practice session without a calendar event should feel like completion, not a prompt for more action. The AI surfaces the pattern only after observing it twice at similar times.

### Design Opportunities

1. **Minimal UI, maximum AI** — The interface is intentionally simple (persistent Agenda strip, one-slide carousel between Practice and Expenses, persistent AI component). All complexity lives in the AI layer. This reduces maintenance surface and keeps cognitive load low.

2. **Bidirectional module relationships** — Practice informs Agenda (spontaneous sessions suggest recurring blocks); Agenda informs Practice (free slots suggest practice opportunities). The UI can visually encode this connection through colour and layout.

3. **Locale-aware design** — XOF currency, DD/MM/YYYY dates, Abidjan context, and future French support create opportunities for thoughtful localization that feels native, not generic.

4. **Local-first proactive AI** — Free-slot + idle-skill detection runs on-device as a scheduled background task. The AI only gets involved if the user acts on the notification. This means proactive suggestions work fully offline.

### Architectural Clarifications

**Navigation Structure:** Agenda strip (always visible) + one-slide carousel between Practice and Expenses. Expenses is deferred to v1.1, but the carousel slot exists from day one so v1.1 doesn't require a navigation redesign. This is critical for the Flutter implementation.

**Proactive Notification Behaviour:** Tapping the 8pm notification opens a contextual confirmation sheet — not the Practice module, not a pre-filled form. The sheet shows the suggestion in plain language with two actions: "Block it" and "Not now." If the user taps "Block it," the session is added to Agenda and Practice simultaneously, the sheet dismisses, and that's it. No navigation, no form, no friction. The user should be able to act on the AI's suggestion in under three seconds without the app fully opening.

**Unanchored Session Handling:** Flag sessions silently. No immediate prompt — logging a session is a moment of completion and prompting immediately breaks that feeling. The flag is invisible to the user until the AI has seen it happen twice at similar times. Then and only then does the AI ask once.

**AI Chat Opening State:** The chat opens to a one-line state summary at the top — not a dashboard, literally one sentence: *"3 events today · Japanese idle 5 days · 2 free slots this week"* — followed immediately by quick-command suggestions below it. The summary is skimmable in under two seconds and gives the AI interaction immediate context without feeling like a report.

**Local Proactive Logic:** The 8pm notification is computed locally, not by the AI. Free-slot + idle-skill detection runs on-device as a scheduled background task. The AI only gets involved if the user taps the notification and opens the confirmation sheet. This ensures proactive suggestions work fully offline.

**Offline AI Behaviour:** The AI never comments on its own absence. If offline, the chat opens normally, quick commands appear, and any query requiring the API returns a neutral inline message: *"Not available right now — try again when you're connected."* No error state, no spinner, no explanation. Just tell the user what to do next.

---

## Core User Experience

### Defining Experience

The core user experience is **receiving and acting on a proactive AI suggestion in under three seconds**. At 8pm, the user gets a notification: "You have 45 free minutes Thursday. Japanese is idle. Block it?" They tap it, see a confirmation sheet with two buttons ("Block it" and "Not now"), tap "Block it," and the session is added to both Agenda and Practice simultaneously. The sheet dismisses. Done.

This is the primary loop that defines TooXTips' value. Everything else — manual event creation, session logging, chat queries — is secondary to this moment of effortless cross-module action.

### Platform Strategy

**Platform:** Flutter mobile app (iOS + Android)  
**Primary interaction:** Touch-based, mobile-first  
**Device context:** Mobile as primary computing device, intermittent connectivity  
**Critical constraint:** Offline-first — all core features work without connectivity  
**Locale:** XOF currency, DD/MM/YYYY dates, Abidjan timezone (UTC+0), future French support

The platform is mobile-only for MVP. The persistent Agenda strip and carousel are designed for vertical scrolling on small screens. The AI component at the bottom is thumb-reachable. Dark mode is default for OLED optimization.

### Effortless Interactions

1. **Proactive notification → action** — Tapping a notification opens the confirmation sheet directly, not the app home screen. The user acts without navigation.

2. **Session logging** — Tapping a skill card opens a timer or quick-log sheet. Logging a session feels like completion, not a prompt for more.

3. **Agenda strip visibility** — The strip is always visible. Users never scroll to see what's coming next. Time awareness is constant.

4. **AI chat context** — Opening the chat shows a one-line state summary immediately: *"3 events today · Japanese idle 5 days · 2 free slots this week."* The user knows their current state without reading a report.

5. **Offline transparency** — If offline, the app works normally. If a query requires the API, a neutral message appears: *"Not available right now — try again when you're connected."* No error state, no spinner.

### Critical Success Moments

1. **First proactive notification** — The user receives the 8pm suggestion, taps it, acts on it in under three seconds, and feels like the AI understands their life. This is the aha moment.

2. **Persistent Agenda strip** — The user opens the app and immediately sees their next events without scrolling. Time is always in context.

3. **Bidirectional connection** — The user logs a spontaneous practice session, and later the AI surfaces: *"You've practised Japanese twice around 7pm this week without scheduling it. Want to make it recurring?"* The system learned from behaviour.

4. **Offline resilience** — The user is commuting with no connectivity, logs events and practice sessions, and later when connectivity returns, everything syncs silently. They never felt the absence of AI.

5. **Minimal cognitive load** — The user opens the app and sees one primary action per screen. No decision paralysis, no submenus, no overwhelming options.

### Experience Principles

1. **Proactive > Reactive** — The AI's primary value is surfacing insights at the moment they're actionable, not answering questions on demand. One suggestion per day at 8pm beats an always-on AI that answers perfectly but at the wrong moment.

2. **Offline-first, AI-enhanced** — The app works completely without connectivity. The AI is a read-only observer that surfaces insights when available. Its absence is never felt.

3. **Friction-free action** — Every critical user action requires under three seconds and zero navigation. Tapping a notification, logging a session, confirming a suggestion — all feel instant.

4. **Silent flagging, visible patterns** — Unanchored sessions are flagged silently. The user never sees the flag until the AI has observed the pattern twice at similar times. Then and only then does the AI ask once.

5. **Minimal UI, infinite AI** — The interface is intentionally simple (persistent strip, one-slide carousel, persistent AI component). All complexity lives in the AI layer. This reduces maintenance and keeps cognitive load low.

6. **Locale-aware, not generic** — XOF currency, DD/MM/YYYY dates, Abidjan context, and future French support are core to how the app feels native and respectful of the user's context.

7. **One AI voice per day** — The proactive notification is the AI's primary channel. The chat is the user's channel. The AI never initiates inside the chat — no "good morning" messages, no unprompted check-ins, no push-style content inside the chat thread. If the user opens chat, they're asking. The AI responds. The 8pm notification is the only moment the AI speaks first. This distinction keeps the AI from feeling like a bot and preserves the notification's signal value.

---

## Core UX Patterns

### Pattern 1: Confirmation Sheet Anatomy

The confirmation sheet is the most critical interaction in the app. It must contain exactly four elements — no more:

1. **Suggestion** — The AI's suggestion in plain language (one sentence, natural, not system-speak)
   - Example: *"You have 45 free minutes Thursday morning. Japanese is idle. Block it?"*

2. **Context** — The contextual reason in muted text below the suggestion
   - Example: *"45 min free · Japanese: 5 days idle"*

3. **Primary action** — "Block it" button, full width, violet background
   - Adds the session to both Agenda and Practice simultaneously

4. **Secondary action** — "Not now" text button, no border, muted colour
   - Dismisses without friction and without asking why

**What's not included:** No close icon. No "remind me later." No explanation of how the AI decided this. The user either acts or doesn't. Asking why they declined adds friction and data you don't need in MVP.

### Pattern 2: Agenda Strip Information Hierarchy

The strip is always visible but its content needs a clear priority rule for when events overlap or the day is empty. Three states:

#### State 1: Events exist today

- Show next 2 upcoming events with time and title
- Titles truncated at 20 characters
- Format: `9:00 Standup · 11:00 Design Review`

#### State 2: No more events today

- Show first event tomorrow with a muted "tomorrow" label
- Format: `Tomorrow · 9:00 Standup`

#### State 3: Nothing scheduled

- Show a single muted line: *"Nothing scheduled — free day"*
- Not a prompt to add events, not a blank space

**Rule:** The strip should never show more than two events simultaneously. If three are back-to-back, show the next two and let the user swipe into Agenda for the rest. The strip is a glance, not a list.

### Pattern 3: Offline State for AI Chat

When the user sends a message while offline, the message appears in the chat thread as normal. Beneath it — in the same muted style as timestamps — a single line appears:

*"Couldn't reach AI · Tap to retry"*

The message stays in the thread. When connectivity returns and they tap retry, it sends without them retyping. Their thought is preserved.

This pattern preserves the "offline absence is never felt" principle. The alternative — silently eating the message or showing a red error state — breaks the experience.

---

## Desired Emotional Response

### Primary Emotional Goals

The primary emotional goal is **"The AI actually understands my life."** This is the aha moment. The user receives a proactive suggestion, acts on it in under three seconds, and feels seen. The AI didn't ask them to describe their schedule or their practice habits — it observed, reasoned across domains, and surfaced a connection they would have missed.

Secondary emotional goals:
- **Calm and focused** — The interface is minimal, decisions are clear, cognitive load is low. Using the app should feel restful, not stressful.
- **Empowered and in control** — The user decides whether to act on suggestions. The AI is a tool they control, not a system that controls them.
- **Trusted and reliable** — The app works offline, data stays local, the AI never surprises them with unexpected behaviour.

### Emotional Journey Mapping

**First discovery:**
The user installs TooXTips and sees a minimal interface: Agenda strip at top, Practice slide, AI component at bottom. No onboarding, no tutorial, no overwhelming options. Feeling: *Curious but not intimidated.*

**First interaction (manual):**
The user adds an event or logs a practice session. The interaction is frictionless — a bottom sheet, a few taps, done. Feeling: *Efficient and capable.*

**First proactive notification (8pm):**
The user gets a notification: "You have 45 free minutes Thursday. Japanese is idle. Block it?" They tap it, see the confirmation sheet, tap "Block it," and the session is added to both modules. Feeling: *Delighted and understood.* This is the aha moment.

**Offline resilience:**
The user is commuting with no connectivity, logs events and practice sessions, and later when connectivity returns, everything syncs silently. They never felt the absence of AI. Feeling: *Reliable and dependable.*

**Returning to use:**
The user opens the app the next day. The Agenda strip shows their schedule, the Practice slide shows their skills, the AI is ready. They feel like the app is a natural extension of their life, not a tool they have to remember to use. Feeling: *Integrated and effortless.*

### Micro-Emotions

1. **Trust vs. Skepticism** — The user should trust that the AI's suggestions are thoughtful, not random. The offline-first architecture and local proactive logic build this trust. The AI never comments on its absence, never shows error states, never breaks the experience.

2. **Delight vs. Satisfaction** — The first proactive notification should delight. Subsequent notifications should satisfy. The "one AI voice per day" principle prevents notification fatigue and preserves the delight of the 8pm check-in.

3. **Accomplishment vs. Frustration** — Logging a session should feel like completion, not a prompt for more. The silent flagging of unanchored sessions means the user never feels frustrated by unexpected prompts.

4. **Confidence vs. Confusion** — The Agenda strip is always visible, providing temporal context. The user never opens the app and wonders "what should I do next?" The primary action is always clear.

5. **Autonomy vs. Dependency** — The user decides whether to act on suggestions. The "Block it" / "Not now" choice is binary and frictionless. The AI never nags, never escalates, never makes decisions for the user.

### Design Implications

**To create "The AI understands my life":**
- The confirmation sheet must show the suggestion in natural language, not system-speak
- The contextual reason ("45 min free · Japanese: 5 days idle") must be visible so the user understands the AI's reasoning
- The action must be instant — no forms, no navigation, no friction

**To create "Calm and focused":**
- The interface is minimal: persistent strip, one-slide carousel, persistent AI component
- One primary action per screen — no decision paralysis
- Dark mode is default for visual calm and OLED optimization
- Typography and spacing are generous, not cramped

**To create "Trusted and reliable":**
- The app works fully offline — no surprise failures when connectivity drops
- Offline messages are neutral, not error states: "Couldn't reach AI · Tap to retry"
- The AI never initiates inside the chat — only the 8pm notification speaks first
- Data stays local; no analytics, no telemetry, no third-party SDKs

**To create "Integrated and effortless":**
- The Agenda strip is always visible — time is always in context
- Session logging feels like completion, not a prompt for more
- Unanchored sessions are flagged silently — the user never sees friction until the AI has observed a pattern
- The app learns from behaviour and suggests formalizing spontaneous patterns

### Emotional Design Principles

1. **Delight through understanding** — The AI's primary value is surfacing connections the user would miss. The confirmation sheet should make this understanding visible through natural language and contextual reasoning.

2. **Calm through simplicity** — The interface is intentionally minimal. All complexity lives in the AI layer. Users should never feel overwhelmed by options or decisions.

3. **Trust through transparency** — The app works offline, data stays local, the AI's reasoning is visible in the confirmation sheet. Users should never feel surprised or manipulated.

4. **Autonomy through clarity** — Every critical action has a clear primary choice and a clear secondary choice. The user is always in control. The AI suggests; the user decides.

5. **Integration through invisibility** — The app should feel like a natural extension of the user's life, not a tool they have to remember to use. The persistent Agenda strip and the 8pm notification are the only moments the app demands attention.

### Emotional Failure States

The AI will occasionally get suggestions wrong. The user already practised, the "free slot" is actually blocked by something the app doesn't know about, or the suggestion just doesn't resonate that day. One bad suggestion is fine. Three in a row and the notification gets turned off.

**Design solution:** The confirmation sheet needs a third micro-action — a silent thumbs-down or "not relevant" button that takes no explanation and costs zero friction. One tap, dismissed, the system notes it. After two consecutive dismissals on the same skill, the AI deprioritises that skill in its suggestions for a week. The user never sees this logic — they just notice the suggestions get better.

Implementation: a single `dismissed_at` timestamp per suggestion with a suppression window. This preserves the "in control" feeling even when the AI misses, because the user has a way to correct it without confronting the system.

### Suggestion Construction Algorithm

When multiple idle skills and free slots exist, the algorithm prioritises in this order:

1. **Longest idle skill first** — Most days since last session
2. **If tied** — Shortest available free slot that fits a default session (prevents suggesting a 2-hour slot when 30 minutes would do)
3. **If still tied** — Earliest free slot in the week (sooner is more actionable)

One suggestion per night, first match wins, algorithm stops. This ensures every suggestion is defensibly non-random, not arbitrary.

### Stale Slot Guard

The user gets the 8pm notification but doesn't tap it until 11am the next day. The "45 free minutes Thursday" slot may no longer exist — they may have added an event overnight.

When the confirmation sheet opens, recheck the Agenda locally before rendering. If the slot is gone, display a single line: *"This slot is no longer available"* with a single button: "Close." No explanation, no alternative suggestion. The AI will try again tonight.

This prevents a trust-breaking moment where the user taps "Block it" for a slot that doesn't exist.

### Completion Animation and Navigation

The completion animation plays for 400ms (durationSlow). After the animation finishes, the sheet pops using `Navigator.of(context).pop()`.

If the user wasn't in the app when they tapped the notification, they return to their home screen. If they were in the app, they return to whatever slide they were on. No forced navigation, no app opening.

### Success Criterion: Improvement Over Time

After two weeks of use, the suggestion acceptance rate should be higher than week one. If it isn't, the deprioritisation logic isn't working or the slot-detection algorithm is too loose.

Store `accepted_at` and `dismissed_at` per suggestion in the local DB with no external analytics. A simple weekly count tells you whether the product is actually learning from user behaviour, not just tracking it.

### Implementation Sequence for Notification System

Build in this order:

1. `SuggestionEngine` — on-device algorithm (slot detection + idle skill ranking + priority rule)
2. `SuggestionStore` — local DB table for suggestion history (`suggested_at`, `accepted_at`, `dismissed_at`, `skill_id`, `slot_start`)
3. `BackgroundTaskService` — schedules 8pm check using `workmanager` or `flutter_background_fetch`
4. `ConfirmationSheet` — UI surface with stale-slot guard and completion animation
5. `NotificationService` — triggers local notification with constructed suggestion text

The engine is the product — everything else is delivery infrastructure.

---

## UX Pattern Analysis & Inspiration

### Inspiring Products Analysis

#### Duolingo — Streak as Identity

**What works:** The streak is not a gamification mechanic — it's identity. After 12 days of Japanese, the user is no longer tracking a habit. They're protecting something that feels like theirs. The emotional weight of not wanting to break the streak is more motivating than any reward system.

**Lesson for TooXTips:** The 7-day bar on skill cards needs to feel like something worth protecting, not just a progress indicator. The visual design of that bar matters more than it appears in current mockups. This is where the "streak as identity" principle should live.

**Anti-pattern to avoid:** Duolingo becomes a notification factory. "You haven't practised today!" at 9pm every night is meaningless noise. This is exactly what the "one AI voice per day" principle was designed to prevent. TooXTips must never send multiple notifications per day.

#### Things 3 — Completion as Feeling

**What works:** No dashboard, no analytics, no gamification. Just tasks that feel good to complete. The key interaction is how tasks disappear when checked — a tiny animation that feels like *done*, not *deleted*. Completion has weight and satisfaction.

**Lesson for TooXTips:** Session logging should chase this completion feeling. Logging 45 minutes of Japanese should feel like that checkmark in Things 3, not like filling out a form. The bottom sheet should confirm the action instantly and dismiss with a sense of accomplishment.

**Anti-pattern to avoid:** Things 3 is entirely reactive. It waits for the user. TooXTips' entire thesis is that waiting for the user is the wrong model. The proactive 8pm notification is the counter to this pattern.

#### Claude / ChatGPT — Always-Accessible Input with Conversation Starters

**What works:** The input is always at the bottom, always thumb-reachable, always ready. You never navigate to ask a question. The conversation persists without effort. The blank chat with a blinking cursor is intimidating, so quick-command suggestions act as conversation starters that lower activation energy to zero.

**Lesson for TooXTips:** The AI component design already embeds this pattern — input always at the bottom, thumb-reachable. The one-line state summary + quick commands at chat opening is the exact pattern that lowers activation energy. This is correct.

**Anti-pattern to avoid:** Both Claude and ChatGPT are entirely reactive with no concept of *when* to speak. TooXTips fixes this with the 8pm notification as the only proactive channel. This distinction is critical.

### Transferable UX Patterns

**From Duolingo:**
- Streak as identity, not gamification — the 7-day bar on skill cards should feel like something worth protecting
- Visual weight on the streak indicator to make it emotionally significant
- Restraint in notifications — never more than one per day

**From Things 3:**
- Completion feeling over form-filling — session logging should feel like a checkmark, not a form
- Tiny animations that signal *done* rather than *deleted*
- Visual restraint and respect for user attention

**From Claude/ChatGPT:**
- Always-accessible input at the bottom, thumb-reachable
- Conversation starters (quick commands) to lower activation energy
- Persistent conversation thread without friction

### Anti-Patterns to Avoid

1. **Notification inflation** — All three inspiring apps have learned the wrong lesson from engagement metrics and send too many notifications that mean too little. TooXTips' "one AI voice per day" principle is the direct counter. This must remain non-negotiable.

2. **Reactive-only design** — Waiting for the user to ask is the wrong model. The proactive 8pm notification is TooXTips' differentiator.

3. **Form-filling friction** — Session logging and event creation should feel like completion, not data entry.

4. **Blank-state intimidation** — Empty screens with no guidance lower activation energy. The first-launch skill question and the AI chat's quick commands solve this.

### Design Inspiration Strategy

**What to Adopt:**
- Streak as identity — the 7-day bar should feel emotionally significant and worth protecting
- Completion feeling — session logging and event creation should feel like accomplishment, not form-filling
- Always-accessible input — the AI component at the bottom, thumb-reachable, always ready
- Conversation starters — quick commands lower activation energy for chat interaction

**What to Adapt:**
- Duolingo's streak mechanics → simplify to a visual bar without points or levels
- Things 3's completion animation → apply to session logging and event creation
- ChatGPT's chat interface → add the one-line state summary and quick commands

**What to Avoid:**
- Notification inflation — one AI voice per day, non-negotiable
- Reactive-only design — the 8pm proactive notification is the differentiator
- Form-filling friction — all critical actions should feel like completion
- Blank-state confusion — the first-launch skill question and quick commands prevent this

This strategy keeps TooXTips unique while borrowing proven patterns from products that respect user attention and create emotional connection.

---

## Design System Foundation

### Design System Choice

**Choice: Flutter's Built-In Theming System + Custom Design Tokens**

Flutter's native theming system is lightweight, requires no external dependencies, and provides complete control over the visual design without the overhead of a full design system framework. This approach supports the minimal aesthetic, dark-mode-first strategy, and locale awareness required for TooXTips.

### Rationale for Selection

1. **Speed** — Flutter's theming system is lightweight. Design tokens are defined once and applied consistently across the app.

2. **Control** — Complete control over visual design without adapting an established system's opinions. The minimal aesthetic (dark mode first, generous spacing, intentional colour use) is easier to implement with custom tokens.

3. **Solo development** — No need to learn a complex design system framework. Flutter's theming is native and well-documented. Custom components can be built as needed without fighting a system's constraints.

4. **Locale awareness** — Custom tokens make it easy to define locale-specific values (XOF currency formatting, DD/MM/YYYY dates, future French typography adjustments) without workarounds.

5. **Offline-first** — No external design system dependencies means no API calls, no cloud-based design tools, no sync issues. Everything is local.

### Implementation Approach

**Two-Layer Colour Token System:**

Layer 1 — Raw palette (never use directly in widgets):
```
violetPrimary   = #7C4DFF
cyanPrimary     = #00C2D4
greenPrimary    = #1D9E75
darkBg          = #0D0D0F
surface         = #1A1A1F
mutedText       = #6B6B80
primaryText     = #E8E8F0
borderDefault   = #2A2A35
```

Layer 2 — Semantic tokens (use these in all widgets):
```
colorAccentAgenda   = violetPrimary
colorAccentPractice = greenPrimary
colorAccentExpenses = cyanPrimary
colorSurface        = surface
colorTextPrimary    = primaryText
colorTextMuted      = mutedText
colorBorder         = borderDefault
```

When light mode is added, only semantic tokens are remapped. Every widget using `colorSurface` automatically gets the light mode value without changes.

**Typography Decisions:**

System fonts (SF Pro / Roboto) are appropriate for body text. The clock display requires explicit tabular figures to prevent width shifting every second:

```
clockStyle: TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.tabularFigures()],
  letterSpacing: 0.06,
)
```

**Spacing Scale:**

Define once, use everywhere. Never use arbitrary padding values:

```
sp2  = 2.0
sp4  = 4.0
sp8  = 8.0
sp12 = 12.0
sp16 = 16.0
sp20 = 20.0
sp24 = 24.0
```

**Animation Durations:**

Three durations cover all MVP animations:

```
durationFast    = 150ms  (dot expansion, badge appearance)
durationDefault = 250ms  (bottom sheet open/close)
durationSlow    = 400ms  (confirmation sheet, session completion)
```

The session completion animation (Things 3 checkmark equivalent) uses `durationSlow` with `AnimatedOpacity` + slight scale-down on the logged duration text. This 400ms duration is deliberate — slow enough to register as meaningful without feeling like a loading state.

### Customization Strategy

**Component Build Priority:**

1. `AppColors` + `AppTheme` — tokens first, nothing else works without them
2. `AgendaStrip` — appears on every screen, most constrained surface, forces early solution of persistent-visibility problem
3. `ConfirmationSheet` — the most important UX surface, build before any module so it's not compromised for implementation convenience
4. `SkillCard` — Practice module's primary surface, needs completion-feeling animation solved here
5. `AiComponent` — persistent bottom bar, build last among shared components because its expanded state (command dropdown) needs other surfaces to exist for context-aware testing
6. Module screens — Agenda slide, Practice slide, built on top of the above

**Theme Mode Default:**

`ThemeMode.dark` as hardcoded default for MVP, with a toggle in settings that writes to `SharedPreferences`. This allows one theme to be perfected before launch. Light mode is deferred to post-MVP. The toggle exists in the UI from day one so it doesn't feel like a missing feature — it just always starts dark.

This decision should be documented in `main.dart` as a comment explaining the choice, preventing second-guessing later.

---
