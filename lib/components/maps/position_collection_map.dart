import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:isar/isar.dart';
import 'package:trekko_backend/model/position.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/tracked_point.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';
import 'package:trekko_frontend/components/maps/position_collection_map_controller.dart';

class PositionCollectionMap extends StatefulWidget {
  final Stream<List<PositionCollection>> collections;
  final PositionCollectionMapController? controller;
  final Function(Leg)? onRoadClick;
  final Function(GeoPoint)? onMarkerClick;

  const PositionCollectionMap(
      {required this.collections,
      this.controller,
      this.onMarkerClick,
      this.onRoadClick,
      Key? key})
      : super(key: key);

  @override
  PositionCollectionMapState createState() => PositionCollectionMapState();
}

class PositionCollectionMapState extends State<PositionCollectionMap>
    with AutomaticKeepAliveClientMixin<PositionCollectionMap> {
  late MapController controller;
  List<PositionCollection>? collections;
  List<GeoPoint> markers = [];
  bool zoomedToBoundingBox = false;
  bool mapReady = false;

  GeoPoint _toGeoPoint(TrackedPoint trackedPoint) {
    return GeoPoint(
        latitude: trackedPoint.latitude, longitude: trackedPoint.longitude);
  }

  _addPosition(TrackedPoint position) {
    markers.add(_toGeoPoint(position));
    controller.addMarker(_toGeoPoint(position));
  }

  _removePosition(TrackedPoint position) {
    markers.remove(_toGeoPoint(position));
    controller.removeMarker(_toGeoPoint(position));
  }

  @override
  void initState() {
    controller = MapController.withPosition(
        initPosition: GeoPoint(latitude: 49.0069, longitude: 8.4037));
    widget.collections.listen((event) {
      collections = event;
      if (mapReady) {
        _drawRoads();
        _drawMarkers();
      }
    });
    if (widget.controller != null) {
      widget.controller!.onPointAdded = _addPosition;
      widget.controller!.onPointRemoved = _removePosition;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return OSMFlutter(
        controller: controller,
        onMapIsReady: (bool ready) {
          if (!ready) return;
          mapReady = true;
          if (collections != null) {
            _drawRoads();
            _drawMarkers();
          }
        },
        onGeoPointClicked: (geoPoint) {
          widget.onMarkerClick?.call(geoPoint);
        },
        mapIsLoading: const Center(
          child: CupertinoActivityIndicator(),
        ),
        osmOption: const OSMOption(
          zoomOption: ZoomOption(
            initZoom: 12,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
        ));
  }

  _drawMarkers() {
    if (widget.onMarkerClick == null) return;
    for (PositionCollection trip in collections!) {
      for (Leg leg in trip.getLegs()) {
        List<GeoPoint> points = leg.trackedPoints.map(_toGeoPoint).toList();
        for (GeoPoint point in points) {
          controller.addMarker(point);
        }
      }
    }
  }

  _drawRoads() async {
    controller.clearAllRoads();
    for (PositionCollection trip in collections!) {
      for (Leg leg in trip.getLegs()) {
        String key = await controller.drawRoadManually(
            leg.trackedPoints.map(_toGeoPoint).toList(growable: false),
            RoadOption(
              zoomInto: false,
                roadWidth: 20,
                roadColor: TransportDesign.getColor(leg.transportType)));
        controller.listenerRoadTapped.addListener(() {
          RoadInfo? info = controller.listenerRoadTapped.value;
          if (info == null) return;
          if (info.key == key) {
            widget.onRoadClick?.call(leg);
          }
        });
      }
      if (zoomedToBoundingBox) return;
      controller.zoomToBoundingBox(
          BoundingBox.fromGeoPoints(
            collections!
                .expand((element) => element.getLegs())
                .expand((element) => element.trackedPoints)
                .map(_toGeoPoint)
                .toList(),
          ),
          paddinInPixel: 200);
      zoomedToBoundingBox = true;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
