import 'dart:math';

import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/tracked_point.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/components/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

import '../../app_theme.dart';
import 'journal_entry.dart';

class Journal extends StatefulWidget {
  final Trekko trekko;

  const Journal({super.key, required this.trekko});

  @override
  State<StatefulWidget> createState() {
    return _JournalState();
  }
}

class _JournalState extends State<Journal> {
  Leg generateLeg() {
    List<TrackedPoint> trackedPoints = [];
    for (int i = 0; i < 10; i++) {
      double latitude = Random().nextDouble() * 180 - 90;
      double longitude = Random().nextDouble() * 360 - 180;
      double speedInKmh = Random().nextDouble() * 100;
      DateTime timestamp = DateTime.now().add(Duration(minutes: i));
      trackedPoints.add(
          TrackedPoint.withData(latitude, longitude, speedInKmh, timestamp));
    }
    return Leg.withData(
        TransportType.values[Random().nextInt(TransportType.values.length)],
        trackedPoints);
  }

  Trip generateTrip() {
    List<Leg> legs = [];
    for (int i = 0; i < 3; i++) {
      legs.add(generateLeg());
    }

    return Trip(
        donationState:
            DonationState.values[Random().nextInt(DonationState.values.length)],
        comment: '',
        purpose: '',
        legs: legs);
  }

  @override
  Widget build(BuildContext context) {
    final Widget addTripDebugButton = Button(
      title: "Debug",
      stretch: false,
      onPressed: () async {
        await widget.trekko.saveTrip(generateTrip());
      },
    );

    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast100,
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: const Text('Tagebuch'),
          trailing: addTripDebugButton,
        ),
        SliverFillRemaining(
          child: StreamBuilder<List<Trip>>(
            stream: widget.trekko
                .getTripQuery()
                .build()
                .watch(fireImmediately: true),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CupertinoActivityIndicator(
                        radius: 20, color: AppThemeColors.contrast500));
              } else {
                final trips = snapshot.data ?? [];
                if (trips.isEmpty) {
                  return Center(
                      child: Text(
                    'Noch keine Wege verfügbar',
                    style: AppThemeTextStyles.title,
                  ));
                } else {
                  return ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return JournalEntry(trip);
                    },
                  );
                }
              }
            },
          ),
        ),
      ]),
    );
  }
}
