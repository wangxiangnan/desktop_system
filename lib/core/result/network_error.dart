/// NetworkError represents a structured error from the networking layer.
///
/// Unlike [AppError] which is domain-level, this is purely for transport-layer
/// errors (HTTP status codes, timeouts, connection failures).
class NetworkError {
  final String message;
  final int? statusCode;
  final bool isUnauthorized;

  const NetworkError({
    required this.message,
    this.statusCode,
    this.isUnauthorized = false,
  });

  @override
  String toString() => 'NetworkError($statusCode): $message';
}
