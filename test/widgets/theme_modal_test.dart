import 'package:anr/services/theme_service.dart';
import 'package:anr/widgets/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'theme_modal_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ThemeService>()])
void main() {
  group('ThemeModal', () {
    late MockThemeService mockThemeService;

    setUpAll(() {
      mockThemeService = MockThemeService();

      GetIt.I.registerLazySingleton<ThemeService>(() => mockThemeService);
    });

    testWidgets('Renders ThemeModal correctly', (WidgetTester tester) async {
      late BuildContext savedContext;

      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Builder(builder: (context) {
          savedContext = context;
          return Container();
        })),
      ));

      expect(find.byKey(const Key('theme_modal')), findsNothing);

      // Open modal
      ThemeModal.showModal(savedContext);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('theme_modal')), findsOneWidget);

      // Dark theme option
      expect(find.text('Dark'), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);

      // Light theme option
      expect(find.text('Light'), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

      // System theme option
      expect(find.text('System'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
    });

    testWidgets('Calls the onPressed function correctly when the button is pressed', (WidgetTester tester) async {
      late BuildContext savedContext;

      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Builder(builder: (context) {
          savedContext = context;
          return Container();
        })),
      ));

      expect(find.byKey(const Key('theme_modal')), findsNothing);

      // Open modal
      ThemeModal.showModal(savedContext);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('theme_modal')), findsOneWidget);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      verify(mockThemeService.changeTheme(ThemeMode.dark)).called(1);
    });
  });
}
