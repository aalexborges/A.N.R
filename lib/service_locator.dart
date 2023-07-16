import 'package:anr/services/authentication_service.dart';
import 'package:anr/services/theme_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupServiceLocator(SharedPreferences prefs) {
  GetIt.I.registerLazySingleton<ThemeService>(() => ThemeService(prefs));
  GetIt.I.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
}

ThemeService get themeService => GetIt.I.get<ThemeService>();
AuthenticationService get authenticationService => GetIt.I.get<AuthenticationService>();
