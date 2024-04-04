import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';

class PathShowcase extends StatelessWidget {
  final PositionCollection data;
  late final double distance;

  PathShowcase({required this.data, Key? key}) : super(key: key) {
    distance = data.calculateDistance().defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableSpace = constraints.maxWidth;

        return Row(
          children: [
            if (data is Trip)
            for (var leg in (data as Trip).legs)
              Container(
                  height: 4,
                  width: leg.calculateDistance().defaultValue /
                      distance *
                      availableSpace,
                  color: TransportDesign.getColor(leg.transportType)),
            if (data is Leg)
              Container(
                  height: 4,
                  width: availableSpace,
                  color: TransportDesign.getColor((data as Leg).transportType)),
          ],
        );
      },
    );
  }
}
