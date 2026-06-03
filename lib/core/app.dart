import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/core/theme/app_theme.dart';
import 'package:desktop_system/core/constants/app_strings.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/core/services/error_handler.dart';
import 'package:desktop_system/features/auth/bloc/auth_bloc.dart';
import 'package:desktop_system/features/auth/bloc/auth_event.dart';
import 'package:desktop_system/features/auth/bloc/auth_state.dart';
import 'package:desktop_system/features/splash/pages/splash_page.dart';
import 'package:desktop_system/routing/app_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  bool _showSplash = true;
  late final AuthBloc _authBloc = getIt<AuthBloc>()
    ..add(const AuthCheckRequested());
  late final ErrorHandler _errorHandler = getIt<ErrorHandler>();
  StreamSubscription<void>? _unauthorizedSub;

  void _onSplashCompleted() {
    final status = _authBloc.state.status;
    if (status != AuthStatus.initial) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _unauthorizedSub = _errorHandler.onUnauthorized.listen((_) {
      _authBloc.add(const AuthLogoutRequested());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unauthorizedSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_showSplash) {
      _authBloc.add(const AuthCheckRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return BlocProvider.value(
        value: _authBloc,
        child: SplashPage(onCompleted: _onSplashCompleted),
      );
    }

    final appRouter = AppRouter(authBloc: _authBloc);

    return BlocProvider.value(
      value: _authBloc,
      child: _ErrorSnackBarListener(
        errorHandler: _errorHandler,
        child: MaterialApp.router(
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter.router,
        ),
      ),
    );
  }
}

/// Listens to [ErrorHandler.errorStream] and displays errors as SnackBars
/// using [AppRouter.navigatorKey].
class _ErrorSnackBarListener extends StatefulWidget {
  final ErrorHandler errorHandler;
  final Widget child;

  const _ErrorSnackBarListener({
    required this.errorHandler,
    required this.child,
  });

  @override
  State<_ErrorSnackBarListener> createState() => _ErrorSnackBarListenerState();
}

class _ErrorSnackBarListenerState extends State<_ErrorSnackBarListener> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.errorHandler.errorStream.listen((error) {
      final context = AppRouter.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
