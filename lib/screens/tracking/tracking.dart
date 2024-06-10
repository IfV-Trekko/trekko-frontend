import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/stream_timer.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/screens/tracking/map_option_sheet.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TrackingScreenState();
  }
}

class _TrackingScreenState extends State<TrackingScreen>
    with AutomaticKeepAliveClientMixin {
  late StreamTimer<List<Trip>>? timer;
  Duration timeFrame = const Duration(days: 1);

  Stream<List<Trip>> _subscribe() {
    Trekko trekko = TrekkoProvider.of(context);
    DateTime start = DateTime.now().subtract(timeFrame);
    return trekko.getTripQuery().andTimeAbove(start).completeStream();
  }

  @override
  void initState() {
    timer = StreamTimer(_subscribe);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          Stack(
            children: [
              PositionCollectionMap(
                collections: timer!.schedule(const Duration(minutes: 5)),
                onlyZoomOnce: false,
              ),
              SafeArea(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CupertinoSlidingSegmentedControl(
                  backgroundColor: CupertinoColors.lightBackgroundGray,
                  thumbColor: CupertinoColors.white,
                  groupValue: timeFrame,
                  children: {
                    const Duration(days: 1): const Text("1 Tag"),
                    const Duration(days: 7): const Text("1 Woche"),
                    const Duration(days: 30): const Text("1 Monat"),
                  },
                  onValueChanged: (value) async {
                    setState(() {
                      timeFrame = value as Duration;
                    });
                    timer!.refresh();
                  },
                ),
                const SizedBox(width: 10),
              ])),
            ],
          ),
          MapOptionSheet(trekko: TrekkoProvider.of(context))
        ],
      ),
    );
  }
}
