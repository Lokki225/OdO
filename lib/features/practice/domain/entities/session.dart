import 'package:flutter/foundation.dart';

@immutable
class Session {
  const Session({
    this.id,
    required this.skillId,
    required this.startedAt,
    required this.durationMinutes,
    required this.modeTags,
    this.performanceMetric,
    this.feelScore,
    this.notes,
    required this.isAnchored,
    this.suggestedTime,
    required this.isMilestone,
    this.milestoneLabel,
  });

  final int? id;
  final int skillId;
  final DateTime startedAt;
  final int durationMinutes;
  final List<String> modeTags;
  final double? performanceMetric;
  final int? feelScore;
  final String? notes;
  final bool isAnchored;
  final DateTime? suggestedTime;
  final bool isMilestone;
  final String? milestoneLabel;

  Session copyWith({
    int? id,
    int? skillId,
    DateTime? startedAt,
    int? durationMinutes,
    List<String>? modeTags,
    double? performanceMetric,
    int? feelScore,
    String? notes,
    bool? isAnchored,
    DateTime? suggestedTime,
    bool? isMilestone,
    String? milestoneLabel,
    bool clearId = false,
  }) {
    return Session(
      id: clearId ? null : (id ?? this.id),
      skillId: skillId ?? this.skillId,
      startedAt: startedAt ?? this.startedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      modeTags: modeTags ?? this.modeTags,
      performanceMetric: performanceMetric ?? this.performanceMetric,
      feelScore: feelScore ?? this.feelScore,
      notes: notes ?? this.notes,
      isAnchored: isAnchored ?? this.isAnchored,
      suggestedTime: suggestedTime ?? this.suggestedTime,
      isMilestone: isMilestone ?? this.isMilestone,
      milestoneLabel: milestoneLabel ?? this.milestoneLabel,
    );
  }
}
