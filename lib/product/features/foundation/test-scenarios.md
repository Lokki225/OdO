# Foundation Epic — Test Scenarios

## TS-001: pubspec.yaml dependency resolution

**ID:** TS-001  
**Title:** All 23 dependencies resolve without conflicts  
**Preconditions:** Flutter SDK ≥3.22 installed; network connectivity available  
**Input:** Run `flutter pub get` from project root  
**Expected Output:** Exit code 0; `pubspec.lock` created/updated; no "version solving failed" or "no matching version" messages  
**Validation Rule:** `flutter pub get` exit code must be 0  
**Test Type:** Integration

---

## TS-002: build_runner code generation

**ID:** TS-002  
**Title:** build_runner generates .g.dart files without errors  
**Preconditions:** `flutter pub get` succeeded; at least one `@riverpod` annotation or Drift table exists in lib/  
**Input:** Run `dart run build_runner build`  
**Expected Output:** Exit code 0; `.g.dart` files generated for all annotated files; no "conflicting outputs" error  
**Validation Rule:** `dart run build_runner build` exit code = 0; generated files exist  
**Test Type:** Integration

---

## TS-003: flutter analyze clean

**ID:** TS-003  
**Title:** No lint warnings or errors on any file in lib/  
**Preconditions:** All product layer and lib/ files written  
**Input:** Run `flutter analyze`  
**Expected Output:** "No issues found!"  
**Validation Rule:** Output contains exactly "No issues found!"  
**Test Type:** Quality

---

## TS-004: Android debug build

**ID:** TS-004  
**Title:** App compiles to APK without errors  
**Preconditions:** Android SDK installed; `flutter pub get` succeeded  
**Input:** Run `flutter build apk --debug`  
**Expected Output:** Exit code 0; `.apk` file created in `build/app/outputs/`  
**Validation Rule:** Exit code 0; APK file exists  
**Test Type:** Integration

---

## TS-005: main.dart initialization order

**ID:** TS-005  
**Title:** Services initialize in correct order before runApp  
**Preconditions:** `lib/main.dart` written; stub service classes exist  
**Input:** Unit test with mocked service initializers, call sequence recorder  
**Expected Output:** Call order: (1) `ensureInitialized`, (2) `tz.initializeTimeZones`, (3) `BackgroundTaskService.initialize`, (4) `NotificationService.initialize`, (5) `runApp`  
**Validation Rule:** Recorded call sequence matches expected order exactly  
**Test Type:** Unit

---

## TS-006: Android manifest permissions

**ID:** TS-006  
**Title:** AndroidManifest.xml contains all 7 required permissions  
**Preconditions:** `AndroidManifest.xml` edited with permissions  
**Input:** Parse `android/app/src/main/AndroidManifest.xml`  
**Expected Output:** All 7 `<uses-permission>` elements found: RECORD_AUDIO, USE_BIOMETRIC, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, WAKE_LOCK, VIBRATE, INTERNET  
**Validation Rule:** All 7 permission strings present in file  
**Test Type:** Unit (file content assertion)

---

## TS-007: iOS Info.plist required keys

**ID:** TS-007  
**Title:** Info.plist contains all 4 required entries  
**Preconditions:** `ios/Runner/Info.plist` edited  
**Input:** Parse `ios/Runner/Info.plist`  
**Expected Output:** Keys present: NSMicrophoneUsageDescription, NSSpeechRecognitionUsageDescription, NSFaceIDUsageDescription; UIBackgroundModes array contains "fetch" and "processing"  
**Validation Rule:** All 4 entries verified in plist  
**Test Type:** Unit (file content assertion)

---

## TS-008: Project folder structure

**ID:** TS-008  
**Title:** All required directories exist in lib/  
**Preconditions:** Folder scaffold task complete  
**Input:** Directory existence checks  
**Expected Output:** All of the following exist: `lib/app/`, `lib/core/constants/`, `lib/core/database/`, `lib/core/services/`, `lib/core/types/`, `lib/core/domain/`, `lib/core/widgets/`, `lib/core/utils/`, `lib/features/glance/data/`, `lib/features/glance/domain/`, `lib/features/glance/presentation/`, `lib/features/home/presentation/`, `lib/features/agenda/data/`, `lib/features/agenda/domain/`, `lib/features/agenda/presentation/`, `lib/features/practice/data/`, `lib/features/practice/domain/`, `lib/features/practice/presentation/`, `lib/features/ai/data/`, `lib/features/ai/domain/`, `lib/features/ai/presentation/`, `lib/features/evening_session/data/`, `lib/features/evening_session/domain/`, `lib/features/evening_session/presentation/`, `lib/features/settings/data/`, `lib/features/settings/presentation/`  
**Validation Rule:** All directories exist (`.gitkeep` files acceptable)  
**Test Type:** Unit (filesystem assertion)

---

## TS-009: CONVENTIONS.md exists with required sections

**ID:** TS-009  
**Title:** CONVENTIONS.md at repo root with all required content sections  
**Preconditions:** CONVENTIONS.md created  
**Input:** Parse file content  
**Expected Output:** File contains all of: "Clean Architecture", "import rules", "Riverpod", "AsyncNotifier", "naming conventions", "snake_case", "PascalCase", "flutter analyze", "dart-define"  
**Validation Rule:** All keyword strings present in file  
**Test Type:** Unit (file content assertion)

---

## TS-010: minSdkVersion is 21

**ID:** TS-010  
**Title:** Android build.gradle has minSdkVersion 21  
**Preconditions:** `android/app/build.gradle` written  
**Input:** Read `android/app/build.gradle`  
**Expected Output:** `minSdkVersion 21` (or `minSdk = 21` for newer AGP) found  
**Validation Rule:** minSdkVersion value ≥ 21  
**Test Type:** Unit (file content assertion)

---

## TS-011: .env not committed

**ID:** TS-011  
**Title:** .gitignore prevents .env from being committed  
**Preconditions:** `.gitignore` written; `.env` is in `.gitignore`  
**Input:** Parse `.gitignore`; check if `.env` pattern is present  
**Expected Output:** `.gitignore` contains `.env` entry; `.env.example` is NOT in `.gitignore`  
**Validation Rule:** `.env` pattern present in `.gitignore`; `.env.example` not in `.gitignore`  
**Test Type:** Unit (file content assertion)

---

## TS-012: OdoApp renders without crash

**ID:** TS-012  
**Title:** Widget test: OdoApp renders 5-tab bottom nav  
**Preconditions:** `lib/app/app.dart` written with stub router  
**Input:** `testWidgets('OdoApp renders', (tester) async { await tester.pumpWidget(const ProviderScope(child: OdoApp())); })`  
**Expected Output:** No exceptions; widget tree renders; `BottomNavigationBar` or `NavigationBar` found in tree  
**Validation Rule:** `expect(find.byType(NavigationBar), findsOneWidget)` passes (or BottomNavigationBar)  
**Test Type:** Widget (unit)
