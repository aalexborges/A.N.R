import 'package:A.N.R/constants/routes_path.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/screens/about.screen.dart';
import 'package:A.N.R/screens/book.screen.dart';
import 'package:A.N.R/screens/favorites.screen.dart';
import 'package:A.N.R/screens/home.screen.dart';
import 'package:A.N.R/screens/login.screen.dart';
import 'package:A.N.R/screens/reader.screen.dart';
import 'package:A.N.R/screens/search.screen.dart';
import 'package:A.N.R/utils/go_router_refresh_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final routes = GoRouter(
  initialLocation: RoutesPath.LOGIN,
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),
  redirect: (context, state) {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    final isLoginRoute = state.subloc == RoutesPath.LOGIN;

    if (!isAuthenticated) return isLoginRoute ? null : RoutesPath.LOGIN;
    if (isLoginRoute) return RoutesPath.HOME;
    return null;
  },
  routes: [
    GoRoute(
      path: RoutesPath.ABOUT,
      builder: (context, state) => AboutScreen(state.extra! as AboutProps),
    ),
    GoRoute(
      path: RoutesPath.BOOK,
      builder: (context, state) => BookScreen(book: state.extra! as Book),
    ),
    GoRoute(
      path: RoutesPath.FAVORITES,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: RoutesPath.HOME,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutesPath.LOGIN,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutesPath.READER,
      builder: (context, state) => ReaderScreen(state.extra! as ReaderProps),
    ),
    GoRoute(
      path: RoutesPath.SEARCH,
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
