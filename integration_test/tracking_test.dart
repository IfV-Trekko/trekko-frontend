import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/screens/tracking/tracking.dart';
import 'package:app_frontend/screens/trekko_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../test/test_utils.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Trekko? trekko;

  tearDown(() async {
    if (trekko != null) await TestUtils.clearTrekko(trekko!);
  });

  testWidgets('Test every screen, after onboarding',
      (WidgetTester tester) async {
    initializeDateFormatting();

    final Trekko trekko = await TestUtils.initTrekko();
    await tester.pumpWidget(
      TrekkoApp(
        trekko: trekko,
      ),
    );
    await tester.pump(Duration(seconds: 5));

    expect(find.byType(TrackingScreen), findsOneWidget);
    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle();

    expect(find.text('Stoppen'), findsOneWidget);
    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle();

    expect(find.text('Erhebung starten'), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
