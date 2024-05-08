import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
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
  late Timer timer;
  late StreamController<List<PositionCollection>> refreshController;
  Duration timeFrame = const Duration(days: 1);
  List<PositionCollection> collections = [];
  StreamSubscription? subscription;

  bool _compareCollections(
      List<PositionCollection> data1, List<PositionCollection> data2) {
    if (data1.length != data2.length) {
      return false;
    }

    for (int i = 0; i < data1.length; i++) {
      if (!data1[i].deepEquals(data2[i])) {
        return false;
      }
    }

    return true;
  }

  void _onStreamData(List<PositionCollection> data) {
    // Check if the data has been modified compared to last time
    if (_compareCollections(collections, data)) {
      return;
    }

    collections = data;
    refreshController.add(collections);
  }

  void _subscribe(Trekko trekko) {
    if (subscription != null) {
      subscription!.cancel();
    }

    DateTime start = DateTime.now().subtract(timeFrame);
    subscription = trekko
        .getTripQuery()
        .andTimeAbove(start)
        .completeStream()
        .listen(_onStreamData);
  }

  // Set timer on initState which will refresh the map
  @override
  void initState() {
    refreshController = StreamController();
    refreshController.onListen = () {
      refreshController.add(collections);
    };
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Trekko trekko = TrekkoProvider.of(context);
    _subscribe(trekko);
    timer = Timer.periodic(
        const Duration(minutes: 5), (timer) => _subscribe(trekko));
    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          Stack(
            children: [
              PositionCollectionMap(
                collections: refreshController.stream,
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
                    _subscribe(trekko);
                  },
                ),
              ])),
            ],
          ),
          MapOptionSheet(trekko: trekko)
        ],
      ),
    );
  }
}
