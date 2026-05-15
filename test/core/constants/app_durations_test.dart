import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/constants/app_durations.dart';

void main() {
  group('AppDurations (AC8)', () {
    test('durationFast == 150ms', () {
      expect(AppDurations.durationFast, const Duration(milliseconds: 150));
    });

    test('durationDefault == 300ms', () {
      expect(AppDurations.durationDefault, const Duration(milliseconds: 300));
    });

    test('durationSlow == 500ms', () {
      expect(AppDurations.durationSlow, const Duration(milliseconds: 500));
    });

    test('durations are in ascending order', () {
      expect(
        AppDurations.durationFast < AppDurations.durationDefault,
        isTrue,
      );
      expect(
        AppDurations.durationDefault < AppDurations.durationSlow,
        isTrue,
      );
    });
  });
}
