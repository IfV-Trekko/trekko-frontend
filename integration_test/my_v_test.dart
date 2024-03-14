import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app_frontend/main.dart' as app;

import '../test/trekko_build_utils.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await TrekkoBuildUtils.init();

  testWidgets('Test network call and data display',
      (WidgetTester tester) async {
    app.runLoginApp();
    await tester.pumpAndSettle(); // Wait for initial animations to settle

    // expect(find.text('Willkommen\nbei\n TREKKO'), findsOneWidget);
    // expect(find.text('Eine App des Institut für\nVerkehrswesen am KIT'),
    //     findsOneWidget);
    expect(find.text('Beginnen'), findsOneWidget);
    expect(find.byType(Button), findsOneWidget);

    print("found");

    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle();

    expect(
        find.widgetWithText(CupertinoTextField, 'Project-URL'), findsOneWidget);
    expect(find.widgetWithText(Button, 'Weiter'), findsOneWidget);
    print("found2");
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Project-URL'),
        'http://localhost:8080');
    print("found3");
    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();
    print("found4");

    expect(find.widgetWithText(Button, 'Anmelden'), findsOneWidget);
    await tester.tap(find.widgetWithText(Button, 'Registrieren'));
    await tester.pumpAndSettle();

    print("found5");

    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'E-Mail Adresse'),
        'test@web.de');
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Passwort'), 'aaAA11!!');
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Passwort wiederholen'),
        'aaAA11!!');
    await tester.tap(find.byType(CupertinoCheckbox));
    await tester.pumpAndSettle();
    print("found6");
    await tester.tap(find.widgetWithText(Button, 'Registrieren'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextInput, 'Code'), '123456');
    await tester.tap(find.widgetWithText(Button, 'Verifizieren'));
    await tester.pumpAndSettle();
    print("found7");

    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CupertinoListTile, 'Alter'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextInput), '12');
    await tester.tap(find.widgetWithText(Button, 'Speichern'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Registrierung abschließen'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(BottomNavigationBarItem, 'Profil'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CupertinoListTile, 'Abmelden'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Beginnen'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Project-URL'),
        'http://localhost:8080');
    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Anmelden'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'E-Mail Adresse'),
        'test@web.de');
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Passwort'), 'aaAA11!!');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(BottomNavigationBarItem, 'Profil'));
    await tester.pumpAndSettle();

    expect(find.text('12'), findsOneWidget);
  });
}
