import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odo/app/theme.dart';
import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/constants/app_spacing.dart';

// All calls to AppTheme.fromOdoTheme pass textThemeOverride: const TextTheme()
// to prevent google_fonts async font loading from leaking into test assertions.
ThemeData _build(dynamic theme) =>
    AppTheme.fromOdoTheme(theme, textThemeOverride: const TextTheme());

void main() {
  group('AppTheme.fromOdoTheme (AC1, AC11)', () {
    test('returns a ThemeData', () {
      expect(_build(AppColors.violetDark), isA<ThemeData>());
    });

    test('uses Material3', () {
      expect(_build(AppColors.violetDark).useMaterial3, isTrue);
    });

    test('dark theme has dark brightness', () {
      expect(_build(AppColors.violetDark).colorScheme.brightness, Brightness.dark);
    });

    test('light theme has light brightness', () {
      expect(_build(AppColors.lightMode).colorScheme.brightness, Brightness.light);
    });

    test('scaffoldBackgroundColor matches theme background', () {
      expect(
        _build(AppColors.violetDark).scaffoldBackgroundColor,
        AppColors.violetDark.colorBackground,
      );
    });

    test('scaffoldBackgroundColor changes when theme changes (AC11)', () {
      expect(
        _build(AppColors.violetDark).scaffoldBackgroundColor,
        isNot(_build(AppColors.lightMode).scaffoldBackgroundColor),
      );
    });

    test('primary color maps to theme accent', () {
      expect(
        _build(AppColors.violetDark).colorScheme.primary,
        AppColors.violetDark.colorAccent,
      );
    });

    test('accent remaps for different theme (AC11)', () {
      expect(
        _build(AppColors.violetDark).colorScheme.primary,
        isNot(_build(AppColors.cyanDark).colorScheme.primary),
      );
    });

    test('card theme uses surface color from OdoTheme', () {
      expect(
        _build(AppColors.violetDark).cardTheme.color,
        AppColors.violetDark.colorSurface,
      );
    });

    test('card shape uses radiusLg', () {
      final shape =
          _build(AppColors.violetDark).cardTheme.shape as RoundedRectangleBorder;
      final br = shape.borderRadius as BorderRadius;
      expect(br.topLeft.x, AppSpacing.radiusLg);
    });

    test('bottom sheet radius uses radiusXl', () {
      final shape = _build(AppColors.violetDark).bottomSheetTheme.shape
          as RoundedRectangleBorder;
      final br = shape.borderRadius as BorderRadius;
      expect(br.topLeft.x, AppSpacing.radiusXl);
    });

    test('custom accent override is reflected in ThemeData (AC11)', () {
      final custom = AppColors.violetDark.withCustomAccent('#FF0000');
      expect(
        _build(custom).colorScheme.primary,
        const Color(0xFFFF0000),
      );
    });
  });
}
