import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TripMap extends StatefulWidget {
  final List<GeoPoint> pathGeoPoints;
  late BoundingBox tripBoundingBox;
  //TODO bisher nur aus Prototypen übernommen
  TripMap({required this.pathGeoPoints, Key? key}) : super(key: key) {
    tripBoundingBox = BoundingBox.fromGeoPoints(pathGeoPoints);
  }

  @override
  _TripMapState createState() => _TripMapState();
}

class _TripMapState extends State<TripMap>
    with AutomaticKeepAliveClientMixin<TripMap> {
  MapController controller = MapController.withPosition(
      initPosition: // Karlsruhe
          GeoPoint(latitude: 49.013379, longitude: 8.404393));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    controller.init();
    controller.zoomToBoundingBox(widget.tripBoundingBox);
    controller.listenerMapLongTapping.addListener(() {
      //TODO check nicht was da passiert
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
    Future.delayed(const Duration(seconds: 5), () {
      for (var i = 0; i < widget.pathGeoPoints.length - 2; i++) {
        controller.drawRoad(
            widget.pathGeoPoints[i], widget.pathGeoPoints[i + 1],
            roadType: RoadType.foot,
            roadOption: const RoadOption(
              roadWidth: 5,
              roadColor: CupertinoColors.systemBlue,
              zoomInto: true,
            ));
        //TODO sollte funktionieren, brauche nur ein Testobjekt
        //TODO wird erst bei Save ausgeführt warum?
      }
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
