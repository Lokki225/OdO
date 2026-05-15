# Foundation Epic — Risks

## Risk 1: Dependency Version Conflicts

**Description:** The 19 runtime dependencies may have transitive conflicts. Drift ^2.18.0 and drift_dev ^2.18.0 must be version-aligned; similarly, `build_runner` must be compatible with both `riverpod_generator` and `drift_dev`.

**Probability:** Low (versions are pinned from architecture.md which was authored with compatibility in mind)

**Impact:** High (blocks entire foundation; no code can be written until `pub get` succeeds)

**Severity:** High

**Mitigation:** Use exact minor versions from architecture.md. Run `flutter pub get` before writing any Dart code. If conflict occurs, downgrade the conflicting package by one minor version.

**Contingency:** Run `flutter pub deps` to identify the conflict tree. Check pub.dev for compatible version matrix. Escalate to Franklin if unresolvable.

---

## Risk 2: Dart SDK Version Incompatibility

**Description:** Sealed classes (used for `Result<T, F>`) require Dart 3.0+. If the installed Flutter SDK ships with Dart 2.x, code generation and sealed class syntax will fail.

**Probability:** Low (Flutter 3.22+ ships Dart 3.x, but CI environments may have older versions)

**Impact:** High (prevents compilation; sealed classes are used throughout)

**Severity:** High

**Mitigation:** Enforce `environment.sdk: ">=3.0.0 <4.0.0"` in `pubspec.yaml`. Run `dart --version` at the start and confirm ≥3.0.0.

**Contingency:** Update Flutter SDK via `flutter upgrade`. If constrained environment, replace sealed classes with abstract classes + factory pattern as a temporary workaround (escalate to Franklin).

---

## Risk 3: workmanager BroadcastReceiver Misconfiguration

**Description:** If the workmanager `BroadcastReceiver` element is placed outside the `<application>` tag, or if the `CallbackDispatcher` is not registered, the 8pm background task will fail silently on Android. There is no runtime error — the task simply never fires.

**Probability:** Medium (easy to place in wrong XML location)

**Impact:** High (Story 5.8 background tasks, 8pm evening session trigger — core product feature)

**Severity:** High

**Mitigation:** Follow the workmanager README exactly. Place receiver inside `<application>`. Write a test that verifies the manifest entry exists in the correct location.

**Contingency:** The architecture already defines a fallback: if the user opens the app between 8pm and midnight with no session delivered, the session surfaces inline. This covers silent background failure.

---

## Risk 4: iOS UIBackgroundModes Missing

**Description:** If `UIBackgroundModes` is not added to `Info.plist` with `fetch` and `processing` modes, iOS will not wake the app for background tasks. No error is reported — tasks simply don't fire.

**Probability:** Medium (Info.plist is edited manually; easy to omit)

**Impact:** Medium (iOS background task for 8pm session fails silently; fallback exists)

**Severity:** Medium

**Mitigation:** Add `UIBackgroundModes` as an array with both `fetch` and `processing` strings. Verify with `plutil -p ios/Runner/Info.plist | grep -A 5 UIBackgroundModes`.

**Contingency:** Same app-open fallback as Risk 3. The feature degrades gracefully.

---

## Risk 5: sqlite3_flutter_libs Requires minSdkVersion 21

**Description:** `sqlite3_flutter_libs` requires Android `minSdkVersion` ≥ 21. `flutter create` defaults to `minSdkVersion 16` or `19`. The app will fail to build on Android if this is not corrected.

**Probability:** High (this is a known, documented requirement of the package)

**Impact:** High (blocks Android build entirely)

**Severity:** High

**Mitigation:** Immediately after `flutter create`, update `android/app/build.gradle`: change `minSdkVersion` to 21.

**Contingency:** N/A — this is a hard package requirement with no workaround.

---

## Risk 6: build_runner Conflicting Outputs

**Description:** If a `.g.dart` file is committed but then `build_runner` regenerates it with different content, git merge conflicts can occur. If both `drift_dev` and `riverpod_generator` target the same file patterns, a "conflicting outputs" error stops code generation.

**Probability:** Low (only occurs if build is run twice with different inputs)

**Impact:** Medium (blocks feature code until resolved)

**Severity:** Medium

**Mitigation:** Add `*.g.dart` to `.gitignore`. Generated files should never be committed. Add a `build.yaml` if output conflicts need resolution.

**Contingency:** Delete all `.g.dart` files and re-run `dart run build_runner build --delete-conflicting-outputs`.
