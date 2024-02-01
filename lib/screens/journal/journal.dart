import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/controller/utils/trip_builder.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/screens/journal/donation_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import '../../app_theme.dart';
import '../../components/constants/button_size.dart';
import 'journal_entry.dart';
import 'package:fling_units/fling_units.dart';

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
  TripBuilder tripBuilder = TripBuilder();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void showModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return DonationModal(widget.trekko);
      },
    ).then((_) {
      setState(() {
        selectionMode = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget donationButton = Button(
      title: "Spenden",
      stretch: false,
      size: ButtonSize.small,
      onPressed: () async {
        showModal(context);
        setState(() {
          selectionMode = !selectionMode;
        });
      },
    );

    return Stack(
      children: [
        CupertinoPageScaffold(
          backgroundColor: AppThemeColors.contrast0,
          child: CustomScrollView(slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Tagebuch'),
              leading: Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectionMode = !selectionMode;
                    });
                  },
                  child: Text(
                    selectionMode ? "Fertig" : "Bearbeiten",
                    style: AppThemeTextStyles.normal
                        .copyWith(color: AppThemeColors.blue),
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!selectionMode) donationButton,
                  const SizedBox(width: 32.0),
                  if (!selectionMode)
                    GestureDetector(
                      onTap: () {
                        widget.trekko.saveTrip(TripBuilder()
                            .move_r(Duration(minutes: 10), 1000000.meters)
                            .build());
                      },
                      child: const Icon(CupertinoIcons.add,
                          color: AppThemeColors.blue),
                    ),
                ],
              ),
            ),
            SliverFillRemaining(
                child: SafeArea(
              top: false,
              bottom: true,
              child: StreamBuilder<List<Trip>>(
                stream: widget.trekko
                    .getTripQuery()
                    .build()
                    .watch(fireImmediately: true),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                          ConnectionState.waiting &&
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
                      return buildTripsListView(trips);
                    }
                  }
                },
              ),
            )),
          ]),
        ),
        if (selectionMode)
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppThemeColors.contrast0,
                border: Border(
                  top: BorderSide(
                    color: AppThemeColors.contrast400,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        merge();
                      },
                      child: Text(
                        "Vereinigen",
                        style: AppThemeTextStyles.normal
                            .copyWith(color: AppThemeColors.blue),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        revoke();
                      },
                      child: Text(
                        "Zurückziehen",
                        style: AppThemeTextStyles.normal
                            .copyWith(color: AppThemeColors.blue),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        delete();
                      },
                      child: Text(
                        "Löschen",
                        style: AppThemeTextStyles.normal
                            .copyWith(color: AppThemeColors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: AppThemeColors.contrast0.withOpacity(0.5),
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  //only way to fix horrible nesting, too bad
  Widget buildTripsListView(List<Trip> trips) {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: selectionMode ? 64.0 : 16.0,
      ),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: JournalEntry(
              key: ValueKey(trips[index].id),
              trip,
              selectionMode,
              widget.trekko,
              isSelected: selectedTrips.contains(trip.id),
              onSelectionChanged: (Trip trip, bool isSelected) {
                setState(() {
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

  void delete() async {
    try {
      setState(() {
        isLoading = true;
      });
      QueryBuilder<Trip, Trip, QAfterFilterCondition> query =
          widget.trekko.getTripQuery().filter().idEqualTo(selectedTrips.first);
      for (var tripId in selectedTrips) {
        query = query.or().idEqualTo(tripId);
      }
      int deletedTrips = await widget.trekko.deleteTrip(query.build());
      finishedAction('Sie haben $deletedTrips Wege gelöscht', false);
    } catch (e) {
      finishedAction("Fehler beim Löschen der Wege", true);
    }
  }

  void merge() async {
    try {
      setState(() {
        isLoading = true;
      });
      QueryBuilder<Trip, Trip, QAfterFilterCondition> query =
          widget.trekko.getTripQuery().filter().idEqualTo(selectedTrips.first);
      int count = 0;
      for (var tripId in selectedTrips) {
        query = query.or().idEqualTo(tripId);
        count++;
      }
      await widget.trekko.mergeTrips(query.build());
      finishedAction('Sie haben $count Wege zusammengefügt', false);
    } catch (e) {
      finishedAction("Fehler beim Vereinigen der Wege", true);
    }
  }

  void revoke() async {
    try {
      QueryBuilder<Trip, Trip, QAfterFilterCondition> query =
          widget.trekko.getTripQuery().filter().idEqualTo(selectedTrips.first);
      for (var tripId in selectedTrips) {
        query = query.or().idEqualTo(tripId);
      }
      int count = await widget.trekko.revoke(query.build());
      finishedAction(
          'Sie haben ihre Spende über $count Wege zurückgezogen', false);
    } catch (e) {
      finishedAction(
          "Fehler beim Zurückziehen der Wege", true); // Handle the error here
    }
  }

  void finishedAction(String message, bool error) {
    selectedTrips.clear();
    setState(() {
      isLoading = false;
    });
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(error ? 'Fehler' : 'Abgeschlossen'),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: Text('Schließen'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
