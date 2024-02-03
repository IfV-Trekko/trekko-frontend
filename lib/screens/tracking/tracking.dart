import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/controller/utils/trip_builder.dart';
import 'package:app_backend/model/tracking_state.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/components/main_map.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          MainMap(),
          SafeArea(
            //TODO nur eine Idee
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: Idea(),
              ),
            ),
          ),
          MapOptionSheet(
            trekko: widget.trekko,
          )
        ],
      ),
    );
  }
}

class MapOptionSheet extends StatefulWidget {
  final Trekko trekko;

  const MapOptionSheet({super.key, required this.trekko});
  @override
  State<MapOptionSheet> createState() => _MapOptionSheetState();
}

class _MapOptionSheetState extends State<MapOptionSheet> {
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
              builder: (context) => JournalEntryDetailView(trip!)))
        });

    // });
  }

  @override
  Widget build(BuildContext context) {
    //TODO eventutell auslagern
    return DraggableScrollableSheet(
        minChildSize: 0.265,
        maxChildSize: 0.5,
        initialChildSize: 0.265,
        builder: (context, scrollController) {
          return Container(
              decoration: BoxDecoration(
                color: AppThemeColors.contrast100,
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: <Widget>[
                    PullTab(),
                    SizedBox(height: 8),
                    Container(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        child: Text('Mobilitätsdaten',
                            style: AppThemeTextStyles.largeTitle
                                .copyWith(fontWeight: FontWeight.w700))),
                    StreamBuilder(
                        stream: super
                            .widget
                            .trekko
                            .getTrackingState(), //TODO funktioniert nicht?
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data! == TrackingState.running) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Automatisch erfasst seit 2 Tagen', //TODO dynamisch machen
                                    // 'Automatisch erfasst seit ${super.widget.trekko} Tagen',
                                    style: AppThemeTextStyles.normal),
                              );
                            } else if (snapshot.data! == TrackingState.paused) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Letzte Erhebung vor 5 Tagen',
                                    // 'Letzte Erhebung vor ${super.widget.trekko} Tagen',
                                    style: AppThemeTextStyles.normal),
                              );
                            }
                          }
                          return Container(
                              alignment: Alignment.centerLeft,
                              child: CupertinoActivityIndicator());
                        }),
                    SizedBox(height: 16),
                    StreamBuilder(
                        stream: super
                            .widget
                            .trekko
                            .getTrackingState(), //TODO funktioniert nicht?
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
                          return CupertinoActivityIndicator();
                        }),
                    SizedBox(height: 16),
                    Idea(),
                    SizedBox(height: 16),
                    Button(title: 'Generate Trip', onPressed: generateTrip),
                    SizedBox(height: 16),
                    Button(title: 'Open detailView', onPressed: openTripModal),
                  ],
                ),
              ));
        });
  }
}

class Idea extends StatefulWidget {
  const Idea({super.key});

  @override
  State<Idea> createState() => _IdeaState();
}

class _IdeaState extends State<Idea> {
  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      groupValue: 0,
      onValueChanged: (value) {
        print(value);
      },
      children: Map.from({
        0: Text('Selten'),
        1: Text('Oft'),
        2: Text('Sehr oft'),
      }),
    );
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
