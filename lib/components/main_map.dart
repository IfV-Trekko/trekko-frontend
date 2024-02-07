import 'package:app_frontend/trekko_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap>
    with AutomaticKeepAliveClientMixin<MainMap> {
  MapController controller = MapController.withUserPosition(
      trackUserLocation:
          const UserTrackingOption(enableTracking: true, unFollowUser: false));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _moveToUserLocation();
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

  Future<void> _moveToUserLocation() async {
    TrekkoProvider.of(context).getPosition().listen((event) {
      controller.changeLocation(
          GeoPoint(latitude: event.latitude, longitude: event.longitude));
      controller.goToLocation(
          GeoPoint(latitude: event.latitude, longitude: event.longitude));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
