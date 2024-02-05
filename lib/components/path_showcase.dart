import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:flutter/cupertino.dart';

class PathShowcase extends StatelessWidget {
  //TODO testen!
  final Trip trip;
  late final double distance;

  PathShowcase({required this.trip, Key? key}) : super(key: key) {
    distance = trip.calculateDistance().defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableSpace = constraints.maxWidth;

        return Row(
          children: [
            for (var leg in trip.legs)
              Container(
                  height: 4,
                  width: leg.getDistance().defaultValue /
                      distance *
                      availableSpace,
                  color: TransportDesign.getColor(leg.transportType)),
          ],
        );
      },
    );
  }
}
