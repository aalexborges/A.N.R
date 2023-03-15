import 'package:anr/color_schemes.dart';
import 'package:anr/firebase_options.dart';
import 'package:anr/repositories/auth_repository.dart';
import 'package:anr/repositories/book_repository.dart';
import 'package:anr/repositories/theme_repository.dart';
import 'package:anr/repositories/user_repository.dart';
import 'package:anr/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  final prefs = await SharedPreferences.getInstance();
  registerSingletons(prefs);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _currentTheme = themeRepository.currentTheme;

  void _changeThemeListener() {
    setState(() {
      _currentTheme = themeRepository.currentTheme;
    });
  }

  @override
  void initState() {
    themeRepository.addListener(_changeThemeListener);
    super.initState();

    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    themeRepository.removeListener(_changeThemeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'A.N.R',
      themeMode: _currentTheme,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      debugShowCheckedModeBanner: false,
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('pt')],
    );
  }
}

void registerSingletons(SharedPreferences prefs) {
  GetIt.I.registerSingleton<AuthRepository>(AuthRepository());
  GetIt.I.registerSingleton<ThemeRepository>(ThemeRepository(prefs));
  GetIt.I.registerLazySingleton<UserRepository>(() => const UserRepository());
  GetIt.I.registerLazySingleton<BookRepository>(() => const BookRepository());
}

AuthRepository get authRepository => GetIt.I.get<AuthRepository>();
BookRepository get bookRepository => GetIt.I.get<BookRepository>();
UserRepository get userRepository => GetIt.I.get<UserRepository>();
ThemeRepository get themeRepository => GetIt.I.get<ThemeRepository>();
