import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_style.dart';
import 'package:trekko_frontend/screens/analysis/analysis.dart';
import 'package:trekko_frontend/screens/journal/journal.dart';
import 'package:trekko_frontend/screens/journal/journal_entry.dart';
import 'package:trekko_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';
import 'package:trekko_frontend/screens/tracking/tracking.dart';
import 'package:trekko_frontend/screens/trekko_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main () async {
  late Trekko trekko;
  setUp(() async {
    trekko = await TestUtils.initTrekko();
  });

  tearDown(() async {
    await TestUtils.clearTrekko(trekko);
  });

  testWidgets('Test creating, donating and deleting a journal entry',
          (WidgetTester tester) async {
        await tester.pumpWidget(TrekkoApp(trekko: trekko,),);

        await tester.pumpAndSettle();
        expect(find.byType(TrackingScreen), findsOneWidget);

        await tester.tap(find.text('Tagebuch'));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(find.byType(JournalScreen), findsOneWidget);
        await tester.tap(find.widgetWithIcon(GestureDetector, CupertinoIcons.add));
        await tester.pumpAndSettle();
        expect(find.byType(JournalEntryDetailView), findsOneWidget);

        await tester.tap(find.widgetWithText(Button, 'Spenden'));
        await tester.pump(const Duration(seconds: 5));
        expect(find.text('Spende zurückziehen'), findsOneWidget);

        await tester.tap(find.text('Statistik'));
        await tester.pumpAndSettle();
        expect(find.byType(Analysis), findsOneWidget);

        await tester.tap(find.text('Tagebuch'));
        await tester.pumpAndSettle();
        expect(find.byType(JournalEntryDetailView), findsOneWidget);
        await tester.tap(find.byWidgetPredicate((Widget button) => button is Button && button.style == ButtonStyle.destructive));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Löschen'));
        expect(find.byType(JournalEntry), findsNothing);
      });
}