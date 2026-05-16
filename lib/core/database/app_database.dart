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
  daos: [AgendaDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @visibleForTesting
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

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
