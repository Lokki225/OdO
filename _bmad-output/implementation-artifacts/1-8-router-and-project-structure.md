# Story 1.8: Router and Project Structure

Status: ready-for-dev

## Story

As a developer,
I want `go_router` configured with all V1 routes and bottom sheets as routes,
so that navigation is centralized and deep linking works.

## Acceptance Criteria

1. `lib/app/router.dart` defines all top-level routes: `/glance`, `/home`, `/home/agenda`, `/home/agenda/event/:id`, `/home/agenda/calendar`, `/home/practice`, `/home/practice/skill/:id`, `/evening`, `/settings`, `/settings/themes`
2. Bottom sheet routes defined: `/home/agenda/add-event`, `/home/practice/add-skill`, `/home/practice/log-session/:id`, `/confirm-suggestion/:id`
3. Shell route wraps `/home` children with a 5-tab bottom nav bar (Home, Agenda, Practice, Insights, Profile)
4. Each top-level route renders a placeholder screen (title text + route path) confirming routing works end-to-end
5. Deep linking confirmed: navigating to `/home/agenda` from outside renders the Agenda tab active in the bottom nav
6. Bottom sheet routes use `CustomTransitionPage` with slide-up animation (`durationDefault`)
7. `CONVENTIONS.md` is updated with import rules: domain imports nothing from data/presentation; data imports only domain; presentation imports only domain entities and providers
8. All files pass `flutter analyze` with no issues

## Tasks / Subtasks

- [ ] Task 1: Create `app/router.dart` (AC: 1–6)
  - [ ] `final router = GoRouter(routes: [...])` at top-level
  - [ ] `ShellRoute` wrapping home tabs with `ScaffoldWithNavBar` widget
  - [ ] Define all top-level `GoRoute` entries
  - [ ] Bottom sheet routes use `pageBuilder` with `CustomTransitionPage` (slide-up)
  - [ ] Expose `routerProvider` as `Provider<GoRouter>` for injection
- [ ] Task 2: Create `ScaffoldWithNavBar` widget (AC: 3)
  - [ ] `lib/features/home/presentation/scaffold_with_nav_bar.dart`
  - [ ] 5 tabs: Home (house icon), Agenda (calendar icon), Practice (dumbbell icon), Insights (sparkle icon), Profile (person icon)
  - [ ] `NavigationBar` (Material 3) with semantic labels in French: Accueil, Agenda, Pratique, Insights, Profil
  - [ ] Uses `context.go(location)` to navigate tabs
- [ ] Task 3: Placeholder screens (AC: 4)
  - [ ] One `PlaceholderScreen` widget accepting `title` parameter
  - [ ] Used for all routes until feature screens are implemented
- [ ] Task 4: Wire router into `app/app.dart` (AC: 5)
  - [ ] `MaterialApp.router(routerConfig: router)`
- [ ] Task 5: Update CONVENTIONS.md (AC: 7)
  - [ ] Add section: "Import Rules" with the three-layer dependency rule
  - [ ] Add section: "Navigation" — always use `context.go` or `context.push`, never `Navigator.push`
- [ ] Task 6: Lint check (AC: 8)
  - [ ] `flutter analyze lib/app/ lib/features/home/presentation/scaffold_with_nav_bar.dart` — zero issues

## Dev Notes

- **go_router v14:** Uses `GoRouter` with `routes` list; `ShellRoute` wraps the nav bar shell. The `builder` on `ShellRoute` receives `child` (the active tab's content).
- **Bottom sheet routing:** For bottom sheets, use `pageBuilder: (context, state, child) => CustomTransitionPage(...)` with a slide-up `SlideTransition`. The sheet is dismissed with `context.pop()`.
- **Insights and Profile tabs:** Not implemented in V1 epic stories — leave as placeholder screens. Do NOT remove from nav bar.
- **`/glance` route:** This is the initial route (default) — set `initialLocation: '/glance'` on `GoRouter`.
- **Event ID routing:** `/home/agenda/event/:id` — the `id` is an integer event ID from the database. `GoRouterState.pathParameters['id']` returns a string; parse with `int.parse()`.
- **Deep link testing:** In `flutter test`, use `GoRouter.optionURLReflectsImperativeAPIs = true` for accurate testing.
- **5-tab nav bar:** Navigation to Practice tab from voice command (Story 4.4) uses `ref.read(routerProvider).go('/home/practice')` — the router must be accessible via Riverpod provider.

### Project Structure Notes

```
lib/app/
├── app.dart               # MaterialApp.router
├── theme.dart             # from Story 1.3
└── router.dart            # GoRouter + all routes (this story)

lib/features/home/presentation/
├── scaffold_with_nav_bar.dart   # ShellRoute wrapper + NavigationBar
└── placeholder_screen.dart     # used until feature screens exist
```

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.8] — acceptance criteria + route list
- [Source: _bmad-output/planning-artifacts/architecture.md#Project-Structure] — folder layout
- [Source: CLAUDE.md#Tech-stack] — go_router navigation

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
