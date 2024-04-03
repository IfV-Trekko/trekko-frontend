import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trekko_frontend/app_theme.dart';

//renders the dividers in the journal
class JournalSubtitle extends StatelessWidget {
  final DateTime _date;

  const JournalSubtitle(this._date, {super.key});

  @override
  Widget build(BuildContext context) {
    String title = DateFormat('EEEE, dd. MMMM yyyy', 'de_DE').format(_date);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 48.0,
        constraints: const BoxConstraints(maxWidth: double.infinity),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppThemeColors.contrast200,
              width: 1.0,
            ),
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            title,
            style: AppThemeTextStyles.normal.copyWith(
              fontWeight: FontWeight.bold,
              color: AppThemeColors.contrast500,
            ),
          ),
        ),
      ),
    );
  }
}
