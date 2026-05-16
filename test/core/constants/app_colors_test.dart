import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/constants/app_colors.dart';

void main() {
  group('AppColors — raw palette (AC1)', () {
    test('violetPrimary is #7C4DFF', () {
      expect(AppColors.violetPrimary, const Color(0xFF7C4DFF));
    });

    test('cyanPrimary is #00C2D4', () {
      expect(AppColors.cyanPrimary, const Color(0xFF00C2D4));
    });

    test('greenPrimary is #1D9E75', () {
      expect(AppColors.greenPrimary, const Color(0xFF1D9E75));
    });

    test('emberOrange is #FF6B35', () {
      expect(AppColors.emberOrange, const Color(0xFFFF6B35));
    });

    test('cosmicMagenta is #C770FF', () {
      expect(AppColors.cosmicMagenta, const Color(0xFFC770FF));
    });

    test('auroraTeal is #2DD4BF', () {
      expect(AppColors.auroraTeal, const Color(0xFF2DD4BF));
    });

    test('darkBg is OLED #0D0D0F', () {
      expect(AppColors.darkBg, const Color(0xFF0D0D0F));
    });

    test('lightBg is #FDFBF7', () {
      expect(AppColors.lightBg, const Color(0xFFFDFBF7));
    });
  });

  group('AppColors — category semantic tokens (AC3, AC6)', () {
    test('colorCategoryPersonal is violet #7C4DFF', () {
      expect(AppColors.colorCategoryPersonal, const Color(0xFF7C4DFF));
    });

    test('colorCategoryWork is cyan #00C2D4', () {
      expect(AppColors.colorCategoryWork, const Color(0xFF00C2D4));
    });

    test('colorCategoryPractice is green #1D9E75', () {
      expect(AppColors.colorCategoryPractice, const Color(0xFF1D9E75));
    });

    test('colorAccentAgenda aliases colorCategoryPersonal', () {
      expect(AppColors.colorAccentAgenda, AppColors.colorCategoryPersonal);
    });

    test('colorAccentWork aliases colorCategoryWork', () {
      expect(AppColors.colorAccentWork, AppColors.colorCategoryWork);
    });

    test('colorAccentPractice aliases colorCategoryPractice', () {
      expect(AppColors.colorAccentPractice, AppColors.colorCategoryPractice);
    });
  });

  group('AppColors.allThemes — seven presets count (AC4)', () {
    test('allThemes contains exactly 7 presets', () {
      expect(AppColors.allThemes.length, 7);
    });

    test('allThemes contains all named presets', () {
      final names = AppColors.allThemes.map((t) => t.name).toList();
      expect(names, containsAll([
        'Violet Dark',
        'Cyan Dark',
        'Green Dark',
        'Light Mode',
        'Cosmic',
        'Ember',
        'Aurora',
      ]));
    });
  });

  group('OdoTheme — Violet Dark (AC4)', () {
    const theme = AppColors.violetDark;

    test('accent is #7C4DFF', () {
      expect(theme.colorAccent, const Color(0xFF7C4DFF));
    });

    test('background is OLED black #0D0D0F', () {
      expect(theme.colorBackground, const Color(0xFF0D0D0F));
    });

    test('surface is #1A1A1F', () {
      expect(theme.colorSurface, const Color(0xFF1A1A1F));
    });

    test('isDark is true', () {
      expect(theme.isDark, isTrue);
    });

    test('orbIdle alpha is ~30% (0x4D)', () {
      final alpha = (theme.colorOrbIdle.a * 255.0).round().clamp(0, 255);
      expect(alpha, 0x4D);
    });

    test('orbActive equals colorAccent', () {
      expect(theme.colorOrbActive, theme.colorAccent);
    });

    test('customAccentHex is null by default', () {
      expect(theme.customAccentHex, isNull);
    });
  });

  group('OdoTheme — Light Mode (AC4)', () {
    const theme = AppColors.lightMode;

    test('isDark is false', () {
      expect(theme.isDark, isFalse);
    });

    test('background is light #FDFBF7', () {
      expect(theme.colorBackground, const Color(0xFFFDFBF7));
    });

    test('surface is white', () {
      expect(theme.colorSurface, const Color(0xFFFFFFFF));
    });

    test('textPrimary is near-black', () {
      expect(theme.colorTextPrimary, const Color(0xFF1A1A1A));
    });
  });

  group('OdoTheme — all dark themes have correct backgrounds (AC4)', () {
    final darkThemes = [
      AppColors.cyanDark,
      AppColors.greenDark,
    ];

    for (final theme in darkThemes) {
      test('${theme.name} background is OLED black', () {
        expect(theme.colorBackground, const Color(0xFF0D0D0F));
      });

      test('${theme.name} isDark is true', () {
        expect(theme.isDark, isTrue);
      });
    }

    test('Cosmic has bg #0A0014', () {
      expect(AppColors.cosmic.colorBackground, const Color(0xFF0A0014));
    });

    test('Ember has bg #0F0A00', () {
      expect(AppColors.ember.colorBackground, const Color(0xFF0F0A00));
    });

    test('Aurora has bg #001A14', () {
      expect(AppColors.aurora.colorBackground, const Color(0xFF001A14));
    });
  });

  group('OdoTheme.withCustomAccent (AC5)', () {
    test('overrides colorAccent with parsed hex', () {
      final custom = AppColors.violetDark.withCustomAccent('#FF0000');
      expect(custom.colorAccent, const Color(0xFFFF0000));
    });

    test('overrides colorOrbActive with parsed hex', () {
      final custom = AppColors.violetDark.withCustomAccent('#FF0000');
      expect(custom.colorOrbActive, const Color(0xFFFF0000));
    });

    test('orbIdle has ~30% alpha of new accent', () {
      final custom = AppColors.violetDark.withCustomAccent('#FF0000');
      expect((custom.colorOrbIdle.r * 255.0).round(), greaterThan(200));
      final alpha = (custom.colorOrbIdle.a * 255.0).round().clamp(0, 255);
      expect(alpha, closeTo(77, 2));
    });

    test('stores customAccentHex', () {
      final custom = AppColors.violetDark.withCustomAccent('#00FF00');
      expect(custom.customAccentHex, '#00FF00');
    });

    test('does not mutate original theme', () {
      AppColors.violetDark.withCustomAccent('#FF0000');
      expect(AppColors.violetDark.colorAccent, const Color(0xFF7C4DFF));
    });

    test('leaves other tokens unchanged', () {
      final custom = AppColors.violetDark.withCustomAccent('#FF0000');
      expect(custom.colorBackground, AppColors.violetDark.colorBackground);
      expect(custom.colorSurface, AppColors.violetDark.colorSurface);
      expect(custom.colorTextPrimary, AppColors.violetDark.colorTextPrimary);
      expect(custom.isDark, AppColors.violetDark.isDark);
    });

    test('works with hex without # prefix', () {
      final custom = AppColors.violetDark.withCustomAccent('00FF00');
      expect(custom.colorAccent, const Color(0xFF00FF00));
    });
  });
}
