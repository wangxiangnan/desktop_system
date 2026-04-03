import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/di/setup_dependencies.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/splash/presentation/bloc/splash_bloc.dart';
import '../features/splash/presentation/page/splash_page.dart';
import '../routing/app_router.dart';
import '../services/permission_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _showSplash = true;

  void _onAuthenticated() {
    setState(() {
      _showSplash = false;
    });
  }

  void _onUnauthenticated() {
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
          onAuthenticated: _onAuthenticated,
          onUnauthenticated: _onUnauthenticated,
        ),
      );
    }

    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
      child: Builder(
        builder: (context) => BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final permissionService = state is AuthAuthenticated
                ? PermissionService(state.user)
                : null;

            final appRouter = AppRouter(permissionService: permissionService);

            return MaterialApp.router(
              title: AppStrings.appName,
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter.router,
            );
          },
        ),
      ),
    );
  }
}
