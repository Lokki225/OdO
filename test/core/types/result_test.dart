import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/types/result.dart';

void main() {
  group('Success (AC1, AC3, AC7)', () {
    test('when returns success value', () {
      const result = Success(42);
      final value = result.when(success: (v) => v, failure: (_) => 0);
      expect(value, 42);
    });

    test('getOrNull returns value', () {
      const result = Success('hello');
      expect(result.getOrNull(), 'hello');
    });

    test('isSuccess is true', () {
      expect(const Success(1).isSuccess, isTrue);
    });

    test('isFailure is false', () {
      expect(const Success(1).isFailure, isFalse);
    });
  });

  group('Failure (AC1, AC3, AC7)', () {
    test('when calls failure branch and returns null in success branch', () {
      const Result<int> result = Failure(AppError.aiUnavailable);
      final value = result.when(success: (v) => v, failure: (_) => null);
      expect(value, isNull);
    });

    test('when failure branch receives the error', () {
      const Result<int> result = Failure(AppError.databaseWriteFailed);
      final error = result.when(success: (_) => null, failure: (e) => e);
      expect(error, AppError.databaseWriteFailed);
    });

    test('getOrNull returns null', () {
      const Result<int> result = Failure(AppError.voiceCaptureFailed);
      expect(result.getOrNull(), isNull);
    });

    test('isSuccess is false', () {
      expect(const Failure<int>(AppError.aiUnavailable).isSuccess, isFalse);
    });

    test('isFailure is true', () {
      expect(const Failure<int>(AppError.aiUnavailable).isFailure, isTrue);
    });
  });

  group('AppError enum (AC2)', () {
    test('has exactly 9 variants', () {
      expect(AppError.values.length, 9);
    });

    test('all variants have non-empty messages', () {
      for (final e in AppError.values) {
        expect(e.message, isNotEmpty);
      }
    });
  });
}
