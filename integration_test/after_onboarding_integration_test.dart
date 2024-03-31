import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/picker/time_picker.dart';
import 'package:trekko_frontend/components/constants/button_size.dart';
import 'package:trekko_frontend/components/constants/button_style.dart';
import 'package:trekko_frontend/screens/journal/journal.dart';
import 'package:trekko_frontend/screens/journal/journal_detail/vehicle_box.dart';
import 'package:trekko_frontend/screens/journal/journal_entry.dart';
import 'package:trekko_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';
import 'package:trekko_frontend/screens/tracking/tracking.dart';
import 'package:trekko_frontend/screens/trekko_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'test_utils.dart';

void main () async {
  setUp(() async {
    await TrekkoBuildUtils.init();
  });

  Trekko? trekko;

  tearDown(() async {
    if (trekko != null) await TestUtils.clearTrekko(trekko);
  });

  testWidgets('Test creating and deleting a journal entry',
          (WidgetTester tester) async {
    initializeDateFormatting();

    final Trekko trekko = await TestUtils.initTrekko();
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