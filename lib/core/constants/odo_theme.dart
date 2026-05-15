import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class OdoTheme {
  const OdoTheme({
    required this.name,
    required this.colorAccent,
    required this.colorBackground,
    required this.colorSurface,
    required this.colorTextPrimary,
    required this.colorTextMuted,
    required this.colorBorder,
    required this.colorOrbIdle,
    required this.colorOrbActive,
    required this.isDark,
    this.customAccentHex,
  });

  final String name;
  final Color colorAccent;
  final Color colorBackground;
  final Color colorSurface;
  final Color colorTextPrimary;
  final Color colorTextMuted;
  final Color colorBorder;
  final Color colorOrbIdle;
  final Color colorOrbActive;
  final bool isDark;
  final String? customAccentHex;

  /// Returns a copy of this theme with [hexString] applied as the accent.
  /// Overrides [colorAccent], [colorOrbIdle] (accent @ 30%), and [colorOrbActive].
  /// Persisted separately in SharedPreferences under key `custom_accent_hex`.
  OdoTheme withCustomAccent(String hexString) {
    final accent = _parseHex(hexString);
    return OdoTheme(
      name: name,
      colorAccent: accent,
      colorBackground: colorBackground,
      colorSurface: colorSurface,
      colorTextPrimary: colorTextPrimary,
      colorTextMuted: colorTextMuted,
      colorBorder: colorBorder,
      colorOrbIdle: accent.withValues(alpha: 0.30),
      colorOrbActive: accent,
      isDark: isDark,
      customAccentHex: hexString,
    );
  }

  static Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final withAlpha = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.parse(withAlpha, radix: 16));
  }
}