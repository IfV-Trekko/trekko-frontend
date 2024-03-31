import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_frontend/components/maps/main_map.dart';
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

    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          const MainMap(),
          MapOptionSheet(
            trekko: widget.trekko,
          )
        ],
      ),
    );
  }
}
