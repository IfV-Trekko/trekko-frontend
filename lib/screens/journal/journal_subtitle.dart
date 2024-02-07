import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class JournalSubtitle extends StatelessWidget {
  final DateTime _date;

  @override
  Widget build(BuildContext context) {
    String title = _formatDate(_date);
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

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, dd. MMMM yyyy', 'de_DE').format(date);
  }

  const JournalSubtitle(this._date, {super.key});
}
