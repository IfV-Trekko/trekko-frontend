import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/journal/journalDetail/journalDetailBoxVehicle.dart';
import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'journalDetail/journalDetailBox.dart';
import 'package:intl/intl.dart';

import 'journalDetail/journalDetailBoxDonation.dart';

class JournalEntry extends StatelessWidget {
  final Trip trip;
  final bool selectionMode;
  final bool isSelected;
  final Function(Trip, bool)?
      onSelectionChanged; // Callback for selection change

  JournalEntry(this.trip, this.selectionMode,
      {this.onSelectionChanged, this.isSelected = false, Key? key})
      : super(key: key ?? ValueKey(trip.id));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectionMode) {
          if (onSelectionChanged != null) {
            onSelectionChanged!(trip, !isSelected);
          }
        } else {
          onPressed();
        }
      },
      child: Row(
        children: [
          if (selectionMode)
            ClipRect(
              //transform: Matrix4.translationValues(-16, 0, 0),
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CupertinoCheckbox(
                shape: const CircleBorder(),
                activeColor: AppThemeColors.blue,
                value: isSelected,
                onChanged: (value) {
                  if (onSelectionChanged != null) {
                    onSelectionChanged!(trip, !isSelected);
                  }
                },
              )),
            ),
          if (selectionMode) const SizedBox(width: 16.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppThemeColors.contrast0,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppThemeColors.contrast400,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InformationRow(trip),
                    VehicleLine(trip),
                    FooterRow(trip, selectionMode),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPressed() {}
}

class InformationRow extends StatelessWidget {
  final Trip trip;

  InformationRow(this.trip);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('HH:mm').format(trip.getStartTime()),
            style: AppThemeTextStyles.largeTitle.copyWith(letterSpacing: -1),
          ),
          Container(
            child: Row(
              children: [
                Text("${trip.getDuration().inMinutes} min"),
                const SizedBox(width: 4.0),
                Text(
                    "- ${trip.getDistance().as(kilo.meters).toStringAsFixed(1)} km"),
              ],
            ),
          ),
          Text(
            DateFormat('HH:mm').format(trip.getEndTime()),
            style: AppThemeTextStyles.largeTitle,
          ),
        ],
      ),
    );
  }
}

class VehicleLine extends StatelessWidget {
  final Trip trip;

  VehicleLine(this.trip);

  @override
  Widget build(BuildContext context) {
    return Container(); //TODO Linie implementieren
  }
}

class LabelRow extends StatelessWidget {
  final Trip trip;

  LabelRow(this.trip);

  @override
  Widget build(BuildContext context) {
    // Erstellen Sie ein Set aus den Fahrzeugtypen in der legs-Liste
    final uniqueVehicleTypes =
        trip.legs.map((leg) => leg.transportType).toSet();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 6.0, // Horizontal space between children
        runSpacing: 6.0, // Vertical space between lines
        children: [
          // Generate vehicle type boxes
          for (var vehicleType in uniqueVehicleTypes)
            Wrap(
              children: [
                JournalDetailBoxVehicle(vehicleType),
              ],
            ),
          // Add JournalDetailBox for purpose and donation
          if (trip.purpose!.isNotEmpty && trip.purpose != null)
            JournalDetailBox(trip.purpose.toString()),
          JournalDetailBoxDonation(trip.donationState),
          // Icon at the end
        ],
      ),
    );
  }
}

class FooterRow extends StatelessWidget {
  final Trip trip;
  final bool selectionMode;

  FooterRow(this.trip, this.selectionMode);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: LabelRow(trip),
        ),
        if (!selectionMode)
          Container(
            child: const Icon(
              CupertinoIcons.ellipsis,
              color: AppThemeColors.contrast500,
              size: 24,
            ),
          ),
        //TODO implement Popup Menu
      ],
    );
  }
}