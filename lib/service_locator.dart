import 'package:anr/repositories/auth_repository.dart';
import 'package:anr/repositories/database_repository.dart';
import 'package:anr/repositories/favorites_repository.dart';
import 'package:anr/repositories/http_repository.dart';
import 'package:anr/repositories/theme_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void registerSingletons(SharedPreferences prefs) {
  GetIt.I.registerSingleton<AuthRepository>(AuthRepository());
  GetIt.I.registerSingleton<ThemeRepository>(ThemeRepository(prefs));
  GetIt.I.registerLazySingleton<HttpRepository>(() => HttpRepository());
  GetIt.I.registerLazySingleton<DatabaseRepository>(() => DatabaseRepository());
  GetIt.I.registerLazySingleton<FavoritesRepository>(() => FavoritesRepository());
}

AuthRepository get authRepository => GetIt.I.get<AuthRepository>();
HttpRepository get httpRepository => GetIt.I.get<HttpRepository>();
ThemeRepository get themeRepository => GetIt.I.get<ThemeRepository>();
DatabaseRepository get databaseRepository => GetIt.I.get<DatabaseRepository>();
FavoritesRepository get favoritesRepository => GetIt.I.get<FavoritesRepository>();
