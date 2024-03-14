import 'package:app_backend/controller/profiled_trekko.dart';
import 'package:app_backend/controller/request/bodies/request/auth_request.dart';
import 'package:app_backend/controller/request/url_trekko_server.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/screens/journal/journal.dart';
import 'package:flutter_test/flutter_test.dart';

import 'trekko_build_utils.dart';


void main() {
  TrekkoBuildUtils.init();
  Future<Trekko> makeTrekko(
      String projectUrl, String email, String token) async {
    Trekko trekko =
    ProfiledTrekko(projectUrl: projectUrl, email: email, token: token);
    await trekko.init();
    return trekko;
  }

    testWidgets('Navigation on "Erhebung starten" button tap', (
        WidgetTester tester) async {
      Future<Trekko> testTrekko = UrlTrekkoServer('http://localhost:8080')
          .signUp(AuthRequest('test@web.de', '!Abc123#'))
          .then((value) async {
        // await _server.confirmEmail(CodeRequest(_code)); // TODO: exc handling
        return makeTrekko('http://localhost:8080', 'lalilu@web.de', value.token);
      });
      await tester.pumpWidget(
          JournalScreen()); // Erstelle den Screen
      await tester
          .pumpAndSettle(); // Lässt alle Animationen und Futures auslaufen

      //TODO HIER
      // Vor der Interaktion könnte man überprüfen, ob der Start-Screen sichtbar ist
      expect(find.text('Mobilitätsdaten'), findsOneWidget);
      expect(find.text('Erhebung starten'), findsOneWidget);
      expect(find.byType(Button), findsOneWidget);
      // Simuliere das Tippen auf den Button
      await tester.tap(find.byType(Button));
      await tester.pumpAndSettle();
      expect(find.text('Stoppen'), findsOneWidget);
      expect(find.byType(Button), findsOneWidget);
      // Überprüfe die Navigation, z.B. ob der Screen jetzt der Erhebungs-Screen ist
      expect(find.text('Erhebung läuft...'), findsOneWidget);
      (await testTrekko).signOut(delete: true);
    });

}




