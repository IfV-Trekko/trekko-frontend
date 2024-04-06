import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_frontend/app_theme.dart';

class EntryAction {
  final String title;
  final IconData icon;
  final Function onClick;
  late TextStyle textStyle;

  EntryAction(
      {required this.title,
      required this.icon,
      required this.onClick,
      TextStyle? textStyle}) {
    this.textStyle = textStyle ??
        AppThemeTextStyles.normal.copyWith(color: AppThemeColors.contrast900);
  }
}

class CollectionEntryContextMenu extends StatelessWidget {
  final PositionCollection trip;
  final List<EntryAction> actions;
  final Function() onEdit;
  final Function() onDelete;
  final Widget child;

  const CollectionEntryContextMenu({
    super.key,
    required this.trip,
    required this.actions,
    required this.onEdit,
    required this.onDelete,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    List<EntryAction> actions = List.from(this.actions, growable: true);
    actions.add(EntryAction(
        title: "Bearbeiten", icon: CupertinoIcons.pencil, onClick: onEdit));
    actions.add(EntryAction(
        title: "Unwiderruflich löschen",
        icon: CupertinoIcons.trash,
        onClick: onDelete,
        textStyle:
            AppThemeTextStyles.normal.copyWith(color: AppThemeColors.red)));

    return CupertinoContextMenu(
      enableHapticFeedback: true,
      actions: <Widget>[
        for (final action in actions)
          Builder(
            builder: (menuContext) => CupertinoContextMenuAction(
              onPressed: () {
                action.onClick();
                Navigator.pop(menuContext);
              },
              trailingIcon: action.icon,
              child: Text(
                action.title,
                style: action.textStyle,
              ),
            ),
          ),
      ],
      child: child,
    );
  }
}
