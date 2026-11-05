import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/protocol_detail_screen.dart';
import '../screens/protocol_list_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/protocols',
      builder: (context, state) => const ProtocolListScreen(),
      routes: [
        GoRoute(
          path: ':code',
          builder: (context, state) =>
              ProtocolDetailScreen(code: state.pathParameters['code']!),
        ),
      ],
    ),
  ],
);
