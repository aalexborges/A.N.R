import 'package:anr/repositories/user_repository.dart';
import 'package:anr/widgets/user_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_button_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  group('UserButton', () {
    late MockUserRepository mockUserRepository;

    setUpAll(() {
      mockUserRepository = MockUserRepository();

      when(mockUserRepository.photoURL).thenReturn('photoURL');

      GetIt.I.registerLazySingleton<UserRepository>(() => mockUserRepository);
    });

    testWidgets('Renders UserButton with user photo correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(child: UserButton(onPressed: () {}, tooltip: 'Perfil')),
      ));

      expect(find.byKey(const Key('user_icon_button')), findsOneWidget);
      expect(find.byKey(const Key('user_icon_button_photo')), findsOneWidget);
    });

    testWidgets('Renders UserButton without user photo correctly', (WidgetTester tester) async {
      when(mockUserRepository.photoURL).thenReturn(null);

      await tester.pumpWidget(MaterialApp(
        home: Material(child: UserButton(onPressed: () {}, tooltip: 'Perfil')),
      ));

      expect(find.byKey(const Key('user_icon_button')), findsOneWidget);
      expect(find.byKey(const Key('user_icon_button_photo')), findsNothing);
    });

    testWidgets('Calls the onPressed function correctly when the button is pressed', (WidgetTester tester) async {
      bool onPressedCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: UserButton(
            tooltip: 'Perfil',
            onPressed: () {
              onPressedCalled = true;
            },
          ),
        ),
      ));

      final userIconButton = find.byKey(const Key('user_icon_button'));

      await tester.tap(userIconButton);
      await tester.pump();

      expect(onPressedCalled, true);
    });
  });
}
