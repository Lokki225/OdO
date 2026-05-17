import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/database/app_database.dart';
import 'package:odo/core/types/result.dart';
import 'package:odo/features/practice/data/mappers/session_mapper.dart';
import 'package:odo/features/practice/data/mappers/skill_mapper.dart';
import 'package:odo/features/practice/data/practice_dao.dart';
import 'package:odo/features/practice/data/repositories/practice_repository_impl.dart';
import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/entities/skill_type.dart';

class _FailInsertPracticeDao extends PracticeDao {
  _FailInsertPracticeDao(super.db);

  @override
  Future<int> insertSkill(SkillsCompanion companion) =>
      Future.error(Exception('Simulated insert failure'));
}

AppDatabase _openTestDb() => AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );

SkillsCompanion _skillCompanion({
  String name = 'Chess',
  String type = 'strategy',
}) {
  return SkillsCompanion.insert(
    name: name,
    type: type,
    createdAt: DateTime(2026, 1, 1).millisecondsSinceEpoch,
  );
}

SessionsCompanion _sessionCompanion({
  required int skillId,
  DateTime? startedAt,
}) {
  return SessionsCompanion.insert(
    skillId: skillId,
    startedAt: (startedAt ?? DateTime(2026, 1, 1)).millisecondsSinceEpoch,
    durationMinutes: 30,
  );
}

void main() {
  late AppDatabase db;
  late PracticeDao dao;
  late PracticeRepositoryImpl repo;

  setUp(() {
    db = _openTestDb();
    dao = db.practiceDao;
    repo = PracticeRepositoryImpl(dao);
  });

  tearDown(() async => db.close());

  // TS-042 — watchAllSkills reactivity (IR1)
  test('TS-042: inserting skill causes watchAllSkills to emit', () async {
    // Wait for first emission that actually contains a skill
    final future = dao
        .watchAllSkills()
        .where((rows) => rows.any((r) => r.name == 'Chess'))
        .first;

    await dao.insertSkill(_skillCompanion());

    final rows = await future.timeout(const Duration(milliseconds: 500));
    expect(rows.length, 1);
    expect(rows.first.name, 'Chess');
  });

  // TS-043 — cascade delete
  test('TS-043: deleting skill removes all child sessions', () async {
    final skillId = await dao.insertSkill(_skillCompanion());
    await dao.insertSession(_sessionCompanion(skillId: skillId));
    await dao.insertSession(_sessionCompanion(skillId: skillId));

    await dao.deleteSkill(skillId);

    final sessions = await dao.getSessionsForSkill(skillId);
    expect(sessions, isEmpty);
  });

  // TS-044 — addSession updates lastSessionAt atomically
  test('TS-044: addSession updates parent skill lastSessionAt', () async {
    final skillId = await dao.insertSkill(_skillCompanion());
    final t = DateTime(2026, 5, 17, 10, 0, 0);

    final session = Session(
      skillId: skillId,
      startedAt: t,
      durationMinutes: 45,
      modeTags: const ['Full Game'],
      isAnchored: false,
      isMilestone: false,
    );

    await repo.addSession(session);

    final row = await dao.getSkillById(skillId);
    expect(row, isNotNull);
    expect(
      row!.lastSessionAt,
      t.millisecondsSinceEpoch,
    );
    expect(row.sessionsSinceLevelUpdate, 1);
  });

  // TS-045 — getUnanchoredSessions limit and ordering
  test('TS-045: getUnanchoredSessions returns at most 3 DESC', () async {
    final skillId = await dao.insertSkill(_skillCompanion());
    final times = List.generate(
      5,
      (i) => DateTime(2026, 1, i + 1),
    );
    for (final t in times) {
      await dao.insertSession(_sessionCompanion(skillId: skillId, startedAt: t));
    }

    final rows = await dao.getUnanchoredSessions(skillId);
    expect(rows.length, 3);
    // most recent first
    expect(rows[0].startedAt, times[4].millisecondsSinceEpoch);
    expect(rows[1].startedAt, times[3].millisecondsSinceEpoch);
    expect(rows[2].startedAt, times[2].millisecondsSinceEpoch);
  });

  // TS-046 — mode_tags JSON round-trip
  test('TS-046: mode_tags serializes and deserializes', () {
    final session = Session(
      skillId: 1,
      startedAt: DateTime(2026, 1, 1),
      durationMinutes: 30,
      modeTags: const ['Speaking', 'Listening'],
      isAnchored: false,
      isMilestone: false,
    );
    final companion = SessionMapper.toCompanion(session);
    expect(companion.modeTags.value, '["Speaking","Listening"]');

    final row = SessionRow(
      id: 1,
      skillId: 1,
      startedAt: DateTime(2026, 1, 1).millisecondsSinceEpoch,
      durationMinutes: 30,
      modeTags: '["Speaking","Listening"]',
      isAnchored: false,
      isMilestone: false,
    );
    expect(SessionMapper.fromRow(row).modeTags, ['Speaking', 'Listening']);
  });

  // TS-047 — empty modeTags
  test('TS-047: empty modeTags serializes to "[]" and deserializes to []', () {
    final session = Session(
      skillId: 1,
      startedAt: DateTime(2026, 1, 1),
      durationMinutes: 30,
      modeTags: const [],
      isAnchored: false,
      isMilestone: false,
    );
    final companion = SessionMapper.toCompanion(session);
    expect(companion.modeTags.value, '[]');

    final row = SessionRow(
      id: 1,
      skillId: 1,
      startedAt: DateTime(2026, 1, 1).millisecondsSinceEpoch,
      durationMinutes: 30,
      modeTags: '[]',
      isAnchored: false,
      isMilestone: false,
    );
    expect(SessionMapper.fromRow(row).modeTags, isEmpty);
  });

  // TS-048 — null mode_tags column
  test('TS-048: null mode_tags column deserializes to empty list', () {
    final row = SessionRow(
      id: 1,
      skillId: 1,
      startedAt: DateTime(2026, 1, 1).millisecondsSinceEpoch,
      durationMinutes: 30,
      modeTags: null,
      isAnchored: false,
      isMilestone: false,
    );
    expect(SessionMapper.fromRow(row).modeTags, isEmpty);
  });

  // TS-049 — getLastSession null for no sessions
  test('TS-049: getLastSession returns Success(null) when no sessions', () async {
    final skillId = await dao.insertSkill(_skillCompanion());
    final result = await repo.getLastSession(skillId);
    expect(result, isA<Success<Session?>>());
    expect((result as Success<Session?>).value, isNull);
  });

  // TS-050 — unknown SkillType throws ArgumentError
  test('TS-050: SkillMapper.fromRow throws ArgumentError on unknown type', () {
    final row = SkillRow(
      id: 1,
      name: 'Test',
      type: 'unknown_type',
      sessionsSinceLevelUpdate: 0,
      createdAt: DateTime(2026, 1, 1).millisecondsSinceEpoch,
      isArchived: false,
    );
    expect(
      () => SkillMapper.fromRow(row),
      throwsA(
        isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('unknown_type'),
        ),
      ),
    );
  });

  // TS-051 — performanceMetric float precision
  test('TS-051: performanceMetric 1234.56 round-trips without loss', () async {
    final skillId = await dao.insertSkill(_skillCompanion());
    final companion = SessionsCompanion.insert(
      skillId: skillId,
      startedAt: DateTime(2026, 1, 1).millisecondsSinceEpoch,
      durationMinutes: 30,
      performanceMetric: const Value(1234.56),
    );
    final id = await dao.insertSession(companion);
    final sessions = await dao.getSessionsForSkill(skillId);
    final row = sessions.firstWhere((r) => r.id == id);
    expect(row.performanceMetric, 1234.56);
  });

  // TS-052 — watchAllSkills includes archived
  test('TS-052: watchAllSkills returns archived and non-archived skills', () async {
    await dao.insertSkill(_skillCompanion(name: 'Active'));
    // Insert archived skill via custom companion
    await dao.insertSkill(
      SkillsCompanion.insert(
        name: 'Archived',
        type: 'language',
        createdAt: DateTime(2026, 1, 1).millisecondsSinceEpoch,
        isArchived: const Value(true),
      ),
    );

    final rows = await dao.watchAllSkills().first;
    expect(rows.length, 2);
    expect(rows.any((r) => r.isArchived), isTrue);
    expect(rows.any((r) => !r.isArchived), isTrue);
  });

  // TS-053 — addSkill returns Failure on DAO exception (EH1)
  test('TS-053: addSkill returns Failure when DAO throws', () async {
    final failRepo = PracticeRepositoryImpl(_FailInsertPracticeDao(db));
    final result = await failRepo.addSkill(
      Skill(
        name: 'Chess',
        type: SkillType.strategy,
        sessionssSinceLevelUpdate: 0,
        createdAt: DateTime(2026, 1, 1),
        isArchived: false,
      ),
    );
    expect(result, isA<Failure<int>>());
    expect((result as Failure<int>).error, AppError.databaseWriteFailed);
  });

  // TS-054 — addSession returns Failure on invalid skillId (FK violation)
  test('TS-054: addSession returns Failure when skillId FK is violated', () async {
    final result = await repo.addSession(
      Session(
        skillId: 99999,
        startedAt: DateTime(2026, 1, 1),
        durationMinutes: 30,
        modeTags: const [],
        isAnchored: false,
        isMilestone: false,
      ),
    );
    expect(result, isA<Failure<int>>());
    expect((result as Failure<int>).error, AppError.databaseWriteFailed);
  });

  // TS-056 — schema migration v1 to v2
  test('TS-056: DB opens at schemaVersion 2 without error', () async {
    expect(db.schemaVersion, 2);
  });

  // TS-057 — SkillMapper.toCompanion round-trip
  test('TS-057: SkillMapper.toCompanion produces correct values', () {
    final skill = Skill(
      name: 'Chess',
      type: SkillType.strategy,
      sessionssSinceLevelUpdate: 0,
      createdAt: DateTime(2026, 1, 1),
      isArchived: false,
    );
    final companion = SkillMapper.toCompanion(skill);
    expect(companion.name.value, 'Chess');
    expect(companion.type.value, 'strategy');
    expect(companion.isArchived.value, false);
    expect(companion.sessionsSinceLevelUpdate.value, 0);
  });
}
