import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/tracked_point.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';

class TripsMap extends StatefulWidget {
  final Stream<List<Trip>> trips;

  const TripsMap({required this.trips, Key? key}) : super(key: key);

  @override
  TripsMapState createState() => TripsMapState();
}

class TripsMapState extends State<TripsMap>
    with AutomaticKeepAliveClientMixin<TripsMap> {
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

    return StreamBuilder(
        stream: widget.trips,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading trips'));
          }

          return OSMFlutter(
              controller: controller,
              onMapIsReady: (bool ready) {
                if (!ready) return;
                _drawRoads(snapshot.data!);
              },
              osmOption: const OSMOption(
                  zoomOption: ZoomOption(
                initZoom: 12,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              )));
        });
  }

  _drawRoads(List<Trip> trips) {
    for (Trip trip in trips) {
      for (Leg leg in trip.legs) {
        controller.drawRoadManually(
            leg.trackedPoints.map(_toGeoPoint).toList(growable: false),
            RoadOption(
                roadWidth: 20,
                roadColor: TransportDesign.getColor(leg.transportType)));
      }
    }
    controller.zoomToBoundingBox(
        BoundingBox.fromGeoPoints(trips
            .expand((trip) =>
                trip.legs.expand((leg) => leg.trackedPoints.map(_toGeoPoint)))
            .toList()),
        paddinInPixel: 200);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
