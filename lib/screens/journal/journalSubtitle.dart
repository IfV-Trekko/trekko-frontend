import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class journalSubtitle extends StatelessWidget {
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppThemeColors.contrast500,
            width: 1.0,
          ),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        _title,
        style: const TextStyle(
          color: AppThemeColors.contrast500,
          fontFamily: 'SF Pro',
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  journalSubtitle(this._title);
}
