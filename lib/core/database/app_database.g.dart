// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SkillsTable extends Skills with TableInfo<$SkillsTable, SkillRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastSessionAtMeta =
      const VerificationMeta('lastSessionAt');
  @override
  late final GeneratedColumn<int> lastSessionAt = GeneratedColumn<int>(
      'last_session_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, lastSessionAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skills';
  @override
  VerificationContext validateIntegrity(Insertable<SkillRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_session_at')) {
      context.handle(
          _lastSessionAtMeta,
          lastSessionAt.isAcceptableOrUnknown(
              data['last_session_at']!, _lastSessionAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SkillRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkillRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      lastSessionAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_session_at']),
    );
  }

  @override
  $SkillsTable createAlias(String alias) {
    return $SkillsTable(attachedDatabase, alias);
  }
}

class SkillRow extends DataClass implements Insertable<SkillRow> {
  final int id;
  final String name;
  final int createdAt;
  final int? lastSessionAt;
  const SkillRow(
      {required this.id,
      required this.name,
      required this.createdAt,
      this.lastSessionAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || lastSessionAt != null) {
      map['last_session_at'] = Variable<int>(lastSessionAt);
    }
    return map;
  }

  SkillsCompanion toCompanion(bool nullToAbsent) {
    return SkillsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      lastSessionAt: lastSessionAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSessionAt),
    );
  }

  factory SkillRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkillRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      lastSessionAt: serializer.fromJson<int?>(json['lastSessionAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<int>(createdAt),
      'lastSessionAt': serializer.toJson<int?>(lastSessionAt),
    };
  }

  SkillRow copyWith(
          {int? id,
          String? name,
          int? createdAt,
          Value<int?> lastSessionAt = const Value.absent()}) =>
      SkillRow(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        lastSessionAt:
            lastSessionAt.present ? lastSessionAt.value : this.lastSessionAt,
      );
  SkillRow copyWithCompanion(SkillsCompanion data) {
    return SkillRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSessionAt: data.lastSessionAt.present
          ? data.lastSessionAt.value
          : this.lastSessionAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkillRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSessionAt: $lastSessionAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, lastSessionAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkillRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.lastSessionAt == this.lastSessionAt);
}

class SkillsCompanion extends UpdateCompanion<SkillRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> createdAt;
  final Value<int?> lastSessionAt;
  const SkillsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSessionAt = const Value.absent(),
  });
  SkillsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int createdAt,
    this.lastSessionAt = const Value.absent(),
  })  : name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<SkillRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? createdAt,
    Expression<int>? lastSessionAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSessionAt != null) 'last_session_at': lastSessionAt,
    });
  }

  SkillsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? createdAt,
      Value<int?>? lastSessionAt}) {
    return SkillsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (lastSessionAt.present) {
      map['last_session_at'] = Variable<int>(lastSessionAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkillsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSessionAt: $lastSessionAt')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _skillIdMeta =
      const VerificationMeta('skillId');
  @override
  late final GeneratedColumn<int> skillId = GeneratedColumn<int>(
      'skill_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES skills (id) ON DELETE CASCADE'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
      'started_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isAnchoredMeta =
      const VerificationMeta('isAnchored');
  @override
  late final GeneratedColumn<bool> isAnchored = GeneratedColumn<bool>(
      'is_anchored', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_anchored" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _suggestedTimeMeta =
      const VerificationMeta('suggestedTime');
  @override
  late final GeneratedColumn<int> suggestedTime = GeneratedColumn<int>(
      'suggested_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        skillId,
        startedAt,
        durationMinutes,
        notes,
        isAnchored,
        suggestedTime
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<SessionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('skill_id')) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta));
    } else if (isInserting) {
      context.missing(_skillIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_anchored')) {
      context.handle(
          _isAnchoredMeta,
          isAnchored.isAcceptableOrUnknown(
              data['is_anchored']!, _isAnchoredMeta));
    }
    if (data.containsKey('suggested_time')) {
      context.handle(
          _suggestedTimeMeta,
          suggestedTime.isAcceptableOrUnknown(
              data['suggested_time']!, _suggestedTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      skillId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}skill_id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}started_at'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isAnchored: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_anchored'])!,
      suggestedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}suggested_time']),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final int id;
  final int skillId;
  final int startedAt;
  final int durationMinutes;
  final String? notes;
  final bool isAnchored;
  final int? suggestedTime;
  const SessionRow(
      {required this.id,
      required this.skillId,
      required this.startedAt,
      required this.durationMinutes,
      this.notes,
      required this.isAnchored,
      this.suggestedTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['skill_id'] = Variable<int>(skillId);
    map['started_at'] = Variable<int>(startedAt);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_anchored'] = Variable<bool>(isAnchored);
    if (!nullToAbsent || suggestedTime != null) {
      map['suggested_time'] = Variable<int>(suggestedTime);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      skillId: Value(skillId),
      startedAt: Value(startedAt),
      durationMinutes: Value(durationMinutes),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isAnchored: Value(isAnchored),
      suggestedTime: suggestedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedTime),
    );
  }

  factory SessionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<int>(json['id']),
      skillId: serializer.fromJson<int>(json['skillId']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      notes: serializer.fromJson<String?>(json['notes']),
      isAnchored: serializer.fromJson<bool>(json['isAnchored']),
      suggestedTime: serializer.fromJson<int?>(json['suggestedTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'skillId': serializer.toJson<int>(skillId),
      'startedAt': serializer.toJson<int>(startedAt),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'notes': serializer.toJson<String?>(notes),
      'isAnchored': serializer.toJson<bool>(isAnchored),
      'suggestedTime': serializer.toJson<int?>(suggestedTime),
    };
  }

  SessionRow copyWith(
          {int? id,
          int? skillId,
          int? startedAt,
          int? durationMinutes,
          Value<String?> notes = const Value.absent(),
          bool? isAnchored,
          Value<int?> suggestedTime = const Value.absent()}) =>
      SessionRow(
        id: id ?? this.id,
        skillId: skillId ?? this.skillId,
        startedAt: startedAt ?? this.startedAt,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        notes: notes.present ? notes.value : this.notes,
        isAnchored: isAnchored ?? this.isAnchored,
        suggestedTime:
            suggestedTime.present ? suggestedTime.value : this.suggestedTime,
      );
  SessionRow copyWithCompanion(SessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      notes: data.notes.present ? data.notes.value : this.notes,
      isAnchored:
          data.isAnchored.present ? data.isAnchored.value : this.isAnchored,
      suggestedTime: data.suggestedTime.present
          ? data.suggestedTime.value
          : this.suggestedTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('skillId: $skillId, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('isAnchored: $isAnchored, ')
          ..write('suggestedTime: $suggestedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, skillId, startedAt, durationMinutes,
      notes, isAnchored, suggestedTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.skillId == this.skillId &&
          other.startedAt == this.startedAt &&
          other.durationMinutes == this.durationMinutes &&
          other.notes == this.notes &&
          other.isAnchored == this.isAnchored &&
          other.suggestedTime == this.suggestedTime);
}

class SessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<int> id;
  final Value<int> skillId;
  final Value<int> startedAt;
  final Value<int> durationMinutes;
  final Value<String?> notes;
  final Value<bool> isAnchored;
  final Value<int?> suggestedTime;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.skillId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.isAnchored = const Value.absent(),
    this.suggestedTime = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int skillId,
    required int startedAt,
    required int durationMinutes,
    this.notes = const Value.absent(),
    this.isAnchored = const Value.absent(),
    this.suggestedTime = const Value.absent(),
  })  : skillId = Value(skillId),
        startedAt = Value(startedAt),
        durationMinutes = Value(durationMinutes);
  static Insertable<SessionRow> custom({
    Expression<int>? id,
    Expression<int>? skillId,
    Expression<int>? startedAt,
    Expression<int>? durationMinutes,
    Expression<String>? notes,
    Expression<bool>? isAnchored,
    Expression<int>? suggestedTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (skillId != null) 'skill_id': skillId,
      if (startedAt != null) 'started_at': startedAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (notes != null) 'notes': notes,
      if (isAnchored != null) 'is_anchored': isAnchored,
      if (suggestedTime != null) 'suggested_time': suggestedTime,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? skillId,
      Value<int>? startedAt,
      Value<int>? durationMinutes,
      Value<String?>? notes,
      Value<bool>? isAnchored,
      Value<int?>? suggestedTime}) {
    return SessionsCompanion(
      id: id ?? this.id,
      skillId: skillId ?? this.skillId,
      startedAt: startedAt ?? this.startedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      isAnchored: isAnchored ?? this.isAnchored,
      suggestedTime: suggestedTime ?? this.suggestedTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<int>(skillId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isAnchored.present) {
      map['is_anchored'] = Variable<bool>(isAnchored.value);
    }
    if (suggestedTime.present) {
      map['suggested_time'] = Variable<int>(suggestedTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('skillId: $skillId, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('isAnchored: $isAnchored, ')
          ..write('suggestedTime: $suggestedTime')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, EventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
      'start_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
      'end_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, startTime, endTime, category, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<EventRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class EventRow extends DataClass implements Insertable<EventRow> {
  final int id;
  final String title;
  final int startTime;
  final int endTime;
  final String category;
  final String? notes;
  const EventRow(
      {required this.id,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.category,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['start_time'] = Variable<int>(startTime);
    map['end_time'] = Variable<int>(endTime);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      title: Value(title),
      startTime: Value(startTime),
      endTime: Value(endTime),
      category: Value(category),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory EventRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int>(json['endTime']),
      category: serializer.fromJson<String>(json['category']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int>(endTime),
      'category': serializer.toJson<String>(category),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  EventRow copyWith(
          {int? id,
          String? title,
          int? startTime,
          int? endTime,
          String? category,
          Value<String?> notes = const Value.absent()}) =>
      EventRow(
        id: id ?? this.id,
        title: title ?? this.title,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        category: category ?? this.category,
        notes: notes.present ? notes.value : this.notes,
      );
  EventRow copyWithCompanion(EventsCompanion data) {
    return EventRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      category: data.category.present ? data.category.value : this.category,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, startTime, endTime, category, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.category == this.category &&
          other.notes == this.notes);
}

class EventsCompanion extends UpdateCompanion<EventRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> startTime;
  final Value<int> endTime;
  final Value<String> category;
  final Value<String?> notes;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.category = const Value.absent(),
    this.notes = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int startTime,
    required int endTime,
    required String category,
    this.notes = const Value.absent(),
  })  : title = Value(title),
        startTime = Value(startTime),
        endTime = Value(endTime),
        category = Value(category);
  static Insertable<EventRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<String>? category,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (category != null) 'category': category,
      if (notes != null) 'notes': notes,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<int>? startTime,
      Value<int>? endTime,
      Value<String>? category,
      Value<String?>? notes}) {
    return EventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SuggestionsTable extends Suggestions
    with TableInfo<$SuggestionsTable, SuggestionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuggestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _skillIdMeta =
      const VerificationMeta('skillId');
  @override
  late final GeneratedColumn<int> skillId = GeneratedColumn<int>(
      'skill_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES skills (id) ON DELETE SET NULL'));
  static const VerificationMeta _slotStartMeta =
      const VerificationMeta('slotStart');
  @override
  late final GeneratedColumn<int> slotStart = GeneratedColumn<int>(
      'slot_start', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _slotDurationMeta =
      const VerificationMeta('slotDuration');
  @override
  late final GeneratedColumn<int> slotDuration = GeneratedColumn<int>(
      'slot_duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _suggestedAtMeta =
      const VerificationMeta('suggestedAt');
  @override
  late final GeneratedColumn<int> suggestedAt = GeneratedColumn<int>(
      'suggested_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _acceptedAtMeta =
      const VerificationMeta('acceptedAt');
  @override
  late final GeneratedColumn<int> acceptedAt = GeneratedColumn<int>(
      'accepted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dismissedAtMeta =
      const VerificationMeta('dismissedAt');
  @override
  late final GeneratedColumn<int> dismissedAt = GeneratedColumn<int>(
      'dismissed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _thumbsDownAtMeta =
      const VerificationMeta('thumbsDownAt');
  @override
  late final GeneratedColumn<int> thumbsDownAt = GeneratedColumn<int>(
      'thumbs_down_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _suppressedUntilMeta =
      const VerificationMeta('suppressedUntil');
  @override
  late final GeneratedColumn<int> suppressedUntil = GeneratedColumn<int>(
      'suppressed_until', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        skillId,
        slotStart,
        slotDuration,
        suggestedAt,
        acceptedAt,
        dismissedAt,
        thumbsDownAt,
        suppressedUntil
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suggestions';
  @override
  VerificationContext validateIntegrity(Insertable<SuggestionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('skill_id')) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta));
    }
    if (data.containsKey('slot_start')) {
      context.handle(_slotStartMeta,
          slotStart.isAcceptableOrUnknown(data['slot_start']!, _slotStartMeta));
    } else if (isInserting) {
      context.missing(_slotStartMeta);
    }
    if (data.containsKey('slot_duration')) {
      context.handle(
          _slotDurationMeta,
          slotDuration.isAcceptableOrUnknown(
              data['slot_duration']!, _slotDurationMeta));
    } else if (isInserting) {
      context.missing(_slotDurationMeta);
    }
    if (data.containsKey('suggested_at')) {
      context.handle(
          _suggestedAtMeta,
          suggestedAt.isAcceptableOrUnknown(
              data['suggested_at']!, _suggestedAtMeta));
    } else if (isInserting) {
      context.missing(_suggestedAtMeta);
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
          _acceptedAtMeta,
          acceptedAt.isAcceptableOrUnknown(
              data['accepted_at']!, _acceptedAtMeta));
    }
    if (data.containsKey('dismissed_at')) {
      context.handle(
          _dismissedAtMeta,
          dismissedAt.isAcceptableOrUnknown(
              data['dismissed_at']!, _dismissedAtMeta));
    }
    if (data.containsKey('thumbs_down_at')) {
      context.handle(
          _thumbsDownAtMeta,
          thumbsDownAt.isAcceptableOrUnknown(
              data['thumbs_down_at']!, _thumbsDownAtMeta));
    }
    if (data.containsKey('suppressed_until')) {
      context.handle(
          _suppressedUntilMeta,
          suppressedUntil.isAcceptableOrUnknown(
              data['suppressed_until']!, _suppressedUntilMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SuggestionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SuggestionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      skillId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}skill_id']),
      slotStart: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot_start'])!,
      slotDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot_duration'])!,
      suggestedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}suggested_at'])!,
      acceptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}accepted_at']),
      dismissedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dismissed_at']),
      thumbsDownAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}thumbs_down_at']),
      suppressedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}suppressed_until']),
    );
  }

  @override
  $SuggestionsTable createAlias(String alias) {
    return $SuggestionsTable(attachedDatabase, alias);
  }
}

class SuggestionRow extends DataClass implements Insertable<SuggestionRow> {
  final int id;
  final int? skillId;
  final int slotStart;
  final int slotDuration;
  final int suggestedAt;
  final int? acceptedAt;
  final int? dismissedAt;
  final int? thumbsDownAt;
  final int? suppressedUntil;
  const SuggestionRow(
      {required this.id,
      this.skillId,
      required this.slotStart,
      required this.slotDuration,
      required this.suggestedAt,
      this.acceptedAt,
      this.dismissedAt,
      this.thumbsDownAt,
      this.suppressedUntil});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || skillId != null) {
      map['skill_id'] = Variable<int>(skillId);
    }
    map['slot_start'] = Variable<int>(slotStart);
    map['slot_duration'] = Variable<int>(slotDuration);
    map['suggested_at'] = Variable<int>(suggestedAt);
    if (!nullToAbsent || acceptedAt != null) {
      map['accepted_at'] = Variable<int>(acceptedAt);
    }
    if (!nullToAbsent || dismissedAt != null) {
      map['dismissed_at'] = Variable<int>(dismissedAt);
    }
    if (!nullToAbsent || thumbsDownAt != null) {
      map['thumbs_down_at'] = Variable<int>(thumbsDownAt);
    }
    if (!nullToAbsent || suppressedUntil != null) {
      map['suppressed_until'] = Variable<int>(suppressedUntil);
    }
    return map;
  }

  SuggestionsCompanion toCompanion(bool nullToAbsent) {
    return SuggestionsCompanion(
      id: Value(id),
      skillId: skillId == null && nullToAbsent
          ? const Value.absent()
          : Value(skillId),
      slotStart: Value(slotStart),
      slotDuration: Value(slotDuration),
      suggestedAt: Value(suggestedAt),
      acceptedAt: acceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acceptedAt),
      dismissedAt: dismissedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dismissedAt),
      thumbsDownAt: thumbsDownAt == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbsDownAt),
      suppressedUntil: suppressedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(suppressedUntil),
    );
  }

  factory SuggestionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SuggestionRow(
      id: serializer.fromJson<int>(json['id']),
      skillId: serializer.fromJson<int?>(json['skillId']),
      slotStart: serializer.fromJson<int>(json['slotStart']),
      slotDuration: serializer.fromJson<int>(json['slotDuration']),
      suggestedAt: serializer.fromJson<int>(json['suggestedAt']),
      acceptedAt: serializer.fromJson<int?>(json['acceptedAt']),
      dismissedAt: serializer.fromJson<int?>(json['dismissedAt']),
      thumbsDownAt: serializer.fromJson<int?>(json['thumbsDownAt']),
      suppressedUntil: serializer.fromJson<int?>(json['suppressedUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'skillId': serializer.toJson<int?>(skillId),
      'slotStart': serializer.toJson<int>(slotStart),
      'slotDuration': serializer.toJson<int>(slotDuration),
      'suggestedAt': serializer.toJson<int>(suggestedAt),
      'acceptedAt': serializer.toJson<int?>(acceptedAt),
      'dismissedAt': serializer.toJson<int?>(dismissedAt),
      'thumbsDownAt': serializer.toJson<int?>(thumbsDownAt),
      'suppressedUntil': serializer.toJson<int?>(suppressedUntil),
    };
  }

  SuggestionRow copyWith(
          {int? id,
          Value<int?> skillId = const Value.absent(),
          int? slotStart,
          int? slotDuration,
          int? suggestedAt,
          Value<int?> acceptedAt = const Value.absent(),
          Value<int?> dismissedAt = const Value.absent(),
          Value<int?> thumbsDownAt = const Value.absent(),
          Value<int?> suppressedUntil = const Value.absent()}) =>
      SuggestionRow(
        id: id ?? this.id,
        skillId: skillId.present ? skillId.value : this.skillId,
        slotStart: slotStart ?? this.slotStart,
        slotDuration: slotDuration ?? this.slotDuration,
        suggestedAt: suggestedAt ?? this.suggestedAt,
        acceptedAt: acceptedAt.present ? acceptedAt.value : this.acceptedAt,
        dismissedAt: dismissedAt.present ? dismissedAt.value : this.dismissedAt,
        thumbsDownAt:
            thumbsDownAt.present ? thumbsDownAt.value : this.thumbsDownAt,
        suppressedUntil: suppressedUntil.present
            ? suppressedUntil.value
            : this.suppressedUntil,
      );
  SuggestionRow copyWithCompanion(SuggestionsCompanion data) {
    return SuggestionRow(
      id: data.id.present ? data.id.value : this.id,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      slotStart: data.slotStart.present ? data.slotStart.value : this.slotStart,
      slotDuration: data.slotDuration.present
          ? data.slotDuration.value
          : this.slotDuration,
      suggestedAt:
          data.suggestedAt.present ? data.suggestedAt.value : this.suggestedAt,
      acceptedAt:
          data.acceptedAt.present ? data.acceptedAt.value : this.acceptedAt,
      dismissedAt:
          data.dismissedAt.present ? data.dismissedAt.value : this.dismissedAt,
      thumbsDownAt: data.thumbsDownAt.present
          ? data.thumbsDownAt.value
          : this.thumbsDownAt,
      suppressedUntil: data.suppressedUntil.present
          ? data.suppressedUntil.value
          : this.suppressedUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SuggestionRow(')
          ..write('id: $id, ')
          ..write('skillId: $skillId, ')
          ..write('slotStart: $slotStart, ')
          ..write('slotDuration: $slotDuration, ')
          ..write('suggestedAt: $suggestedAt, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('dismissedAt: $dismissedAt, ')
          ..write('thumbsDownAt: $thumbsDownAt, ')
          ..write('suppressedUntil: $suppressedUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, skillId, slotStart, slotDuration,
      suggestedAt, acceptedAt, dismissedAt, thumbsDownAt, suppressedUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SuggestionRow &&
          other.id == this.id &&
          other.skillId == this.skillId &&
          other.slotStart == this.slotStart &&
          other.slotDuration == this.slotDuration &&
          other.suggestedAt == this.suggestedAt &&
          other.acceptedAt == this.acceptedAt &&
          other.dismissedAt == this.dismissedAt &&
          other.thumbsDownAt == this.thumbsDownAt &&
          other.suppressedUntil == this.suppressedUntil);
}

class SuggestionsCompanion extends UpdateCompanion<SuggestionRow> {
  final Value<int> id;
  final Value<int?> skillId;
  final Value<int> slotStart;
  final Value<int> slotDuration;
  final Value<int> suggestedAt;
  final Value<int?> acceptedAt;
  final Value<int?> dismissedAt;
  final Value<int?> thumbsDownAt;
  final Value<int?> suppressedUntil;
  const SuggestionsCompanion({
    this.id = const Value.absent(),
    this.skillId = const Value.absent(),
    this.slotStart = const Value.absent(),
    this.slotDuration = const Value.absent(),
    this.suggestedAt = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.dismissedAt = const Value.absent(),
    this.thumbsDownAt = const Value.absent(),
    this.suppressedUntil = const Value.absent(),
  });
  SuggestionsCompanion.insert({
    this.id = const Value.absent(),
    this.skillId = const Value.absent(),
    required int slotStart,
    required int slotDuration,
    required int suggestedAt,
    this.acceptedAt = const Value.absent(),
    this.dismissedAt = const Value.absent(),
    this.thumbsDownAt = const Value.absent(),
    this.suppressedUntil = const Value.absent(),
  })  : slotStart = Value(slotStart),
        slotDuration = Value(slotDuration),
        suggestedAt = Value(suggestedAt);
  static Insertable<SuggestionRow> custom({
    Expression<int>? id,
    Expression<int>? skillId,
    Expression<int>? slotStart,
    Expression<int>? slotDuration,
    Expression<int>? suggestedAt,
    Expression<int>? acceptedAt,
    Expression<int>? dismissedAt,
    Expression<int>? thumbsDownAt,
    Expression<int>? suppressedUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (skillId != null) 'skill_id': skillId,
      if (slotStart != null) 'slot_start': slotStart,
      if (slotDuration != null) 'slot_duration': slotDuration,
      if (suggestedAt != null) 'suggested_at': suggestedAt,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
      if (dismissedAt != null) 'dismissed_at': dismissedAt,
      if (thumbsDownAt != null) 'thumbs_down_at': thumbsDownAt,
      if (suppressedUntil != null) 'suppressed_until': suppressedUntil,
    });
  }

  SuggestionsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? skillId,
      Value<int>? slotStart,
      Value<int>? slotDuration,
      Value<int>? suggestedAt,
      Value<int?>? acceptedAt,
      Value<int?>? dismissedAt,
      Value<int?>? thumbsDownAt,
      Value<int?>? suppressedUntil}) {
    return SuggestionsCompanion(
      id: id ?? this.id,
      skillId: skillId ?? this.skillId,
      slotStart: slotStart ?? this.slotStart,
      slotDuration: slotDuration ?? this.slotDuration,
      suggestedAt: suggestedAt ?? this.suggestedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      dismissedAt: dismissedAt ?? this.dismissedAt,
      thumbsDownAt: thumbsDownAt ?? this.thumbsDownAt,
      suppressedUntil: suppressedUntil ?? this.suppressedUntil,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<int>(skillId.value);
    }
    if (slotStart.present) {
      map['slot_start'] = Variable<int>(slotStart.value);
    }
    if (slotDuration.present) {
      map['slot_duration'] = Variable<int>(slotDuration.value);
    }
    if (suggestedAt.present) {
      map['suggested_at'] = Variable<int>(suggestedAt.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<int>(acceptedAt.value);
    }
    if (dismissedAt.present) {
      map['dismissed_at'] = Variable<int>(dismissedAt.value);
    }
    if (thumbsDownAt.present) {
      map['thumbs_down_at'] = Variable<int>(thumbsDownAt.value);
    }
    if (suppressedUntil.present) {
      map['suppressed_until'] = Variable<int>(suppressedUntil.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuggestionsCompanion(')
          ..write('id: $id, ')
          ..write('skillId: $skillId, ')
          ..write('slotStart: $slotStart, ')
          ..write('slotDuration: $slotDuration, ')
          ..write('suggestedAt: $suggestedAt, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('dismissedAt: $dismissedAt, ')
          ..write('thumbsDownAt: $thumbsDownAt, ')
          ..write('suppressedUntil: $suppressedUntil')
          ..write(')'))
        .toString();
  }
}

class $EveningSessionsTable extends EveningSessions
    with TableInfo<$EveningSessionsTable, EveningSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EveningSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionDateMeta =
      const VerificationMeta('sessionDate');
  @override
  late final GeneratedColumn<String> sessionDate = GeneratedColumn<String>(
      'session_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
      'started_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _abandonedAtMeta =
      const VerificationMeta('abandonedAt');
  @override
  late final GeneratedColumn<int> abandonedAt = GeneratedColumn<int>(
      'abandoned_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _headlineMeta =
      const VerificationMeta('headline');
  @override
  late final GeneratedColumn<String> headline = GeneratedColumn<String>(
      'headline', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _closeSummaryMeta =
      const VerificationMeta('closeSummary');
  @override
  late final GeneratedColumn<String> closeSummary = GeneratedColumn<String>(
      'close_summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionDate,
        startedAt,
        completedAt,
        abandonedAt,
        headline,
        closeSummary
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evening_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<EveningSessionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_date')) {
      context.handle(
          _sessionDateMeta,
          sessionDate.isAcceptableOrUnknown(
              data['session_date']!, _sessionDateMeta));
    } else if (isInserting) {
      context.missing(_sessionDateMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('abandoned_at')) {
      context.handle(
          _abandonedAtMeta,
          abandonedAt.isAcceptableOrUnknown(
              data['abandoned_at']!, _abandonedAtMeta));
    }
    if (data.containsKey('headline')) {
      context.handle(_headlineMeta,
          headline.isAcceptableOrUnknown(data['headline']!, _headlineMeta));
    } else if (isInserting) {
      context.missing(_headlineMeta);
    }
    if (data.containsKey('close_summary')) {
      context.handle(
          _closeSummaryMeta,
          closeSummary.isAcceptableOrUnknown(
              data['close_summary']!, _closeSummaryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EveningSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EveningSessionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_date'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_at']),
      abandonedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}abandoned_at']),
      headline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}headline'])!,
      closeSummary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}close_summary']),
    );
  }

  @override
  $EveningSessionsTable createAlias(String alias) {
    return $EveningSessionsTable(attachedDatabase, alias);
  }
}

class EveningSessionRow extends DataClass
    implements Insertable<EveningSessionRow> {
  final int id;
  final String sessionDate;
  final int startedAt;
  final int? completedAt;
  final int? abandonedAt;
  final String headline;
  final String? closeSummary;
  const EveningSessionRow(
      {required this.id,
      required this.sessionDate,
      required this.startedAt,
      this.completedAt,
      this.abandonedAt,
      required this.headline,
      this.closeSummary});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_date'] = Variable<String>(sessionDate);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    if (!nullToAbsent || abandonedAt != null) {
      map['abandoned_at'] = Variable<int>(abandonedAt);
    }
    map['headline'] = Variable<String>(headline);
    if (!nullToAbsent || closeSummary != null) {
      map['close_summary'] = Variable<String>(closeSummary);
    }
    return map;
  }

  EveningSessionsCompanion toCompanion(bool nullToAbsent) {
    return EveningSessionsCompanion(
      id: Value(id),
      sessionDate: Value(sessionDate),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      abandonedAt: abandonedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(abandonedAt),
      headline: Value(headline),
      closeSummary: closeSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(closeSummary),
    );
  }

  factory EveningSessionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EveningSessionRow(
      id: serializer.fromJson<int>(json['id']),
      sessionDate: serializer.fromJson<String>(json['sessionDate']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
      abandonedAt: serializer.fromJson<int?>(json['abandonedAt']),
      headline: serializer.fromJson<String>(json['headline']),
      closeSummary: serializer.fromJson<String?>(json['closeSummary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionDate': serializer.toJson<String>(sessionDate),
      'startedAt': serializer.toJson<int>(startedAt),
      'completedAt': serializer.toJson<int?>(completedAt),
      'abandonedAt': serializer.toJson<int?>(abandonedAt),
      'headline': serializer.toJson<String>(headline),
      'closeSummary': serializer.toJson<String?>(closeSummary),
    };
  }

  EveningSessionRow copyWith(
          {int? id,
          String? sessionDate,
          int? startedAt,
          Value<int?> completedAt = const Value.absent(),
          Value<int?> abandonedAt = const Value.absent(),
          String? headline,
          Value<String?> closeSummary = const Value.absent()}) =>
      EveningSessionRow(
        id: id ?? this.id,
        sessionDate: sessionDate ?? this.sessionDate,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        abandonedAt: abandonedAt.present ? abandonedAt.value : this.abandonedAt,
        headline: headline ?? this.headline,
        closeSummary:
            closeSummary.present ? closeSummary.value : this.closeSummary,
      );
  EveningSessionRow copyWithCompanion(EveningSessionsCompanion data) {
    return EveningSessionRow(
      id: data.id.present ? data.id.value : this.id,
      sessionDate:
          data.sessionDate.present ? data.sessionDate.value : this.sessionDate,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      abandonedAt:
          data.abandonedAt.present ? data.abandonedAt.value : this.abandonedAt,
      headline: data.headline.present ? data.headline.value : this.headline,
      closeSummary: data.closeSummary.present
          ? data.closeSummary.value
          : this.closeSummary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EveningSessionRow(')
          ..write('id: $id, ')
          ..write('sessionDate: $sessionDate, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('abandonedAt: $abandonedAt, ')
          ..write('headline: $headline, ')
          ..write('closeSummary: $closeSummary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionDate, startedAt, completedAt,
      abandonedAt, headline, closeSummary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EveningSessionRow &&
          other.id == this.id &&
          other.sessionDate == this.sessionDate &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.abandonedAt == this.abandonedAt &&
          other.headline == this.headline &&
          other.closeSummary == this.closeSummary);
}

class EveningSessionsCompanion extends UpdateCompanion<EveningSessionRow> {
  final Value<int> id;
  final Value<String> sessionDate;
  final Value<int> startedAt;
  final Value<int?> completedAt;
  final Value<int?> abandonedAt;
  final Value<String> headline;
  final Value<String?> closeSummary;
  const EveningSessionsCompanion({
    this.id = const Value.absent(),
    this.sessionDate = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.abandonedAt = const Value.absent(),
    this.headline = const Value.absent(),
    this.closeSummary = const Value.absent(),
  });
  EveningSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionDate,
    required int startedAt,
    this.completedAt = const Value.absent(),
    this.abandonedAt = const Value.absent(),
    required String headline,
    this.closeSummary = const Value.absent(),
  })  : sessionDate = Value(sessionDate),
        startedAt = Value(startedAt),
        headline = Value(headline);
  static Insertable<EveningSessionRow> custom({
    Expression<int>? id,
    Expression<String>? sessionDate,
    Expression<int>? startedAt,
    Expression<int>? completedAt,
    Expression<int>? abandonedAt,
    Expression<String>? headline,
    Expression<String>? closeSummary,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionDate != null) 'session_date': sessionDate,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (abandonedAt != null) 'abandoned_at': abandonedAt,
      if (headline != null) 'headline': headline,
      if (closeSummary != null) 'close_summary': closeSummary,
    });
  }

  EveningSessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? sessionDate,
      Value<int>? startedAt,
      Value<int?>? completedAt,
      Value<int?>? abandonedAt,
      Value<String>? headline,
      Value<String?>? closeSummary}) {
    return EveningSessionsCompanion(
      id: id ?? this.id,
      sessionDate: sessionDate ?? this.sessionDate,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      abandonedAt: abandonedAt ?? this.abandonedAt,
      headline: headline ?? this.headline,
      closeSummary: closeSummary ?? this.closeSummary,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionDate.present) {
      map['session_date'] = Variable<String>(sessionDate.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (abandonedAt.present) {
      map['abandoned_at'] = Variable<int>(abandonedAt.value);
    }
    if (headline.present) {
      map['headline'] = Variable<String>(headline.value);
    }
    if (closeSummary.present) {
      map['close_summary'] = Variable<String>(closeSummary.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EveningSessionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionDate: $sessionDate, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('abandonedAt: $abandonedAt, ')
          ..write('headline: $headline, ')
          ..write('closeSummary: $closeSummary')
          ..write(')'))
        .toString();
  }
}

class $EveningHighlightsTable extends EveningHighlights
    with TableInfo<$EveningHighlightsTable, HighlightRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EveningHighlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eveningSessionIdMeta =
      const VerificationMeta('eveningSessionId');
  @override
  late final GeneratedColumn<int> eveningSessionId = GeneratedColumn<int>(
      'evening_session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES evening_sessions (id) ON DELETE CASCADE'));
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceRefIdMeta =
      const VerificationMeta('sourceRefId');
  @override
  late final GeneratedColumn<int> sourceRefId = GeneratedColumn<int>(
      'source_ref_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _userTagMeta =
      const VerificationMeta('userTag');
  @override
  late final GeneratedColumn<String> userTag = GeneratedColumn<String>(
      'user_tag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taggedAtMeta =
      const VerificationMeta('taggedAt');
  @override
  late final GeneratedColumn<int> taggedAt = GeneratedColumn<int>(
      'tagged_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        eveningSessionId,
        displayOrder,
        content,
        sourceType,
        sourceRefId,
        userTag,
        taggedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evening_highlights';
  @override
  VerificationContext validateIntegrity(Insertable<HighlightRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('evening_session_id')) {
      context.handle(
          _eveningSessionIdMeta,
          eveningSessionId.isAcceptableOrUnknown(
              data['evening_session_id']!, _eveningSessionIdMeta));
    } else if (isInserting) {
      context.missing(_eveningSessionIdMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_ref_id')) {
      context.handle(
          _sourceRefIdMeta,
          sourceRefId.isAcceptableOrUnknown(
              data['source_ref_id']!, _sourceRefIdMeta));
    }
    if (data.containsKey('user_tag')) {
      context.handle(_userTagMeta,
          userTag.isAcceptableOrUnknown(data['user_tag']!, _userTagMeta));
    }
    if (data.containsKey('tagged_at')) {
      context.handle(_taggedAtMeta,
          taggedAt.isAcceptableOrUnknown(data['tagged_at']!, _taggedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HighlightRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighlightRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eveningSessionId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}evening_session_id'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      sourceRefId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_ref_id']),
      userTag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_tag']),
      taggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tagged_at']),
    );
  }

  @override
  $EveningHighlightsTable createAlias(String alias) {
    return $EveningHighlightsTable(attachedDatabase, alias);
  }
}

class HighlightRow extends DataClass implements Insertable<HighlightRow> {
  final int id;
  final int eveningSessionId;
  final int displayOrder;
  final String content;
  final String sourceType;
  final int? sourceRefId;
  final String? userTag;
  final int? taggedAt;
  const HighlightRow(
      {required this.id,
      required this.eveningSessionId,
      required this.displayOrder,
      required this.content,
      required this.sourceType,
      this.sourceRefId,
      this.userTag,
      this.taggedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['evening_session_id'] = Variable<int>(eveningSessionId);
    map['display_order'] = Variable<int>(displayOrder);
    map['content'] = Variable<String>(content);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceRefId != null) {
      map['source_ref_id'] = Variable<int>(sourceRefId);
    }
    if (!nullToAbsent || userTag != null) {
      map['user_tag'] = Variable<String>(userTag);
    }
    if (!nullToAbsent || taggedAt != null) {
      map['tagged_at'] = Variable<int>(taggedAt);
    }
    return map;
  }

  EveningHighlightsCompanion toCompanion(bool nullToAbsent) {
    return EveningHighlightsCompanion(
      id: Value(id),
      eveningSessionId: Value(eveningSessionId),
      displayOrder: Value(displayOrder),
      content: Value(content),
      sourceType: Value(sourceType),
      sourceRefId: sourceRefId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRefId),
      userTag: userTag == null && nullToAbsent
          ? const Value.absent()
          : Value(userTag),
      taggedAt: taggedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(taggedAt),
    );
  }

  factory HighlightRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighlightRow(
      id: serializer.fromJson<int>(json['id']),
      eveningSessionId: serializer.fromJson<int>(json['eveningSessionId']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      content: serializer.fromJson<String>(json['content']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceRefId: serializer.fromJson<int?>(json['sourceRefId']),
      userTag: serializer.fromJson<String?>(json['userTag']),
      taggedAt: serializer.fromJson<int?>(json['taggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eveningSessionId': serializer.toJson<int>(eveningSessionId),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'content': serializer.toJson<String>(content),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceRefId': serializer.toJson<int?>(sourceRefId),
      'userTag': serializer.toJson<String?>(userTag),
      'taggedAt': serializer.toJson<int?>(taggedAt),
    };
  }

  HighlightRow copyWith(
          {int? id,
          int? eveningSessionId,
          int? displayOrder,
          String? content,
          String? sourceType,
          Value<int?> sourceRefId = const Value.absent(),
          Value<String?> userTag = const Value.absent(),
          Value<int?> taggedAt = const Value.absent()}) =>
      HighlightRow(
        id: id ?? this.id,
        eveningSessionId: eveningSessionId ?? this.eveningSessionId,
        displayOrder: displayOrder ?? this.displayOrder,
        content: content ?? this.content,
        sourceType: sourceType ?? this.sourceType,
        sourceRefId: sourceRefId.present ? sourceRefId.value : this.sourceRefId,
        userTag: userTag.present ? userTag.value : this.userTag,
        taggedAt: taggedAt.present ? taggedAt.value : this.taggedAt,
      );
  HighlightRow copyWithCompanion(EveningHighlightsCompanion data) {
    return HighlightRow(
      id: data.id.present ? data.id.value : this.id,
      eveningSessionId: data.eveningSessionId.present
          ? data.eveningSessionId.value
          : this.eveningSessionId,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      content: data.content.present ? data.content.value : this.content,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      sourceRefId:
          data.sourceRefId.present ? data.sourceRefId.value : this.sourceRefId,
      userTag: data.userTag.present ? data.userTag.value : this.userTag,
      taggedAt: data.taggedAt.present ? data.taggedAt.value : this.taggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HighlightRow(')
          ..write('id: $id, ')
          ..write('eveningSessionId: $eveningSessionId, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('content: $content, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceRefId: $sourceRefId, ')
          ..write('userTag: $userTag, ')
          ..write('taggedAt: $taggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eveningSessionId, displayOrder, content,
      sourceType, sourceRefId, userTag, taggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighlightRow &&
          other.id == this.id &&
          other.eveningSessionId == this.eveningSessionId &&
          other.displayOrder == this.displayOrder &&
          other.content == this.content &&
          other.sourceType == this.sourceType &&
          other.sourceRefId == this.sourceRefId &&
          other.userTag == this.userTag &&
          other.taggedAt == this.taggedAt);
}

class EveningHighlightsCompanion extends UpdateCompanion<HighlightRow> {
  final Value<int> id;
  final Value<int> eveningSessionId;
  final Value<int> displayOrder;
  final Value<String> content;
  final Value<String> sourceType;
  final Value<int?> sourceRefId;
  final Value<String?> userTag;
  final Value<int?> taggedAt;
  const EveningHighlightsCompanion({
    this.id = const Value.absent(),
    this.eveningSessionId = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.content = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceRefId = const Value.absent(),
    this.userTag = const Value.absent(),
    this.taggedAt = const Value.absent(),
  });
  EveningHighlightsCompanion.insert({
    this.id = const Value.absent(),
    required int eveningSessionId,
    required int displayOrder,
    required String content,
    required String sourceType,
    this.sourceRefId = const Value.absent(),
    this.userTag = const Value.absent(),
    this.taggedAt = const Value.absent(),
  })  : eveningSessionId = Value(eveningSessionId),
        displayOrder = Value(displayOrder),
        content = Value(content),
        sourceType = Value(sourceType);
  static Insertable<HighlightRow> custom({
    Expression<int>? id,
    Expression<int>? eveningSessionId,
    Expression<int>? displayOrder,
    Expression<String>? content,
    Expression<String>? sourceType,
    Expression<int>? sourceRefId,
    Expression<String>? userTag,
    Expression<int>? taggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eveningSessionId != null) 'evening_session_id': eveningSessionId,
      if (displayOrder != null) 'display_order': displayOrder,
      if (content != null) 'content': content,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceRefId != null) 'source_ref_id': sourceRefId,
      if (userTag != null) 'user_tag': userTag,
      if (taggedAt != null) 'tagged_at': taggedAt,
    });
  }

  EveningHighlightsCompanion copyWith(
      {Value<int>? id,
      Value<int>? eveningSessionId,
      Value<int>? displayOrder,
      Value<String>? content,
      Value<String>? sourceType,
      Value<int?>? sourceRefId,
      Value<String?>? userTag,
      Value<int?>? taggedAt}) {
    return EveningHighlightsCompanion(
      id: id ?? this.id,
      eveningSessionId: eveningSessionId ?? this.eveningSessionId,
      displayOrder: displayOrder ?? this.displayOrder,
      content: content ?? this.content,
      sourceType: sourceType ?? this.sourceType,
      sourceRefId: sourceRefId ?? this.sourceRefId,
      userTag: userTag ?? this.userTag,
      taggedAt: taggedAt ?? this.taggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eveningSessionId.present) {
      map['evening_session_id'] = Variable<int>(eveningSessionId.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceRefId.present) {
      map['source_ref_id'] = Variable<int>(sourceRefId.value);
    }
    if (userTag.present) {
      map['user_tag'] = Variable<String>(userTag.value);
    }
    if (taggedAt.present) {
      map['tagged_at'] = Variable<int>(taggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EveningHighlightsCompanion(')
          ..write('id: $id, ')
          ..write('eveningSessionId: $eveningSessionId, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('content: $content, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceRefId: $sourceRefId, ')
          ..write('userTag: $userTag, ')
          ..write('taggedAt: $taggedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SkillsTable skills = $SkillsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $SuggestionsTable suggestions = $SuggestionsTable(this);
  late final $EveningSessionsTable eveningSessions =
      $EveningSessionsTable(this);
  late final $EveningHighlightsTable eveningHighlights =
      $EveningHighlightsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        skills,
        sessions,
        events,
        suggestions,
        eveningSessions,
        eveningHighlights
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('skills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('sessions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('skills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('suggestions', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('evening_sessions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('evening_highlights', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$SkillsTableCreateCompanionBuilder = SkillsCompanion Function({
  Value<int> id,
  required String name,
  required int createdAt,
  Value<int?> lastSessionAt,
});
typedef $$SkillsTableUpdateCompanionBuilder = SkillsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> createdAt,
  Value<int?> lastSessionAt,
});

final class $$SkillsTableReferences
    extends BaseReferences<_$AppDatabase, $SkillsTable, SkillRow> {
  $$SkillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<SessionRow>>
      _sessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.sessions,
          aliasName: $_aliasNameGenerator(db.skills.id, db.sessions.skillId));

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.skillId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SuggestionsTable, List<SuggestionRow>>
      _suggestionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.suggestions,
              aliasName:
                  $_aliasNameGenerator(db.skills.id, db.suggestions.skillId));

  $$SuggestionsTableProcessedTableManager get suggestionsRefs {
    final manager = $$SuggestionsTableTableManager($_db, $_db.suggestions)
        .filter((f) => f.skillId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_suggestionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SkillsTableFilterComposer
    extends Composer<_$AppDatabase, $SkillsTable> {
  $$SkillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSessionAt => $composableBuilder(
      column: $table.lastSessionAt, builder: (column) => ColumnFilters(column));

  Expression<bool> sessionsRefs(
      Expression<bool> Function($$SessionsTableFilterComposer f) f) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.skillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> suggestionsRefs(
      Expression<bool> Function($$SuggestionsTableFilterComposer f) f) {
    final $$SuggestionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.suggestions,
        getReferencedColumn: (t) => t.skillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuggestionsTableFilterComposer(
              $db: $db,
              $table: $db.suggestions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SkillsTableOrderingComposer
    extends Composer<_$AppDatabase, $SkillsTable> {
  $$SkillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSessionAt => $composableBuilder(
      column: $table.lastSessionAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SkillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkillsTable> {
  $$SkillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get lastSessionAt => $composableBuilder(
      column: $table.lastSessionAt, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
      Expression<T> Function($$SessionsTableAnnotationComposer a) f) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.skillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> suggestionsRefs<T extends Object>(
      Expression<T> Function($$SuggestionsTableAnnotationComposer a) f) {
    final $$SuggestionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.suggestions,
        getReferencedColumn: (t) => t.skillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuggestionsTableAnnotationComposer(
              $db: $db,
              $table: $db.suggestions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SkillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SkillsTable,
    SkillRow,
    $$SkillsTableFilterComposer,
    $$SkillsTableOrderingComposer,
    $$SkillsTableAnnotationComposer,
    $$SkillsTableCreateCompanionBuilder,
    $$SkillsTableUpdateCompanionBuilder,
    (SkillRow, $$SkillsTableReferences),
    SkillRow,
    PrefetchHooks Function({bool sessionsRefs, bool suggestionsRefs})> {
  $$SkillsTableTableManager(_$AppDatabase db, $SkillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int?> lastSessionAt = const Value.absent(),
          }) =>
              SkillsCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            lastSessionAt: lastSessionAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int createdAt,
            Value<int?> lastSessionAt = const Value.absent(),
          }) =>
              SkillsCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            lastSessionAt: lastSessionAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SkillsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {sessionsRefs = false, suggestionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionsRefs) db.sessions,
                if (suggestionsRefs) db.suggestions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<SkillRow, $SkillsTable,
                            SessionRow>(
                        currentTable: table,
                        referencedTable:
                            $$SkillsTableReferences._sessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SkillsTableReferences(db, table, p0).sessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.skillId == item.id),
                        typedResults: items),
                  if (suggestionsRefs)
                    await $_getPrefetchedData<SkillRow, $SkillsTable,
                            SuggestionRow>(
                        currentTable: table,
                        referencedTable:
                            $$SkillsTableReferences._suggestionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SkillsTableReferences(db, table, p0)
                                .suggestionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.skillId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SkillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SkillsTable,
    SkillRow,
    $$SkillsTableFilterComposer,
    $$SkillsTableOrderingComposer,
    $$SkillsTableAnnotationComposer,
    $$SkillsTableCreateCompanionBuilder,
    $$SkillsTableUpdateCompanionBuilder,
    (SkillRow, $$SkillsTableReferences),
    SkillRow,
    PrefetchHooks Function({bool sessionsRefs, bool suggestionsRefs})>;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required int skillId,
  required int startedAt,
  required int durationMinutes,
  Value<String?> notes,
  Value<bool> isAnchored,
  Value<int?> suggestedTime,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int> skillId,
  Value<int> startedAt,
  Value<int> durationMinutes,
  Value<String?> notes,
  Value<bool> isAnchored,
  Value<int?> suggestedTime,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, SessionRow> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SkillsTable _skillIdTable(_$AppDatabase db) => db.skills
      .createAlias($_aliasNameGenerator(db.sessions.skillId, db.skills.id));

  $$SkillsTableProcessedTableManager get skillId {
    final $_column = $_itemColumn<int>('skill_id')!;

    final manager = $$SkillsTableTableManager($_db, $_db.skills)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_skillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAnchored => $composableBuilder(
      column: $table.isAnchored, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get suggestedTime => $composableBuilder(
      column: $table.suggestedTime, builder: (column) => ColumnFilters(column));

  $$SkillsTableFilterComposer get skillId {
    final $$SkillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableFilterComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAnchored => $composableBuilder(
      column: $table.isAnchored, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get suggestedTime => $composableBuilder(
      column: $table.suggestedTime,
      builder: (column) => ColumnOrderings(column));

  $$SkillsTableOrderingComposer get skillId {
    final $$SkillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableOrderingComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isAnchored => $composableBuilder(
      column: $table.isAnchored, builder: (column) => column);

  GeneratedColumn<int> get suggestedTime => $composableBuilder(
      column: $table.suggestedTime, builder: (column) => column);

  $$SkillsTableAnnotationComposer get skillId {
    final $$SkillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableAnnotationComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    SessionRow,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (SessionRow, $$SessionsTableReferences),
    SessionRow,
    PrefetchHooks Function({bool skillId})> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> skillId = const Value.absent(),
            Value<int> startedAt = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isAnchored = const Value.absent(),
            Value<int?> suggestedTime = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            skillId: skillId,
            startedAt: startedAt,
            durationMinutes: durationMinutes,
            notes: notes,
            isAnchored: isAnchored,
            suggestedTime: suggestedTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int skillId,
            required int startedAt,
            required int durationMinutes,
            Value<String?> notes = const Value.absent(),
            Value<bool> isAnchored = const Value.absent(),
            Value<int?> suggestedTime = const Value.absent(),
          }) =>
              SessionsCompanion.insert(
            id: id,
            skillId: skillId,
            startedAt: startedAt,
            durationMinutes: durationMinutes,
            notes: notes,
            isAnchored: isAnchored,
            suggestedTime: suggestedTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SessionsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({skillId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (skillId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.skillId,
                    referencedTable:
                        $$SessionsTableReferences._skillIdTable(db),
                    referencedColumn:
                        $$SessionsTableReferences._skillIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTable,
    SessionRow,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (SessionRow, $$SessionsTableReferences),
    SessionRow,
    PrefetchHooks Function({bool skillId})>;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required String title,
  required int startTime,
  required int endTime,
  required String category,
  Value<String?> notes,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<int> startTime,
  Value<int> endTime,
  Value<String> category,
  Value<String?> notes,
});

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$EventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventsTable,
    EventRow,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (EventRow, BaseReferences<_$AppDatabase, $EventsTable, EventRow>),
    EventRow,
    PrefetchHooks Function()> {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> startTime = const Value.absent(),
            Value<int> endTime = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              EventsCompanion(
            id: id,
            title: title,
            startTime: startTime,
            endTime: endTime,
            category: category,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required int startTime,
            required int endTime,
            required String category,
            Value<String?> notes = const Value.absent(),
          }) =>
              EventsCompanion.insert(
            id: id,
            title: title,
            startTime: startTime,
            endTime: endTime,
            category: category,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventsTable,
    EventRow,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (EventRow, BaseReferences<_$AppDatabase, $EventsTable, EventRow>),
    EventRow,
    PrefetchHooks Function()>;
typedef $$SuggestionsTableCreateCompanionBuilder = SuggestionsCompanion
    Function({
  Value<int> id,
  Value<int?> skillId,
  required int slotStart,
  required int slotDuration,
  required int suggestedAt,
  Value<int?> acceptedAt,
  Value<int?> dismissedAt,
  Value<int?> thumbsDownAt,
  Value<int?> suppressedUntil,
});
typedef $$SuggestionsTableUpdateCompanionBuilder = SuggestionsCompanion
    Function({
  Value<int> id,
  Value<int?> skillId,
  Value<int> slotStart,
  Value<int> slotDuration,
  Value<int> suggestedAt,
  Value<int?> acceptedAt,
  Value<int?> dismissedAt,
  Value<int?> thumbsDownAt,
  Value<int?> suppressedUntil,
});

final class $$SuggestionsTableReferences
    extends BaseReferences<_$AppDatabase, $SuggestionsTable, SuggestionRow> {
  $$SuggestionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SkillsTable _skillIdTable(_$AppDatabase db) => db.skills
      .createAlias($_aliasNameGenerator(db.suggestions.skillId, db.skills.id));

  $$SkillsTableProcessedTableManager? get skillId {
    final $_column = $_itemColumn<int>('skill_id');
    if ($_column == null) return null;
    final manager = $$SkillsTableTableManager($_db, $_db.skills)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_skillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SuggestionsTableFilterComposer
    extends Composer<_$AppDatabase, $SuggestionsTable> {
  $$SuggestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get slotStart => $composableBuilder(
      column: $table.slotStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get slotDuration => $composableBuilder(
      column: $table.slotDuration, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get suggestedAt => $composableBuilder(
      column: $table.suggestedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get acceptedAt => $composableBuilder(
      column: $table.acceptedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dismissedAt => $composableBuilder(
      column: $table.dismissedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get thumbsDownAt => $composableBuilder(
      column: $table.thumbsDownAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get suppressedUntil => $composableBuilder(
      column: $table.suppressedUntil,
      builder: (column) => ColumnFilters(column));

  $$SkillsTableFilterComposer get skillId {
    final $$SkillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableFilterComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SuggestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SuggestionsTable> {
  $$SuggestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get slotStart => $composableBuilder(
      column: $table.slotStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get slotDuration => $composableBuilder(
      column: $table.slotDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get suggestedAt => $composableBuilder(
      column: $table.suggestedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get acceptedAt => $composableBuilder(
      column: $table.acceptedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dismissedAt => $composableBuilder(
      column: $table.dismissedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get thumbsDownAt => $composableBuilder(
      column: $table.thumbsDownAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get suppressedUntil => $composableBuilder(
      column: $table.suppressedUntil,
      builder: (column) => ColumnOrderings(column));

  $$SkillsTableOrderingComposer get skillId {
    final $$SkillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableOrderingComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SuggestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuggestionsTable> {
  $$SuggestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get slotStart =>
      $composableBuilder(column: $table.slotStart, builder: (column) => column);

  GeneratedColumn<int> get slotDuration => $composableBuilder(
      column: $table.slotDuration, builder: (column) => column);

  GeneratedColumn<int> get suggestedAt => $composableBuilder(
      column: $table.suggestedAt, builder: (column) => column);

  GeneratedColumn<int> get acceptedAt => $composableBuilder(
      column: $table.acceptedAt, builder: (column) => column);

  GeneratedColumn<int> get dismissedAt => $composableBuilder(
      column: $table.dismissedAt, builder: (column) => column);

  GeneratedColumn<int> get thumbsDownAt => $composableBuilder(
      column: $table.thumbsDownAt, builder: (column) => column);

  GeneratedColumn<int> get suppressedUntil => $composableBuilder(
      column: $table.suppressedUntil, builder: (column) => column);

  $$SkillsTableAnnotationComposer get skillId {
    final $$SkillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableAnnotationComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SuggestionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuggestionsTable,
    SuggestionRow,
    $$SuggestionsTableFilterComposer,
    $$SuggestionsTableOrderingComposer,
    $$SuggestionsTableAnnotationComposer,
    $$SuggestionsTableCreateCompanionBuilder,
    $$SuggestionsTableUpdateCompanionBuilder,
    (SuggestionRow, $$SuggestionsTableReferences),
    SuggestionRow,
    PrefetchHooks Function({bool skillId})> {
  $$SuggestionsTableTableManager(_$AppDatabase db, $SuggestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuggestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuggestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuggestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> skillId = const Value.absent(),
            Value<int> slotStart = const Value.absent(),
            Value<int> slotDuration = const Value.absent(),
            Value<int> suggestedAt = const Value.absent(),
            Value<int?> acceptedAt = const Value.absent(),
            Value<int?> dismissedAt = const Value.absent(),
            Value<int?> thumbsDownAt = const Value.absent(),
            Value<int?> suppressedUntil = const Value.absent(),
          }) =>
              SuggestionsCompanion(
            id: id,
            skillId: skillId,
            slotStart: slotStart,
            slotDuration: slotDuration,
            suggestedAt: suggestedAt,
            acceptedAt: acceptedAt,
            dismissedAt: dismissedAt,
            thumbsDownAt: thumbsDownAt,
            suppressedUntil: suppressedUntil,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> skillId = const Value.absent(),
            required int slotStart,
            required int slotDuration,
            required int suggestedAt,
            Value<int?> acceptedAt = const Value.absent(),
            Value<int?> dismissedAt = const Value.absent(),
            Value<int?> thumbsDownAt = const Value.absent(),
            Value<int?> suppressedUntil = const Value.absent(),
          }) =>
              SuggestionsCompanion.insert(
            id: id,
            skillId: skillId,
            slotStart: slotStart,
            slotDuration: slotDuration,
            suggestedAt: suggestedAt,
            acceptedAt: acceptedAt,
            dismissedAt: dismissedAt,
            thumbsDownAt: thumbsDownAt,
            suppressedUntil: suppressedUntil,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SuggestionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({skillId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (skillId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.skillId,
                    referencedTable:
                        $$SuggestionsTableReferences._skillIdTable(db),
                    referencedColumn:
                        $$SuggestionsTableReferences._skillIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SuggestionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SuggestionsTable,
    SuggestionRow,
    $$SuggestionsTableFilterComposer,
    $$SuggestionsTableOrderingComposer,
    $$SuggestionsTableAnnotationComposer,
    $$SuggestionsTableCreateCompanionBuilder,
    $$SuggestionsTableUpdateCompanionBuilder,
    (SuggestionRow, $$SuggestionsTableReferences),
    SuggestionRow,
    PrefetchHooks Function({bool skillId})>;
typedef $$EveningSessionsTableCreateCompanionBuilder = EveningSessionsCompanion
    Function({
  Value<int> id,
  required String sessionDate,
  required int startedAt,
  Value<int?> completedAt,
  Value<int?> abandonedAt,
  required String headline,
  Value<String?> closeSummary,
});
typedef $$EveningSessionsTableUpdateCompanionBuilder = EveningSessionsCompanion
    Function({
  Value<int> id,
  Value<String> sessionDate,
  Value<int> startedAt,
  Value<int?> completedAt,
  Value<int?> abandonedAt,
  Value<String> headline,
  Value<String?> closeSummary,
});

final class $$EveningSessionsTableReferences extends BaseReferences<
    _$AppDatabase, $EveningSessionsTable, EveningSessionRow> {
  $$EveningSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EveningHighlightsTable, List<HighlightRow>>
      _eveningHighlightsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.eveningHighlights,
              aliasName: $_aliasNameGenerator(db.eveningSessions.id,
                  db.eveningHighlights.eveningSessionId));

  $$EveningHighlightsTableProcessedTableManager get eveningHighlightsRefs {
    final manager = $$EveningHighlightsTableTableManager(
            $_db, $_db.eveningHighlights)
        .filter(
            (f) => f.eveningSessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_eveningHighlightsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EveningSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $EveningSessionsTable> {
  $$EveningSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionDate => $composableBuilder(
      column: $table.sessionDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get abandonedAt => $composableBuilder(
      column: $table.abandonedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get headline => $composableBuilder(
      column: $table.headline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closeSummary => $composableBuilder(
      column: $table.closeSummary, builder: (column) => ColumnFilters(column));

  Expression<bool> eveningHighlightsRefs(
      Expression<bool> Function($$EveningHighlightsTableFilterComposer f) f) {
    final $$EveningHighlightsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.eveningHighlights,
        getReferencedColumn: (t) => t.eveningSessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EveningHighlightsTableFilterComposer(
              $db: $db,
              $table: $db.eveningHighlights,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EveningSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EveningSessionsTable> {
  $$EveningSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionDate => $composableBuilder(
      column: $table.sessionDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get abandonedAt => $composableBuilder(
      column: $table.abandonedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get headline => $composableBuilder(
      column: $table.headline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closeSummary => $composableBuilder(
      column: $table.closeSummary,
      builder: (column) => ColumnOrderings(column));
}

class $$EveningSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EveningSessionsTable> {
  $$EveningSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionDate => $composableBuilder(
      column: $table.sessionDate, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get abandonedAt => $composableBuilder(
      column: $table.abandonedAt, builder: (column) => column);

  GeneratedColumn<String> get headline =>
      $composableBuilder(column: $table.headline, builder: (column) => column);

  GeneratedColumn<String> get closeSummary => $composableBuilder(
      column: $table.closeSummary, builder: (column) => column);

  Expression<T> eveningHighlightsRefs<T extends Object>(
      Expression<T> Function($$EveningHighlightsTableAnnotationComposer a) f) {
    final $$EveningHighlightsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.eveningHighlights,
            getReferencedColumn: (t) => t.eveningSessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EveningHighlightsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.eveningHighlights,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$EveningSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EveningSessionsTable,
    EveningSessionRow,
    $$EveningSessionsTableFilterComposer,
    $$EveningSessionsTableOrderingComposer,
    $$EveningSessionsTableAnnotationComposer,
    $$EveningSessionsTableCreateCompanionBuilder,
    $$EveningSessionsTableUpdateCompanionBuilder,
    (EveningSessionRow, $$EveningSessionsTableReferences),
    EveningSessionRow,
    PrefetchHooks Function({bool eveningHighlightsRefs})> {
  $$EveningSessionsTableTableManager(
      _$AppDatabase db, $EveningSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EveningSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EveningSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EveningSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sessionDate = const Value.absent(),
            Value<int> startedAt = const Value.absent(),
            Value<int?> completedAt = const Value.absent(),
            Value<int?> abandonedAt = const Value.absent(),
            Value<String> headline = const Value.absent(),
            Value<String?> closeSummary = const Value.absent(),
          }) =>
              EveningSessionsCompanion(
            id: id,
            sessionDate: sessionDate,
            startedAt: startedAt,
            completedAt: completedAt,
            abandonedAt: abandonedAt,
            headline: headline,
            closeSummary: closeSummary,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sessionDate,
            required int startedAt,
            Value<int?> completedAt = const Value.absent(),
            Value<int?> abandonedAt = const Value.absent(),
            required String headline,
            Value<String?> closeSummary = const Value.absent(),
          }) =>
              EveningSessionsCompanion.insert(
            id: id,
            sessionDate: sessionDate,
            startedAt: startedAt,
            completedAt: completedAt,
            abandonedAt: abandonedAt,
            headline: headline,
            closeSummary: closeSummary,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EveningSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({eveningHighlightsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eveningHighlightsRefs) db.eveningHighlights
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eveningHighlightsRefs)
                    await $_getPrefetchedData<EveningSessionRow,
                            $EveningSessionsTable, HighlightRow>(
                        currentTable: table,
                        referencedTable: $$EveningSessionsTableReferences
                            ._eveningHighlightsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EveningSessionsTableReferences(db, table, p0)
                                .eveningHighlightsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.eveningSessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EveningSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EveningSessionsTable,
    EveningSessionRow,
    $$EveningSessionsTableFilterComposer,
    $$EveningSessionsTableOrderingComposer,
    $$EveningSessionsTableAnnotationComposer,
    $$EveningSessionsTableCreateCompanionBuilder,
    $$EveningSessionsTableUpdateCompanionBuilder,
    (EveningSessionRow, $$EveningSessionsTableReferences),
    EveningSessionRow,
    PrefetchHooks Function({bool eveningHighlightsRefs})>;
typedef $$EveningHighlightsTableCreateCompanionBuilder
    = EveningHighlightsCompanion Function({
  Value<int> id,
  required int eveningSessionId,
  required int displayOrder,
  required String content,
  required String sourceType,
  Value<int?> sourceRefId,
  Value<String?> userTag,
  Value<int?> taggedAt,
});
typedef $$EveningHighlightsTableUpdateCompanionBuilder
    = EveningHighlightsCompanion Function({
  Value<int> id,
  Value<int> eveningSessionId,
  Value<int> displayOrder,
  Value<String> content,
  Value<String> sourceType,
  Value<int?> sourceRefId,
  Value<String?> userTag,
  Value<int?> taggedAt,
});

final class $$EveningHighlightsTableReferences extends BaseReferences<
    _$AppDatabase, $EveningHighlightsTable, HighlightRow> {
  $$EveningHighlightsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EveningSessionsTable _eveningSessionIdTable(_$AppDatabase db) =>
      db.eveningSessions.createAlias($_aliasNameGenerator(
          db.eveningHighlights.eveningSessionId, db.eveningSessions.id));

  $$EveningSessionsTableProcessedTableManager get eveningSessionId {
    final $_column = $_itemColumn<int>('evening_session_id')!;

    final manager =
        $$EveningSessionsTableTableManager($_db, $_db.eveningSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eveningSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EveningHighlightsTableFilterComposer
    extends Composer<_$AppDatabase, $EveningHighlightsTable> {
  $$EveningHighlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceRefId => $composableBuilder(
      column: $table.sourceRefId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userTag => $composableBuilder(
      column: $table.userTag, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taggedAt => $composableBuilder(
      column: $table.taggedAt, builder: (column) => ColumnFilters(column));

  $$EveningSessionsTableFilterComposer get eveningSessionId {
    final $$EveningSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eveningSessionId,
        referencedTable: $db.eveningSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EveningSessionsTableFilterComposer(
              $db: $db,
              $table: $db.eveningSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EveningHighlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $EveningHighlightsTable> {
  $$EveningHighlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceRefId => $composableBuilder(
      column: $table.sourceRefId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userTag => $composableBuilder(
      column: $table.userTag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taggedAt => $composableBuilder(
      column: $table.taggedAt, builder: (column) => ColumnOrderings(column));

  $$EveningSessionsTableOrderingComposer get eveningSessionId {
    final $$EveningSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eveningSessionId,
        referencedTable: $db.eveningSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EveningSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.eveningSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EveningHighlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EveningHighlightsTable> {
  $$EveningHighlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<int> get sourceRefId => $composableBuilder(
      column: $table.sourceRefId, builder: (column) => column);

  GeneratedColumn<String> get userTag =>
      $composableBuilder(column: $table.userTag, builder: (column) => column);

  GeneratedColumn<int> get taggedAt =>
      $composableBuilder(column: $table.taggedAt, builder: (column) => column);

  $$EveningSessionsTableAnnotationComposer get eveningSessionId {
    final $$EveningSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eveningSessionId,
        referencedTable: $db.eveningSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EveningSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.eveningSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EveningHighlightsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EveningHighlightsTable,
    HighlightRow,
    $$EveningHighlightsTableFilterComposer,
    $$EveningHighlightsTableOrderingComposer,
    $$EveningHighlightsTableAnnotationComposer,
    $$EveningHighlightsTableCreateCompanionBuilder,
    $$EveningHighlightsTableUpdateCompanionBuilder,
    (HighlightRow, $$EveningHighlightsTableReferences),
    HighlightRow,
    PrefetchHooks Function({bool eveningSessionId})> {
  $$EveningHighlightsTableTableManager(
      _$AppDatabase db, $EveningHighlightsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EveningHighlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EveningHighlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EveningHighlightsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> eveningSessionId = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> sourceType = const Value.absent(),
            Value<int?> sourceRefId = const Value.absent(),
            Value<String?> userTag = const Value.absent(),
            Value<int?> taggedAt = const Value.absent(),
          }) =>
              EveningHighlightsCompanion(
            id: id,
            eveningSessionId: eveningSessionId,
            displayOrder: displayOrder,
            content: content,
            sourceType: sourceType,
            sourceRefId: sourceRefId,
            userTag: userTag,
            taggedAt: taggedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int eveningSessionId,
            required int displayOrder,
            required String content,
            required String sourceType,
            Value<int?> sourceRefId = const Value.absent(),
            Value<String?> userTag = const Value.absent(),
            Value<int?> taggedAt = const Value.absent(),
          }) =>
              EveningHighlightsCompanion.insert(
            id: id,
            eveningSessionId: eveningSessionId,
            displayOrder: displayOrder,
            content: content,
            sourceType: sourceType,
            sourceRefId: sourceRefId,
            userTag: userTag,
            taggedAt: taggedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EveningHighlightsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({eveningSessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (eveningSessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eveningSessionId,
                    referencedTable: $$EveningHighlightsTableReferences
                        ._eveningSessionIdTable(db),
                    referencedColumn: $$EveningHighlightsTableReferences
                        ._eveningSessionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EveningHighlightsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EveningHighlightsTable,
    HighlightRow,
    $$EveningHighlightsTableFilterComposer,
    $$EveningHighlightsTableOrderingComposer,
    $$EveningHighlightsTableAnnotationComposer,
    $$EveningHighlightsTableCreateCompanionBuilder,
    $$EveningHighlightsTableUpdateCompanionBuilder,
    (HighlightRow, $$EveningHighlightsTableReferences),
    HighlightRow,
    PrefetchHooks Function({bool eveningSessionId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SkillsTableTableManager get skills =>
      $$SkillsTableTableManager(_db, _db.skills);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$SuggestionsTableTableManager get suggestions =>
      $$SuggestionsTableTableManager(_db, _db.suggestions);
  $$EveningSessionsTableTableManager get eveningSessions =>
      $$EveningSessionsTableTableManager(_db, _db.eveningSessions);
  $$EveningHighlightsTableTableManager get eveningHighlights =>
      $$EveningHighlightsTableTableManager(_db, _db.eveningHighlights);
}
