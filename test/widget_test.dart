import 'package:app_backend/controller/profiled_trekko.dart';
import 'package:app_backend/controller/request/bodies/request/auth_request.dart';
import 'package:app_backend/controller/request/url_trekko_server.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/screens/tracking/tracking.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';
import 'trekko_build_utils.dart';

//TODO: T4, T5, T6, T7,

void main() {
  Trekko? trekko;

  setUp(() async {
    await TrekkoBuildUtils.init();
    trekko = await TestUtils.initTrekko();
  });

  tearDown(() async {
    if (trekko != null) await TestUtils.clearTrekko(trekko!);
  });

  testWidgets("EXAMPLE DESCRIPTION", (tester) async {
    await tester.pumpWidget(TrackingScreen(trekko: trekko!));
    await tester.pumpAndSettle();
    expect(find.text('Mobilitätsdaten'), findsOneWidget);
    expect(find.text('Erhebung starten'), findsOneWidget);
    expect(find.byType(Button), findsOneWidget);
    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle();
    expect(find.text('Stoppen'), findsOneWidget);
    expect(find.byType(Button), findsOneWidget);
    expect(find.text('Erhebung läuft...'), findsOneWidget);
    (await trekko)?.signOut(delete: true);
  });
}
