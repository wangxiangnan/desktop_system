import 'dart:async';

import 'package:desktop_system/core/result/network_error.dart';
import 'package:desktop_system/core/services/app_logger.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';

/// Centralized error handler for network and other application errors.
///
/// The networking layer pushes errors here via [reportError], and the UI layer
/// subscribes to [errorStream] to display them. This decouples the network
/// interceptor from BuildContext, go_router, and ScaffoldMessenger.
///
/// For 401 (unauthorized) errors, [onUnauthorized] is called so the routing
/// layer can redirect to login without the interceptor knowing about routes.
class ErrorHandler {
  final _errorController = StreamController<NetworkError>.broadcast();
  final _unauthorizedController = StreamController<void>.broadcast();

  /// Stream of all network errors for UI display (SnackBar, dialog, etc.).
  Stream<NetworkError> get errorStream => _errorController.stream;

  /// Stream that fires on 401 responses so the router can redirect.
  Stream<void> get onUnauthorized => _unauthorizedController.stream;

  /// Report a network error. If [error.isUnauthorized] is true, also fires
  /// [onUnauthorized].
  void reportError(NetworkError error) {
    getIt<AppLogger>().e(
      'Network error',
      error: '${error.statusCode}: ${error.message}',
    );
    _errorController.add(error);
    if (error.isUnauthorized) {
      _unauthorizedController.add(null);
    }
  }

  void dispose() {
    _errorController.close();
    _unauthorizedController.close();
  }
}
