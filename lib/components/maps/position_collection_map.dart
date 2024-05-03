import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/tracked_point.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';

class PositionCollectionMap extends StatefulWidget {
  static final GeoPoint karlsruhe =
      GeoPoint(latitude: 49.006889, longitude: 8.403653);

  final Stream<List<PositionCollection>> collections;
  final MapController Function()? controllerSupplier;
  final Function(GeoPoint)? onMarkerClick;
  final Function(Leg)? onRoadClick;
  final Function()? onMapReady;
  final bool onlyZoomOnce;

  const PositionCollectionMap(
      {required this.collections,
      this.controllerSupplier,
      this.onMarkerClick,
      this.onRoadClick,
      this.onMapReady,
      this.onlyZoomOnce = true,
      Key? key})
      : super(key: key);

  @override
  PositionCollectionMapState createState() => PositionCollectionMapState();
}

class PositionCollectionMapState extends State<PositionCollectionMap>
    with AutomaticKeepAliveClientMixin<PositionCollectionMap> {
  List<PositionCollection>? collections;
  late MapController controller;
  bool zoomedToBoundingBox = false;
  bool mapReady = false;

  GeoPoint _toGeoPoint(TrackedPoint trackedPoint) {
    return GeoPoint(
        latitude: trackedPoint.latitude, longitude: trackedPoint.longitude);
  }

  @override
  void initState() {
    controller = widget.controllerSupplier != null
        ? widget.controllerSupplier!()
        : MapController.withPosition(
            // karlsruhe location
            initPosition: PositionCollectionMap.karlsruhe);
    widget.collections.listen((event) {
      collections = event;
      if (!mapReady) return;
      _drawRoads(event);
    });
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
          widget.onMapReady?.call();
          if (collections != null) {
            _drawRoads(collections!);
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

  _drawRoads(List<PositionCollection> collections) async {
    controller.clearAllRoads();
    for (PositionCollection trip in collections) {
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
      if (zoomedToBoundingBox && widget.onlyZoomOnce) return;
      controller.zoomToBoundingBox(
          BoundingBox.fromGeoPoints(
            collections
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
