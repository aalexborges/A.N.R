import 'package:anr/cache/http_cache_manager.dart';
import 'package:anr/firebase_options.dart';
import 'package:anr/models/http_cache.dart';
import 'package:anr/routes.dart';
import 'package:anr/service_locator.dart';
import 'package:anr/utils/color_schemes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  Hive.registerAdapter(HttpCacheAdapter());

  if (!Hive.isBoxOpen(HttpCacheManager.boxKey)) await Hive.openBox(HttpCacheManager.boxKey);

  final prefs = await SharedPreferences.getInstance();
  setupServiceLocator(prefs);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  void _themeListening() {
    setState(() {
      _themeMode = themeService.getThemeMode();
    });
  }

  @override
  void initState() {
    _themeMode = themeService.getThemeMode();

    FlutterNativeSplash.remove();
    themeService.addListener(_themeListening);

    super.initState();
  }

  @override
  void dispose() {
    themeService.removeListener(_themeListening);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'A.N.R',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: _themeMode,
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
