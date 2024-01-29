import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

import '../../../app_theme.dart';
import '../../../components/button.dart';
import '../../../components/constants/button_size.dart';
import '../../../components/constants/button_style.dart';
import '../journal_entry.dart';

class DonationModal extends StatefulWidget {
  final Trekko trekko;

  const DonationModal(this.trekko, {Key? key}) : super(key: key);

  @override
  DonationModalState createState() => DonationModalState();
}

class DonationModalState extends State<DonationModal>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<int> selectedTrips = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Tagebuch',
        middle: Text('Wege'),
        trailing: Button(
          title: "Spenden",
          stretch: false,
          size: ButtonSize.small,
          onPressed: () {
            donate();
          },
        )
      ),
      child: SafeArea(
          top: true,
          child: Stack(children: [
            BuildEntries(context, true),
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
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 32.0, top: 13.0),
                  child: Button(
                    title: 'Spenden',
                    size: ButtonSize.large,
                    style: ButtonStyle.primary,
                    onPressed: () {
                     donate();
                    },
                  ),
                ),
              ),
            ),
          ])),
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

  void donate() async {
    selectedTrips.forEach((element) {
      widget.trekko.donate(widget.trekko.getTripQuery().filter().idEqualTo(element).build());
    });
  }
}
