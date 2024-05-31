import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/trekko_state.dart';
import 'package:trekko_backend/controller/utils/trip_query.dart';
import 'package:trekko_backend/model/trip/donation_state.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_size.dart';
import 'package:trekko_frontend/components/maps/position_collection_map.dart';
import 'package:trekko_frontend/components/picker/date_picker.dart';
import 'package:trekko_frontend/components/pop_up_utils.dart';
import 'package:trekko_frontend/screens/journal/create/trip_create_screen.dart';
import 'package:trekko_frontend/screens/journal/donation_modal.dart';
import 'package:trekko_frontend/screens/journal/entry/collection_entry_context_menu.dart';
import 'package:trekko_frontend/screens/journal/entry/selectable_position_collection_entry.dart';
import 'package:trekko_frontend/screens/journal/journal_edit_bar.dart';
import 'package:trekko_frontend/screens/journal/trip/trip_edit_view.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class JournalScreen extends StatefulWidget {
  final BuildContext tabContext;

  const JournalScreen({super.key, required this.tabContext});

  @override
  State<JournalScreen> createState() => JournalScreenState();
}

class JournalScreenState extends State<JournalScreen>
    with AutomaticKeepAliveClientMixin {
  static const int crazyHighNumberSoWeCanScroll = 30000;

  bool selectionMode = false;
  bool isLoading = false;
  List<int> selectedTrips = [];
  late DateTime currentDate;
  late PageController _pageController;

  @override
  void initState() {
    currentDate = _startOfDay(DateTime.now());
    _pageController = PageController(initialPage: crazyHighNumberSoWeCanScroll);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _getCurrentDate(int index) {
    return currentDate.add(Duration(days: index - _pageController.initialPage));
  }

  Widget buildSliverNavbar(Trekko trekko) {
    return CupertinoSliverNavigationBar(
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
            style:
                AppThemeTextStyles.normal.copyWith(color: AppThemeColors.blue),
          )
        ]),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!selectionMode && trekko.getState() == TrekkoState.online)
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
                DateTime start = _getCurrentDate(_pageController.page!.round());
                DateTime end = start.add(const Duration(days: 1));
                Navigator.of(widget.tabContext).push(CupertinoPageRoute(
                    builder: (context) => CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(
                          middle:
                              Text('${start.day}.${start.month}.${start.year}'),
                          backgroundColor: AppThemeColors.contrast0,
                        ),
                        child: PositionCollectionMap(
                            collections: trekko
                                .getTripQuery()
                                .andTimeBetween(start, end)
                                .completeStream()))));
              },
              child: const HeroIcon(HeroIcons.map, color: AppThemeColors.blue),
            ),
          if (!selectionMode)
            GestureDetector(
              onTap: () async {
                Trip? newTrip = await Navigator.of(widget.tabContext).push(
                    CupertinoPageRoute(
                        builder: (context) => const TripCreateScreen()));
                if (newTrip != null) trekko.saveTrip(newTrip);
              },
              child: const Icon(CupertinoIcons.add, color: AppThemeColors.blue),
            ),
        ],
      ),
      backgroundColor: AppThemeColors.contrast0,
    );
  }

  Widget buildEntry(Trekko trekko, Trip trip) {
    TripQuery query = trekko.getTripQuery().andId(trip.id);
    List<EntryAction> actions = [
      EntryAction(
          title: "Daten exportieren",
          icon: CupertinoIcons.square_arrow_down,
          onClick: () async {
            await trekko.export(query);
            PopUpUtils.showPopUp(context, 'Export erfolgreich',
                'Der Trip wurde erfolgreich in die Zwischenablage kopiert.');
          }),
    ];
    if (trekko.getState() == TrekkoState.online) {
      actions.addAll([
        if (trip.donationState == DonationState.donated)
          EntryAction(
              title: "Zurückziehen",
              icon: CupertinoIcons.xmark,
              onClick: () {
                trekko.revoke(query);
              }),
        if (trip.donationState != DonationState.donated)
          EntryAction(
              title: "Spenden",
              icon: CupertinoIcons.heart,
              onClick: () {
                trekko.donate(query);
              }),
      ]);
    }
    return SelectablePositionCollectionEntry(
      key: ValueKey(trip.id),
      trekko: trekko,
      data: trip,
      selected: selectedTrips.contains(trip.id),
      selectionMode: selectionMode,
      onTap: () => handleSelectionChange(trip),
      onEdit: () {
        Navigator.of(widget.tabContext).push(CupertinoPageRoute(
            builder: (context) => TripEditView(tripId: trip.id)));
      },
      onDelete: () {
        trekko.deleteTrip(trekko.getTripQuery().andId(trip.id));
      },
      actions: actions,
    );
  }

  Widget buildJournal(Trekko trekko, DateTime time) {
    return StreamBuilder(
        stream: trekko
            .getTripQuery()
            .andTimeBetween(time, time.add(const Duration(days: 1)))
            .stream(),
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
            double height = MediaQuery.of(context).size.height;
            return CustomScrollView(
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: DatePicker(
                    time: time,
                    mode: CupertinoDatePickerMode.date,
                    onDateChanged: (newDate) {
                      setState(() {
                        currentDate = newDate;
                        _pageController
                            .jumpToPage(crazyHighNumberSoWeCanScroll);
                      });
                    },
                  ),
                ),
                if (trips.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: buildEntry(trekko, trips[index])),
                      childCount: trips.length,
                    ),
                  ),
                if (trips.isEmpty)
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.only(top: height * 0.3),
                    child: Center(
                      child: Text(
                        'Keine Wege an diesem Tag',
                        style: AppThemeTextStyles.title,
                      ),
                    ),
                  )),
              ],
            );
          }
        });
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
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: buildSliverNavbar(trekko)),
              ];
            },
            body: Builder(
              builder: (BuildContext context) {
                double height = MediaQuery.of(context).size.height;
                return SizedBox(
                  height: height * 0.8,
                  child: PageView.builder(
                    controller: _pageController,
                    allowImplicitScrolling: false,
                    itemBuilder: (context, index) {
                      DateTime date = _getCurrentDate(index);
                      return Column(
                        children: [
                          Expanded(
                            child: buildJournal(trekko, date),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
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
            )
          else if (selectionMode)
            JournalEditBar(
                onRevoke: trekko.getState() != TrekkoState.online
                    ? null
                    : () async {
                        await revoke(trekko);
                        setState(() {
                          selectionMode = false;
                        });
                      },
                onMerge: () async {
                  await merge(trekko);
                  setState(() {
                    selectionMode = false;
                  });
                },
                onDelete: () async {
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
      Navigator.of(widget.tabContext).push(CupertinoPageRoute(
          builder: (context) => TripEditView(tripId: trip.id)));
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
      var query = trekko.getTripQuery().andAnyId(selectedTrips);
      int deletedTrips = await trekko.deleteTrip(query);
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
      var query = trekko.getTripQuery().andAnyId(selectedTrips);
      await trekko.mergeTrips(query);
      showPopupMessage('Sie haben $count Wege zusammengefügt', false);
    } catch (e) {
      showPopupMessage(
          "Diese Wege konnten nicht zusammengeführt werden. Bitte stelle sicher, dass sie sich nicht überschneiden.",
          true);
      rethrow;
    }
  }

  Future<void> revoke(Trekko trekko) async {
    try {
      var query = trekko.getTripQuery().andAnyId(selectedTrips);
      int count = await trekko.revoke(query);
      showPopupMessage(
          'Sie haben ihre Spende über $count Wege zurückgezogen', false);
    } catch (e) {
      showPopupMessage("Fehler beim Zurückziehen der Wege", true);
      rethrow;
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
