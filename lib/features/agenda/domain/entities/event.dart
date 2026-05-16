import 'package:flutter/foundation.dart';

import 'package:odo/core/types/result.dart';

enum EventCategory {
  personal,
  work,
  practice;

  String get value => switch (this) {
        EventCategory.personal => 'personal',
        EventCategory.work => 'work',
        EventCategory.practice => 'practice',
      };
}

@immutable
class Event {
  const Event({
    this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.category,
    this.notes,
  });

  final int? id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final EventCategory category;
  final String? notes;

  Result<Event> validate() {
    if (title.trim().isEmpty) {
      return const Failure(AppError.databaseWriteFailed);
    }
    if (!endTime.isAfter(startTime)) {
      return const Failure(AppError.databaseWriteFailed);
    }
    return Success(this);
  }

  Event copyWith({
    int? id,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    EventCategory? category,
    String? notes,
    bool clearId = false,
  }) {
    return Event(
      id: clearId ? null : (id ?? this.id),
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          category == other.category &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(id, title, startTime, endTime, category, notes);
}
