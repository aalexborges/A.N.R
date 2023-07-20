import 'package:anr/repositories/user_repository.dart';
import 'package:anr/services/authentication_service.dart';
import 'package:anr/services/theme_service.dart';
import 'package:anr/widgets/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_modal_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>(), MockSpec<ThemeService>(), MockSpec<AuthenticationService>()])
void main() {
  group('UserModal', () {
    late MockAuthenticationService mockAuthenticationService;
    late MockUserRepository mockUserRepository;
    late MockThemeService mockThemeService;

    const userEmail = 'email@email.com';
    const userDisplayName = 'User Name';
    const userPhotoURL = 'photoURL';

    setUpAll(() {
      mockThemeService = MockThemeService();
      mockUserRepository = MockUserRepository();
      mockAuthenticationService = MockAuthenticationService();

      when(mockUserRepository.email).thenReturn(userEmail);
      when(mockUserRepository.displayName).thenReturn(userDisplayName);
      when(mockUserRepository.photoURL).thenReturn(userPhotoURL);

      when(mockThemeService.getIcon()).thenReturn(Icons.auto_awesome_rounded);

      GetIt.I.registerLazySingleton<ThemeService>(() => mockThemeService);
      GetIt.I.registerLazySingleton<UserRepository>(() => mockUserRepository);
      GetIt.I.registerLazySingleton<AuthenticationService>(() => mockAuthenticationService);
    });

    testWidgets('Renders UserModal correctly', (WidgetTester tester) async {
      late BuildContext savedContext;

      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Builder(builder: (context) {
          savedContext = context;
          return Container();
        })),
      ));

      expect(find.byKey(const Key('user_modal')), findsNothing);

      // Open modal
      UserModal.showModal(savedContext);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('user_modal')), findsOneWidget);
      expect(find.text(userDisplayName), findsOneWidget);
      expect(find.text(userEmail), findsOneWidget);
      expect(find.text('Change theme'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
    });

    group('Calls the onPressed function correctly when the button is pressed', () {
      testWidgets('Change theme option', (WidgetTester tester) async {
        late BuildContext savedContext;

        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: Builder(builder: (context) {
            savedContext = context;
            return Container();
          })),
        ));

        expect(find.byKey(const Key('user_modal')), findsNothing);

        // Open modal
        UserModal.showModal(savedContext);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('user_modal')), findsOneWidget);

        await tester.tap(find.text('Change theme'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('theme_modal')), findsOneWidget);
      });

      testWidgets('Sign out option', (WidgetTester tester) async {
        late BuildContext savedContext;

        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: Builder(builder: (context) {
            savedContext = context;
            return Container();
          })),
        ));

        expect(find.byKey(const Key('user_modal')), findsNothing);

        // Open modal
        UserModal.showModal(savedContext);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('user_modal')), findsOneWidget);

        await tester.tap(find.text('Sign out'));
        await tester.pumpAndSettle();

        verify(mockAuthenticationService.signOut()).called(1);
      });
    });
  });
}
