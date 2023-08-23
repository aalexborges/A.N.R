import 'dart:async';

import 'package:anr/models/book_data.dart';
import 'package:anr/models/book_item.dart';
import 'package:anr/screens/book_screen.dart';
import 'package:anr/screens/details_screen.dart';
import 'package:anr/screens/favorites_screen.dart';
import 'package:anr/screens/home_screen.dart';
import 'package:anr/screens/login_screen.dart';
import 'package:anr/screens/search_screen.dart';
import 'package:anr/utils/route_paths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutePaths.login,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: _handleRedirect,
    routes: [
      GoRoute(path: RoutePaths.book, builder: (context, state) => BookScreen(bookItem: state.extra as BookItem)),
      GoRoute(path: RoutePaths.home, builder: (context, state) => const HomeScreen()),
      GoRoute(path: RoutePaths.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: RoutePaths.search, builder: (context, state) => const SearchScreen()),
      GoRoute(path: RoutePaths.details, builder: (context, state) => DetailsScreen(bookData: state.extra as BookData)),
      GoRoute(path: RoutePaths.favorites, builder: (context, state) => const FavoritesScreen()),
    ],
  );

  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    final isLoginRoute = state.matchedLocation == RoutePaths.login;

    if (!isAuthenticated) return isLoginRoute ? null : RoutePaths.login;
    if (isLoginRoute) return RoutePaths.home;
    return null;
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
