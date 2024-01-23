import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class journalDetailBox extends StatelessWidget {
  final String _title;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: AppThemeColors.contrast200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _title,
            style: AppThemeTextStyles.tiny,
          ),
        ],
      ),
    );
  }

  journalDetailBox(this._title);
}
