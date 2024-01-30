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
    );
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

    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast0,
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: const Text('Tagebuch'),
          leading: Container(
            alignment: Alignment.centerLeft,
            // Aligns the GestureDetector to the right
            child: GestureDetector(
              onTap: () {},
              child: Text("Bearbeiten",
                  style: AppThemeTextStyles.normal
                      .copyWith(color: AppThemeColors.blue)),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              donationButton,
              const SizedBox(width: 32.0),
              GestureDetector(
                onTap: () {
                  widget.trekko.saveTrip(TripBuilder()
                      .move_r(Duration(minutes: 10), 1000.meters)
                      .build());
                },
                child:
                    const Icon(CupertinoIcons.add, color: AppThemeColors.blue),
              ),
            ],
          ),
        ),
        SliverFillRemaining(
            child: StreamBuilder<List<Trip>>(
          stream:
              widget.trekko.getTripQuery().build().watch(fireImmediately: true),
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
                          false,
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
        )),
      ]),
    );
  }
}
