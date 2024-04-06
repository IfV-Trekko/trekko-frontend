import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/trip_builder.dart';
import 'package:trekko_backend/controller/utils/trip_query.dart';
import 'package:trekko_backend/model/trip/donation_state.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_size.dart';
import 'package:trekko_frontend/components/picker/date_carousel.dart';
import 'package:trekko_frontend/components/pop_up_utils.dart';
import 'package:trekko_frontend/screens/journal/donation_modal.dart';
import 'package:trekko_frontend/screens/journal/entry/collection_entry_context_menu.dart';
import 'package:trekko_frontend/screens/journal/entry/selectable_position_collection_entry.dart';
import 'package:trekko_frontend/screens/journal/journal_edit_bar.dart';
import 'package:trekko_frontend/screens/journal/trip/trip_edit_view.dart';
import 'package:trekko_frontend/trekko_provider.dart';

//This renders the basic journal screen showing all journal entries
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  JournalScreenState createState() => JournalScreenState();
}

class JournalScreenState extends State<StatefulWidget>
    with AutomaticKeepAliveClientMixin {
  bool selectionMode = false;
  bool isLoading = false;
  List<int> selectedTrips = [];

  @override
  bool get wantKeepAlive => true;

  _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

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
            physics: const NeverScrollableScrollPhysics(),
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: const Text("Tagebuch"),
                leading: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectionMode = !selectionMode;
                    });
                  },
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      selectionMode ? "Fertig" : "Bearbeiten",
                      style: AppThemeTextStyles.normal
                          .copyWith(color: AppThemeColors.blue),
                    )
                  ]),
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
                        },
                      ),
                    const SizedBox(width: 20.0),
                    if (!selectionMode)
                      GestureDetector(
                        onTap: () {
                          Trip newTrip = TripBuilder()
                              .move_r(const Duration(minutes: 5), 100.meters)
                              .build();
                          trekko.saveTrip(newTrip).then((value) => {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => TripEditView(
                                        trekko: TrekkoProvider.of(context),
                                        tripId: value)))
                              });
                        },
                        child: const Icon(CupertinoIcons.add,
                            color: AppThemeColors.blue),
                      ),
                  ],
                ),
                backgroundColor: AppThemeColors.contrast0,
              ),
              DateCarousel(
                  initialTime: _startOfDay(DateTime.now()),
                  childBuilder: (DateTime time) {
                    return StreamBuilder(
                        stream: TripQuery(trekko)
                            .andTimeBetween(
                                time, time.add(const Duration(days: 1)))
                            .stream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              snapshot.data == null) {
                            return const Center(
                                child: CupertinoActivityIndicator(
                                    radius: 20,
                                    color: AppThemeColors.contrast500));
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
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 64.0,
                                ),
                                itemCount: trips.length,
                                itemBuilder: (context, index) {
                                  Trip trip = trips[index];
                                  return SelectablePositionCollectionEntry(
                                    key: ValueKey(trip.id),
                                    trekko: trekko,
                                    data: trip,
                                    selected: selectedTrips.contains(trip.id),
                                    selectionMode: selectionMode,
                                    onTap: () => handleSelectionChange(trip),
                                    onEdit: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  TripEditView(
                                                      trekko: trekko,
                                                      tripId: trip.id)));
                                    },
                                    onDelete: () {
                                      trekko.deleteTrip(TripQuery(trekko)
                                          .andId(trip.id)
                                          .build());
                                    },
                                    actions: [
                                      if (trip.donationState ==
                                          DonationState.donated)
                                        EntryAction(
                                            title: "Zurückziehen",
                                            icon: CupertinoIcons.xmark,
                                            onClick: () {
                                              trekko.revoke(TripQuery(trekko)
                                                  .andId(trip.id)
                                                  .build());
                                            }),
                                      if (trip.donationState !=
                                          DonationState.donated)
                                        EntryAction(
                                            title: "Spenden",
                                            icon: CupertinoIcons.heart,
                                            onClick: () {
                                              trekko.donate(TripQuery(trekko)
                                                  .andId(trip.id)
                                                  .build());
                                            }),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        });
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
            JournalEditBar(onRevoke: () async {
              await revoke(trekko);
              setState(() {
                selectionMode = false;
              });
            }, onMerge: () async {
              await merge(trekko);
              setState(() {
                selectionMode = false;
              });
            }, onDelete: () async {
              await delete(trekko);
              setState(() {
                selectionMode = false;
              });
            })
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

  void handleSelectionChange(PositionCollection coll) {
    Trip trip = coll as Trip;
    if (!selectionMode) {
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => TripEditView(
              trekko: TrekkoProvider.of(context), tripId: trip.id)));
    } else {
      setState(() {
        if (!selectedTrips.contains(trip.id)) {
          selectedTrips.add(trip.id);
        } else {
          selectedTrips.remove(trip.id);
        }
      });
    }
  }

  Future<void> delete(Trekko trekko) async {
    try {
      setState(() {
        isLoading = true;
      });
      var query = TripQuery(trekko).andAnyId(selectedTrips);
      int deletedTrips = await trekko.deleteTrip(query.build());
      showPopupMessage('Sie haben $deletedTrips Wege gelöscht', false);
    } catch (e) {
      showPopupMessage("Fehler beim Löschen der Wege", true);
    }
  }

  Future<void> merge(Trekko trekko) async {
    try {
      setState(() {
        isLoading = true;
      });
      int count = selectedTrips.length;
      var query = TripQuery(trekko).andAnyId(selectedTrips);
      await trekko.mergeTrips(query.build());
      showPopupMessage('Sie haben $count Wege zusammengefügt', false);
    } catch (e) {
      showPopupMessage("Fehler beim Vereinigen der Wege", true);
      // Log
      Logger().f("Error while merging trips", error: e);
    }
  }

  Future<void> revoke(Trekko trekko) async {
    try {
      var query = TripQuery(trekko).andAnyId(selectedTrips);
      int count = await trekko.revoke(query.build());
      showPopupMessage(
          'Sie haben ihre Spende über $count Wege zurückgezogen', false);
    } catch (e) {
      showPopupMessage("Fehler beim Zurückziehen der Wege", true);
      Logger().f("Error while revoking trips", error: e);
    }
  }

  void showPopupMessage(String message, bool error) {
    selectedTrips.clear();
    setState(() {
      isLoading = false;
    });
    PopUpUtils.showPopUp(context, error ? "Fehler" : "Abgeschlossen", message);
  }
}
