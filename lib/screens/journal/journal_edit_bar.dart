import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class JournalEditBar extends StatelessWidget {
  final Function onRevoke;
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
                  // await merge(trekko);
                  // setState(() {
                  //   selectionMode = false;
                  // });
                },
                child: Text(
                  "Vereinigen",
                  style: AppThemeTextStyles.normal
                      .copyWith(color: AppThemeColors.blue),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onRevoke();
                  // await revoke(trekko);
                  // setState(() {
                  //   selectionMode = false;
                  // });
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
                  // await delete(trekko);
                  // setState(() {
                  //   selectionMode = false;
                  // });
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
