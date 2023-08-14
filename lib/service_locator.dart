import 'package:anr/repositories/http_repository.dart';
import 'package:anr/repositories/user_repository.dart';
import 'package:anr/services/authentication_service.dart';
import 'package:anr/services/theme_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupServiceLocator(SharedPreferences prefs) {
  GetIt.I.registerLazySingleton<ThemeService>(() => ThemeService(prefs));
  GetIt.I.registerLazySingleton<HttpRepository>(() => HttpRepository());
  GetIt.I.registerLazySingleton<UserRepository>(() => UserRepository());
  GetIt.I.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
}

ThemeService get themeService => GetIt.I.get<ThemeService>();
HttpRepository get httpRepository => GetIt.I.get<HttpRepository>();
UserRepository get userRepository => GetIt.I.get<UserRepository>();
AuthenticationService get authenticationService => GetIt.I.get<AuthenticationService>();
