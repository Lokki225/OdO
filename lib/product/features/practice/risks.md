# Practice Module — Risks

## R1 — Schema Migration Breaking Existing Data
**Description:** Bumping `schemaVersion` from 1 to 2 and adding columns via `onUpgrade` migration; if any existing column default is wrong or a column is added to the wrong table, production data could be silently corrupted or migration could throw.
**Probability:** Medium
**Impact:** High (data loss, forced reinstall)
**Severity:** Critical
**Mitigation:** Test migration explicitly with `NativeDatabase.memory()` pre-seeded at schemaVersion 1 then migrated to 2; verify all new column defaults using SQL `PRAGMA table_info`. Use `m.addColumn(table, column)` not raw SQL.
**Contingency:** Ship with `MigrationStrategy.onUpgrade` guarded by `from < 2 && to >= 2` version check; if migration fails, fall back to `m.recreateAllViews()` (no user data yet in practice tables).

---

## R2 — Drift Code-Gen Mismatch After Schema Change
**Description:** Editing table files and re-running `build_runner` may produce stale `.g.dart` files if conflicting outputs exist, causing compile errors or silent field mismatches.
**Probability:** Medium
**Impact:** Medium (build fails, no runtime data loss)
**Severity:** Major
**Mitigation:** Always run `flutter pub run build_runner build --delete-conflicting-outputs` after any table edit. Verify generated companion classes include all new fields before proceeding.
**Contingency:** Delete `.dart_tool/build/` cache and regenerate from scratch.

---

## R3 — JSON Round-Trip Failure for mode_tags
**Description:** `mode_tags` is stored as a JSON text column and deserialized via `jsonDecode` → `List<String>`. If the DB stores a malformed string (e.g., a plain string instead of a JSON array from a migration bug), `jsonDecode` will throw a `FormatException` at runtime.
**Probability:** Low
**Impact:** High (crash on skill load)
**Severity:** Major
**Mitigation:** `SessionMapper.fromRow` wraps decode in try/catch; on failure returns empty list. Null column value always → empty list (never throws). Test null, empty `[]`, valid array, and malformed inputs explicitly.
**Contingency:** Add a DB migration step that coerces any non-null, non-JSON value in `mode_tags` to `'[]'`.

---

## R4 — Transaction Atomicity for addSession + updateSessionsCount
**Description:** `addSession` must atomically insert the session row AND update `last_session_at` + `sessions_since_level_update` on the parent skill. If this is not inside a single `db.transaction()`, a crash between the two writes leaves inconsistent data.
**Probability:** Low
**Impact:** Medium (stale streak/level data until next session)
**Severity:** Moderate
**Mitigation:** Implement using `database.transaction(() async { ... })` in `PracticeRepositoryImpl.addSession`. Test this atomicity by verifying skill counters immediately after `addSession` in integration tests.
**Contingency:** A repair migration at next launch that recomputes `sessions_since_level_update` from session count for each skill.

---

## R5 — Domain Purity Leakage
**Description:** Domain files (`lib/features/practice/domain/`) might accidentally import `drift`, `flutter`, or `data/` packages (violating QR3), which compiles fine but breaks the Clean Architecture contract.
**Probability:** Low
**Impact:** Low (architecture violation, no runtime bug)
**Severity:** Minor
**Mitigation:** After writing each domain file, run `flutter analyze` and check import list manually. CI lint rule: domain files must not contain `import 'package:drift'` or `import 'package:flutter'` (except `foundation.dart`).
**Contingency:** Refactor the leaking import before marking story complete.

---

## R6 — SkillType Unknown Value at Runtime
**Description:** If a future story or migration writes an unrecognized string to `skills.type`, `SkillMapper.fromRow` will throw `ArgumentError`. This crashes the `watchAllSkills` stream, taking down the entire Practice tab.
**Probability:** Low (single-device, no sync)
**Impact:** High (feature unavailable)
**Severity:** Major
**Mitigation:** `ArgumentError` is intentional and documented (EC3); however, `PracticeRepositoryImpl.watchAllSkills` must catch the stream error and emit an empty list rather than propagating the exception.
**Contingency:** Add a DB validation step at app startup that logs any skill with an unrecognized type.
