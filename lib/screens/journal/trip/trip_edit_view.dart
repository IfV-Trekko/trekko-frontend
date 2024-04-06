import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/trip_builder.dart';
import 'package:trekko_backend/controller/utils/trip_query.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/components/rounded_scrollable_sheet.dart';
import 'package:trekko_frontend/components/stream_wrapper.dart';
import 'package:trekko_frontend/screens/journal/entry/selectable_position_collection_entry.dart';
import 'package:trekko_frontend/screens/journal/trip/detail/editable_trip_details.dart';
import 'package:trekko_frontend/screens/journal/trip/detail/position_detail_box.dart';
import 'package:trekko_frontend/trekko_provider.dart';

import 'leg_edit_view.dart';

class TripEditView extends StatefulWidget {
  final Trekko trekko;
  final int tripId;

  const TripEditView({required this.trekko, required this.tripId, super.key});

  @override
  State<TripEditView> createState() => _TripEditViewState();
}

class _TripEditViewState extends State<TripEditView> {
  void _editLegs(Function(List<Leg>) editFunc, Trip trip) {
    List<Leg> newLegs = List.from(trip.legs);
    editFunc(newLegs);
    trip.legs = newLegs;
    widget.trekko.saveTrip(trip);
  }

  @override
  Widget build(BuildContext context) {
    Trekko trekko = TrekkoProvider.of(context);
    return StreamWrapper(
        stream: TripQuery(trekko)
            .andId(widget.tripId)
            .stream()
            .map((event) => event.first),
        builder: (context, trip) {
          return CupertinoPageScaffold(
            child: Stack(
              children: <Widget>[
                PositionCollectionMap(collections: Stream.value([trip])),
                RoundedScrollableSheet(
                  title: "Details",
                  initialChildSize: 0.15,
                  child: Column(
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
                      const SizedBox(height: 10),
                      Button(
                          title: "Zurück",
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      const SizedBox(height: 10),
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
                                  Leg newLeg = Leg.withData(
                                      TransportType.by_foot,
                                      TripBuilder()
                                          .move_r(const Duration(minutes: 1),
                                              100.meters)
                                          .collect());
                                  _editLegs((p0) => p0.add(newLeg), trip);
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => LegEditView(
                                        leg: newLeg,
                                        onEditComplete: () {
                                          trekko.saveTrip(trip);
                                        },
                                      ),
                                    ),
                                  );
                                })
                          ]),
                      const SizedBox(height: 10),
                      for (int i = 0; i < trip.legs.length; i++)
                        SelectablePositionCollectionEntry(
                            trekko: trekko,
                            data: trip.legs[i],
                            key: ValueKey(i),
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => LegEditView(
                                    leg: trip.legs[i],
                                    onEditComplete: () {
                                      trekko.saveTrip(trip);
                                    },
                                  ),
                                ),
                              );
                            },
                            onEdit: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => LegEditView(
                                    leg: trip.legs[i],
                                    onEditComplete: () {
                                      trekko.saveTrip(trip);
                                    },
                                  ),
                                ),
                              );
                            },
                            onDelete: () {
                              if (trip.legs.length == 1) {
                                trekko.deleteTrip(
                                    TripQuery(trekko).andId(trip.id).build());
                                Navigator.of(context).pop();
                              } else {
                                _editLegs((p0) => p0.removeAt(i), trip);
                              }
                            }),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
