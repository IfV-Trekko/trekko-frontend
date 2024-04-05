import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/trip/donation_state.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/screens/journal/entry/components/donation_box.dart';
import 'package:trekko_frontend/screens/journal/entry/components/purpose_box.dart';
import 'package:trekko_frontend/screens/journal/entry/components/vehicle_box.dart';
import 'package:trekko_frontend/screens/journal/entry/components/vehicle_types_wrap.dart';

class LabelRow extends StatelessWidget {
  final PositionCollection data;

  const LabelRow({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
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
          VehicleTypesWrap(data: data),
          if (purpose != null && purpose.isNotEmpty)
            PurposeBox(purpose.toString()),
          DonationBox(donationState),
        ],
      ),
    );
  }
}
