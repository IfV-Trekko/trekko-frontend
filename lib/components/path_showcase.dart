import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

import '../screens/journal/journalDetail/transportDesign.dart';

class PathShowcase extends StatelessWidget {
  //TODO testen!
  final Trip trip;
  late final double distance;

  PathShowcase({required this.trip, Key? key}) : super(key: key) {
    distance = trip.getDistance().defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // This is the available width for the Expanded widget
        final double availableSpace = constraints.maxWidth;

        return Row(
          children: [
            for (var leg in trip.legs)
              Container(
                height: 4,
                width:
                    leg.getDistance().defaultValue / distance * availableSpace,
                color: TransportDesign.getColor(leg.transportType),
              ),
          ],
        );
      },
    );
  }
}
