import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/journal/entry/collection_entry_context_menu.dart';
import 'package:trekko_frontend/screens/journal/entry/position_collection_entry.dart';

class SelectablePositionCollectionEntry extends StatelessWidget {
  final Trekko trekko;
  final PositionCollection data;
  final bool selectionMode;
  final bool selected;
  final Function()? onTap;
  final List<EntryAction> actions;
  final Function()? onEdit;
  final Function()? onDelete;

  const SelectablePositionCollectionEntry(
      {required this.trekko,
      required this.data,
      this.actions = const [],
      this.selected = false,
      this.selectionMode = false,
      this.onTap,
      this.onEdit,
      this.onDelete,
      required super.key}); // TODO: this key thingy

  @override
  Widget build(BuildContext context) {
    Widget entry = PositionCollectionEntry(
        trekko: trekko, data: data, onTap: (a) => onTap?.call());
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (selectionMode)
              ClipRect(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CupertinoCheckbox(
                      shape: const CircleBorder(),
                      activeColor: AppThemeColors.blue,
                      value: selected,
                      onChanged: (value) {
                        onTap?.call();
                      },
                    )),
              ),
            if (selectionMode) const SizedBox(width: 16.0),
            Expanded(
              child: selectionMode
                  ? entry
                  : CollectionEntryContextMenu(
                      trip: data,
                      actions: actions,
                      onEdit: onEdit ?? () {},
                      onDelete: onDelete ?? () {},
                      child: entry,
                    ),
            ),
          ],
        ));
  }
}
