import 'dart:math';

import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/controller/utils/trip_builder.dart';
import 'package:app_backend/model/tracking_state.dart';
import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/tracked_point.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';

class TrackingScreen extends StatefulWidget {
  final Trekko trekko;

  const TrackingScreen({super.key, required this.trekko});

  @override
  State<StatefulWidget> createState() {
    return _TrackingScreenState();
  }
}

class _TrackingScreenState extends State<TrackingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void generateTrip() {
    Trip trip =
        TripBuilder().move_r(Duration(minutes: 20), 2.kilo.meters).build();
    widget.trekko.saveTrip(trip);
  }

  void openTripModal() {
    // Trip trip =
    //     TripBuilder().move_r(Duration(minutes: 40), 2.kilo.meters).build();
    widget.trekko.getTripQuery().findFirst().then((trip) => {
          // widget.trekko.deleteTrip(
          //     widget.trekko.getTripQuery().idEqualTo(trip!.id).build())

          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => JournalEntryDetailView(Stream.value(trip!)
                  // widget.trekko
                  //     .getTripQuery()
                  //     .idEqualTo(trip!.id)
                  //     .watch(fireImmediately: true)
                  //     .map((event) => event.first),
                  )))
        });
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CupertinoPageScaffold(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            title: 'Generate new trip for modal',
            style: ButtonStyle.secondary,
            onPressed: () {
              generateTrip();
            },
          ),
          Button(
            title: 'Open Detail View',
            style: ButtonStyle.secondary,
            onPressed: () {
              openTripModal();
            },
          ),
          StreamBuilder(
              stream: super.widget.trekko.getTrackingState(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data! == TrackingState.running) {
                    return Button(
                      title: 'Stop',
                      style: ButtonStyle.primary,
                      onPressed: () {
                        super
                            .widget
                            .trekko
                            .setTrackingState(TrackingState.paused);
                      },
                    );
                  } else if (snapshot.data! == TrackingState.paused) {
                    return Button(
                      title: 'Start',
                      style: ButtonStyle.primary,
                      onPressed: () {
                        super
                            .widget
                            .trekko
                            .setTrackingState(TrackingState.running);
                      },
                    );
                  }
                }
                return CupertinoActivityIndicator();
              }),
        ],
      )),
    );
  }
}
