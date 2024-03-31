import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/text_input.dart';
import 'package:trekko_frontend/screens/profile/profile_screen.dart';
import 'package:trekko_frontend/screens/tracking/tracking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trekko_frontend/main.dart' as app;
import 'package:intl/intl.dart';

import 'test_utils.dart';

/*
  This test is an integration test.
  It tests the whole registration process.
  It starts with the login screen, then the registration screen, the verification screen, the profile screen and finally the logout.
  After that, the login screen is tested again and the profile screen is opened to check if you are registered to the correct account.
  Testcase: T1 & T10
 */
void main() async {
  setUp(() async {
    await TestUtils.init();
  });

  testWidgets('Onboarding test with registration and login',
      (WidgetTester tester) async {
    app.runLoginApp();
    await tester.pumpAndSettle(); // Wait for initial animations to settle

    expect(find.text('Beginnen'), findsOneWidget);
    expect(find.byType(Button), findsOneWidget);

    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle();

    expect(
        find.widgetWithText(CupertinoTextField, 'Project-URL'), findsOneWidget);
    expect(find.widgetWithText(Button, 'Weiter'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Project-URL'),
        TestUtils.getAddress());
    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(Button, 'Anmelden'), findsOneWidget);
    await tester.tap(find.widgetWithText(Button, 'Registrieren'));
    await tester.pumpAndSettle();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy.MM.dd.HH.mm.ss').format(now);
    String email = 'test$formattedDate@web.de';
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'E-Mail Adresse'), email);
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Passwort'), 'aaAA11!!');
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Passwort wiederholen'),
        'aaAA11!!');
    await tester.tap(find.byType(CupertinoCheckbox));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Registrieren'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextInput, 'Code'), '123456');
    await tester.tap(find.widgetWithText(Button, 'Verifizieren'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CupertinoListTile, 'Alter'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(CupertinoTextField), '12.0');
    await tester.tap(find.widgetWithText(Button, 'Speichern'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Registrierung abschließen'));
    await tester.pumpAndSettle();

    expect(find.byType(TrackingScreen), findsOneWidget);
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.widgetWithText(CupertinoListTile, email), findsOneWidget);
    expect(find.widgetWithText(CupertinoListTile, TestUtils.getAddress()),
        findsOneWidget);
    expect(find.widgetWithText(CupertinoListTile, 'Alter'), findsOneWidget);
    expect(find.widgetWithText(CupertinoListTile, '12.0'), findsOneWidget);
    await tester.tap(find.widgetWithText(CupertinoListTile, 'Abmelden'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Beginnen'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Project-URL'),
        TestUtils.getAddress());
    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Anmelden'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'E-Mail Adresse'), email);
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Passwort'), 'aaAA11!!');
    await tester.tap(find.widgetWithText(Button, 'Anmelden'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.text(email), findsOneWidget);
  });
}
