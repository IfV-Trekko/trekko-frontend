import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/tracking_state.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_style.dart';
import 'package:trekko_frontend/components/pull_tab.dart';
import 'package:trekko_frontend/components/rounded_scrollable_sheet.dart';

class MapOptionSheet extends StatefulWidget {
  final Trekko trekko;

  const MapOptionSheet({super.key, required this.trekko});

  @override
  State<MapOptionSheet> createState() => _MapOptionSheetState();
}

class _MapOptionSheetState extends State<MapOptionSheet> {
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

  String _getTrackingText(TrackingState state, DateTime? lastTimeTracked) {
    if (state == TrackingState.running && lastTimeTracked != null) {
      return 'Automatisch erfasst seit ${DateTime.now().difference(lastTimeTracked).inDays} Tagen';
    } else if (state == TrackingState.paused && lastTimeTracked != null) {
      return 'Letzte Erhebung vor ${DateTime.now().difference(lastTimeTracked).inDays} Tagen';
    }
    return 'Noch keine Erhebung gestartet';
  }

  @override
  Widget build(BuildContext context) {
    return RoundedScrollableSheet(
      title: "Mobilitätsdaten",
      initialChildSize: 0.23,
        child: Column(children: [
      StreamBuilder(
          stream: super.widget.trekko.getTrackingState(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TrackingState state = snapshot.data!;
              return StreamBuilder(
                  stream: widget.trekko.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            _getTrackingText(
                                state, snapshot.data!.lastTimeTracked),
                            style: AppThemeTextStyles.normal),
                      );
                    }
                    return Container(
                        alignment: Alignment.centerLeft,
                        child: const CupertinoActivityIndicator());
                  });
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
                    super.widget.trekko.setTrackingState(TrackingState.paused);
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
                        .setTrackingState(TrackingState.running))) {
                      _dialogNeedLocationPermission();
                    }
                  },
                );
              }
            }
            return const CupertinoActivityIndicator();
          })
    ]));
  }
}
