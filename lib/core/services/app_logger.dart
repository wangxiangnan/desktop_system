import 'package:logger/logger.dart';

import '../config/app_config.dart';

/// Application-level logger wrapping the [Logger] package.
///
/// Respects [AppConfig.debugMode] and [AppConfig.logLevel] to control output.
/// Use the named methods (`.d()`, `.i()`, `.w()`, `.e()`) instead of `print()`.
///
/// ```dart
/// final log = getIt<AppLogger>();
/// log.d('Fetching orders with params: $params');
/// log.e('Failed to login', error: e);
/// ```
class AppLogger {
  late final Logger _logger;

  AppLogger() {
    _logger = Logger(
      level: AppConfig.debugMode ? Level.trace : Level.info,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 120,
        colors: false,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    );
  }

  /// Debug-level message — only shown when [AppConfig.debugMode] is true.
  void d(String message) => _logger.d(message);

  /// Info-level message.
  void i(String message) => _logger.i(message);

  /// Warning-level message.
  void w(String message) => _logger.w(message);

  /// Error-level message with optional error stack trace.
  void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
