import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class JournalEntryContextMenu extends StatelessWidget {
  final Trip trip;
  final Function onDonate;
  final Function onRevoke;
  final Function onDelete;
  final Function onEdit;
  final Function buildEntry;

  const JournalEntryContextMenu({
    super.key,
    required this.trip,
    required this.onDonate,
    required this.onRevoke,
    required this.onDelete,
    required this.onEdit,
    required this.buildEntry,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      enableHapticFeedback: true,
      actions: <Widget>[
        Builder(
          builder: (menuContext) => CupertinoContextMenuAction(
            onPressed: () {
              if (trip.donationState == DonationState.donated) {
                onRevoke();
                // trekko.revoke(createQuery().build());
              } else {
                onDonate();
              }
              Navigator.pop(menuContext);
            },
            isDefaultAction: true,
            trailingIcon: trip.donationState == DonationState.donated
                ? CupertinoIcons.xmark
                : CupertinoIcons.share,
            child: Text(
              trip.donationState == DonationState.donated
                  ? 'Spende zurückziehen'
                  : 'Spenden',
              style: AppThemeTextStyles.normal
                  .copyWith(color: AppThemeColors.contrast900),
            ),
          ),
        ),
        Builder(
          builder: (menuContext) => CupertinoContextMenuAction(
            onPressed: () {
              Navigator.pop(menuContext);
              onEdit();
            },
            trailingIcon: CupertinoIcons.pen,
            child: Text(
              'Bearbeiten',
              style: AppThemeTextStyles.normal
                  .copyWith(color: AppThemeColors.contrast900),
            ),
          ),
        ),
        Builder(
          builder: (menuContext) => CupertinoContextMenuAction(
            onPressed: () {
              onDelete();
              Navigator.pop(menuContext);
            },
            trailingIcon: CupertinoIcons.trash,
            child: Text(
              'Unwiderruflich löschen',
              style:
                  AppThemeTextStyles.normal.copyWith(color: AppThemeColors.red),
            ),
          ),
        ),
      ],
      child: buildEntry(),
    );
  }
}
