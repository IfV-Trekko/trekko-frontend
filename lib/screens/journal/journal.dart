import 'package:app_backend/controller/utils/trip_builder.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/screens/journal/donation_modal.dart';
import 'package:app_frontend/screens/journal/journal_entry.dart';
import 'package:app_frontend/screens/journal/trips_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/trekko_provider.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';

class JournalScreen extends StatefulWidget {
  JournalScreen({super.key});

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<StatefulWidget>
    with AutomaticKeepAliveClientMixin {
  bool selectionMode = false;
  bool isLoading = false;
  List<int> selectedTrips = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Trekko trekko = TrekkoProvider.of(context);

    return CupertinoPageScaffold(
        child: SafeArea(
      bottom: true,
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: const Text("Tagebuch"),
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
                    if (!selectionMode)
                      Button(
                        title: "Spenden",
                        stretch: false,
                        size: ButtonSize.small,
                        onPressed: () async {
                          showDonationModal(context);
                          setState(() {
                            selectionMode = !selectionMode;
                          });
                        },
                      ),
                    const SizedBox(width: 32.0),
                    if (!selectionMode)
                      GestureDetector(
                        onTap: () {
                          trekko.saveTrip(TripBuilder()
                              .move_r(const Duration(minutes: 10), 1000.meters)
                              .build());
                        },
                        child: const Icon(CupertinoIcons.add,
                            color: AppThemeColors.blue),
                      ),
                  ],
                ),
                backgroundColor: AppThemeColors.contrast0,
              ),
              StreamBuilder(
                  stream: trekko
                      .getTripQuery()
                      .build()
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SliverFillRemaining(
                          child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.connectionState ==
                            ConnectionState.waiting &&
                        snapshot.data == null) {
                      return const SliverFillRemaining(
                          child: Center(
                              child: CupertinoActivityIndicator(
                                  radius: 20,
                                  color: AppThemeColors.contrast500)));
                    } else {
                      final trips = snapshot.data ?? [];
                      if (trips.isEmpty) {
                        return Center(
                            child: Text(
                          'Noch keine Wege verfügbar',
                          style: AppThemeTextStyles.title,
                        ));
                      } else {
                        return TripsList(
                            trips: trips,
                            selectionMode: selectionMode,
                            onSelectionChanged: handleSelectionChange,
                            selectedTrips: selectedTrips);
                      }
                    }
                  }),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
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
            )
          else if (selectionMode)
            Align(
              alignment: Alignment.bottomCenter,
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
                          merge(trekko);
                        },
                        child: Text(
                          "Vereinigen",
                          style: AppThemeTextStyles.normal
                              .copyWith(color: AppThemeColors.blue),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          revoke(trekko);
                        },
                        child: Text(
                          "Zurückziehen",
                          style: AppThemeTextStyles.normal
                              .copyWith(color: AppThemeColors.blue),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          delete(trekko);
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
            )
        ],
      ),
    ));
  }

  void showDonationModal(BuildContext context) {
    final Trekko trekko = TrekkoProvider.of(context);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return DonationModal(trekko);
      },
    ).then((_) {
      setState(() {
        selectionMode = false;
      });
    });
  }

  void handleSelectionChange(Trip trip, bool isSelected) {
    if (isSelected) {
      selectedTrips.add(trip.id);
    } else {
      selectedTrips.remove(trip.id);
    }
  }

  void delete(Trekko trekko) async {
    try {
      setState(() {
        isLoading = true;
      });
      QueryBuilder<Trip, Trip, QAfterFilterCondition> query =
          trekko.getTripQuery().filter().idEqualTo(selectedTrips.first);
      for (var tripId in selectedTrips) {
        query = query.or().idEqualTo(tripId);
      }
      int deletedTrips = await trekko.deleteTrip(query.build());
      finishedAction('Sie haben $deletedTrips Wege gelöscht', false);
    } catch (e) {
      finishedAction("Fehler beim Löschen der Wege", true);
    }
  }

  void merge(Trekko trekko) async {
    try {
      setState(() {
        isLoading = true;
      });
      QueryBuilder<Trip, Trip, QAfterFilterCondition> query =
          trekko.getTripQuery().filter().idEqualTo(selectedTrips.first);
      int count = 0;
      for (var tripId in selectedTrips) {
        query = query.or().idEqualTo(tripId);
        count++;
      }
      await trekko.mergeTrips(query.build());
      finishedAction('Sie haben $count Wege zusammengefügt', false);
    } catch (e) {
      finishedAction("Fehler beim Vereinigen der Wege", true);
    }
  }

  void revoke(Trekko trekko) async {
    try {
      QueryBuilder<Trip, Trip, QAfterFilterCondition> query =
          trekko.getTripQuery().filter().idEqualTo(selectedTrips.first);
      for (var tripId in selectedTrips) {
        query = query.or().idEqualTo(tripId);
      }
      int count = await trekko.revoke(query.build());
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
                  child: const Text("Schließen"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
