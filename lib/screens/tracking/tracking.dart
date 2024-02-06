import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/main_map.dart';
import 'package:app_frontend/screens/tracking/map_option_sheet.dart';
import 'package:flutter/cupertino.dart';

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
          Transform.translate(
            offset: const Offset(0, 64),
            child: MapOptionSheet(
              trekko: widget.trekko,
            ),
          )
        ],
      ),
    );
  }
}
