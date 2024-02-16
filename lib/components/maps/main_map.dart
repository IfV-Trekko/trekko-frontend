import 'package:app_frontend/trekko_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap>
    with AutomaticKeepAliveClientMixin<MainMap> {
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController.withPosition(
        initPosition: GeoPoint(latitude: 49.0069, longitude: 8.4037));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return OSMFlutter(
        controller: controller,
        onMapIsReady: (bool ready) {
          _moveToUserLocation();
        },
        osmOption: OSMOption(
          markerOption: MarkerOption(
              defaultMarker: const MarkerIcon(
                  icon: Icon(
            CupertinoIcons.location_solid,
          ))),
          zoomOption: const ZoomOption(
            initZoom: 16,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _moveToUserLocation() {
    TrekkoProvider.of(context).getPosition().listen((event) {
      controller.changeLocation(
          GeoPoint(latitude: event.latitude, longitude: event.longitude));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
