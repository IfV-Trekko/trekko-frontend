import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';

class PurposeBox extends StatelessWidget {
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 100,
      ),
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: AppThemeColors.contrast200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _title,
            overflow: TextOverflow.ellipsis,
            style: AppThemeTextStyles.small.copyWith(
              color: AppThemeColors.contrast900,
            ),
          ),
        ],
      ),
    );
  }

  const PurposeBox(this._title, {super.key});
}
