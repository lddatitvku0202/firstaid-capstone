import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/protocol_detail_screen.dart';
import '../screens/protocol_list_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/sos_screen.dart';
import '../screens/triage_screen.dart';

/// Màn khẩn cấp không dùng animation chuyển cảnh.
Page<void> _noAnimation(GoRouterState state, Widget child) =>
    NoTransitionPage<void>(key: state.pageKey, child: child);

GoRouter buildRouter() => GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/triage',
      pageBuilder: (context, state) =>
          _noAnimation(state, const TriageScreen()),
    ),
    GoRoute(
      path: '/sos',
      pageBuilder: (context, state) => _noAnimation(state, const SosScreen()),
    ),
    GoRoute(
      path: '/protocols',
      builder: (context, state) => const ProtocolListScreen(),
      routes: [
        GoRoute(
          path: ':code',
          pageBuilder: (context, state) => _noAnimation(
            state,
            ProtocolDetailScreen(code: state.pathParameters['code']!),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
