import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/constants/app_spacing.dart';

void main() {
  group('AppSpacing — spacing scale (AC6)', () {
    test('sp2 == 2.0', () => expect(AppSpacing.sp2, 2.0));
    test('sp4 == 4.0', () => expect(AppSpacing.sp4, 4.0));
    test('sp8 == 8.0', () => expect(AppSpacing.sp8, 8.0));
    test('sp12 == 12.0', () => expect(AppSpacing.sp12, 12.0));
    test('sp16 == 16.0', () => expect(AppSpacing.sp16, 16.0));
    test('sp20 == 20.0', () => expect(AppSpacing.sp20, 20.0));
    test('sp24 == 24.0', () => expect(AppSpacing.sp24, 24.0));
    test('sp32 == 32.0', () => expect(AppSpacing.sp32, 32.0));
  });

  group('AppSpacing — radius scale (AC9)', () {
    test('radiusSm == 10.0', () => expect(AppSpacing.radiusSm, 10.0));
    test('radiusMd == 14.0', () => expect(AppSpacing.radiusMd, 14.0));
    test('radiusLg == 20.0', () => expect(AppSpacing.radiusLg, 20.0));
    test('radiusXl == 28.0', () => expect(AppSpacing.radiusXl, 28.0));
    test('radiusFull == 100.0', () => expect(AppSpacing.radiusFull, 100.0));
  });
}
