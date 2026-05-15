# Story 5.3: The Orb Widget

Status: ready-for-dev

## Story

As a developer,
I want a reusable `Orb` widget with all visual states,
so that the same widget renders on Glance and home and (V2) watch.

## Acceptance Criteria

1. `lib/core/widgets/orb.dart` defines a reusable `Orb` widget accepting `OrbState state` and `double size` parameters
2. `OrbState.idle`: breathing animation (scale 1.0 → 1.08 → 1.0) at ~12 BPM (5s cycle) in `colorOrbIdle` (active accent at ~20% opacity)
3. `OrbState.listening`: waveform bars animation in `colorOrbActive` (active accent at full opacity)
4. `OrbState.parsing`: brief scale pulse (`durationFast`)
5. `OrbState.committed`: bright pulse + checkmark overlay (`durationDefault`), then auto-transitions back to idle after 1.5 seconds
6. Orb sizes: Glance Screen uses `size: 120`, home screen uses `size: 80` — passed via constructor
7. `MediaQuery.disableAnimations` disables breathing/waveform; orb becomes a static filled circle
8. Orb is a `StatefulWidget` with internal `AnimationController`s — no external animation control needed
9. Unit test: verify `disableAnimations = true` renders a static container; verify all 4 states produce correct visual output (via `matchesGoldenFile` or semantic test)
10. All files pass `flutter analyze`

## Tasks / Subtasks

- [ ] Task 1: `OrbState` enum (AC: 1)
  - [ ] Add to `lib/core/widgets/orb.dart` or `lib/core/types/orb_state.dart`
  - [ ] Values: `idle`, `listening`, `parsing`, `committed`
- [ ] Task 2: `Orb` StatefulWidget (AC: 2–8)
  - [ ] `_OrbState` creates and manages `AnimationController`s:
    - `_breathController`: `AnimationController(duration: 5 seconds, vsync: this)` + `repeat(reverse: true)`
    - `_waveController`: `AnimationController(duration: 800ms, vsync: this)` + `repeat()`
    - `_pulseController`: `AnimationController(duration: durationFast, vsync: this)`
  - [ ] `didUpdateWidget`: switch animation based on new state
  - [ ] `build()`: return different widgets per state:
    - idle: `AnimatedBuilder` with `ScaleTransition` on a `CircleAvatar(backgroundColor: colorOrbIdle)`
    - listening: `AnimatedBuilder` drawing 5 vertical waveform bars (varying heights via sine wave)
    - parsing: `AnimatedBuilder` with `Curves.elasticOut` scale pulse
    - committed: `Stack` with `CircleAvatar` + `Icon(Icons.check)` overlay, auto-returns to idle after 1.5s via `Future.delayed`
- [ ] Task 3: `disableAnimations` check (AC: 7)
  - [ ] In `build()`: `if (MediaQuery.disableAnimationsOf(context)) return _staticOrb()`
  - [ ] `_staticOrb()`: plain `CircleAvatar(radius: size/2, backgroundColor: colorOrbIdle)` with no animation
- [ ] Task 4: Wire `orbStateProvider` (from Story 4.4) to `Orb` on Glance and home (AC: 6)
  - [ ] Glance Screen: `Consumer(builder: (ctx, ref, _) => Orb(state: ref.watch(orbStateProvider), size: 120))`
  - [ ] Home screen (future): `Orb(state: ref.watch(orbStateProvider), size: 80)` — leave a hook
- [ ] Task 5: Tests (AC: 9)
- [ ] Task 6: Lint check (AC: 10)

## Dev Notes

- **12 BPM breathing:** 60s/12 = 5s full cycle. `AnimationController(duration: Duration(seconds: 5))` with `repeat(reverse: true)`. Scale from 1.0 to 1.08 using `Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(curve: Curves.easeInOut))`.
- **Waveform bars (listening state):** 5 `Container` bars in a `Row`. Heights animated as `sin(phase + i * pi/2.5)` for a natural waveform. Use `AnimatedBuilder` with the wave controller.
- **`SingleTickerProviderStateMixin`:** Only one `AnimationController` active at a time — use `TickerProviderStateMixin` since multiple controllers exist, or chain controller switches.
- **`flutter_animate` alternative:** Could use `flutter_animate` for the breathing animation: `CircleAvatar().animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.08, duration: 5.seconds)`. Cleaner for idle state.
- **colorOrbIdle:** From `OdoTheme.colorOrbIdle` — active accent at ~20% opacity. `colorAccent.withOpacity(0.2)`.

### Project Structure Notes

```
lib/core/widgets/
└── orb.dart          # Orb widget + OrbState enum
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-5.3] — 4 states spec
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md] — orb visual design, 12 BPM
- [Source: CLAUDE.md#UI-Design] — colorOrbIdle, colorOrbActive tokens

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List