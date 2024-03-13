import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/journal/journal_entry.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_utils.dart';
import 'trekko_build_utils.dart';

void main() {

  Trekko? trekko;

  final Trip trip = Trip();

  setUp(() async {
    await TrekkoBuildUtils.init();
    trekko = await TestUtils.initTrekko();
  });

  tearDown(() async {
    if (trekko != null) await TestUtils.clearTrekko(trekko!);
  });

  testWidgets('Navigate to JournalEntryDetailView, if tapped on JournalEntry', (tester) async {
      await tester.pumpWidget(
          JournalEntry(trip, false, trekko!));
      await tester
          .pumpAndSettle();
      await tester.tap(find.byType(JournalEntry));
      await tester.pumpAndSettle();
      expect(find.byType(JournalEntryDetailView), findsOneWidget);
    });
}
