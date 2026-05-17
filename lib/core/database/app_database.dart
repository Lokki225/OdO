import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/evening_highlights_table.dart';
import 'tables/evening_sessions_table.dart';
import 'tables/events_table.dart';
import 'tables/sessions_table.dart';
import 'tables/skills_table.dart';
import 'tables/suggestions_table.dart';
import 'package:odo/features/agenda/data/agenda_dao.dart';
import 'package:odo/features/practice/data/practice_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Skills,
    Sessions,
    Events,
    Suggestions,
    EveningSessions,
    EveningHighlights,
  ],
  daos: [AgendaDao, PracticeDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @visibleForTesting
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await customStatement(
            'CREATE INDEX idx_events_start ON events(start_time)',
          );
          await customStatement(
            'CREATE INDEX idx_sessions_skill ON sessions(skill_id, started_at)',
          );
          await customStatement(
            'CREATE INDEX idx_sessions_anchored ON sessions(is_anchored)',
          );
          await customStatement(
            'CREATE INDEX idx_suggestions_suppressed '
            'ON suggestions(suppressed_until)',
          );
          await customStatement(
            'CREATE INDEX idx_evening_sessions_date '
            'ON evening_sessions(session_date)',
          );
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(skills, skills.type);
            await m.addColumn(skills, skills.metricConfig);
            await m.addColumn(skills, skills.levelLabel);
            await m.addColumn(skills, skills.levelUpdatedAt);
            await m.addColumn(skills, skills.sessionsSinceLevelUpdate);
            await m.addColumn(skills, skills.isArchived);
            await m.addColumn(skills, skills.suppressedUntil);
            await m.addColumn(sessions, sessions.modeTags);
            await m.addColumn(sessions, sessions.performanceMetric);
            await m.addColumn(sessions, sessions.feelScore);
            await m.addColumn(sessions, sessions.isMilestone);
            await m.addColumn(sessions, sessions.milestoneLabel);
            await m.addColumn(suggestions, suggestions.category);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'odo.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
  });
}
