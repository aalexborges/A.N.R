import 'package:A.N.R/firebase_options.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/services/worker.service.dart';
import 'package:A.N.R/store/download.store.dart';
import 'package:A.N.R/store/favorites.store.dart';
import 'package:A.N.R/store/historic.store.dart';
import 'package:A.N.R/utils/download.util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HistoricStore _historicStore;
  late FavoritesStore _favoritesStore;

  @override
  void initState() {
    _historicStore = HistoricStore();
    _favoritesStore = FavoritesStore();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user is User) {
        _historicStore.getAll();
        _favoritesStore.getAll();
      } else {
        _historicStore.clean();
        _favoritesStore.clean();
      }
    });

    // To continue the downloads
    DownloadUtil.start();

    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => _historicStore),
        Provider(create: (_) => _favoritesStore),
        Provider(create: (_) => DownloadStore()),
      ],
      child: MaterialApp.router(
        title: 'A.N.R',
        theme: ThemeData.from(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.dark,
        routerDelegate: routes.routerDelegate,
        routeInformationParser: routes.routeInformationParser,
        routeInformationProvider: routes.routeInformationProvider,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
