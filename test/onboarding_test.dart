import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/screens/onboarding/login_app.dart';
import 'package:app_frontend/screens/trekko_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'trekko_build_utils.dart';

void runTrekkoApp(Trekko trekko) {
  runApp(TrekkoApp(trekko: trekko));
}

void main() {
  setUp(() async {
    await TrekkoBuildUtils.init();
  });

  testWidgets('Navigation on "Erhebung starten" button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(LoginApp((trekko) => runTrekkoApp(trekko)));
    await tester.pumpAndSettle();

    expect(find.text('Willkommen\nbei\n TREKKO'), findsOneWidget);
    expect(find.text('Eine App des Institut für\nVerkehrswesen am KIT'),
        findsOneWidget);
    expect(find.text('Beginnen'), findsOneWidget);
    expect(find.byType(Button), findsOneWidget);

    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle();

    expect(
        find.widgetWithText(CupertinoTextField, 'Project-URL'), findsOneWidget);
    expect(find.widgetWithText(Button, 'Weiter'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(CupertinoTextField, 'Project-URL'),
        'http://localhost:8080');
    await tester.tap(find.widgetWithText(Button, 'Weiter'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(Button, 'Anmelden'), findsOneWidget);
    await tester.tap(find.widgetWithText(Button, 'Registrieren'));
    await tester.pumpAndSettle();

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
