import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:desktop_system/routing/auth_change_notifier.dart';
import 'package:desktop_system/routing/routes.dart';
import 'package:desktop_system/features/auth/bloc/auth_bloc.dart';
import 'package:desktop_system/features/auth/bloc/auth_state.dart';
import 'package:desktop_system/features/auth/pages/login_page.dart';
import 'package:desktop_system/features/home/pages/home_page.dart';
import 'package:desktop_system/features/order/pages/order_list_page.dart';
import 'package:desktop_system/features/settings/pages/settings_page.dart';
import 'package:desktop_system/features/print_preview/pages/print_preview_page.dart';
import 'package:desktop_system/features/settings/pages/print_settings_page.dart';
import 'package:desktop_system/core/models/print_content.dart';
import 'package:desktop_system/core/widgets/app_shell.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.login,
    refreshListenable: AuthChangeNotifier(authBloc),
    redirect: (context, state) {
      final authState = authBloc.state;
      final currentLocation = state.matchedLocation;

      final isAuthenticated =
          authState.status == AuthStatus.authenticated && authState.user != null;
      final isLoading = authState.status == AuthStatus.loading ||
          authState.status == AuthStatus.captchaLoading ||
          authState.status == AuthStatus.initial;

      final isPublicRoute = currentLocation == Routes.login;

      if (isLoading) {
        return null;
      }

      if (!isAuthenticated && !isPublicRoute) {
        return Routes.login;
      }

      if (isAuthenticated && isPublicRoute) {
        return Routes.home;
      }

      return null;
    },
    routes: [
      GoRoute(path: Routes.login, builder: (context, state) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(currentPath: state.uri.path, child: child);
        },
        routes: [
          GoRoute(path: Routes.home, builder: (context, state) => const HomePage()),
          GoRoute(
            path: Routes.orders,
            builder: (context, state) => const OrderListPage(),
          ),
          GoRoute(
            path: Routes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: Routes.printSettings,
            builder: (context, state) => const PrintSettingsPage(),
          ),
          GoRoute(
            path: Routes.printPreview,
            builder: (context, state) {
              final content = state.extra! as PrintContent;
              return PrintPreviewPage(content: content);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}