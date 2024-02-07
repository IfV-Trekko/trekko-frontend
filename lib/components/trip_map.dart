import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'constants/transportDesign.dart';

class TripMap extends StatefulWidget {
  final Trip trip;
  final MapController controller = MapController.withPosition(
      initPosition: // Karlsruhe
          GeoPoint(latitude: 49.013379, longitude: 8.404393));
  late List<GeoPoint> pathGeoPoints = [];
  late BoundingBox tripBoundingBox;

  TripMap({required this.trip, Key? key}) : super(key: key) {
    for (var leg in trip.legs) {
      pathGeoPoints.insert(
          pathGeoPoints.length,
          GeoPoint(
              latitude: leg.trackedPoints.first.latitude,
              longitude: leg.trackedPoints.first.longitude));
      pathGeoPoints.insert(
          pathGeoPoints.length,
          GeoPoint(
              latitude: leg.trackedPoints.last.latitude,
              longitude: leg.trackedPoints.last.longitude));
    }
    tripBoundingBox = BoundingBox.fromGeoPoints(pathGeoPoints);
  }

  @override
  _TripMapState createState() => _TripMapState();
}

class _TripMapState extends State<TripMap>
    with AutomaticKeepAliveClientMixin<TripMap> {
  @override
  void initState() {
    super.initState();
    widget.controller.zoomToBoundingBox(widget.tripBoundingBox);
    Future.delayed(const Duration(seconds: 5), () {
      for (var i = 0; i < widget.pathGeoPoints.length - 1; i += 2) {
        widget.controller
            .drawRoad(widget.pathGeoPoints[i], widget.pathGeoPoints[i + 1],
                roadType: switch (widget.trip.legs[i ~/ 2].transportType) {
                  TransportType.bicycle => RoadType.bike,
                  TransportType.by_foot => RoadType.foot,
                  _ => RoadType.foot,
                },
                roadOption: RoadOption(
                  roadWidth: 5,
                  roadColor: TransportDesign.getColor(
                      widget.trip.legs[i ~/ 2].transportType),
                  zoomInto: false,
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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

  @override
  bool get wantKeepAlive => true;
}
