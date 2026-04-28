/// A functional-style result type for handling success and failure cases.
sealed class Result<T> {
  const Result();

  /// Executes the appropriate callback based on result type.
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

/// Represents a successful result.
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

/// Represents a failed result.
final class Failure<T> extends Result<T> {
  final AppError error;

  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';
}

/// Application error.
class AppError implements Exception {
  final String message;
  final String? code;

  const AppError({required this.message, this.code});

  factory AppError.auth({String message = 'Authentication failed'}) {
    return AppError(message: message, code: 'AUTH_ERROR');
  }

  factory AppError.unknown({String message = 'An unknown error occurred'}) {
    return AppError(message: message, code: 'UNKNOWN_ERROR');
  }

  @override
  String toString() => 'AppError: $message (code: $code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppError && code == other.code && message == other.message;

  @override
  int get hashCode => Object.hash(code, message);
}
