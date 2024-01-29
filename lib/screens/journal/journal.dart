import 'dart:math';

import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/tracked_point.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/screens/journal/donationModal/vonDavid.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:isar/isar.dart';
import '../../app_theme.dart';
import 'journal_entry.dart';

class Journal extends StatefulWidget {
  final Trekko trekko;

  Journal({super.key, required this.trekko});

  @override
  State<StatefulWidget> createState() {
    return _JournalState();
  }
}

class _JournalState extends State<Journal> {
  bool selectionMode = false;
  List<int> selectedTrips = [];

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

    return Trip.withData(legs);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget addTripDebugButton = Button(
      title: "Debug",
      stretch: false,
      onPressed: () async {
        DonationModal.showModal(context);
        setState(() {
          selectionMode = !selectionMode;
        });
      },
    );

    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast0,
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: const Text('Tagebuch'),
          leading: GestureDetector(
            onTap: () {},
            child: Text("Bearbeiten",
                style: AppThemeTextStyles.normal
                    .copyWith(color: AppThemeColors.blue)),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              addTripDebugButton,
              const SizedBox(width: 32.0),
              const HeroIcon(
                HeroIcons.plus,
                size: 16,
                color: AppThemeColors.blue,
              )
            ],
          ),
        ),
        SliverFillRemaining(child: BuildEntries(context, false)),
      ]),
    );
  }

  Widget BuildEntries(BuildContext context, bool loadCheckmark) {
    return StreamBuilder<List<Trip>>(
      stream: widget.trekko.getTripQuery().build().watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
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
              padding: const EdgeInsets.all(16.0),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: JournalEntry(
                      key: ValueKey(trips[index].id),
                      trip,
                      loadCheckmark,
                      isSelected: selectedTrips.contains(trip.id),
                      onSelectionChanged: (Trip trip, bool isSelected) {
                        setState(() {
                          print(selectedTrips.length);
                          if (isSelected) {
                            selectedTrips.add(trip.id);
                          } else {
                            selectedTrips.remove(trip.id);
                          }
                        });
                      },
                    ));
              },
            );
          }
        }
      },
    );
  }
}
