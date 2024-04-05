import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/tracked_point.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/components/rounded_scrollable_sheet.dart';
import 'package:trekko_frontend/screens/journal/trip/detail/editable_position_details.dart';
import 'package:trekko_frontend/screens/journal/trip/leg_edit_bar.dart';
import 'package:trekko_frontend/screens/journal/trip/detail/position_detail_box.dart';

class LegEditView extends StatefulWidget {
  final Leg leg;
  final Function() onEditComplete;

  const LegEditView(
      {required this.leg, required this.onEditComplete, super.key});

  @override
  State<LegEditView> createState() => _LegEditViewState();
}

class _LegEditViewState extends State<LegEditView> {
  final Duration _timeStep = const Duration(minutes: 10);
  late StreamController<PositionCollection> _streamController;
  late MapController _mapController;
  late DateTime _currentDate;

  GeoPoint _toGeoPoint(TrackedPoint trackedPoint) {
    return GeoPoint(
        latitude: trackedPoint.latitude, longitude: trackedPoint.longitude);
  }

  @override
  void initState() {
    _currentDate = widget.leg.calculateEndTime().add(_timeStep);
    _streamController = StreamController<Leg>.broadcast();
    _mapController = MapController.withPosition(initPosition: PositionCollectionMap.karlsruhe);
    super.initState();
  }

  void _onMapReady() {
    _streamController.add(widget.leg);
    if (widget.leg.trackedPoints.isNotEmpty) {
      for (var point in widget.leg.trackedPoints) {
        _mapController.addMarker(_toGeoPoint(point));
      }
    }
  }

  void _onEditComplete() {
    widget.onEditComplete();
    Navigator.of(context).pop();
  }

  void _onEdit() {
    _streamController.add(widget.leg);
  }

  void _onPointAdded(TrackedPoint point) {
    _mapController.addMarker(_toGeoPoint(point));
    _modifyPoints((points) =>
        points.add(TrackedPoint.withData(49.0069, 8.4037, _currentDate)));
    _onEdit();
  }

  void _modifyPoints(Function(List<TrackedPoint>) modifier) {
    List<TrackedPoint> copy =
        List.from(widget.leg.trackedPoints, growable: true);
    modifier(copy);
    copy.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    widget.leg.trackedPoints = copy;
    _onEdit();
  }

  void _onMarkerClick(GeoPoint point) {
    for (var i = 0; i < widget.leg.trackedPoints.length; i++) {
      var trackedPoint = widget.leg.trackedPoints[i];
      if (trackedPoint.latitude == point.latitude &&
          trackedPoint.longitude == point.longitude) {
        _currentDate = widget.leg.trackedPoints[i].timestamp;
        _mapController.removeMarker(_toGeoPoint(trackedPoint));
        _modifyPoints((points) => points.removeAt(i));
        _onEdit();
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          PositionCollectionMap(
            collections: _streamController.stream.map((event) => [event]),
            onMarkerClick: _onMarkerClick,
            onMapReady: _onMapReady,
            controllerSupplier: () => _mapController,
          ),
          // Leg edit bar which is shown always right above the sheet
          RoundedScrollableSheet(
            title: "Details",
            initialChildSize: 0.2,
            child: Column(
              children: [
                PositionDetailBox(data: widget.leg),
                LegEditBar(
                    time: _currentDate,
                    onDateChanged: (DateTime newDate) {
                      _currentDate = newDate;
                    },
                    onAddPoint: _onPointAdded),
                Button(title: "Fertig", onPressed: _onEditComplete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
