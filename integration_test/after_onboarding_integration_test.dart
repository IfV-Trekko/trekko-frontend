import 'package:app_backend/controller/profiled_trekko.dart';
import 'package:app_backend/controller/request/bodies/request/auth_request.dart';
import 'package:app_backend/controller/request/bodies/response/auth_response.dart';
import 'package:app_backend/controller/request/url_trekko_server.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/picker/time_picker.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/screens/journal/journal.dart';
import 'package:app_frontend/screens/journal/journal_detail/vehicle_box.dart';
import 'package:app_frontend/screens/journal/journal_entry.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';
import 'package:app_frontend/screens/tracking/tracking.dart';
import 'package:app_frontend/screens/trekko_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main () async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<Trekko> makeTrekko(
  String projectUrl, String email, String token) async {
    Trekko trekko =
    ProfiledTrekko(projectUrl: projectUrl, email: email, token: token);
    await trekko.init();
    return trekko;
  }

  Future<Trekko> initTrekko() async {
    final UrlTrekkoServer trekkoServer = UrlTrekkoServer('http://localhost:8080');

    String uniqueEmail = 'test@example.com';
    AuthResponse authResponse;

    try {
      authResponse = await trekkoServer.signUp(AuthRequest(uniqueEmail, '!Abc123#'));
    } catch (e) {
      authResponse = await trekkoServer.signIn(AuthRequest(uniqueEmail, '!Abc123#'));
    }
    return await makeTrekko('http://localhost:8080', uniqueEmail, authResponse.token);
  }

  Future<void> clearTrekko(Trekko trekko) async {
    await trekko.signOut(delete: true);
  }

  Trekko? trekko;

  tearDown(() async {
    if (trekko != null) await clearTrekko(trekko!);
  });

  testWidgets('Test every screen, after onboarding',
          (WidgetTester tester) async {
    initializeDateFormatting();

    final Trekko trekko = await initTrekko();
    await tester.pumpWidget(TrekkoApp(trekko: trekko,),);

    await tester.pumpAndSettle();
    expect(find.byType(TrackingScreen), findsOneWidget);

    await tester.tap(find.text('Tagebuch'));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byType(JournalScreen), findsOneWidget);
    await tester.tap(find.widgetWithIcon(GestureDetector, CupertinoIcons.add));
    await tester.pumpAndSettle();
    expect(find.byType(JournalEntryDetailView), findsOneWidget);

    await tester.tap(find.byType(TimePicker).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CupertinoListTile, 'Anlass / Zweck'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(CupertinoTextField), 'Arbeit');
    await tester.tap(find.widgetWithText(Button, 'Speichern'));
    await tester.pumpAndSettle();
    expect(find.byType(JournalEntryDetailView), findsOneWidget);

    await tester.tap(find.widgetWithText(CupertinoListTile, 'Verkehrsmittel'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CupertinoListTile, 'Fahrrad'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Button, 'Speichern'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CupertinoNavigationBarBackButton, 'Tagebuch'));
    await tester.pumpAndSettle();
    expect(find.byType(JournalScreen), findsOneWidget);
    expect(find.byType(JournalEntry), findsOneWidget);
    expect(find.widgetWithText(VehicleBox, 'Fahrrad'), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Button, 'Spenden'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(JournalEntry).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byWidgetPredicate((Widget button) => button is Button && button.size == ButtonSize.large));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Schließen'));
    await tester.pumpAndSettle();
    expect(find.byType(JournalEntry), findsOneWidget);
    await tester.tap(find.byType(JournalEntry));
    await tester.pumpAndSettle();
    expect(find.byType(JournalEntryDetailView), findsOneWidget);
    await tester.tap(find.byWidgetPredicate((Widget button) => button is Button && button.style == ButtonStyle.destructive));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Löschen'));
    expect(find.byType(JournalEntry), findsNothing);
  });
}