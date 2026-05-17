import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/database/app_database.dart';

AppDatabase _makeDb() => AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );

void main() {
  group('AppDatabase schema smoke test (AC1–9)', () {
    test('opens without error', () async {
      final db = _makeDb();
      addTearDown(db.close);
      expect(db, isNotNull);
    });

    test('inserts and retrieves a skill (AC2)', () async {
      final db = _makeDb();
      addTearDown(db.close);

      final id = await db.into(db.skills).insert(
            SkillsCompanion.insert(
              name: 'Chess',
              type: 'strategy',
              createdAt: 1700000000000,
            ),
          );

      final row = await (db.select(db.skills)
            ..where((s) => s.id.equals(id)))
          .getSingle();

      expect(row.name, 'Chess');
      expect(row.lastSessionAt, isNull);
    });

    test('inserts a session with FK to skill (AC3)', () async {
      final db = _makeDb();
      addTearDown(db.close);

      final skillId = await db.into(db.skills).insert(
            SkillsCompanion.insert(
              name: 'Piano',
              type: 'creative',
              createdAt: 1700000000000,
            ),
          );

      await db.into(db.sessions).insert(
            SessionsCompanion.insert(
              skillId: skillId,
              startedAt: 1700000000000,
              durationMinutes: 30,
            ),
          );

      final sessions = await db.select(db.sessions).get();
      expect(sessions.length, 1);
      expect(sessions.first.isAnchored, isFalse);
    });

    test('cascade delete removes sessions when skill deleted (AC3)', () async {
      final db = _makeDb();
      addTearDown(db.close);

      final skillId = await db.into(db.skills).insert(
            SkillsCompanion.insert(
              name: 'Painting',
              type: 'creative',
              createdAt: 1700000000000,
            ),
          );

      await db.into(db.sessions).insert(
            SessionsCompanion.insert(
              skillId: skillId,
              startedAt: 1700000000000,
              durationMinutes: 45,
            ),
          );

      await (db.delete(db.skills)
            ..where((s) => s.id.equals(skillId)))
          .go();

      final sessions = await db.select(db.sessions).get();
      expect(sessions, isEmpty);
    });

    test('inserts an event (AC4)', () async {
      final db = _makeDb();
      addTearDown(db.close);

      await db.into(db.events).insert(
            EventsCompanion.insert(
              title: 'Team meeting',
              startTime: 1700000000000,
              endTime: 1700003600000,
              category: 'work',
            ),
          );

      final events = await db.select(db.events).get();
      expect(events.length, 1);
      expect(events.first.category, 'work');
    });

    test('inserts an evening session and highlights (AC6, AC7)', () async {
      final db = _makeDb();
      addTearDown(db.close);

      final sessionId = await db.into(db.eveningSessions).insert(
            EveningSessionsCompanion.insert(
              sessionDate: '2026-05-15',
              startedAt: 1700000000000,
              headline: 'Good day',
            ),
          );

      await db.into(db.eveningHighlights).insert(
            EveningHighlightsCompanion.insert(
              eveningSessionId: sessionId,
              displayOrder: 1,
              content: 'Practiced piano',
              sourceType: 'session',
            ),
          );

      final highlights = await db.select(db.eveningHighlights).get();
      expect(highlights.length, 1);
      expect(highlights.first.eveningSessionId, sessionId);
    });

    test('cascade delete removes highlights when evening session deleted (AC7)',
        () async {
      final db = _makeDb();
      addTearDown(db.close);

      final sessionId = await db.into(db.eveningSessions).insert(
            EveningSessionsCompanion.insert(
              sessionDate: '2026-05-16',
              startedAt: 1700000000000,
              headline: 'Evening',
            ),
          );

      await db.into(db.eveningHighlights).insert(
            EveningHighlightsCompanion.insert(
              eveningSessionId: sessionId,
              displayOrder: 0,
              content: 'Highlight 1',
              sourceType: 'insight',
            ),
          );

      await (db.delete(db.eveningSessions)
            ..where((s) => s.id.equals(sessionId)))
          .go();

      final highlights = await db.select(db.eveningHighlights).get();
      expect(highlights, isEmpty);
    });

    test('inserts a suggestion with nullable skillId (AC5)', () async {
      final db = _makeDb();
      addTearDown(db.close);

      await db.into(db.suggestions).insert(
            SuggestionsCompanion.insert(
              slotStart: 1700000000000,
              slotDuration: 30,
              suggestedAt: 1700000000000,
            ),
          );

      final rows = await db.select(db.suggestions).get();
      expect(rows.length, 1);
      expect(rows.first.skillId, isNull);
    });
  });
}
