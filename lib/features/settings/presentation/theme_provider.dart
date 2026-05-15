import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/constants/odo_theme.dart';
import 'package:odo/core/services/shared_preferences_provider.dart';

part 'theme_provider.g.dart';

const _kActiveThemeKey = 'active_theme_name';

@riverpod
class ActiveTheme extends _$ActiveTheme {
  @override
  OdoTheme build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedName = prefs.getString(_kActiveThemeKey);
    if (savedName == null) return AppColors.violetDark;
    return AppColors.allThemes.firstWhere(
      (t) => t.name == savedName,
      orElse: () => AppColors.violetDark,
    );
  }

  Future<void> setTheme(OdoTheme theme) async {
    state = theme;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_kActiveThemeKey, theme.name);
  }
}
