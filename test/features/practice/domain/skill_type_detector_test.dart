import 'package:flutter_test/flutter_test.dart';
import 'package:odo/features/practice/domain/entities/skill_type.dart';
import 'package:odo/features/practice/domain/usecases/skill_type_detector.dart';

void main() {
  group('SkillTypeDetector', () {
    test('detects language from "japonais"', () {
      expect(SkillTypeDetector.detect('japonais'), SkillType.language);
    });

    test('detects language from "French vocabulary"', () {
      expect(SkillTypeDetector.detect('French vocabulary'), SkillType.language);
    });

    test('detects strategy from "chess"', () {
      expect(SkillTypeDetector.detect('chess'), SkillType.strategy);
    });

    test('detects strategy from "Poker online"', () {
      expect(SkillTypeDetector.detect('Poker online'), SkillType.strategy);
    });

    test('detects physical from "running"', () {
      expect(SkillTypeDetector.detect('running'), SkillType.physical);
    });

    test('detects physical from "Musculation gym"', () {
      expect(SkillTypeDetector.detect('Musculation gym'), SkillType.physical);
    });

    test('detects technical from "flutter"', () {
      expect(SkillTypeDetector.detect('flutter'), SkillType.technical);
    });

    test('detects technical from "Python programming"', () {
      expect(SkillTypeDetector.detect('Python programming'), SkillType.technical);
    });

    test('detects creative from "guitar"', () {
      expect(SkillTypeDetector.detect('guitar'), SkillType.creative);
    });

    test('detects creative from "Piano classique"', () {
      expect(SkillTypeDetector.detect('Piano classique'), SkillType.creative);
    });

    test('defaults to personal for unknown name', () {
      expect(SkillTypeDetector.detect('meditation'), SkillType.personal);
    });

    test('defaults to personal for empty string', () {
      expect(SkillTypeDetector.detect(''), SkillType.personal);
    });

    test('is case-insensitive', () {
      expect(SkillTypeDetector.detect('CHESS'), SkillType.strategy);
      expect(SkillTypeDetector.detect('Japanese'), SkillType.language);
    });
  });
}
