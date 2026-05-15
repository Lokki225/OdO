# OdO — UI Design Reference

> Source: `ux-design-specification.md` + `_bmad-output/planning-artifacts/epics.md`
> Strategy: minimal surface, deep substance — the UI is intentionally restrained
> Last updated: 2026-05-13

---

## 1. Typography

Two font roles. Body uses the system font (SF Pro on iOS, Roboto on Android). The serif Fraunces is used only for ritual surfaces (evening session headline, skill names) to signal "reflection, not tool."

### Type Scale (Semantic Tokens)

| Token | Size | Weight | Font | Usage |
|---|---|---|---|---|
| `textDisplay` | 28px | 400 | Fraunces | Evening session headline |
| `textTitle` | 22px | 500 | System | Section headings, clock display |
| `textBody` | 16px | 400 | System | Default body copy |
| `textBodyMuted` | 14px | 400 | System | Strip context, timestamps, subtitles |
| `textCaption` | 12px | 500 | System | Category labels, badges, chip text |
| `textMicro` | 11px | 600 | System | Streak numbers, all-caps labels |

### Clock Display

```dart
clockStyle: TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.tabularFigures()],
  letterSpacing: 0.06,
)
```

---

## 2. Color System

### Strategy — Two-Layer Architecture

**Layer 1 — Raw Palette** (`app_colors.dart`): never used directly in widgets.
**Layer 2 — Semantic Tokens**: the only layer widgets import.

When the active theme changes at runtime, only semantic tokens remap. Every widget using `colorSurface` automatically gets the correct value for the active theme.

### Layer 1 — Raw Palette

```dart
// Theme accents
violetPrimary   = #7C4DFF   // Violet Dark (default) + agenda category
cyanPrimary     = #00C2D4   // Cyan Dark
greenPrimary    = #1D9E75   // Green Dark + Practice category
emberOrange     = #FF6B35   // Ember
cosmicMagenta   = #C770FF   // Cosmic
auroraTeal      = #2DD4BF   // Aurora

// Backgrounds
darkBg          = #0D0D0F   // OLED near-black
darkSurface     = #1A1A1F   // Dark card surface
lightBg         = #FDFBF7   // Light screen background
lightSurface    = #FFFFFF   // Light card surface

// Text
primaryTextDark  = #E8E8F0  // Warm white
mutedTextDark    = #6B6B80  // Muted purple-grey
primaryTextLight = #1A1A1A
mutedTextLight   = #6B6B6B

// Borders
borderDark       = #2A2A35
borderLight      = #E6E1D7

// Category colors (never remapped by theme)
categoryPersonal = #7C4DFF  // violet — Personal events
categoryWork     = #5B8BD4  // blue — Work events
categoryPractice = #1D9E75  // green — Practice events + sessions
```

### Layer 2 — Semantic Tokens

| Token | Usage |
|---|---|
| `colorAccent` | Active theme accent — orb, buttons, active indicators |
| `colorAccentAgenda` | Personal event blocks, strip dots |
| `colorAccentWork` | Work event blocks |
| `colorAccentPractice` | Practice event blocks, streak fill |
| `colorSurface` | Card backgrounds |
| `colorBackground` | Screen background |
| `colorTextPrimary` | All primary text |
| `colorTextMuted` | Secondary text, timestamps, captions |
| `colorBorder` | Card borders, dividers |
| `colorOrbIdle` | Orb breathing color (active accent at low opacity) |
| `colorOrbActive` | Orb waveform color (active accent at full opacity) |

### Seven Theme Presets

| Theme | Mode | Accent | Character |
|---|---|---|---|
| **Violet Dark** (default) | dark | `violetPrimary` (#7C4DFF) | Calm, reflective, identifiable |
| **Cyan Dark** | dark | `cyanPrimary` (#00C2D4) | Cool, focused, tech-forward |
| **Green Dark** | dark | `greenPrimary` (#1D9E75) | Grounded, practice-forward |
| **Light Mode** | light | `violetPrimary` (#7C4DFF) | High-contrast, outdoor-readable |
| **Cosmic** | dark | `cosmicMagenta` (#C770FF) | Soft magenta, reflective |
| **Ember** | dark | `emberOrange` (#FF6B35) | Warm, evening-toned |
| **Aurora** | dark | `auroraTeal` (#2DD4BF) | Cool teal, calm |

### Dark Mode (Violet Dark default) Semantic Mapping

| Token | Value |
|---|---|
| `colorAccent` | `#7C4DFF` |
| `colorAccentAgenda` | `#7C4DFF` |
| `colorAccentWork` | `#5B8BD4` |
| `colorAccentPractice` | `#1D9E75` |
| `colorSurface` | `#1A1A1F` |
| `colorBackground` | `#0D0D0F` |
| `colorTextPrimary` | `#E8E8F0` |
| `colorTextMuted` | `#6B6B80` |
| `colorBorder` | `#2A2A35` |
| `colorOrbIdle` | `#7C4DFF` @ 30% opacity |
| `colorOrbActive` | `#7C4DFF` |

### Light Mode Semantic Mapping

| Token | Value |
|---|---|
| `colorAccent` | `#7C4DFF` |
| `colorSurface` | `#FFFFFF` |
| `colorBackground` | `#FDFBF7` |
| `colorTextPrimary` | `#1A1A1A` |
| `colorTextMuted` | `#6B6B6B` |
| `colorBorder` | `#E6E1D7` |

### Custom Accent Picker

Overrides `colorAccent` only. Surface/text/border tokens stay locked to the active mode.
- Default: 24 curated swatches
- Advanced: full HSL picker behind "advanced" toggle
- Persisted as hex string in `SharedPreferences`

---

## 3. Border Radius

| Token | Value | Usage |
|---|---|---|
| `radiusSm` | 10px | Small chips, badges, tag buttons |
| `radiusMd` | 14px | Input fields, buttons, day chips |
| `radiusLg` | 20px | Cards, skill cards, event blocks |
| `radiusXl` | 28px | Bottom sheets, hero cards |
| `radiusFull` | 100px | Pills, streak badge, status chips |

---

## 4. Spacing

Base unit: 4px. All padding/margin values are multiples of 4.

| Token | Value | Usage |
|---|---|---|
| `sp2` | 2px | Sub-pixel corrections |
| `sp4` | 4px | Icon gaps, tiny offsets |
| `sp8` | 8px | Between related elements |
| `sp12` | 12px | Card internal gap |
| `sp16` | 16px | Card padding, scroll area padding |
| `sp20` | 20px | Between sections |
| `sp24` | 24px | Section separators |
| `sp32` | 32px | Screen-level vertical rhythm |

---

## 5. Animation Durations

Three durations cover all V1 animations:

| Token | Value | Usage |
|---|---|---|
| `durationFast` | 150ms | Tag tap, badge appear, dot expand |
| `durationDefault` | 250ms | Bottom sheet open/close, theme swap, card transitions |
| `durationSlow` | 400ms | Session completion, confirmation sheet, orb state transition |

**Orb breathing:** ~12 BPM (one cycle ~5s). Slow and calm — signals presence, not activity.
`MediaQuery.disableAnimations` disables all non-essential motion. Orb becomes a static circle.

---

## 6. Navigation and Screen Architecture

OdO does **not** use a bottom tab bar. The navigation model has two top-level surfaces:

### Glance Screen (`/glance`)

The most-used surface. An ambient lock screen that is the entry point for every session.

**Route:** `/glance` (initial route)

### Home Screen (`/home`)

Behind the Glance Screen. Contains the Agenda strip, Practice carousel, and persistent AI bottom bar.

**Sub-routes:**
- `/home/agenda` — Agenda slide
- `/home/agenda/event/:id` — Event detail
- `/home/agenda/calendar` — Monthly calendar
- `/home/practice` — Practice slide
- `/home/practice/skill/:id` — Skill detail

### Modal Routes (Bottom Sheets)

- `/home/agenda/add-event`
- `/home/practice/add-skill`
- `/home/practice/log-session/:id`
- `/confirm-suggestion/:id`

### Other Routes

- `/evening` — Evening Session screen
- `/settings` — Settings
- `/settings/themes` — Theme picker

---

## 7. Screen Inventory

### Glance Screen (`/glance`)

| Element | Position | Spec |
|---|---|---|
| Lock state row | Top | Lock icon (violet locked / green unlocked) + state label |
| AI orb | Center | Large, breathing (idle) or waveform (listening) |
| Info cards | Below orb | ≤2 cards: next event + latest suggestion (if within 18h) |
| Bottom bar | Bottom | quick-add (+) · text input · mic toggle |
| Slide-up handle | Very bottom | 4×36px muted bar, centered |

**Auth paths:** Vocal password · Typed password · Biometric (configurable)

### Home Screen (`/home`)

| Element | Position | Spec |
|---|---|---|
| Agenda strip | Top, always visible | 3 states — events / no-more-today / nothing scheduled |
| Practice carousel | Main scroll area | Skill cards |
| AI bottom bar | Persistent bottom | quick-add (+) · text input · mic |

### Agenda Slide (`/home/agenda`)

| Element | Spec |
|---|---|
| Timeline | Vertical, 30-min grid, 6am–11pm default |
| Event blocks | Category left-bar (violet/blue/green), colored bg tint |
| Free slots | Dashed border, muted green tint (if ≥30 min gap) |
| Header | Selected date + navigation |

### Practice Slide (`/home/practice`)

| Element | Spec |
|---|---|
| Skill cards | Scrollable list |
| Empty state | "No skills yet" + quick-add CTA |

### Evening Session (`/evening`)

| Element | Spec |
|---|---|
| Wrap-up button | Always visible at top (right-aligned) |
| Headline | Fraunces `textDisplay`, one sentence |
| Highlight cards | 3–4 items; tag/expand/dismiss inline |
| Cross-domain insight | Same card pattern as highlights |
| Close summary | Single line, queues tomorrow's nudge |

### Confirmation Sheet (`/confirm-suggestion/:id`)

Four elements only — no more:

| Element | Spec |
|---|---|
| Suggestion text | Plain language, one sentence |
| Context line | Muted — *"45 min free · Japanese: 5 days idle"* |
| "Block it" | Full-width primary button, `colorAccent` background |
| "Not now" | Text button, `colorTextMuted`, no border |

**Stale slot state:** All four elements collapse to single line + "Close" button.

### Settings (`/settings`)

| Element | Spec |
|---|---|
| Theme section | Opens `/settings/themes` |
| Theme picker | 7 preset cards + custom accent swatch/HSL |
| Voice toggle | Voice output on/off per surface |
| Biometric toggle | Enable/disable biometric unlock |
| Lock timeout | Configurable (default 5 min) |
| Language | French / English |
| Clear all data | Confirmation required |

---

## 8. Component Patterns

### The AI Orb

The single element that carries OdO's presence across all surfaces.

```
States:
  OrbState.idle       — breathing animation, colorOrbIdle (accent at 30%)
  OrbState.listening  — waveform animation, colorOrbActive (accent at 100%)
  OrbState.parsing    — brief pulse, durationFast
  OrbState.committed  — bright pulse + checkmark overlay, durationDefault

Sizes:
  Glance Screen  — large  (~80dp)
  Home Screen    — medium (~48dp)
  Watch V2 prep  — small  (~36dp)

Accessibility: announces state ("OdO is listening", "OdO is idle")
disableAnimations: orb becomes static circle
```

### Persistent AI Bottom Bar

```
Layout (left → right):
  [quick-add (+)] [text input — flex] [mic toggle]

quick-add tap     → bottom sheet: Add event / Log session / Add skill
text input tap    → opens /chat (modal)
mic toggle tap    → voice capture, orb → OrbState.listening

Background: colorSurface
Top border: 1px colorBorder
Min height: 56dp
Horizontal padding: sp16
```

### Agenda Strip

```
Background: colorBackground (flush to screen)
Height: 44dp minimum
Padding: sp12 vertical, sp16 horizontal
Font: textBodyMuted for times, textBody 500 for titles

State 1 (events today):
  "9:00 Standup · 11:00 Design Review"
  Title truncated at 20 characters

State 2 (no more today):
  "Tomorrow · 9:00 Standup"
  "Tomorrow" label in colorTextMuted

State 3 (nothing scheduled):
  "Nothing scheduled — free day"
  Entire line in colorTextMuted

Tap → /home/agenda
Long-press → /home/agenda/calendar
```

### Card

```
Background: colorSurface
Border: 1px colorBorder
Radius: radiusLg (20px)
Padding: sp16
```

### Skill Card

```
Background: colorSurface
Border: 1px colorBorder
Radius: radiusLg
Padding: sp16

Layout (top → middle → bottom):
  Top row:     skill name (textBody 500) + streak badge (🔥 N, textCaption, radiusFull)
  Middle:      7-day activity bar — 7 vertical bars, sp4 gap
                 Filled day: colorAccentPractice
                 Empty day: colorBorder
  Bottom:      "35 min · 2 days ago" (textBodyMuted)

No XP. No levels. No goal bars.

Tap       → /home/practice/skill/:id
Long-press → /home/practice/log-session/:id
```

### Highlight Card (Evening Session)

```
Background: colorSurface
Border: 1px colorBorder
Radius: radiusLg
Padding: sp16

Content: brief context + highlight text (textBody)
Tag row: [significant ●] [dismiss ×] [expand ›] — radiusFull chips, sp8 gap

significant: colorAccent dot appears on card, durationFast
dismiss: card fades out, durationDefault
expand: card expands inline, durationDefault
```

### Event Block (Timeline)

```
Radius: radiusMd
Padding: sp8 sp12
Left border: 3px solid category color
Background: category color at 10% opacity

Personal:  violet left-bar + violet tint bg
Work:      blue left-bar + blue tint bg
Practice:  green left-bar + green tint bg

Title: textBodyMuted 500 colorTextPrimary
Subtitle: textCaption colorTextMuted
```

### Free Slot Block (Timeline)

```
Border: 1px dashed colorAccentPractice at 40%
Background: colorAccentPractice at 6%
Radius: radiusMd
Label: "Free — Xh Ymin" in textCaption colorTextMuted

Tap → /home/agenda/add-event (slot pre-filled)
```

### Confirmation Sheet

```
Route: /confirm-suggestion/:id
Radius: radiusXl (top corners)
Background: colorSurface
Padding: sp24

Element 1 — Suggestion:
  textTitle, colorTextPrimary
  "You have 45 free minutes Thursday morning. Japanese is idle. Block it?"

Element 2 — Context:
  textBodyMuted, colorTextMuted
  "45 min free · Japanese: 5 days idle"

Element 3 — "Block it":
  Full-width, height 52dp, radiusMd
  Background: colorAccent, text: white, textCaption 500

Element 4 — "Not now":
  Full-width text button, no border
  Color: colorTextMuted, textCaption 500
  Long-press → reveals "Don't suggest this again" (suppresses 7 days)

Stale slot state:
  All elements replaced by:
  Single line: "This slot is no longer available" (colorTextMuted)
  One button: "Close"
```

### Stat Badge (Streak)

```
Radius: radiusFull
Padding: sp4 sp8
Background: colorAccentPractice at 15%
Text: textMicro 600 colorAccentPractice
Icon: 🔥 (emoji, not icon)
```

### Input Field

```
Background: colorSurface
Border: 1px colorBorder (focused: colorAccent)
Radius: radiusMd
Padding: sp12 sp16
Font: textBody
Min-height: 48dp
Tall variant: 80dp (notes fields)
```

### Bottom Sheet

```
Radius: radiusXl top corners only
Background: colorSurface
Handle bar: 4×36px, colorBorder, centered, sp8 from top
Animation: durationDefault, ease-out curve
```

### Pill / Status Chip

```
Radius: radiusFull
Padding: sp4 sp12
Font: textCaption 500
```

### Settings Row

```
Layout: [icon 24dp] [label + sublabel] [chevron / toggle]
Background: colorSurface
Border-bottom: 1px colorBorder (except last row)
Padding: sp16 horizontal, sp12 vertical
First row in group: radius top radiusMd
Last row in group: radius bottom radiusMd
```

---

## 9. Interaction Patterns

### Voice Capture Flow

```
Tap mic button
  → orb: idle → listening (waveform, colorOrbActive)
  → VoiceService.startListening()
  → 1.5s silence → parsing (orb pulses, durationFast)
  → AiService.parseCommand(transcript)

Clear intent:
  → commit immediately (create event / log session / add skill)
  → orb: committed (bright pulse + checkmark, durationDefault)

Ambiguous intent:
  → single follow-up line appears above bottom bar
  → user speaks or types reply

STT failure:
  → orb returns to idle silently (no error toast)

Tap mic during listening:
  → cancel, no commit, orb → idle
```

### First-Launch Flow

```
1. Glance Screen onboarding
   → Set vocal unlock phrase
   → Optional biometric enable

2. Home screen (empty state)
   → First-launch skill prompt (bottom sheet)
   → "What's one skill you're working on?"
   → Type skill name → "Add it"

3. Skill card appears immediately
4. Agenda strip: "Nothing scheduled — free day"
5. At 8pm: first evening session notification

Total: ≤5 minutes, zero instruction
```

### Session Completion Animation

```
On "Add it" / "Block it" / session log save:
  AnimatedOpacity: 1.0 → 0.0
  AnimatedScale: 1.0 → 0.92
  Duration: durationSlow (400ms)
```

---

## 10. Accessibility Requirements

- All interactive elements: semantic labels (readable by TalkBack / VoiceOver)
- Orb: announces state change ("OdO is listening", "OdO is idle")
- All touch targets: ≥44dp
- Color is never the only signal — icon + label always paired with color
- Voice is a fully equivalent path for all critical actions
- WCAG AA contrast on all semantic tokens in all seven themes
- Light mode: body text ≥7:1 contrast (outdoor Abidjan readability)
- `MediaQuery.disableAnimations` respected throughout

---

## 11. Locale and Formatting

| Context | Format |
|---|---|
| Currency | `15 000 F` — no decimals, thin-space thousands, F suffix |
| Dates | `DD/MM/YYYY` everywhere |
| Times | 24-hour (`14:30`, not `2:30 PM`) |
| Timezone | UTC+0 in storage; local-day boundary for display |
| Language | French default; English in settings |
| AI responses | English in V1 (French deferred to V1.5) |

---

## 12. What Is Out of Scope in V1

| Feature | Deferred to |
|---|---|
| Expenses module | V1.5 |
| Recurring events | V1.5 |
| French AI responses | V1.5 |
| Apple Watch / Wear OS | V2 |
| Wake-word "Hey OdO" | V2 |
| Cross-device handoff | V2 |
| User accounts / sync / backend | V3 |

The Glance Screen design and Orb widget are built V2-ready (scaled for watch) even though V2 is not yet built.

---

## 13. Design Decisions Log

| Decision | Rationale |
|---|---|
| No bottom tab bar | Glance Screen + persistent bottom bar replaces tab navigation; one interaction model across phone and watch |
| Violet Dark as default | Calm, reflective, identifiable. Sets the ritual tone. |
| System fonts (body) + Fraunces (display) | Fraunces serif signals "reflection, not tool" for the evening session headline. System fonts keep everything else fast and locale-correct. |
| Orb as AI presence | One element carries all AI personality. No chatbot avatar, no animated mascot. |
| "One AI voice per day" | Prevents notification fatigue. Preserves the evening session as the primary proactive channel. |
| Offline is never an error state | "Couldn't reach AI — tap to retry" is a notice, not a failure. All core features work offline. |
| No XP, no levels, no badges | Gamification signals engagement metrics, not reflection. OdO values cumulative understanding. |
| Four-element confirmation sheet (max) | Every extra element dilutes the decision. The user acts or doesn't. |
| Category colors fixed across themes | Personal/Work/Practice must be instantly recognizable regardless of active theme. |