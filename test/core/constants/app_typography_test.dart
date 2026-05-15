import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odo/core/constants/app_typography.dart';

// google_fonts triggers async font loading on every getter call. When
// allowRuntimeFetching is false and fonts aren't in test assets, that
// Future eventually throws. The properties (fontSize, fontWeight, …) are
// set synchronously, so we run each getter inside a guarded zone that
// absorbs only the font-loading error; everything else propagates normally.
Future<TextStyle> _style(TextStyle Function() getter) async {
  late TextStyle result;
  await runZonedGuarded<Future<void>>(
    () async {
      result = getter();
      // Give the async font-loading Future a chance to fire (and be caught)
      // inside this zone before we exit it.
      await Future<void>.delayed(const Duration(milliseconds: 30));
    },
    (error, _) {
      if (!error.toString().contains('allowRuntimeFetching')) throw error;
    },
  );
  return result;
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppTypography — type scale (AC4, AC7)', () {
    test('textDisplay is 28px w400', () async {
      final style = await _style(() => AppTypography.textDisplay);
      expect(style.fontSize, 28);
      expect(style.fontWeight, FontWeight.w400);
    });

    test('textTitle is 22px w500', () async {
      final style = await _style(() => AppTypography.textTitle);
      expect(style.fontSize, 22);
      expect(style.fontWeight, FontWeight.w500);
    });

    test('textBody is 16px w400', () async {
      final style = await _style(() => AppTypography.textBody);
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w400);
    });

    test('textBodyMuted is 14px w400', () async {
      final style = await _style(() => AppTypography.textBodyMuted);
      expect(style.fontSize, 14);
      expect(style.fontWeight, FontWeight.w400);
    });

    test('textCaption is 12px w500', () async {
      final style = await _style(() => AppTypography.textCaption);
      expect(style.fontSize, 12);
      expect(style.fontWeight, FontWeight.w500);
    });

    test('textMicro is 11px w600', () async {
      final style = await _style(() => AppTypography.textMicro);
      expect(style.fontSize, 11);
      expect(style.fontWeight, FontWeight.w600);
    });
  });

  group('AppTypography — clock style (AC5)', () {
    test('clockStyle is 22px w500', () async {
      final style = await _style(() => AppTypography.clockStyle);
      expect(style.fontSize, 22);
      expect(style.fontWeight, FontWeight.w500);
    });

    test('clockStyle has letterSpacing 0.06', () async {
      final style = await _style(() => AppTypography.clockStyle);
      expect(style.letterSpacing, 0.06);
    });

    test('clockStyle has tabularFigures FontFeature', () async {
      final style = await _style(() => AppTypography.clockStyle);
      expect(style.fontFeatures, isNotNull);
      expect(
        style.fontFeatures!.any((f) => f == const FontFeature.tabularFigures()),
        isTrue,
      );
    });

    test('textDisplay has tabularFigures FontFeature (AC5)', () async {
      final style = await _style(() => AppTypography.textDisplay);
      expect(style.fontFeatures, isNotNull);
      expect(
        style.fontFeatures!.any((f) => f == const FontFeature.tabularFigures()),
        isTrue,
      );
    });
  });
}
