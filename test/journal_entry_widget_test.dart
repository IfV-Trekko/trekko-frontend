import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/analysis/analysis.dart';
import 'package:app_frontend/screens/journal/journal.dart';
import 'package:app_frontend/screens/journal/journal_entry.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';
import 'package:app_frontend/screens/profile/profile_screen.dart';
import 'package:app_frontend/screens/tracking/tracking.dart';
import 'package:app_frontend/screens/trekko_app.dart';
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
        TrekkoApp(
                trekko: trekko!,
              ),
            );
            await tester.pumpAndSettle();


            expect(find.byType(TrackingScreen), findsOneWidget);

            // Wechseln zum Tagebuch-Tab
            await tester.tap(find.text('Tagebuch'));
            await tester.pumpAndSettle();
            expect(find.byType(JournalScreen), findsOneWidget);

            // Wechseln zum Statistik-Tab
            await tester.tap(find.text('Statistik'));
            await tester.pumpAndSettle();
            expect(find.byType(Analysis), findsOneWidget);

            // Wechseln zum Profil-Tab
            await tester.tap(find.text('Profil'));
            await tester.pumpAndSettle();
            expect(find.byType(ProfileScreen), findsOneWidget);
    });
}
