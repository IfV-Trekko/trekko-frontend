import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/tracked_point.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/components/pop_up_utils.dart';
import 'package:trekko_frontend/components/rounded_scrollable_sheet.dart';
import 'package:trekko_frontend/screens/journal/trip/detail/editable_vehicle_type_box.dart';
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
  final Duration _timeStep = const Duration(minutes: 5);
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
    _mapController = MapController.withPosition(
        initPosition: PositionCollectionMap.karlsruhe);
    super.initState();
  }

  bool _checkPointExists(GeoPoint point) {
    return widget.leg.trackedPoints.any((element) =>
        element.latitude == point.latitude &&
        element.longitude == point.longitude);
  }

  bool _checkDateExists() {
    return widget.leg.trackedPoints.any((element) =>
        element.timestamp.difference(_currentDate).abs().inMilliseconds < 1000);
  }

  void _changeDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
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

  void _onPointAdded() async {
    var point = await _mapController.centerMap;
    if (_checkPointExists(point)) {
      PopUpUtils.showPopUp(context, "Fehler", "Punkt existiert bereits");
      return;
    }

    if (_checkDateExists()) {
      PopUpUtils.showPopUp(context, "Fehler", "Zeitpunkt existiert bereits");
      return;
    }

    _mapController.addMarker(point);
    _modifyPoints((points) => points.add(
        TrackedPoint.withData(point.latitude, point.longitude, _currentDate)));
    _changeDate(_currentDate.add(_timeStep));
    _onEdit();
  }

  void _modifyPoints(Function(List<TrackedPoint>) modifier) {
    List<TrackedPoint> copy =
        List.from(widget.leg.trackedPoints, growable: true);
    modifier(copy);
    copy.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    setState(() {
      widget.leg.trackedPoints = copy;
    });
    _onEdit();
  }

  void _onMarkerClick(GeoPoint point) {
    for (var i = 0; i < widget.leg.trackedPoints.length; i++) {
      var trackedPoint = widget.leg.trackedPoints[i];
      if (trackedPoint.latitude == point.latitude &&
          trackedPoint.longitude == point.longitude) {
        if (widget.leg.trackedPoints.length <= 2) {
          PopUpUtils.showPopUp(context, "Fehler",
              "Es müssen immer mindestens zwei Punkte existieren");
          return;
        }

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
          Stack(
            children: [
              PositionCollectionMap(
                collections: _streamController.stream.map((event) => [event]),
                onMarkerClick: _onMarkerClick,
                onMapReady: _onMapReady,
                controllerSupplier: () => _mapController,
              ),
              // A cross in the middle of the map to indicate the center
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 46,
                left: MediaQuery.of(context).size.width / 2 - 20,
                // The indicator is an icon
                child: const Center(
                  child: HeroIcon(
                    HeroIcons.mapPin,
                    style: HeroIconStyle.solid,
                    size: 30,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          RoundedScrollableSheet(
            title: "Details",
            initialChildSize: 0.2,
            child: Column(
              children: [
                LegEditBar(
                    time: _currentDate,
                    onDateChanged: (DateTime newDate) {
                      _changeDate(DateTime(newDate.year, newDate.month,
                          newDate.day, _currentDate.hour, _currentDate.minute));
                    },
                    onTimeChanged: (DateTime newTime) {
                      _changeDate(DateTime(
                          _currentDate.year,
                          _currentDate.month,
                          _currentDate.day,
                          newTime.hour,
                          newTime.minute));
                    },
                    onAddPoint: _onPointAdded),
                PositionDetailBox(data: widget.leg),
                CupertinoListSection.insetGrouped(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    EditableVehicleTypeBox(
                      type: widget.leg.transportType,
                      onSavedVehicle: (value) {
                        setState(() {
                          widget.leg.transportType = value;
                        });
                      },
                    ),
                  ],
                ),
                Button(title: "Speichern", onPressed: _onEditComplete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
