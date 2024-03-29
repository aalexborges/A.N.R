import 'dart:async';

import 'package:anr/models/book.dart';
import 'package:anr/models/content.dart';
import 'package:anr/models/details.dart';
import 'package:anr/screens/auth_screen.dart';
import 'package:anr/screens/book_screen.dart';
import 'package:anr/screens/content_screen.dart';
import 'package:anr/screens/details_screen.dart';
import 'package:anr/screens/favorites_screen.dart';
import 'package:anr/screens/home_screen.dart';
import 'package:anr/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScreenPaths {
  static const String auth = '/auth';
  static const String home = '/home';
  static const String book = '/book';
  static const String search = '/search';
  static const String content = '/content';
  static const String details = '/details';
  static const String favorites = '/favorites';
}

final appRouter = GoRouter(
  initialLocation: ScreenPaths.auth,
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: _handleRedirect,
  routes: [
    GoRoute(path: ScreenPaths.auth, builder: (ctx, state) => const AuthScreen()),
    GoRoute(path: ScreenPaths.home, builder: (ctx, state) => const HomeScreen()),
    GoRoute(path: ScreenPaths.book, builder: (ctx, state) => BookScreen(book: state.extra! as Book)),
    GoRoute(path: ScreenPaths.search, builder: (ctx, state) => const SearchScreen()),
    GoRoute(path: ScreenPaths.content, builder: (ctx, state) => ContentScreen(params: state.extra! as ContentParams)),
    GoRoute(path: ScreenPaths.details, builder: (ctx, state) => DetailsScreen(details: state.extra! as Details)),
    GoRoute(path: ScreenPaths.favorites, builder: (ctx, state) => const FavoritesScreen()),
  ],
);

String? _handleRedirect(BuildContext context, GoRouterState state) {
  final isAuthenticated = FirebaseAuth.instance.currentUser != null;
  final isLoginRoute = state.matchedLocation == ScreenPaths.auth;

  if (!isAuthenticated) return isLoginRoute ? null : ScreenPaths.auth;
  if (isLoginRoute) return ScreenPaths.home;
  return null;
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
