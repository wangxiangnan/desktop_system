import 'package:desktop_system/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success.when calls success callback', () {
      const result = Success<int>(42);
      result.when(
        success: (value) => expect(value, 42),
        failure: (_) => fail('should not call failure'),
      );
    });

    test('Failure.when calls failure callback', () {
      const error = AppError(message: 'test error');
      const result = Failure<int>(error);
      result.when(
        success: (_) => fail('should not call success'),
        failure: (err) => expect(err.message, 'test error'),
      );
    });

    test('AppError.auth creates auth error', () {
      final error = AppError.auth(message: 'invalid credentials');
      expect(error.message, 'invalid credentials');
      expect(error.code, 'AUTH_ERROR');
    });

    test('AppError.unknown creates unknown error', () {
      final error = AppError.unknown();
      expect(error.message, 'An unknown error occurred');
      expect(error.code, 'UNKNOWN_ERROR');
    });
  });
}
