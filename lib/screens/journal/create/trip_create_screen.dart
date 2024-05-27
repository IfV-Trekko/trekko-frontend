import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/model/position.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/tracked_point.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';
import 'package:trekko_frontend/components/picker/date_picker.dart';
import 'package:trekko_frontend/screens/journal/create/add_stop_screen.dart';

class TripCreateScreen extends StatefulWidget {
  const TripCreateScreen({super.key});

  @override
  State<TripCreateScreen> createState() => _TripCreateScreenState();
}

class _TripCreateScreenState extends State<TripCreateScreen> {
  final List<Position> _positions = [];
  final Map<int, TransportType> transportTypes = {};

  TransportType getType(int index) {
    return transportTypes[index] ?? TransportType.by_foot;
  }

  Widget buildWayIndicator(int index) {
    return Row(children: [
      const Column(children: [
        SizedBox(height: 10),
        Icon(Icons.fiber_manual_record, color: Colors.grey, size: 18),
        SizedBox(height: 5),
        Icon(Icons.fiber_manual_record, color: Colors.grey, size: 18),
        SizedBox(height: 5),
        Icon(Icons.fiber_manual_record, color: Colors.grey, size: 18),
        SizedBox(height: 10),
      ]),
      HeroIcon(TransportDesign.getIcon(getType(index)), size: 30)
    ]);
  }

  Widget buildPosBox(Position position, int i) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppThemeColors.blue)),
      child: GestureDetector(
        onTap: () async {
          Position? pos = await showCupertinoDialog(
              context: context,
              builder: (context) => AddStopScreen(initialPosition: position));
          if (pos == null) return;
          setState(() {
            _positions[i] = pos;
          });
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(CupertinoIcons.location_solid, size: 30),
          FutureBuilder(
              future: placemarkFromCoordinates(
                  position.latitude, position.longitude),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                      width: 100,
                      child: Text(snapshot.data!.first.street!,
                          overflow: TextOverflow.clip));
                }
                return const CupertinoActivityIndicator();
              }),
          const SizedBox(width: 5),
          const HeroIcon(HeroIcons.clock, size: 30),
          const SizedBox(width: 5),
          Column(children: [
            Text(DatePicker.DAY.format(position.timestamp)),
            Text(DatePicker.HOUR.format(position.timestamp)),
          ])
        ]),
      ),
    );
  }

  Widget buildLatestRow() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppThemeColors.blue)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              Position? pos = await showCupertinoDialog(
                  context: context,
                  builder: (context) => AddStopScreen(
                      initialPosition:
                          _positions.isNotEmpty ? _positions.last : null));
              if (pos != null) {
                setState(() {
                  _positions.add(pos);
                });
              }
            },
            child: const Icon(CupertinoIcons.plus, size: 30),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CustomScrollView(slivers: [
      const CupertinoSliverNavigationBar(
        largeTitle: Text('Neuer Weg'),
      ),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < _positions.length; i++) ... [
                    if (i != 0) buildWayIndicator(i - 1),
                      buildPosBox(_positions[i], i),
                  ],
                  const SizedBox(height: 20),
                  buildLatestRow(),
                  const SizedBox(height: 20),
                  if (_positions.length >= 2)
                    Button(
                        title: "Fertig",
                        stretch: true,
                        onPressed: () {
                          List<Leg> legs = [];
                          for (int i = 0; i < _positions.length - 1; i++) {
                            TransportType type = getType(i);
                            TrackedPoint start =
                                TrackedPoint.fromPosition(_positions[i]);
                            TrackedPoint end =
                                TrackedPoint.fromPosition(_positions[i + 1]);

                            legs.add(Leg.withData(type, [start, end]));
                          }
                          Navigator.of(context).pop(Trip.withData(legs));
                        })
                ],
              )))
    ]));
  }
}
