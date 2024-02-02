import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TripMap extends StatefulWidget {
  //TODO bisher nur aus Prototypen übernommen
  const TripMap({Key? key}) : super(key: key);

  @override
  _TripMapState createState() => _TripMapState();
}

class _TripMapState extends State<TripMap>
    with AutomaticKeepAliveClientMixin<TripMap> {
  MapController controller = MapController.withPosition(
      initPosition: // Karlsruhe
          GeoPoint(latitude: 48.981847914665394, longitude: 8.404279436383945));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    controller.init();
    controller.listenerMapLongTapping.addListener(() {
      if (controller.listenerMapLongTapping.value != null) {
        GeoPoint point = controller.listenerMapLongTapping.value!;
        print(point);
      }
    });

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
    Future.delayed(Duration(seconds: 5), () {
      controller.drawRoad(
        GeoPoint(latitude: 49.00956, longitude: 8.41526),
        GeoPoint(latitude: 48.99333, longitude: 8.38521),
        roadType: RoadType.foot,
        roadOption: const RoadOption(
          roadWidth: 10,
          roadColor: CupertinoColors.systemBlue,
          zoomInto: true,
        ),
      );
    });
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
