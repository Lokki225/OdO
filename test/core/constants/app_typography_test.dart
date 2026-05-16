import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/constants/app_typography.dart';

void main() {
  group('AppTypography — type scale (AC4, AC7)', () {
    test('textDisplay is 28px w400', () {
      expect(AppTypography.textDisplay.fontSize, 28);
      expect(AppTypography.textDisplay.fontWeight, FontWeight.w400);
    });

    test('textTitle is 22px w500', () {
      expect(AppTypography.textTitle.fontSize, 22);
      expect(AppTypography.textTitle.fontWeight, FontWeight.w500);
    });

    test('textBody is 16px w400', () {
      expect(AppTypography.textBody.fontSize, 16);
      expect(AppTypography.textBody.fontWeight, FontWeight.w400);
    });

    test('textBodyMuted is 14px w400', () {
      expect(AppTypography.textBodyMuted.fontSize, 14);
      expect(AppTypography.textBodyMuted.fontWeight, FontWeight.w400);
    });

    test('textCaption is 12px w500', () {
      expect(AppTypography.textCaption.fontSize, 12);
      expect(AppTypography.textCaption.fontWeight, FontWeight.w500);
    });

    test('textMicro is 11px w600', () {
      expect(AppTypography.textMicro.fontSize, 11);
      expect(AppTypography.textMicro.fontWeight, FontWeight.w600);
    });
  });

  group('AppTypography — clock style (AC5)', () {
    test('clockStyle is 22px w500', () {
      expect(AppTypography.clockStyle.fontSize, 22);
      expect(AppTypography.clockStyle.fontWeight, FontWeight.w500);
    });

    test('clockStyle has letterSpacing 0.06', () {
      expect(AppTypography.clockStyle.letterSpacing, 0.06);
    });

    test('clockStyle has tabularFigures FontFeature', () {
      expect(AppTypography.clockStyle.fontFeatures, isNotNull);
      expect(
        AppTypography.clockStyle.fontFeatures!
            .any((f) => f == const FontFeature.tabularFigures()),
        isTrue,
      );
    });

    test('textDisplay has tabularFigures FontFeature (AC5)', () {
      expect(AppTypography.textDisplay.fontFeatures, isNotNull);
      expect(
        AppTypography.textDisplay.fontFeatures!
            .any((f) => f == const FontFeature.tabularFigures()),
        isTrue,
      );
    });
  });
}
