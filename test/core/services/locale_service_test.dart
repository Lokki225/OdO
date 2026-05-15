import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/services/locale_service.dart';

void main() {
  final service = LocaleService();

  group('LocaleService.formatXof (AC5, AC7)', () {
    test('formatXof(15000) returns "15 000 F"', () {
      expect(service.formatXof(15000), '15 000 F');
    });

    test('formatXof(0) returns "0 F"', () {
      expect(service.formatXof(0), '0 F');
    });

    test('formatXof(1000000) returns "1 000 000 F"', () {
      expect(service.formatXof(1000000), '1 000 000 F');
    });

    test('formatXof(500) returns "500 F"', () {
      expect(service.formatXof(500), '500 F');
    });
  });

  group('LocaleService.formatDate (AC5, AC7)', () {
    test('formatDate(2026-05-13) returns "13/05/2026"', () {
      expect(service.formatDate(DateTime(2026, 5, 13)), '13/05/2026');
    });

    test('formatDate(2026-01-01) returns "01/01/2026"', () {
      expect(service.formatDate(DateTime(2026, 1, 1)), '01/01/2026');
    });
  });

  group('LocaleService.formatTime (AC5)', () {
    test('formatTime at 08:05 returns "08:05"', () {
      expect(service.formatTime(DateTime(2026, 1, 1, 8, 5)), '08:05');
    });

    test('formatTime at 20:00 returns "20:00"', () {
      expect(service.formatTime(DateTime(2026, 1, 1, 20, 0)), '20:00');
    });
  });
}
