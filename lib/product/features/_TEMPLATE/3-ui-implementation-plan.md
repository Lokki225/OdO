# UI/Presentation Layer Implementation Plan — [Epic Name]

**Epic**: [Epic Name]  
**Layer**: Presentation (pages, widgets, state management)  
**Created**: YYYY-MM-DD  
**Architecture**: Clean Architecture — Presentation Layer  
**Source**: epics.md, ux-design-specification.md

---

## 📋 Overview

The Presentation layer is responsible for:

- **Pages/Screens**: Full-screen composites that users navigate to
- **Widgets**: Reusable UI components
- **State Management**: Riverpod providers (@riverpod) managing UI state

**Dependency Rule**: Presentation imports Domain layer only. Never imports Data layer directly.

---

## 📁 File Structure

```
lib/features/[feature]/presentation/
├── pages/
│   ├── [feature]_page.dart              # Main screen
│   └── [sub_screen]_page.dart           # Sub-screens
├── widgets/
│   ├── [widget_name].dart               # Reusable component
│   └── [widget_name].dart               # Reusable component
├── providers/
│   ├── [feature]_providers.dart         # @riverpod providers
│   └── [feature]_providers.g.dart       # Generated code
└── _providers.dart                      # Single export barrel file
```

---

## 📱 Screens Inventory

| # | Screen Name | File | Route | Purpose | Story |
|---|-------------|------|-------|---------|-------|
| 1 | [Screen]    | `[feature]_page.dart` | `/[route]` | [Purpose] | [X.N] |
| 2 | [Screen]    | `[screen]_page.dart` | `/[route]` | [Purpose] | [X.N] |
| 3 | [Sheet]     | `[sheet].dart` | bottom sheet | [Purpose] | [X.N] |

**TOTAL SCREENS**: [N] — ALL must be implemented

---

## 🧩 Widgets Inventory

| Widget | File | Used By | Purpose | Story |
|--------|------|---------|---------|-------|
| [WidgetName] | `[file].dart` | [Screen] | [Purpose] | [X.N] |
| [WidgetName] | `[file].dart` | [Screen] | [Purpose] | [X.N] |

---

## 🔄 State Management (Riverpod)

### Providers

| Provider | Type | Returns | Watches | Story |
|----------|------|---------|---------|-------|
| `[feature]RepositoryProvider` | `Provider` | `[Feature]Repository` | — | [X.N] |
| `[entities]Provider` | `FutureProvider` | `List<[Entity]>` | repository | [X.N] |
| `[feature]NotifierProvider` | `NotifierProvider` | `[State]` | repository | [X.N] |

### States

| State | Properties | Used By |
|-------|-----------|---------|
| Loading | — | All screens |
| Loaded | `List<[Entity]>` | Main screen |
| Error | `String message` | All screens |
| Empty | — | Main screen |

### User Actions → Provider Methods

| User Action | Provider Method | Side Effect |
|-------------|----------------|-------------|
| [Tap X] | `notifier.[method]()` | [Creates/updates entity] |
| [Swipe Y] | `notifier.[method]()` | [Deletes entity] |

---

## 🎨 UX Requirements (from UX Design Spec)

| UX-DR | Requirement | Implementation | Screen |
|-------|-------------|----------------|--------|
| [UX-DRN] | [Requirement text] | [How to implement] | [Screen] |
| [UX-DRN] | [Requirement text] | [How to implement] | [Screen] |

---

## 🎭 UI States

For each screen, document ALL states:

### [Screen Name] States

| State | Visual | Data Source | Transition |
|-------|--------|-------------|------------|
| Loading | Skeleton loader | — | → Loaded/Error/Empty |
| Loaded | [Description] | `[provider]` | ← from Loading |
| Empty | [Empty state message] | — | ← from Loading |
| Error | [Error message] | `Failure` | ← from Loading, retry → Loading |

---

## 🧭 Navigation

| From | To | Trigger | Route | Animation |
|------|----|---------|-------|-----------|
| [Screen] | [Screen] | [Tap] | `/[route]` | [Default/Custom] |
| [Screen] | [Sheet] | [Tap] | bottom sheet | slide up |

---

## ♿ Accessibility

- [ ] All interactive elements have semantic labels
- [ ] Minimum 44dp touch targets (NFR8)
- [ ] WCAG AA contrast compliance (NFR7)
- [ ] Screen reader navigation order is logical
- [ ] Focus management on sheet open/close

---

## 🧪 Presentation Layer Tests

| Test File | Tests | Story |
|-----------|-------|-------|
| `test/features/[feature]/presentation/pages/[page]_test.dart` | Widget rendering, state handling | [X.N] |
| `test/features/[feature]/presentation/widgets/[widget]_test.dart` | Component behavior, interaction | [X.N] |
| `test/features/[feature]/presentation/providers/[provider]_test.dart` | State transitions, side effects | [X.N] |

---

## ✅ Implementation Checklist

- [ ] ALL screens from spec.md created ([N]/[N])
- [ ] ALL widgets created and functional
- [ ] ALL Riverpod providers wired with @riverpod
- [ ] ALL UI states handled (loading, loaded, empty, error)
- [ ] ALL user interactions trigger correct provider methods
- [ ] ALL navigation routes configured in go_router
- [ ] ALL UX-DR requirements implemented
- [ ] ALL accessibility requirements met
- [ ] Completion animation (400ms, durationSlow) where specified
- [ ] Design system tokens used (no hardcoded colors/spacing)
- [ ] ALL presentation tests passing
- [ ] No imports from data layer
- [ ] flutter analyze: No issues in presentation layer files

---

## 📝 Implementation Order

1. **Providers first** — Define state management structure
2. **Widgets second** — Build reusable components
3. **Pages last** — Compose screens from widgets + providers
4. **Navigation** — Wire routes after all pages exist
