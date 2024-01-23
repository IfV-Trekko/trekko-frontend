import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/journal/journalDetail/journalDetailBoxVehicle.dart';
import 'package:flutter/cupertino.dart';
import 'journalDetail/journalDetailBoxDonation.dart';
import 'package:intl/intl.dart';

class JournalEntry extends StatelessWidget {
  final Trip trip;

  JournalEntry(this.trip);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        child: Container(
          width: double.infinity,
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
                LabelRow(trip),
              ],
            ),
          ),
        ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('HH:mm').format(trip.getStartTime()),
          style: AppThemeTextStyles.largeTitle,
        ),
        Text(""), //TODO Dauer und Distanz berechnen
        Text(
          DateFormat('HH:mm').format(trip.getEndTime()),
          style: AppThemeTextStyles.largeTitle,
        ),
      ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            JournalDetailBoxVehicle(trip.legs[0].transportType), //TODO Label implementieren
            const SizedBox(width: 6.0),
            JournalDetailBoxDonation(trip.donationState),
          ],
        ),
        Container(
            child: const Icon(CupertinoIcons.ellipsis,
                color: AppThemeColors.contrast500)),
        //TODO implement Popup Menu
      ],
    );
  }
}
