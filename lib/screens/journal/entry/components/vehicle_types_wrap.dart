import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_frontend/screens/journal/entry/components/vehicle_box.dart';

class VehicleTypesWrap extends StatelessWidget {

  final PositionCollection data;
  final bool showText;

  const VehicleTypesWrap({required this.data, this.showText = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (var vehicleType in data.calculateTransportTypes())
          Wrap(
            children: [
              VehicleBox(vehicleType, showText: showText),
            ],
          ),
      ],
    );
  }
}
