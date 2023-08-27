import 'package:anr/repositories/database_repository.dart';
import 'package:anr/repositories/favorites_repository.dart';
import 'package:anr/repositories/http_repository.dart';
import 'package:anr/repositories/reading_history_repository.dart';
import 'package:anr/repositories/user_repository.dart';
import 'package:anr/services/authentication_service.dart';
import 'package:anr/services/theme_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupServiceLocator(SharedPreferences prefs) {
  GetIt.I.registerLazySingleton<ThemeService>(() => ThemeService(prefs));
  GetIt.I.registerLazySingleton<HttpRepository>(() => HttpRepository());
  GetIt.I.registerLazySingleton<UserRepository>(() => UserRepository());
  GetIt.I.registerLazySingleton<DatabaseRepository>(() => DatabaseRepository());
  GetIt.I.registerLazySingleton<FavoritesRepository>(() => FavoritesRepository());
  GetIt.I.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  GetIt.I.registerLazySingleton<ReadingHistoryRepository>(() => ReadingHistoryRepository());
}

ThemeService get themeService => GetIt.I.get<ThemeService>();
HttpRepository get httpRepository => GetIt.I.get<HttpRepository>();
UserRepository get userRepository => GetIt.I.get<UserRepository>();
DatabaseRepository get databaseRepository => GetIt.I.get<DatabaseRepository>();
FavoritesRepository get favoritesRepository => GetIt.I.get<FavoritesRepository>();
AuthenticationService get authenticationService => GetIt.I.get<AuthenticationService>();
ReadingHistoryRepository get readingHistoryRepository => GetIt.I.get<ReadingHistoryRepository>();
