import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:odo/core/database/app_database.dart';
import 'package:odo/features/practice/domain/entities/session.dart';

abstract final class SessionMapper {
  static Session fromRow(SessionRow row) {
    final modeTags = _deserializeModeTags(row.modeTags);
    return Session(
      id: row.id,
      skillId: row.skillId,
      startedAt: DateTime.fromMillisecondsSinceEpoch(row.startedAt),
      durationMinutes: row.durationMinutes,
      modeTags: modeTags,
      performanceMetric: row.performanceMetric,
      feelScore: row.feelScore,
      notes: row.notes,
      isAnchored: row.isAnchored,
      suggestedTime: row.suggestedTime != null
          ? DateTime.fromMillisecondsSinceEpoch(row.suggestedTime!)
          : null,
      isMilestone: row.isMilestone,
      milestoneLabel: row.milestoneLabel,
    );
  }

  static SessionsCompanion toCompanion(Session session) {
    return SessionsCompanion(
      id: session.id != null ? Value(session.id!) : const Value.absent(),
      skillId: Value(session.skillId),
      startedAt: Value(session.startedAt.millisecondsSinceEpoch),
      durationMinutes: Value(session.durationMinutes),
      modeTags: Value(jsonEncode(session.modeTags)),
      performanceMetric: Value(session.performanceMetric),
      feelScore: Value(session.feelScore),
      notes: Value(session.notes),
      isAnchored: Value(session.isAnchored),
      suggestedTime:
          Value(session.suggestedTime?.millisecondsSinceEpoch),
      isMilestone: Value(session.isMilestone),
      milestoneLabel: Value(session.milestoneLabel),
    );
  }

  static List<String> _deserializeModeTags(String? raw) {
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>).cast<String>();
    } catch (_) {
      return [];
    }
  }
}
