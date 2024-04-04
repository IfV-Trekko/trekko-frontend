import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/tracked_point.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/components/maps/position_collection_map_controller.dart';
import 'package:trekko_frontend/components/rounded_scrollable_sheet.dart';
import 'package:trekko_frontend/screens/journal/trip/leg_edit_bar.dart';

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
  late PositionCollectionMapController _mapController;
  late DateTime currentDate;

  @override
  void initState() {
    currentDate = widget.leg.calculateEndTime().add(_timeStep);
    _streamController = StreamController<Leg>.broadcast();
    _streamController.onListen = () {
      _streamController.add(widget.leg);
    };
    _mapController = PositionCollectionMapController();
    super.initState();
  }

  void _onEditComplete() {
    widget.onEditComplete();
    Navigator.of(context).pop();
  }

  void _onEdit() {
    _streamController.add(widget.leg);
  }

  void _onPointAdded(TrackedPoint point) {
    _mapController.addPoint(point);
    _modifyPoints((points) =>
        points.add(TrackedPoint.withData(49.0069, 8.4037, currentDate)));
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
        currentDate = widget.leg.trackedPoints[i].timestamp;
        _mapController.removePoint(trackedPoint);
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
            controller: _mapController,
          ),
          // Leg edit bar which is shown always right above the sheet
          RoundedScrollableSheet(
            title: "Optionen",
            initialChildSize: 0.15,
            child: Column(
              children: [
                LegEditBar(
                    time: currentDate,
                    onDateChanged: (DateTime newDate) {
                      currentDate = newDate;
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
