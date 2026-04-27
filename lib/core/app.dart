import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/core/theme/app_theme.dart';
import 'package:desktop_system/core/constants/app_strings.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/features/auth/bloc/auth_bloc.dart';
import 'package:desktop_system/features/auth/bloc/auth_event.dart';
import 'package:desktop_system/features/auth/bloc/auth_state.dart';
import 'package:desktop_system/features/splash/bloc/splash_bloc.dart';
import 'package:desktop_system/features/splash/pages/splash_page.dart';
import 'package:desktop_system/routing/app_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _showSplash = true;
  late final AuthBloc _authBloc = getIt<AuthBloc>()..add(const AuthCheckRequested());

  void _onSplashCompleted() {
    final status = _authBloc.state.status;
    if (status != AuthStatus.initial) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return BlocProvider.value(
        value: _authBloc,
        child: BlocProvider(
          create: (_) => getIt<SplashBloc>(),
          child: SplashPage(onCompleted: _onSplashCompleted),
        ),
      );
    }

    final appRouter = AppRouter(authBloc: _authBloc);
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.router,
      ),
    );
  }
}
