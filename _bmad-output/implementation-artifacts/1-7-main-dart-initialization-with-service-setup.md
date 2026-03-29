---
storyId: 1.7
storyKey: 1-7-main-dart-initialization-with-service-setup
epicId: 1
projectName: TooXTips
date: 2026-03-29
status: ready-for-dev
---

# Story 1.7: Main.dart Initialization with Service Setup

## Story Statement

As a developer,
I want to initialize main.dart with proper sequencing for WidgetsFlutterBinding, BackgroundTaskService, and NotificationService,
So that all services are ready before the app runs.

## Acceptance Criteria

**Given** all services from previous stories
**When** I create `main.dart` with initialization sequence
**Then** WidgetsFlutterBinding.ensureInitialized() is called first
**And** BackgroundTaskService.initialize() is called before runApp
**And** NotificationService.initialize() is called before runApp
**And** ProviderScope wraps the entire app
**And** ThemeMode.dark is hardcoded as default
**And** the app launches without errors

## Technical Requirements

### Initialization Sequence

The main.dart file must follow this exact sequence:

1. Call `WidgetsFlutterBinding.ensureInitialized()` first
2. Call `BackgroundTaskService.initialize()` before runApp
3. Call `NotificationService.initialize()` before runApp
4. Call `runApp()` with ProviderScope wrapper
5. Set ThemeMode.dark as hardcoded default

### Main App Structure

```dart
void main() async {
  // Step 1: Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Step 2: Initialize background task service
  await BackgroundTaskService.initialize();
  
  // Step 3: Initialize notification service
  await NotificationService.initialize();
  
  // Step 4: Run app with Riverpod ProviderScope
  runApp(const ProviderScope(child: TooXTipsApp()));
}
```

### App Widget Structure

```dart
class TooXTipsApp extends StatelessWidget {
  const TooXTipsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TooXTips',
      theme: darkTheme,  // From Story 1.3
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,  // Hardcoded dark mode default
      home: const AppShell(),  // Main app shell (created in later stories)
    );
  }
}
```

### Service Initialization Stubs

For now, create stub implementations of services:

**BackgroundTaskService** (`lib/core/services/background_task_service.dart`):

```dart
class BackgroundTaskService {
  static Future<void> initialize() async {
    // Stub implementation for now
    // Full implementation in Story 5.3
  }
}
```

**NotificationService** (`lib/core/services/notification_service.dart`):

```dart
class NotificationService {
  static Future<void> initialize() async {
    // Stub implementation for now
    // Full implementation in Story 5.5
  }
}
```

### App Shell Stub

Create a temporary app shell (`lib/app/app_shell.dart`):

```dart
class AppShell extends StatelessWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TooXTips')),
      body: const Center(child: Text('App Shell - Ready for Features')),
    );
  }
}
```

## Implementation Details

### File Structure

Create/modify these files:

1. `lib/main.dart` - Main entry point with initialization
2. `lib/app/app.dart` - TooXTipsApp widget
3. `lib/app/app_shell.dart` - Temporary app shell
4. `lib/core/services/background_task_service.dart` - Stub service
5. `lib/core/services/notification_service.dart` - Stub service

### Key Constraints

- WidgetsFlutterBinding MUST be initialized first
- Services MUST be initialized before runApp
- ProviderScope MUST wrap the entire app
- ThemeMode.dark MUST be hardcoded as default
- No light mode toggle in main.dart (handled in Story 1.3)
- All services MUST be async (use `await`)
- App MUST launch without errors

### Verification Steps

1. Create `lib/main.dart` with initialization sequence
2. Create `lib/app/app.dart` with TooXTipsApp widget
3. Create `lib/app/app_shell.dart` with temporary shell
4. Create service stub files
5. Run `flutter pub get` to ensure dependencies are available
6. Run `flutter analyze` to check for errors
7. Run `flutter run` to verify app launches
8. Verify app displays without errors
9. Verify dark mode is active by default

## Success Criteria

- ✓ main.dart created with correct initialization sequence
- ✓ WidgetsFlutterBinding.ensureInitialized() called first
- ✓ BackgroundTaskService.initialize() called before runApp
- ✓ NotificationService.initialize() called before runApp
- ✓ ProviderScope wraps entire app
- ✓ ThemeMode.dark hardcoded as default
- ✓ TooXTipsApp widget created
- ✓ AppShell widget created (temporary)
- ✓ Service stub files created
- ✓ App compiles without errors
- ✓ App launches and displays
- ✓ Dark mode is active by default
- ✓ Ready for feature development (Epics 2-6)

## Dependencies

- Depends on: Story 1.1 (Project Setup), Story 1.2 (Design Tokens), Story 1.3 (Theme System), Story 1.4 (Database), Story 1.5 (AI Provider), Story 1.6 (Conventions)
- Blocks: All subsequent epics (2-6)

## Notes

- This is the final story of Epic 1 (Foundation)
- After this story completes, Epic 1 is complete and all other epics can begin
- Service stubs will be fully implemented in later stories
- AppShell is temporary and will be replaced with proper navigation in later stories
- The initialization sequence is critical; do not change the order
- All services must be async to allow proper initialization
