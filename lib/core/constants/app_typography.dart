import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  // Fraunces — ritual/display surfaces only (evening session headline)
  static TextStyle get textDisplay => GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // DM Sans — all UI surfaces
  static TextStyle get textTitle => GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get textBody => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get textBodyMuted => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get textCaption => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get textMicro => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );

  // Clock / number display: tabular figures + tracking
  static TextStyle get clockStyle => GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.06,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
