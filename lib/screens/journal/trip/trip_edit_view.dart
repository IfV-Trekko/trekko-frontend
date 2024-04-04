import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/trip_query.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/components/rounded_scrollable_sheet.dart';
import 'package:trekko_frontend/components/stream_wrapper.dart';
import 'package:trekko_frontend/screens/journal/entry/position_collection_entry.dart';
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
                PositionCollectionMap(
                  collections: Stream.value([trip]),
                ),
                RoundedScrollableSheet(
                  title: "Teilwege",
                  initialChildSize: 0.15,
                  child: Column(
                    children: trip.legs.map((leg) {
                      return PositionCollectionEntry(
                        trekko: trekko,
                        data: leg,
                        onTap: (a) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => LegEditView(
                                leg: leg,
                                onEditComplete: () {
                                  trekko.saveTrip(trip);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
