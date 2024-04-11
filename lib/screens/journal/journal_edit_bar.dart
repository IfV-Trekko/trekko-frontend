import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';

class JournalEditBar extends StatelessWidget {
  final Function? onRevoke;
  final Function onMerge;
  final Function onDelete;

  const JournalEditBar({
    super.key,
    required this.onRevoke,
    required this.onMerge,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          color: AppThemeColors.contrast0,
          border: Border(
            top: BorderSide(
              color: AppThemeColors.contrast400,
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  onMerge();
                },
                child: Text(
                  "Vereinigen",
                  style: AppThemeTextStyles.normal
                      .copyWith(color: AppThemeColors.blue),
                ),
              ),
              if (onRevoke != null)
                GestureDetector(
                  onTap: () {
                    onRevoke!();
                  },
                  child: Text(
                    "Zurückziehen",
                    style: AppThemeTextStyles.normal
                        .copyWith(color: AppThemeColors.blue),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  onDelete();
                },
                child: Text(
                  "Löschen",
                  style: AppThemeTextStyles.normal
                      .copyWith(color: AppThemeColors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
