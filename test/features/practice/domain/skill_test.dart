import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/types/result.dart';
import 'package:odo/features/practice/domain/entities/session.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/entities/skill_type.dart';

void main() {
  final baseDate = DateTime(2026, 1, 1);

  Skill makeSkill({String name = 'Japanese', SkillType type = SkillType.language}) {
    return Skill(
      name: name,
      type: type,
      sessionssSinceLevelUpdate: 0,
      createdAt: baseDate,
      isArchived: false,
    );
  }

  // TS-037 — SkillType enum values
  group('SkillType', () {
    test('has exactly 6 values', () {
      expect(SkillType.values.length, 6);
    });

    test('language.value == "language"', () {
      expect(SkillType.language.value, 'language');
    });

    test('strategy.value == "strategy"', () {
      expect(SkillType.strategy.value, 'strategy');
    });

    test('physical.value == "physical"', () {
      expect(SkillType.physical.value, 'physical');
    });

    test('technical.value == "technical"', () {
      expect(SkillType.technical.value, 'technical');
    });

    test('creative.value == "creative"', () {
      expect(SkillType.creative.value, 'creative');
    });

    test('personal.value == "personal"', () {
      expect(SkillType.personal.value, 'personal');
    });
  });

  // TS-038 — Skill entity construction
  group('Skill entity', () {
    test('constructs with required fields, nullables default to null', () {
      final skill = makeSkill();
      expect(skill.id, isNull);
      expect(skill.metricConfig, isNull);
      expect(skill.levelLabel, isNull);
      expect(skill.levelUpdatedAt, isNull);
      expect(skill.lastSessionAt, isNull);
      expect(skill.suppressedUntil, isNull);
      expect(skill.isArchived, isFalse);
      expect(skill.sessionssSinceLevelUpdate, 0);
    });

    // TS-039 — validate() empty name
    test('validate() returns Failure on blank name', () {
      final result = makeSkill(name: '   ').validate();
      expect(result, isA<Failure<Skill>>());
      expect((result as Failure<Skill>).error, AppError.validationFailed);
    });

    // TS-040 — validate() valid name
    test('validate() returns Success on non-empty name', () {
      final skill = makeSkill(name: 'Japanese');
      final result = skill.validate();
      expect(result, isA<Success<Skill>>());
      expect((result as Success<Skill>).value, skill);
    });

    test('validate() trims whitespace before checking empty', () {
      final result = makeSkill(name: '\t\n').validate();
      expect(result, isA<Failure<Skill>>());
    });

    test('copyWith returns new instance with changed fields', () {
      final original = makeSkill();
      final copy = original.copyWith(name: 'Chess', type: SkillType.strategy);
      expect(copy.name, 'Chess');
      expect(copy.type, SkillType.strategy);
      expect(copy.isArchived, original.isArchived);
    });

    test('copyWith with clearId=true sets id to null', () {
      final skill = makeSkill().copyWith(id: 5);
      final cleared = skill.copyWith(clearId: true);
      expect(cleared.id, isNull);
    });
  });

  // TS-041 — Session entity construction
  group('Session entity', () {
    test('constructs with required fields, nullables default to null', () {
      final session = Session(
        skillId: 1,
        startedAt: baseDate,
        durationMinutes: 30,
        modeTags: const [],
        isAnchored: false,
        isMilestone: false,
      );
      expect(session.id, isNull);
      expect(session.performanceMetric, isNull);
      expect(session.feelScore, isNull);
      expect(session.notes, isNull);
      expect(session.suggestedTime, isNull);
      expect(session.milestoneLabel, isNull);
    });
  });
}
