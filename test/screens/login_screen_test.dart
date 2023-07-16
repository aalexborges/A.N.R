import 'package:anr/screens/login_screen.dart';
import 'package:anr/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationService>()])
void main() {
  late AuthenticationService authenticationService;

  group('LoginScreen', () {
    setUpAll(() {
      authenticationService = MockAuthenticationService();

      GetIt.I.registerLazySingleton<AuthenticationService>(() => authenticationService);
    });

    testWidgets('Display login button correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: LoginScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ));

      expect(find.byKey(const Key('sign_in_with_google_button')), findsOneWidget);
      expect(find.text('Sign In with Google'), findsOneWidget);
    });

    testWidgets('Calls the login method correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: LoginScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ));

      await tester.tap(find.byKey(const Key('sign_in_with_google_button')));
      await tester.pumpAndSettle();

      verify(authenticationService.signInWithGoogle()).called(1);
    });
  });
}
