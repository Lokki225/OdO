import 'package:flutter/material.dart';

import 'odo_theme.dart';

// Layer 1 — raw palette. Annotated @visibleForTesting so the analyzer warns
// if any widget file imports these directly. All widgets must use OdoTheme
// semantic tokens or the fixed category constants below.
abstract final class AppColors {
  // --- Raw palette (Layer 1) ---

  @visibleForTesting
  static const Color violetPrimary = Color(0xFF7C4DFF);
  @visibleForTesting
  static const Color cyanPrimary = Color(0xFF00C2D4);
  @visibleForTesting
  static const Color greenPrimary = Color(0xFF1D9E75);
  @visibleForTesting
  static const Color emberOrange = Color(0xFFFF6B35);
  @visibleForTesting
  static const Color cosmicMagenta = Color(0xFFC770FF);
  @visibleForTesting
  static const Color auroraTeal = Color(0xFF2DD4BF);
  @visibleForTesting
  static const Color darkBg = Color(0xFF0D0D0F);
  @visibleForTesting
  static const Color lightBg = Color(0xFFFDFBF7);

  // --- Fixed category semantic tokens (Layer 2, not remapped by theme) ---

  static const Color colorCategoryPersonal = Color(0xFF7C4DFF);
  static const Color colorCategoryWork = Color(0xFF5B8BD4);
  static const Color colorCategoryPractice = Color(0xFF1D9E75);

  // Agenda-semantic aliases used by event blocks and strip dots
  static const Color colorAccentAgenda = colorCategoryPersonal;
  static const Color colorAccentWork = colorCategoryWork;
  static const Color colorAccentPractice = colorCategoryPractice;

  // --- Seven theme presets (Layer 2) ---
  // orbIdle = accent at 30% opacity (alpha 0x4D = 77 ≈ 30% of 255)

  static const OdoTheme violetDark = OdoTheme(
    name: 'Violet Dark',
    colorAccent: Color(0xFF7C4DFF),
    colorBackground: Color(0xFF0D0D0F),
    colorSurface: Color(0xFF1A1A1F),
    colorTextPrimary: Color(0xFFE8E8F0),
    colorTextMuted: Color(0xFF6B6B80),
    colorBorder: Color(0xFF2A2A35),
    colorOrbIdle: Color(0x4D7C4DFF),
    colorOrbActive: Color(0xFF7C4DFF),
    isDark: true,
  );

  static const OdoTheme cyanDark = OdoTheme(
    name: 'Cyan Dark',
    colorAccent: Color(0xFF00C2D4),
    colorBackground: Color(0xFF0D0D0F),
    colorSurface: Color(0xFF1A1A1F),
    colorTextPrimary: Color(0xFFE8E8F0),
    colorTextMuted: Color(0xFF6B6B80),
    colorBorder: Color(0xFF2A2A35),
    colorOrbIdle: Color(0x4D00C2D4),
    colorOrbActive: Color(0xFF00C2D4),
    isDark: true,
  );

  static const OdoTheme greenDark = OdoTheme(
    name: 'Green Dark',
    colorAccent: Color(0xFF1D9E75),
    colorBackground: Color(0xFF0D0D0F),
    colorSurface: Color(0xFF1A1A1F),
    colorTextPrimary: Color(0xFFE8E8F0),
    colorTextMuted: Color(0xFF6B6B80),
    colorBorder: Color(0xFF2A2A35),
    colorOrbIdle: Color(0x4D1D9E75),
    colorOrbActive: Color(0xFF1D9E75),
    isDark: true,
  );

  static const OdoTheme lightMode = OdoTheme(
    name: 'Light Mode',
    colorAccent: Color(0xFF7C4DFF),
    colorBackground: Color(0xFFFDFBF7),
    colorSurface: Color(0xFFFFFFFF),
    colorTextPrimary: Color(0xFF1A1A1A),
    colorTextMuted: Color(0xFF6B6B6B),
    colorBorder: Color(0xFFE6E1D7),
    colorOrbIdle: Color(0x4D7C4DFF),
    colorOrbActive: Color(0xFF7C4DFF),
    isDark: false,
  );

  static const OdoTheme cosmic = OdoTheme(
    name: 'Cosmic',
    colorAccent: Color(0xFFC770FF),
    colorBackground: Color(0xFF0A0014),
    colorSurface: Color(0xFF120025),
    colorTextPrimary: Color(0xFFE8E8F0),
    colorTextMuted: Color(0xFF6B6B80),
    colorBorder: Color(0xFF2A2A35),
    colorOrbIdle: Color(0x4DC770FF),
    colorOrbActive: Color(0xFFC770FF),
    isDark: true,
  );

  static const OdoTheme ember = OdoTheme(
    name: 'Ember',
    colorAccent: Color(0xFFFF6B35),
    colorBackground: Color(0xFF0F0A00),
    colorSurface: Color(0xFF1A1200),
    colorTextPrimary: Color(0xFFE8E8F0),
    colorTextMuted: Color(0xFF6B6B80),
    colorBorder: Color(0xFF2A2A35),
    colorOrbIdle: Color(0x4DFF6B35),
    colorOrbActive: Color(0xFFFF6B35),
    isDark: true,
  );

  static const OdoTheme aurora = OdoTheme(
    name: 'Aurora',
    colorAccent: Color(0xFF2DD4BF),
    colorBackground: Color(0xFF001A14),
    colorSurface: Color(0xFF00261C),
    colorTextPrimary: Color(0xFFE8E8F0),
    colorTextMuted: Color(0xFF6B6B80),
    colorBorder: Color(0xFF2A2A35),
    colorOrbIdle: Color(0x4D2DD4BF),
    colorOrbActive: Color(0xFF2DD4BF),
    isDark: true,
  );

  static const List<OdoTheme> allThemes = [
    violetDark,
    cyanDark,
    greenDark,
    lightMode,
    cosmic,
    ember,
    aurora,
  ];
}
