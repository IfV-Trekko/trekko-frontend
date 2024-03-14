import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/tracked_point.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/components/constants/transport_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TripMap extends StatefulWidget {
  final Trip trip;

  const TripMap({required this.trip, Key? key}) : super(key: key);

  @override
  _TripMapState createState() => _TripMapState();
}

class _TripMapState extends State<TripMap>
    with AutomaticKeepAliveClientMixin<TripMap> {
  late MapController controller;

  GeoPoint _toGeoPoint(TrackedPoint trackedPoint) {
    return GeoPoint(
        latitude: trackedPoint.latitude, longitude: trackedPoint.longitude);
  }

  @override
  void initState() {
    controller = MapController.withPosition(
        initPosition: GeoPoint(latitude: 49.0069, longitude: 8.4037));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return OSMFlutter(
        controller: controller,
        onMapIsReady: (bool ready) {
          if (!ready) return;
          _drawRoads();
        },
        osmOption: const OSMOption(
            zoomOption: ZoomOption(
          initZoom: 12,
          minZoomLevel: 3,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        )));
  }

  _drawRoads() {
    for (Leg leg in widget.trip.legs) {
      controller.drawRoadManually(
          leg.trackedPoints.map(_toGeoPoint).toList(growable: false),
          RoadOption(
              roadWidth: 20,
              roadColor: TransportDesign.getColor(leg.transportType)));
    }
    controller.zoomToBoundingBox(
        BoundingBox.fromGeoPoints(widget.trip.legs
            .expand((element) => element.trackedPoints)
            .map(_toGeoPoint)
            .toList(growable: false)),
        paddinInPixel: 50);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
