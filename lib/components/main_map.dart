import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MainMap extends StatefulWidget {
  //TODO bisher nur aus Prototypen übernommen
  MainMap({Key? key}) : super(key: key) {}

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap>
    with AutomaticKeepAliveClientMixin<MainMap> {
  MapController controller = MapController.withUserPosition(
      trackUserLocation:
          UserTrackingOption(enableTracking: true, unFollowUser: false));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    controller.init();

    OSMFlutter osm = OSMFlutter(
        controller: controller,
        osmOption: const OSMOption(
          zoomOption: ZoomOption(
            initZoom: 12,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
        ));
    return osm;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
