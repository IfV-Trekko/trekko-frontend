import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/screens/tracking/tracking.dart';
import 'package:trekko_frontend/screens/trekko_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'test_utils.dart';

void main() async {
  setUp(() async {
    await TrekkoBuildUtils.init();
  });

  Trekko? trekko;

  tearDown(() async {
    if (trekko != null) await TestUtils.clearTrekko(trekko);
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
