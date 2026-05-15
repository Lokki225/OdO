---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7]
inputDocuments:
  - project-brief.md
  - architecture.md
projectName: OdO
userName: Lokki
date: 2026-05-13
---

# UX Design Specification — OdO

**Author:** Lokki
**Date:** May 13, 2026

---

## Executive Summary

### Project Vision

OdO is a personal AI daily companion built natively for the Ivorian context. It is not a productivity app. It is a daily ritual — a five-minute evening conversation with an AI that learns what matters to the user across their time, their habits, and their life, and stays with them all day through timely, voice-first interactions.

The product holds two design tensions in perfect balance: **minimal in surface, deep in substance.** The UI is intentionally restrained. The AI is intentionally proactive. Together they create something that feels less like an app and more like a presence.

### Target Users

**Primary:** Lokki — knowledge worker in Abidjan, full work calendar, ongoing skill commitments (Japanese, others), intermittent connectivity, preference for restraint over feature density. Mobile-first. Uses voice when it helps and tap when it helps. Wants reflection, not engagement metrics.

**Secondary:** A small circle of West African francophone beta testers who value the same things — proactive but quiet AI, local privacy, native locale, depth over breadth.

**User Context:** Mobile-first, intermittent connectivity, XOF currency, DD/MM/YYYY dates, UTC+0 timezone, French-primary UI with English support, occasional outdoor high-brightness use, evening reflective ritual.

### Key Design Challenges

1. **Ambient presence without intrusion** — OdO must feel always-there (Glance Screen, persistent strip, bottom bar) without ever demanding attention. The "one AI voice per day" principle is the spine that holds this together.
2. **Evening session as defining ritual** — The 5-minute session must feel essential without ever feeling obligatory. It must collapse gracefully on quiet days and never penalize skipping.
3. **Glance Screen as both lock and surface** — It is the most-used screen in the product. It must communicate state at a glance, accept voice and text input, and authenticate — all without becoming busy.
4. **Voice as equal-priority input** — Voice and tap must be interchangeable for capture. Voice should never feel like a second-class path. But voice should never demand a response.
5. **Seven themes without fragmentation** — Theme presets + custom picker must feel coherent across orb, strip, cards, and accents. Light mode must be genuinely usable outdoors.
6. **Cross-module AI reasoning surfaced sparingly** — The AI's value is in connecting Agenda + Practice + history. The UI should make this connection visible only at the moment of insight (the cross-domain insight in the evening session, the throughout-day suggestion), never as ambient decoration.
7. **Two-device coherence (V1 prep)** — The Glance Screen design language must extend to the watch (V2) without rework. One interaction model, two scales.

### Design Opportunities

1. **Minimal UI, maximum AI** — The interface is intentionally simple. All complexity lives in the AI layer. Cognitive load stays low.
2. **The orb as personality** — One element carries the entire AI presence. Breathing when idle, waveform when listening, brief pulses on commit. The orb does the emotional work that text would otherwise have to do.
3. **The Glance Screen as ritual entry point** — Every interaction starts here. The lock state, the orb, the next event, the latest suggestion — four pieces of information, perfectly framed.
4. **The evening session as compounding moat** — Five minutes a day, compounding into a model that no other app can replicate. The longer the user stays, the deeper the value.

---

## Design Principles

1. **One AI voice per day.** The proactive notification is the AI's primary channel. The chat is the user's channel. The AI never initiates inside the chat. The 8pm session is the only moment the AI speaks first by default.
2. **The user tags. The system learns.** Every interaction that shapes OdO's understanding is one tap. Significant, dismiss, expand. No forms. No why-fields.
3. **Offline is invisible.** Graceful degradation is never an error state. "Couldn't reach AI — tap to retry" preserves the user's message and never feels like failure.
4. **Restraint is the default.** Empty space is not blank space. Three states — events, no events today, nothing scheduled — each handled with a single line. Never more.
5. **Voice is equal, not better.** Tap and voice route to the same commit pipeline. Voice never demands a response. The user can ignore any notification.
6. **The phone is the brain. The watch is a surface.** All logic, all data, all decisions happen on the phone. The watch (V2) displays and captures.
7. **Local always.** Data does not leave the device except as AI context payload on explicit interaction. No analytics. No telemetry. No advertising IDs.

---

## Core UX Patterns

### Pattern 1: The Glance Screen

The most-used surface in the entire app. Sits before the home screen as an ambient lock screen with privileged information.

**Layout (top to bottom):**

1. **Lock state row** — lock icon (violet locked / green unlocked) + text label ("Locked" / "Unlocked")
2. **AI orb** — centered, breathing animation idle, waveform animation when listening
3. **Info cards** — minimal, two at most: next event, OdO's latest suggestion. Never sensitive data. Never more than two.
4. **Bottom bar** — three elements left-to-right: quick-add (+) button, text input field, microphone toggle
5. **Slide-up affordance** — subtle handle at very bottom signals unlock gesture

**Authentication paths:**
- Vocal: "Hey OdO, unlock — [user's chosen phrase]"
- Typed: tap text input, type password, enter
- Biometric: configurable in settings as a third option

**Auth failure handling:** Three vocal failures → typed password becomes required for the next 5 minutes. Quiet visual cue (lock icon pulses red once), no error toast.

**The orb is the watch face.** Same design at smaller scale (V2). Users learn one interaction model.

### Pattern 2: The Persistent Agenda Strip

The strip is always visible at the top of the home screen. Three states, each handled with one line:

**State 1 — Events exist today:**
- Show next 2 upcoming events with time and title
- Titles truncated at 20 characters
- Format: `9:00 Standup · 11:00 Design Review`

**State 2 — No more events today:**
- Show first event tomorrow with muted "tomorrow" label
- Format: `Tomorrow · 9:00 Standup`

**State 3 — Nothing scheduled:**
- Single muted line: *"Nothing scheduled — free day"*
- Not a prompt. Not a blank space. A statement.

**Rule:** Never more than two events simultaneously. If three are back-to-back, show two and let the user tap into the Agenda slide for the rest. The strip is a glance, not a list.

**Interaction:** Tap to expand into the Agenda slide. Long-press to enter monthly calendar.

### Pattern 3: The Confirmation Sheet

The confirmation sheet is the most critical interaction in the app. It must contain exactly four elements — no more:

1. **Suggestion** — Plain language, one sentence, not system-speak
   - *"You have 45 free minutes Thursday morning. Japanese is idle. Block it?"*
2. **Context** — Muted text below
   - *"45 min free · Japanese: 5 days idle"*
3. **Primary action** — "Block it" button, full width, theme accent background
   - Adds the session to both Agenda and Practice simultaneously
4. **Secondary action** — "Not now" text button, no border, muted colour
   - Dismisses without friction, without asking why

**What is NOT included:** No close icon. No "remind me later." No explanation of how the AI decided this. No third option asking why. The user acts or doesn't.

**Silent thumbs-down:** Long-press on "Not now" reveals "Don't suggest this again" — single tap, sheet closes, that skill is suppressed for 7 days. The user never sees this logic explained — they just notice suggestions get better.

**Stale slot guard:** When the sheet opens, recheck the agenda. If the slot is gone, replace all four elements with a single line *"This slot is no longer available"* and one button: "Close."

### Pattern 4: The Evening Session

The session is OdO's defining surface. Everything else is infrastructure.

**Structure (5-minute ceiling):**

1. **Opening headline** — one sentence summarizing the day
   - *"Productive day. Two practice sessions, three events, on budget."*
2. **Highlights (3–4 items)** — ranked by relevance from current data state
   - Each item rendered as a card: brief context + content
   - Tag actions inline on each card: **significant** (accent dot) · **dismiss** (muted X) · **expand** (chevron)
3. **One cross-domain insight if available**
   - *"Third Japanese session at 7pm this week — want to anchor that time?"*
   - Same tag interaction
4. **Close summary** — one line of what was learned, queues tomorrow's nudge
   - *"Noted: Japanese matters at 7pm. Tomorrow: free slot Thursday morning."*

**Wrap-up shortcut:** Always-visible "wrap up" button at top — jumps to close phase. The user can complete a session in seconds when tired or rushed.

**Voice handling:** All tag actions accept voice ("significant", "dismiss", "expand"). Voice is never required.

**Persistence:** Every tag writes to the database immediately. The session survives interruption until midnight. After midnight, today's session is gone.

**Tone:** Reflective, not corporate. Warm, not chatty. The headline summarizes; it doesn't congratulate.

### Pattern 5: Offline State for AI Chat

When the user sends a message while offline, the message appears in the chat thread as normal. Beneath it, in muted style:

*"Couldn't reach AI · Tap to retry"*

The message stays in the thread. When connectivity returns and the user taps retry, it sends without retyping. Their thought is preserved.

The orb continues breathing. The Agenda strip continues updating. The product remains fully functional. Offline is never an error state.

### Pattern 6: Skill Card

The Practice module's primary surface.

**Layout:**
- **Top row:** skill name + current streak badge (e.g. "🔥 7")
- **Middle:** 7-day activity bar — 7 vertical bars, filled if session that day
- **Bottom:** last session — duration + relative date (*"35 min · 2 days ago"*)

**Interaction:**
- Tap → skill detail screen
- Long-press → quick log session sheet

**No XP. No levels. No goals.** The user types "Japanese" and the card exists. The bar fills as sessions are logged. The streak speaks for itself.

### Pattern 7: First-Launch Skill Prompt

On first app open, after Glance Screen unlock setup, a single bottom sheet appears:

*"What's one skill you're working on?"*

Single text field. Single button: "Add it." That's the entire onboarding.

This question is the difference between an app that feels empty on day one and an app that feels alive from minute one.

---

## Design Inspiration Strategy

**What to adopt:**
- Streak as quiet identity (Duolingo, but simplified — no points, no levels)
- Completion feel (Things 3 — session logging feels like accomplishment)
- Always-accessible voice input (Apple's ambient mic models)
- Conversation starters (ChatGPT quick commands, but only on first chat open)

**What to adapt:**
- Duolingo's streak mechanics → visual bar without gamification
- Things 3's completion animation → session log + event create
- ChatGPT's chat → add one-line state summary, no AI-initiated chat

**What to avoid:**
- Notification inflation — one AI voice per day, non-negotiable
- Reactive-only design — the 8pm proactive notification is the differentiator
- Form-filling friction — all critical actions feel like completion
- Blank-state intimidation — first-launch question, persistent strip, quick commands solve this
- Gamification — no XP, no levels, no badges

This strategy keeps OdO unique while borrowing proven patterns from products that respect attention and create emotional connection.

---

## Design System Foundation

### Design System Choice

**Choice: Flutter's built-in theming + custom design tokens, two-layer color system, seven theme presets + custom picker.**

### Rationale

1. **Speed** — Flutter's theming is lightweight, tokens are defined once and applied everywhere.
2. **Control** — Complete control over the minimal aesthetic without adapting an established system's opinions.
3. **Solo development** — No external design system framework to learn or fight.
4. **Locale awareness** — Tokens make XOF formatting, DD/MM/YYYY, future French typography adjustments trivial.
5. **Offline-first** — No external design system dependencies, no API calls, no sync issues.

### Two-Layer Color Token System

**Layer 1 — Raw palette** (never use directly in widgets):

```
violetPrimary    = #7C4DFF
cyanPrimary      = #00C2D4
greenPrimary     = #1D9E75
emberOrange      = #FF6B35
cosmicMagenta    = #C770FF
auroraTeal       = #2DD4BF

darkBg           = #0D0D0F
darkSurface      = #1A1A1F
lightBg          = #FDFBF7
lightSurface     = #FFFFFF

mutedTextDark    = #6B6B80
mutedTextLight   = #6B6B6B
primaryTextDark  = #E8E8F0
primaryTextLight = #1A1A1A
borderDark       = #2A2A35
borderLight      = #E6E1D7

categoryPersonal = #7C4DFF       (violet)
categoryWork     = #5B8BD4       (blue)
categoryPractice = #1D9E75       (green)
```

**Layer 2 — Semantic tokens** (used everywhere in widgets):

```
colorAccent              // active theme accent
colorAccentAgenda        // Personal events
colorAccentWork          // Work events
colorAccentPractice      // Practice events / sessions
colorSurface             // card background
colorBackground          // screen background
colorTextPrimary
colorTextMuted
colorBorder
colorOrbIdle             // orb breathing color (active accent at low opacity)
colorOrbActive           // orb waveform color (active accent at full)
```

When light mode is active, only semantic tokens remap. Every widget using `colorSurface` automatically gets the light value.

### Seven Theme Presets

| Theme | Mode | Accent | Notes |
|---|---|---|---|
| **Violet Dark** (default) | dark | `violetPrimary` | The default OdO feel — calm, reflective, identifiable |
| **Cyan Dark** | dark | `cyanPrimary` | Cool, focused, tech-forward |
| **Green Dark** | dark | `greenPrimary` | Grounded, practice-emphasized |
| **Light Mode** | light | `violetPrimary` | High-contrast, outdoor-readable for Abidjan brightness |
| **Cosmic** | dark | `cosmicMagenta` | Soft magenta, reflective |
| **Ember** | dark | `emberOrange` | Warm, evening-toned |
| **Aurora** | dark | `auroraTeal` | Cool teal, calm |

**Custom picker:** overrides `colorAccent` only via 24 curated swatches (default) or a full HSL picker (behind "advanced" toggle). Surface/text/border tokens stay locked to the active mode.

**Theme selection:** in settings, post-unlock. Active theme + custom accent (if any) persisted via `SharedPreferences`.

### Typography

System fonts (SF Pro on iOS, Roboto on Android) for body. Clock display requires explicit tabular figures:

```dart
clockStyle: TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.tabularFigures()],
  letterSpacing: 0.06,
)
```

**Type scale (semantic):**

| Token | Size | Weight | Use |
|---|---|---|---|
| `textDisplay` | 28 | 400 | Evening session headline |
| `textTitle` | 22 | 500 | Section headings, clock |
| `textBody` | 16 | 400 | Default body |
| `textBodyMuted` | 14 | 400 | Strip context, timestamps |
| `textCaption` | 12 | 500 | Category labels, badges |
| `textMicro` | 11 | 600 | Streak numbers, all-caps labels |

A serif accent (e.g. Fraunces) is used for the evening session headline and skill names — adds warmth, signals "ritual" not "tool". Body remains system sans-serif throughout.

### Spacing Scale

Define once, use everywhere. Never arbitrary padding:

```
sp2  = 2.0
sp4  = 4.0
sp8  = 8.0
sp12 = 12.0
sp16 = 16.0
sp20 = 20.0
sp24 = 24.0
sp32 = 32.0
```

### Animation Durations

Three durations cover all V1 animations:

```
durationFast    = 150ms  // dot expansion, badge appearance, tag tap
durationDefault = 250ms  // bottom sheet open/close, theme swap
durationSlow    = 400ms  // confirmation sheet, session completion, orb state transition
```

**Session completion animation:** `AnimatedOpacity` + slight scale-down on the logged duration text at `durationSlow`. Deliberate — slow enough to register as meaningful, not so slow it feels like loading.

### Component Build Priority

1. **`AppColors` + `AppTheme`** — tokens first. Nothing else works without them.
2. **`Orb` widget** — the AI presence. Idle breathing, active waveform, brief commit pulse. Build standalone before integrating.
3. **`AgendaStrip`** — appears on every screen. Most constrained surface. Solves persistent-visibility problem early.
4. **`ConfirmationSheet`** — the most important UX surface. Build before any module so it is not compromised for implementation convenience.
5. **`SkillCard`** — Practice module's primary surface. Solves completion-feeling animation.
6. **`EveningSessionScreen`** — the defining surface. Build last in Foundation, but with skeleton during Epic 1 to test architecture early.

---

## Desired Emotional Response

### Primary Emotional Goal

**"OdO understands my life."** This is the aha moment. The user receives a proactive suggestion or a cross-domain insight in the evening session, acts on it in seconds, and feels seen. OdO didn't ask them to describe their schedule or their practice habits — it observed, reasoned across domains, and surfaced a connection they would have missed.

### Secondary Goals

- **Calm and focused** — Interface minimal, decisions clear, cognitive load low. Using OdO should feel restful.
- **Empowered and in control** — User decides. AI suggests. The user is never overridden.
- **Trusted and reliable** — Works offline. Data stays local. AI never surprises.
- **Held, not nagged** — Daily presence without demand. The user can ignore any notification.

### Emotional Journey

**First discovery:** Install. Glance Screen. Orb breathing. A single question: "What's one skill you're working on?" No tutorial. No tour. *Curious but not intimidated.*

**First interaction (manual):** Add event, log a session. Bottom sheet, few taps, done. *Efficient and capable.*

**First evening session (8pm):** Notification: "Your evening with OdO is ready." Tap. Headline. Three highlights. Tap "significant" on one. Cross-domain insight surfaces. Tag it. Close summary. Five minutes. *Reflective and seen.*

**First proactive notification (next day, 3pm):** Meeting canceled. "45 minutes just opened up. Japanese is 4 days idle. Block it?" Tap. Done. *Delighted and understood.* This is the aha moment.

**Offline resilience:** Commute, no signal. Log events. Log a session. Voice command captures. Everything works. *Reliable and dependable.*

**Returning use (week 2):** Open the app. Agenda strip shows the day. Orb breathing. Latest suggestion is relevant — about a pattern OdO noticed last evening session. *Integrated and effortless.*

**Compounding (month 3):** The user catches themselves saying "OdO already knows that." The evening session has become a ritual. Switching to anything else feels like leaving a relationship. *Held.*

### Micro-Emotions

1. **Trust vs. skepticism** — Suggestions feel thoughtful, never random. Local-first + on-device suggestion engine + visible context ("45 min free · Japanese: 5 days idle") builds trust.
2. **Delight vs. satisfaction** — First proactive notification delights. Subsequent ones satisfy. "One AI voice per day" preserves delight.
3. **Accomplishment vs. frustration** — Logging a session feels like completion, never a prompt for more. Silent unanchored flagging prevents frustration.
4. **Confidence vs. confusion** — Agenda strip is always visible. The user never opens the app and wonders what's next.
5. **Autonomy vs. dependency** — "Block it" / "Not now" is binary. The AI suggests; the user decides. Always.
6. **Ritual vs. obligation** — The evening session is held, not required. Skipping has zero penalty. The session collapses on quiet days. It is offered, not demanded.

### Design Implications

**To create "OdO understands my life":**
- Confirmation sheet shows the suggestion in natural language
- Context is visible ("45 min free · Japanese: 5 days idle") — the AI's reasoning is transparent
- Action is instant — no forms, no navigation, no friction
- The evening session's cross-domain insight is the highest-value moment of the day

**To create "Calm and focused":**
- Interface minimal: Glance Screen → home (strip + one slide + bottom bar) → evening session
- One primary action per screen
- Dark mode default for visual calm and OLED battery
- Generous spacing, never cramped

**To create "Trusted and reliable":**
- Works fully offline — no surprise failures
- Offline messages neutral, not error states
- AI never initiates inside the chat
- Data stays local — no analytics, no telemetry, no third-party SDKs

**To create "Integrated and effortless":**
- Agenda strip always visible
- Glance Screen as ambient surface
- Session logging feels like completion
- Pattern detection silent — the user never sees friction until the AI has earned the right to ask

**To create "Held, not nagged":**
- One AI voice per day
- Voice notifications voluntary — the user can ignore
- The evening session has a 5-minute ceiling and a wrap-up shortcut
- No streaks-broken alerts, no shame loops

---

## Interaction Specifications

### Glance Screen — Voice Capture

```
1. Phone wake → Glance renders, orb breathing (durationDefault transition)
2. User taps mic toggle → orb morphs to waveform (durationDefault)
3. User speaks → STT live transcript appears in text input (faded)
4. 1.5s silence → orb pulses (durationFast) → AI parses → commits
5. Banner confirmation slides down from top (durationDefault), dismisses in 2s
6. Orb returns to breathing
```

**Cancel:** Tap mic again during listening → orb returns to idle immediately. No commit.

**STT failure:** Orb returns to idle silently. No error toast.

**Ambiguous parse:** Orb stays active, AI follow-up question appears as one line above the bottom bar: *"For tonight or tomorrow?"* User taps or speaks the answer.

### Home Screen — Carousel + Bottom Bar

**Carousel (V1):** One slide — Practice. (Expenses placeholder removed in V1; deferred to V1.5.) Carousel infrastructure remains so V1.5 ships without refactor.

**Active dot pill** at top of slide adopts the active accent color.

**Persistent bottom bar:**
- Same layout as Glance Screen bottom bar: quick-add, text input, mic toggle
- Tap text input → expands into full chat sheet (modal route)
- Tap mic → voice capture pipeline
- Tap quick-add → bottom sheet with three options: add event, add session, add skill

### Evening Session — Tag Interaction

Each highlight card:

```
┌─────────────────────────────────────────────┐
│  ⓘ Practice                                  │
│  Japanese · 35 min · 7:12pm                  │
│  "Worked through chapter 4, kanji review."   │
│                                              │
│  [ ● significant ]  [ × dismiss ]  [ ⌃ expand ]
└─────────────────────────────────────────────┘
```

- **Significant** — accent dot fills, card scales 0.98 then back (durationFast), persists
- **Dismiss** — card slides out left (durationDefault), next highlight slides in
- **Expand** — card animates to full-screen detail with notes, related sessions, edit options
- **Voice** — speak "significant", "dismiss", "expand" while card is focused

### Confirmation Sheet — Open / Close

- Slides up from bottom (durationSlow with custom curve — feels deliberate)
- Backdrop fades to 60% opacity
- Tap backdrop = dismiss (same as "Not now")
- Stale slot check runs synchronously before render

### Theme Swap — Runtime

- Theme picker in settings shows seven presets as cards with live orb preview
- Tap a card → entire app rebuilds with new tokens (durationDefault crossfade)
- No app restart
- Custom accent picker accessible from the same screen via "Custom" card

---

## Accessibility

- **WCAG AA contrast** for all semantic tokens in both modes
- **44dp minimum touch targets** for all interactive elements
- **Voice as equal input** — every action achievable via voice
- **Screen reader labels** on orb, lock state, all icons
- **Reduced motion respect** — `MediaQuery.disableAnimations` disables breathing/waveform; orb becomes a static solid color
- **High-contrast outdoor light mode** — designed for direct Abidjan sun, not retrofitted from dark

---

## Locale & Internationalization

- **XOF currency** — no decimal places, thin-space thousands separator: `15 000 F`
- **Dates** — DD/MM/YYYY everywhere visible, ISO in storage
- **Times** — 24-hour by default (locale-appropriate), `HH:mm`
- **Timezone** — UTC+0 throughout storage; display in user's local zone (Abidjan = UTC+0, no shift)
- **Languages V1** — French primary, English fallback. UI strings only. AI responses English-only in V1; French AI responses ship in V1.5.

---

## Visual Anti-Patterns

What OdO is not, made explicit:

1. **Notification inflation** — multiple proactive AI messages per day. The "one AI voice per day" principle is the direct counter.
2. **Reactive-only AI** — waiting for the user to ask. The 8pm session and throughout-day suggestions are the differentiator.
3. **Form-filling friction** — session and event creation should feel like completion, not data entry.
4. **Blank-state intimidation** — empty screens with no guidance. The first-launch question, the persistent strip, and the chat quick commands solve this.
5. **Gamification** — XP, levels, achievement badges. The streak speaks for itself.
6. **Chatty AI** — "Good morning! How's your day?" The AI never initiates inside the chat. Only the 8pm session speaks first.
7. **Why-fields** — asking the user to explain dismissals. The system learns from the dismissal itself, not from prose.

---

## Design Validation Checklist (Pre-Ship)

- [ ] All seven themes preserve WCAG AA contrast on both surface and text tokens
- [ ] Light mode tested in direct outdoor sun
- [ ] Glance Screen renders all three lock states cleanly
- [ ] Agenda strip handles all three states (events / no more today / nothing scheduled)
- [ ] Confirmation sheet renders the stale-slot fallback correctly
- [ ] Evening session resumes correctly after interruption between 8pm and midnight
- [ ] Evening session shows the wrap-up shortcut at all times
- [ ] First-launch experience: install → Glance setup → skill prompt → first home screen in under 2 minutes
- [ ] Voice capture pipeline: idle → listening → parsing → commit → return to idle, with orb states matched
- [ ] Offline state: chat retry preserves message, orb continues breathing, agenda updates locally
- [ ] All animations respect `MediaQuery.disableAnimations`
- [ ] XOF formatting correct: `15 000 F` (no decimal, thin space)
- [ ] DD/MM/YYYY everywhere visible
- [ ] French UI strings reviewed by a francophone speaker

---

**Document Status:** Locked for V1 MVP Implementation
**Last Updated:** May 13, 2026
**Owner:** Lokki (Solo Developer, Abidjan)
