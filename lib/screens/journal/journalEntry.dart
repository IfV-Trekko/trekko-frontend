import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/journal/journalDetail/journalDetailBoxVehicle.dart';
import 'package:flutter/cupertino.dart';
import 'journalDetail/journalDetailBoxDonation.dart';

class JournalEntry extends StatelessWidget {
  final Stream<Trip> trip;

  JournalEntry(this.trip);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Trip>(
      stream: trip,
      builder: (BuildContext context, AsyncSnapshot<Trip> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator(
              radius: 20, color: AppThemeColors.contrast500);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return GestureDetector(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppThemeColors.contrast0,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: AppThemeColors.contrast500,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      InformationRow(snapshot.data!),
                      VehicleLine(snapshot.data!),
                      LabelRow(snapshot.data!),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
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
        Text(trip.startTime.toString()),
        Text(""), //TODO Dauer und Distanz berechnen
        Text(trip.endTime.toString()),
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
      //TODO Label implementieren
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            child: JournalDetailBoxDonation(trip.donationState)
        ),
        Container(child: Icon(CupertinoIcons.ellipsis)),
      ],
    );
  }
}
