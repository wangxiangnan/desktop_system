/// A functional-style result type for handling success and failure cases
/// This eliminates the need for try-catch blocks and provides type-safe error handling
sealed class Result<T> {
  const Result();

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is Failure<T>;

  /// Gets the value if success, throws if failure
  T get value {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>(:final error) => throw error,
    };
  }

  /// Gets the error if failure, throws if success
  AppError get error {
    return switch (this) {
      Success<T>(:final data) => throw Exception('Expected failure but got success with: $data'),
      Failure<T>(:final error) => error,
    };
  }

  /// Maps the success value to a new type
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => Success(transform(data)),
      Failure<T>(:final error) => Failure(error),
    };
  }

  /// Maps the success value to a new Result
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => transform(data),
      Failure<T>(:final error) => Failure(error),
    };
  }

  /// Gets the value or a default value
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>() => defaultValue,
    };
  }

  /// Gets the value or computes a default value
  T getOrCompute(T Function() compute) {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>() => compute(),
    };
  }

  /// Executes the appropriate callback based on result type
  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Failure<T>(:final error) => failure(error),
    };
  }
}

/// Represents a successful result
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed result
final class Failure<T> extends Result<T> {
  final AppError error;

  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Failure<T> && error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

/// Application error types
class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  factory AppError.network({
    String message = 'Network error occurred',
    dynamic originalError,
  }) {
    return AppError(
      message: message,
      code: 'NETWORK_ERROR',
      originalError: originalError,
    );
  }

  factory AppError.server({
    String message = 'Server error occurred',
    int? statusCode,
    dynamic originalError,
  }) {
    return AppError(
      message: message,
      code: statusCode != null ? 'SERVER_$statusCode' : 'SERVER_ERROR',
      originalError: originalError,
    );
  }

  factory AppError.auth({
    String message = 'Authentication failed',
    dynamic originalError,
  }) {
    return AppError(
      message: message,
      code: 'AUTH_ERROR',
      originalError: originalError,
    );
  }

  factory AppError.validation({
    required String message,
    Map<String, String>? fieldErrors,
  }) {
    return AppError(
      message: message,
      code: 'VALIDATION_ERROR',
      originalError: fieldErrors,
    );
  }

  factory AppError.unknown({
    String message = 'An unknown error occurred',
    dynamic originalError,
  }) {
    return AppError(
      message: message,
      code: 'UNKNOWN_ERROR',
      originalError: originalError,
    );
  }

  @override
  String toString() => 'AppError: $message (code: $code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppError && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

/// Extension methods for converting exceptions to Results
extension ThrowableToResult<T> on Future<T> {
  /// Wraps the future in a Result, catching any exceptions
  Future<Result<T>> toResult() async {
    try {
      final data = await this;
      return Success(data);
    } on AppError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AppError.unknown(originalError: e));
    }
  }
}
