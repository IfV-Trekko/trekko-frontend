import 'package:app_backend/controller/profiled_trekko.dart';
import 'package:app_backend/controller/request/bodies/request/auth_request.dart';
import 'package:app_backend/controller/request/bodies/response/auth_response.dart';
import 'package:app_backend/controller/request/url_trekko_server.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/screens/journal/journal.dart';
import 'package:app_frontend/screens/tracking/tracking.dart';
import 'package:app_frontend/screens/trekko_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    // Wechseln zum Tagebuch-Tab
    await tester.tap(find.text('Tagebuch'));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byType(JournalScreen), findsOneWidget);
    await tester.tap(find.widgetWithIcon(GestureDetector, CupertinoIcons.add));
    print(2);
    await tester.pumpAndSettle(Duration(seconds: 5));



    // expect(find.byType(JournalEntryDetailView), findsOneWidget);
    // print(12);
    //
    // // Wechseln zum Statistik-Tab
    // await tester.tap(find.text('Statistik'));
    // await tester.pumpAndSettle(Duration(seconds: 2));
    // expect(find.byType(Analysis), findsOneWidget);
    //
    // // Wechseln zum Profil-Tab
    // await tester.tap(find.text('Profil'));
    // await tester.pumpAndSettle(Duration(seconds: 2));
    // expect(find.byType(ProfileScreen), findsOneWidget);
    // await tester.pumpAndSettle(Duration(seconds: 2));
  });
}