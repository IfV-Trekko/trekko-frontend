import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/tracking_state.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';

class MapOptionSheet extends StatefulWidget {
  final Trekko trekko;

  const MapOptionSheet({super.key, required this.trekko});

  @override
  State<MapOptionSheet> createState() => _MapOptionSheetState();
}

class _MapOptionSheetState extends State<MapOptionSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        snap: true,
        minChildSize: 0.19,
        maxChildSize: 0.4,
        initialChildSize: 0.19,
        builder: (context, scrollController) {
          return Container(
              decoration: const BoxDecoration(
                color: AppThemeColors.contrast100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                                                'Letzte Erhebung vor ${DateTime.now().difference(snapshot.data!.lastTimeTracked!).inDays} Tagen',
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
                                fillIcon: true,
                                title: 'Erhebung starten',
                                icon: HeroIcons.play,
                                style: ButtonStyle.primary,
                                onPressed: () async {
                                  if (!(await super
                                      .widget
                                      .trekko
                                      .setTrackingState(
                                          TrackingState.running))) {
                                    _dialogNeedLocationPermission();
                                  }
                                },
                              );
                            }
                          }
                          return const CupertinoActivityIndicator();
                        }),
                  ],
                ),
              ));
        });
  }

  void _dialogNeedLocationPermission() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Standortberechtigung fehlt'),
            content: const Text(
                'Um die Erhebung zu starten, benötigen wir Zugriff auf Ihren Standort. Bitte gehen Sie in die Einstellungen und ändern Sie den Standortzugriff zu "Immer Erlauben".'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
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
