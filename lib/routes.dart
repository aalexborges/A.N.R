import 'package:anr/screens/login_screen.dart';
import 'package:anr/utils/route_paths.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: RoutePaths.login, builder: (context, state) => const LoginScreen()),
    ],
  );
}
