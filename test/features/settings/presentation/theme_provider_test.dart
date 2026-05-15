import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/services/shared_preferences_provider.dart';
import 'package:odo/features/settings/presentation/theme_provider.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'theme_provider_test.mocks.dart';

ProviderContainer _makeContainer(SharedPreferences prefs) {
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    when(mockPrefs.getString(any)).thenReturn(null);
    when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
  });

  group('ActiveTheme — build / default (AC2, AC3)', () {
    test('defaults to Violet Dark when no saved preference', () {
      final container = _makeContainer(mockPrefs);
      addTearDown(container.dispose);

      expect(container.read(activeThemeProvider), AppColors.violetDark);
    });

    test('restores saved theme by name', () {
      when(mockPrefs.getString('active_theme_name'))
          .thenReturn('Cyan Dark');

      final container = _makeContainer(mockPrefs);
      addTearDown(container.dispose);

      expect(container.read(activeThemeProvider), AppColors.cyanDark);
    });

    test('falls back to Violet Dark when saved name is unrecognised', () {
      when(mockPrefs.getString('active_theme_name'))
          .thenReturn('NonExistentTheme');

      final container = _makeContainer(mockPrefs);
      addTearDown(container.dispose);

      expect(container.read(activeThemeProvider), AppColors.violetDark);
    });
  });

  group('ActiveTheme.setTheme (AC10)', () {
    test('updates state immediately', () async {
      final container = _makeContainer(mockPrefs);
      addTearDown(container.dispose);

      await container
          .read(activeThemeProvider.notifier)
          .setTheme(AppColors.ember);

      expect(container.read(activeThemeProvider), AppColors.ember);
    });

    test('persists theme name to SharedPreferences', () async {
      final container = _makeContainer(mockPrefs);
      addTearDown(container.dispose);

      await container
          .read(activeThemeProvider.notifier)
          .setTheme(AppColors.aurora);

      verify(mockPrefs.setString('active_theme_name', 'Aurora')).called(1);
    });

    test('switching themes updates the state each time', () async {
      final container = _makeContainer(mockPrefs);
      addTearDown(container.dispose);

      await container
          .read(activeThemeProvider.notifier)
          .setTheme(AppColors.cosmic);
      expect(container.read(activeThemeProvider), AppColors.cosmic);

      await container
          .read(activeThemeProvider.notifier)
          .setTheme(AppColors.greenDark);
      expect(container.read(activeThemeProvider), AppColors.greenDark);
    });
  });
}
