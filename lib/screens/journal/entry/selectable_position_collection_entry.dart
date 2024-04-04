import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/journal/entry/journal_entry_context_menu.dart';
import 'package:trekko_frontend/screens/journal/entry/position_collection_entry.dart';

//renders the journal entry cards showing the trip information
class SelectablePositionCollectionEntry extends StatelessWidget {
  final Trip data;
  final bool selectionMode;
  final bool selected;
  final Function(Trip) onTap;
  final Trekko trekko;

  const SelectablePositionCollectionEntry(
      {required this.trekko,
      required this.data,
      required this.selected,
      required this.selectionMode,
      required this.onTap,
      required super.key}); // TODO: this key thingy

  @override
  Widget build(BuildContext context) {
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
                        onTap(data);
                      },
                    )),
              ),
            if (selectionMode) const SizedBox(width: 16.0),
            Expanded(
              child: selectionMode
                  ? PositionCollectionEntry(
                      trekko: trekko, data: data, onTap: (a) {})
                  : JournalEntryContextMenu(
                      trip: data,
                      onDonate: () async {
                        trekko.donate(createQuery().build());
                      },
                      onRevoke: () async {
                        trekko.revoke(createQuery().build());
                      },
                      onDelete: () async {
                        trekko.deleteTrip(createQuery().build());
                      },
                      onEdit: () {
                        // Navigator.push( // TODO: re add
                        //     context,
                        //     CupertinoPageRoute(
                        //         builder: (context) =>
                        //             JournalEntryDetailView(trip)));
                      },
                      buildEntry: () => PositionCollectionEntry(
                          trekko: trekko,
                          data: data,
                          onTap: (p) => onTap(data)),
                    ),
            ),
          ],
        ));
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> createQuery() {
    return trekko.getTripQuery().filter().idEqualTo(data.id);
  }
}
