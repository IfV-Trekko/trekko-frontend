import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class JournalEntry extends StatelessWidget {
  final Stream<Trip> trip;

  JournalEntry(this.trip);

  @override
  Widget build(BuildContext context) {
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
                TripRow(trip),
                VehicleRow(trip),
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

//TODO: CupertinoActivityIndicator durch festen text ersetzen?
class TripRow extends StatelessWidget {
  final Stream<Trip> trip;

  TripRow(this.trip);

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
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(snapshot.data!.startTime.toString()),
                Text(""), //TODO Dauer und Distanz berechnen
                Text(snapshot.data!.endTime.toString()),
              ]);
        }
      },
    );
  }
}

class VehicleRow extends StatelessWidget {
  final Stream<Trip> trip;

  VehicleRow(this.trip);

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
          return Container(); //TODO Linie implementieren
        }
      },
    );
  }
}

class LabelRow extends StatelessWidget {
  final Stream<Trip> trip;

  LabelRow(this.trip);

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
          return Row( //TODO Label implementieren
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Container(),
            ],
          );
        }
      },
    );
  }
}