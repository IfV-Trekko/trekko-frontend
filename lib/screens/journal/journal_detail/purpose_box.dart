import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class PurposeBox extends StatelessWidget {
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            _title,
            overflow: TextOverflow.ellipsis,
            style: AppThemeTextStyles.small.copyWith(
              color: AppThemeColors.contrast900,
            ),
          ),
        ),
      ),
    );
  }

  const PurposeBox(this._title, {super.key});
}