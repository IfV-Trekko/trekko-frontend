import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/controller/utils/trip_builder.dart';
import 'package:app_backend/model/tracking_state.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';
import 'package:app_frontend/screens/tracking/tracking.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';

class MapOptionSheet extends StatefulWidget {
  final Trekko trekko;

  const MapOptionSheet({super.key, required this.trekko});
  @override
  State<MapOptionSheet> createState() => _MapOptionSheetState();
}

class _MapOptionSheetState extends State<MapOptionSheet> {
  void generateTrip() {
    Trip trip = TripBuilder()
        .move_r(const Duration(minutes: 20), 1.kilo.meters)
        .leg(type: TransportType.car)
        .move_r(const Duration(minutes: 20), 1.kilo.meters)
        .leg(type: TransportType.bicycle)
        .move_r(const Duration(minutes: 20), 1.kilo.meters)
        .leg(type: TransportType.by_foot)
        .build();
    widget.trekko.saveTrip(trip);
  }

  void openTripModal() {
    // Trip trip =
    //     TripBuilder().move_r(Duration(minutes: 40), 2.kilo.meters).build();
    widget.trekko.getTripQuery().findFirst().then((trip) => {
          // widget.trekko.deleteTrip(
          //     widget.trekko.getTripQuery().idEqualTo(trip!.id).build())

          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => JournalEntryDetailView(trip!)))
        });

    // });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        snap: true,
        minChildSize: 0.265,
        maxChildSize: 0.5,
        initialChildSize: 0.265,
        builder: (context, scrollController) {
          return Container(
              decoration: const BoxDecoration(
                color: AppThemeColors.contrast100,
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  children: <Widget>[
                    const PullTab(),
                    const SizedBox(height: 8),
                    Container(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        child: Text('Mobilitätsdaten',
                            style: AppThemeTextStyles.largeTitle
                                .copyWith(fontWeight: FontWeight.w700))),
                    StreamBuilder(
                        stream: super.widget.trekko.getTrackingState(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data! == TrackingState.running) {
                              return StreamBuilder(
                                  stream: widget.trekko.getProfile(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'Automatisch erfasst seit ${snapshot.data!.lastTimeTracked!.difference(DateTime.now()).inDays} Tagen',
                                            style: AppThemeTextStyles.normal),
                                      );
                                    }
                                    return Container(
                                        alignment: Alignment.centerLeft,
                                        child:
                                            const CupertinoActivityIndicator());
                                  });
                            } else if (snapshot.data! == TrackingState.paused) {
                              return StreamBuilder(
                                  stream: widget.trekko.getProfile(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        child: (snapshot
                                                    .data!.lastTimeTracked ==
                                                null)
                                            ? Text(
                                                'Noch keine Erhebung gestartet',
                                                style:
                                                    AppThemeTextStyles.normal,
                                              )
                                            : Text(
                                                'Letzte Erhebung vor ${snapshot.data!.lastTimeTracked!.difference(DateTime.now()).inDays} Tagen',
                                                style:
                                                    AppThemeTextStyles.normal),
                                      );
                                    }
                                    return Container(
                                        alignment: Alignment.centerLeft,
                                        child:
                                            const CupertinoActivityIndicator());
                                  });
                            }
                          }
                          return Container(
                              alignment: Alignment.centerLeft,
                              child: const CupertinoActivityIndicator());
                        }),
                    const SizedBox(height: 16),
                    StreamBuilder(
                        stream: super.widget.trekko.getTrackingState(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data! == TrackingState.running) {
                              return Button(
                                title: 'Stoppen',
                                icon: HeroIcons.pause,
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
                                title: 'Erhebung starten',
                                icon: HeroIcons.play, //TODO solid machen
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
                          return const CupertinoActivityIndicator();
                        }),
                    const SizedBox(height: 16),
                    Button(title: 'Generate Trip', onPressed: generateTrip),
                    const SizedBox(height: 16),
                    Button(title: 'Open detailView', onPressed: openTripModal),
                  ],
                ),
              ));
        });
  }
}

class PullTab extends StatelessWidget {
  const PullTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: CupertinoColors.inactiveGray,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
