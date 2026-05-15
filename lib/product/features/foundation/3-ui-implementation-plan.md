# Foundation Epic — UI Implementation Plan

## Scope

The Foundation UI covers Story 1.1 (app scaffold), Story 1.3 (theme system), and Story 1.8 (router and project structure). These create the visible shell of OdO: a compilable app with dark OLED background, 5-tab bottom nav, and stub content per tab.

---

## Screen List

| Screen | File | Story | Description |
|--------|------|-------|-------------|
| OdoApp (root) | `lib/app/app.dart` | 1.1 | MaterialApp + ProviderScope + GoRouter |
| Home stub | `lib/features/home/presentation/home_page.dart` | 1.8 | Placeholder scaffold for Home tab |
| Agenda stub | `lib/features/agenda/presentation/agenda_page.dart` | 1.8 | Placeholder scaffold for Agenda tab |
| Practice stub | `lib/features/practice/presentation/practice_page.dart` | 1.8 | Placeholder scaffold for Practice tab |
| Insights stub | `lib/features/home/presentation/insights_page.dart` | 1.8 | Placeholder scaffold for Insights tab |
| Profile stub | `lib/features/settings/presentation/profile_page.dart` | 1.8 | Placeholder scaffold for Profile/Settings tab |
| Shell | Inline in `router.dart` | 1.8 | go_router ShellRoute with NavigationBar |

---

## Widget List

| Widget | File | Responsibility |
|--------|------|----------------|
| `OdoApp` | `lib/app/app.dart` | Root widget; wires MaterialApp with theme and router |
| `OdoShell` | `lib/app/router.dart` (or `lib/app/shell.dart`) | go_router ShellRoute body; renders `NavigationBar` + indexed page |
| Stub tab pages | per feature | Empty `Scaffold` with a centered Text label; no business logic |

---

## Provider List

| Provider | Type | File | Story | Purpose |
|----------|------|------|-------|---------|
| `activeThemeProvider` | `StateProvider<OdoTheme>` | `lib/app/theme.dart` | 1.3 | Active theme preset; default `OdoTheme.violetDark` |
| `appRouterProvider` | `Provider<GoRouter>` | `lib/app/router.dart` | 1.8 | Singleton GoRouter instance; needed for deep linking |

---

## Theme System (Story 1.3)

### OdoTheme enum

```dart
enum OdoTheme { violetDark, cyanDark, greenDark, lightMode, cosmic, ember, aurora }
```

### Two-layer token system

**Layer 1 — Raw palette** (`lib/core/constants/app_colors.dart`):
Never used directly in widgets. Only `AppTheme` reads these.

```dart
abstract class RawPalette {
  static const oledBlack = Color(0xFF0D0D0F);
  static const amberAccent = Color(0xFFC4956A);
  static const violetAccent = Color(0xFF7C4DFF);
  static const greenAccent = Color(0xFF1D9E75);
  // ... all 7 theme raw colors
}
```

**Layer 2 — Semantic tokens** (via ThemeData extensions or theme.colorScheme):
Always used in widgets. Key tokens:

| Token | Dark default | Light default | Description |
|-------|-------------|---------------|-------------|
| `colorBackground` | `#0D0D0F` | `#FDF8F2` | App background (OLED optimized) |
| `colorSurface` | `#1A1A1E` | `#FFFFFF` | Card backgrounds |
| `colorSurfaceVariant` | `#2A2A2F` | `#F5EFE6` | Secondary card bg |
| `colorPrimary` (accent) | Per theme | Per theme | Amber/violet/green per active theme |
| `colorTextPrimary` | `#F5F0E8` | `#1A1209` | Body text |
| `colorTextMuted` | `#8A8490` | `#6B5B45` | Secondary text |
| `colorOutline` | `#3A3A42` | `#D4C5B0` | 1px card borders |
| `aiSurface` | `#1E1A2E` | `#2A1F4E` | AI card background (always dark) |

### ThemeData construction

**File:** `lib/app/theme.dart`

```dart
class AppTheme {
  static ThemeData buildTheme(OdoTheme preset, Brightness brightness) {
    // Returns ThemeData with all semantic tokens as ColorScheme
    // Uses Fraunces + DM Sans via google_fonts (in Story 1.3)
    // Includes FontFeature.tabularFigures() in monospace/clock text styles
  }

  static ThemeData get violetDarkTheme => buildTheme(OdoTheme.violetDark, Brightness.dark);
  // ... all 7 presets
}
```

---

## Navigation (Story 1.8)

### go_router Configuration

**File:** `lib/app/router.dart`

```
Routes:
  /glance                        — Glance Screen (Story 5.1)
  /home (shell)                  — 5-tab shell
    /home/home                   — Home tab
    /home/agenda                 — Agenda tab
    /home/practice               — Practice tab
    /home/insights               — Insights tab
    /home/profile                — Profile/Settings tab
  /home/agenda/event/:id         — Event detail (Story 2.4)
  /home/agenda/new               — New event (Story 2.4)
  /home/practice/session/:id     — Session log (Story 3.4)
  /home/ai/chat                  — Chat sheet (Story 4.3)
  /home/evening                  — Evening session (Story 5.4)
  /onboarding                    — First-launch flow (Story 6.7)
```

**Tab index → route mapping:**

| Index | Tab | Route | Icon |
|-------|-----|-------|------|
| 0 | Home | `/home/home` | home_outlined |
| 1 | Agenda | `/home/agenda` | calendar_today_outlined |
| 2 | Practice | `/home/practice` | self_improvement_outlined |
| 3 | Insights | `/home/insights` | insights_outlined |
| 4 | Profile | `/home/profile` | person_outline |

**Key rules:**
- Bottom sheets are routes (e.g. `/home/ai/chat`), not `showModalBottomSheet` calls
- Navigation pushes go through `context.go()` or `context.push()` — never `Navigator.push`
- `GoRouter.redirect` used for onboarding gate check (Story 6.7)

---

## All UI States

| State | Behavior | Applies To |
|-------|----------|-----------|
| Loading | Tab renders immediately — no skeleton at shell level | Shell (Story 1.8) |
| Empty (tab content) | Stub text label centered — content populated by Epics 2–5 | All stubs |
| Error | Not applicable for scaffold stubs | — |
| First launch | Redirect to `/onboarding` via GoRouter redirect (Story 6.7) | Router |

---

## `main.dart` Implementation

**File:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:odo/app/app.dart';
import 'package:odo/core/services/background_task_service.dart';
import 'package:odo/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  tz.initializeTimeZones();
  await BackgroundTaskService.initialize();
  await NotificationService.initialize();
  runApp(const ProviderScope(child: OdoApp()));
}
```

---

## Architectural Alignment

- `lib/app/` files (`app.dart`, `theme.dart`, `router.dart`) import from `lib/core/` and `lib/features/[feature]/presentation/` only
- No widget imports from `lib/features/[feature]/data/`
- `OdoApp` is a `ConsumerWidget` that watches `activeThemeProvider`
- Theme switching at runtime: changing `activeThemeProvider` causes `MaterialApp.theme` to rebuild — no app restart

---

## Story → File Mapping

| Story | Files Created |
|-------|-------------|
| 1.1 | `lib/main.dart`, `lib/app/app.dart`, `lib/app/theme.dart` (placeholder), `lib/app/router.dart` (stub), all feature/core dir stubs |
| 1.2 | `lib/core/constants/app_colors.dart`, `lib/core/constants/app_spacing.dart`, `lib/core/constants/app_typography.dart` |
| 1.3 | `lib/app/theme.dart` (full), `lib/core/constants/app_colors.dart` (full 7-theme palettes) |
| 1.4 | `lib/core/database/app_database.dart`, `lib/core/database/database_providers.dart`, all 6 DAO files |
| 1.5 | `lib/core/services/ai_provider.dart`, all 5 provider impls |
| 1.6 | `lib/core/services/locale_service.dart`, `notification_service.dart`, `background_task_service.dart`, `connectivity_service.dart`, `voice_service.dart` |
| 1.7 | `lib/core/types/result.dart`, `lib/core/types/app_failure.dart` |
| 1.8 | `lib/app/router.dart` (full), all 5 stub tab page files |
