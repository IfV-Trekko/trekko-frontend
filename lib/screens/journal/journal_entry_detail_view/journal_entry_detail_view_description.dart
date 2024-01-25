import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_kilometer_picker.dart';
import 'package:flutter/cupertino.dart';

class JournalEntryDetailViewDescription extends StatelessWidget {
  final String startingPoint;
  final String endpoint;
  final String startDate;
  final String endDate;

  const JournalEntryDetailViewDescription({
    required this.startingPoint,
    required this.endpoint,
    required this.startDate,
    required this.endDate,
    Key? key,
    // required this.journalEntry,
  }) : super(key: key);

  // final Trip journalEntry;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        color: AppThemeColors.contrast0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text('Start'), //TODO: add date picker
                Spacer(),
                JournalEntryDetailKilometerPicker(),
                Spacer(),
                Text('Ende'),
              ],
            ),
            SizedBox(height: 16),
            Container(
              //TODO Platzhalter für Pathshowcase
              height: 4,
              width: double.infinity,
              color: AppThemeColors.contrast700,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(startingPoint, style: AppThemeTextStyles.small),
                const Spacer(),
                Text(endpoint, style: AppThemeTextStyles.small),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(startDate, style: AppThemeTextStyles.tiny),
                const Spacer(),
                Text(endDate, style: AppThemeTextStyles.tiny),
              ],
            )
          ],
        ));
  }
}
