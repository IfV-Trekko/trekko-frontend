import 'package:app_frontend/trekko_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MainMap extends StatefulWidget {
  final MapController controller = MapController.withUserPosition(
      trackUserLocation:
          const UserTrackingOption(enableTracking: true, unFollowUser: false));

  MainMap({Key? key}) : super(key: key);

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap>
    with AutomaticKeepAliveClientMixin<MainMap> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    _moveToUserLocation();
    OSMFlutter osm = OSMFlutter(
        controller: widget.controller,
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
    widget.controller.dispose();
    super.dispose();
  }

  Future<void> _moveToUserLocation() async {
    TrekkoProvider.of(context).getPosition().listen((event) {
      widget.controller.changeLocation(
          GeoPoint(latitude: event.latitude, longitude: event.longitude));
      widget.controller.goToLocation(
          GeoPoint(latitude: event.latitude, longitude: event.longitude));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
