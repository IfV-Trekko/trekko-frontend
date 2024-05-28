import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/trip_constants.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/components/rounded_scrollable_sheet.dart';
import 'package:trekko_frontend/components/stream_wrapper.dart';
import 'package:trekko_frontend/screens/journal/entry/selectable_position_collection_entry.dart';
import 'package:trekko_frontend/screens/journal/trip/detail/editable_trip_details.dart';
import 'package:trekko_frontend/screens/journal/trip/detail/position_detail_box.dart';
import 'package:trekko_frontend/trekko_provider.dart';

import 'leg_edit_view.dart';

class TripEditView extends StatefulWidget {
  final int tripId;

  const TripEditView({required this.tripId, super.key});

  @override
  State<TripEditView> createState() => _TripEditViewState();
}

class _TripEditViewState extends State<TripEditView> {
  void _editLegs(Trekko trekko, Function(List<Leg>) editFunc, Trip trip) {
    List<Leg> newLegs = List.from(trip.legs);
    editFunc(newLegs);
    trip.legs = newLegs;
    trekko.saveTrip(trip);
  }

  Future _openEditLegView(BuildContext context, Leg leg, Trip trip) async {
    Trekko trekko = TrekkoProvider.of(context);
    Leg? edited = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => LegEditView(leg: leg),
      ),
    );

    if (edited != null) {
      _editLegs(trekko, (p0) => p0.map((e) => e == leg ? edited : e), trip);
      await trekko.saveTrip(trip);
    }
  }

  @override
  Widget build(BuildContext context) {
    Trekko trekko = TrekkoProvider.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Transform.translate(
            offset: const Offset(-16, 0),
            child: CupertinoNavigationBarBackButton(
              previousPageTitle: 'Zurück',
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        middle: const Text("Weg bearbeiten"),
      ),
      child: Stack(
        children: <Widget>[
          PositionCollectionMap(
              collections: trekko
                  .getTripQuery()
                  .andId(widget.tripId)
                  .stream()
                  .map((event) => [event.first])),
          RoundedScrollableSheet(
            title: "Details",
            initialChildSize: 0.15,
            child: StreamWrapper(
                stream: trekko
                    .getTripQuery()
                    .andId(widget.tripId)
                    .stream()
                    .map((event) => event.first),
                builder: (context, trip) {
                  return Column(
                    children: [
                      PositionDetailBox(data: trip),
                      EditableTripDetails(
                        purpose: trip.purpose,
                        comment: trip.comment,
                        onSavedPurpose: (value) {
                          trip.purpose = value;
                          trekko.saveTrip(trip);
                        },
                        onSavedComment: (value) {
                          trip.comment = value;
                          trekko.saveTrip(trip);
                        },
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Teilwege",
                                style: AppThemeTextStyles.largeTitle),
                            CupertinoButton(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppThemeColors.blue,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.add,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Leg newLeg = TripConstants.createDefaultLeg(
                                      trip
                                          .calculateEndTime()
                                          .add(const Duration(minutes: 5)));
                                  _editLegs(
                                      trekko, (p0) => p0.add(newLeg), trip);
                                  _openEditLegView(context, newLeg, trip);
                                })
                          ]),
                      for (int i = 0; i < trip.legs.length; i++)
                        SelectablePositionCollectionEntry(
                            trekko: trekko,
                            data: trip.legs[i],
                            key: ValueKey(i),
                            onTap: () {
                              _openEditLegView(context, trip.legs[i], trip);
                            },
                            onEdit: () {
                              _openEditLegView(context, trip.legs[i], trip);
                            },
                            onDelete: () {
                              if (trip.legs.length == 1) {
                                trekko.deleteTrip(
                                    trekko.getTripQuery().andId(trip.id));
                                Navigator.of(context).pop();
                              } else {
                                _editLegs(trekko, (p0) => p0.removeAt(i), trip);
                              }
                            }),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
