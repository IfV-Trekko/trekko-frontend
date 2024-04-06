import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/trip_query.dart';
import 'package:trekko_frontend/components/maps/main_map.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/screens/tracking/map_option_sheet.dart';

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

    DateTime now = DateTime.now();
    DateTime start = now.subtract(const Duration(days: 1));
    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          PositionCollectionMap(
            collections: TripQuery(widget.trekko).andTimeBetween(start, now).stream(),
          ),
          MapOptionSheet(
            trekko: widget.trekko,
          )
        ],
      ),
    );
  }
}
