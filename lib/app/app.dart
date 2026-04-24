import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/core/theme/app_theme.dart';
import 'package:desktop_system/core/constants/app_strings.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/features/auth/bloc/auth_bloc.dart';
import 'package:desktop_system/features/auth/bloc/auth_event.dart';
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

  void _onSplashCompleted() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return BlocProvider(
        create: (_) => getIt<SplashBloc>(),
        child: SplashPage(
          onCompleted: _onSplashCompleted,
        ),
      );
    }

    final appRouter = AppRouter();
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.router,
      ),
    );
  }
}