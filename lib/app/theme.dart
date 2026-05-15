import 'package:flutter/material.dart';

import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/constants/app_typography.dart';
import 'package:odo/core/constants/odo_theme.dart';

abstract final class AppTheme {
  /// Builds a [ThemeData] from an [OdoTheme] semantic token set.
  /// [textThemeOverride] skips the google_fonts construction — pass
  /// `const TextTheme()` in unit tests to avoid font-loading async side-effects.
  static ThemeData fromOdoTheme(OdoTheme theme, {TextTheme? textThemeOverride}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: theme.colorAccent,
      brightness: theme.isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      primary: theme.colorAccent,
      onPrimary: Colors.white,
      surface: theme.colorBackground,
      onSurface: theme.colorTextPrimary,
      outline: theme.colorBorder,
      surfaceContainerLow: theme.colorSurface,
      surfaceContainer: theme.colorSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: theme.colorBackground,

      textTheme: textThemeOverride ?? TextTheme(
        displayLarge: AppTypography.textDisplay
            .copyWith(color: theme.colorTextPrimary),
        titleLarge: AppTypography.textTitle
            .copyWith(color: theme.colorTextPrimary),
        bodyLarge: AppTypography.textBody
            .copyWith(color: theme.colorTextPrimary),
        bodyMedium: AppTypography.textBodyMuted
            .copyWith(color: theme.colorTextMuted),
        labelLarge: AppTypography.textCaption
            .copyWith(color: theme.colorTextPrimary),
        labelSmall: AppTypography.textMicro
            .copyWith(color: theme.colorTextMuted),
      ),

      cardTheme: CardThemeData(
        color: theme.colorSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: theme.colorBorder),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: theme.colorSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: theme.colorSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp16,
          vertical: AppSpacing.sp12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: theme.colorBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: theme.colorBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: theme.colorAccent),
        ),
      ),

      dividerTheme: DividerThemeData(color: theme.colorBorder, thickness: 1),
    );
  }
}
