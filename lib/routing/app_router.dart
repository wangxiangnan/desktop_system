import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:desktop_system/features/auth/pages/login_page.dart';
import 'package:desktop_system/features/home/pages/home_page.dart';
import 'package:desktop_system/features/tickets/pages/ticket_list_page.dart';
import 'package:desktop_system/features/tickets/pages/ticket_detail_page.dart';
import 'package:desktop_system/features/svg/pages/svg_list_page.dart';
import 'package:desktop_system/features/svg/pages/svg_editor_page.dart';
import 'package:desktop_system/features/settings/pages/settings_page.dart';
import 'package:desktop_system/shared/widgets/app_shell.dart';

class AppRouter {
  AppRouter();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(currentPath: state.uri.path, child: child);
        },
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/tickets',
            builder: (context, state) => const TicketListPage(),
          ),
          GoRoute(
            path: '/tickets/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TicketDetailPage(ticketId: id);
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/svg',
            builder: (context, state) => const SvgListPage(),
          ),
          GoRoute(
            path: '/svg/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SvgEditorPage(canvasId: id);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}