import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/tracking_state.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/buttonSize.dart';
import 'package:app_frontend/components/constants/buttonStyle.dart';
import 'package:app_frontend/screens/journal/journalEntryDetailView/journalEntryDetailView.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

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
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            title: 'Open detail view',
            style: ButtonStyle.secondary,
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) =>
                      journalEntryDetailView(Stream.empty())));
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
