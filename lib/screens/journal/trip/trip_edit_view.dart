import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/trip_query.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/components/maps/trips_map.dart';
import 'package:trekko_frontend/components/rounded_scrollable_sheet.dart';
import 'package:trekko_frontend/components/stream_wrapper.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class TripEditView extends StatefulWidget {
  final int tripId;

  const TripEditView({required this.tripId, super.key});

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
                TripsMap(
                  trips: Stream.value([trip]),
                ),
                RoundedScrollableSheet(
                  initialChildSize: 0.15,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "name",
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "desc",
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
