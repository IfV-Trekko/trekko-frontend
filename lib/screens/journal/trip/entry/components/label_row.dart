import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/trip/donation_state.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/screens/journal/trip/entry/components/donation_box.dart';
import 'package:trekko_frontend/screens/journal/trip/entry/components/purpose_box.dart';
import 'package:trekko_frontend/screens/journal/trip/entry/components/vehicle_box.dart';

class LabelRow extends StatelessWidget {
  final PositionCollection data;

  const LabelRow({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    var uniqueVehicleTypes = data.calculateTransportTypes();
    var purpose = data is Trip ? (data as Trip).purpose : null;
    var donationState =
        data is Trip ? (data as Trip).donationState : DonationState.undefined;

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 6.0,
        runSpacing: 6.0,
        children: [
          for (var vehicleType in uniqueVehicleTypes)
            Wrap(
              children: [
                VehicleBox(vehicleType, showText: true),
              ],
            ),
          if (purpose != null && purpose.isNotEmpty)
            PurposeBox(purpose.toString()),
          DonationBox(donationState),
        ],
      ),
    );
  }
}
