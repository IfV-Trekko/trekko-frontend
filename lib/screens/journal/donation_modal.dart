
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/journal/TripsListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import '../../app_theme.dart';
import '../../components/button.dart';
import '../../components/constants/button_size.dart';
import '../../components/constants/button_style.dart';

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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Tagebuch',
        middle: Text('Wege'),
      ),
      child: SafeArea(
        top: true,
        child: Container(
            color: AppThemeColors.contrast0,
            child: Stack(children: [
              _buildEntries(context, true),
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
                        left: 16.0, right: 16.0, bottom: 12.0, top: 12.0),
                    child: Button(
                      title: 'Spenden',
                      size: ButtonSize.large,
                      style: ButtonStyle.primary,
                      loading: isLoading,
                      onPressed: () {
                        donate();
                      },
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }

  Widget _buildEntries(BuildContext context, bool loadCheckmark) {
    return StreamBuilder<List<Trip>>(
      stream: widget.trekko
          .getTripQuery()
          .filter()
          .donationStateEqualTo(DonationState.undefined)
          .build()
          .watch(fireImmediately: true),
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
              'Keine Wege zum Spenden gefunden',
              style: AppThemeTextStyles.title,
            ));
          } else {
            return TripsListView(
              trips: trips,
              selectionMode: true,
              onSelectionChanged: (Trip trip, bool isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedTrips.add(trip.id);
                  } else {
                    selectedTrips.remove(trip.id);
                  }
                });
              },
              trekko: widget.trekko,
              selectedTrips: selectedTrips,
            );
          }
        }
      },
    );
  }

  void donate() async {
    setState(() {
      isLoading = true;
    });
    int donatedTrips = 0;
    var allTrips = await widget.trekko.getTripQuery().filter().donationStateEqualTo(DonationState.undefined).findAll();
    for (var trip in allTrips) {
      if (selectedTrips.contains(trip.id)) {
        try {
          await widget.trekko.donate(
              widget.trekko.getTripQuery().filter().idEqualTo(trip.id).build());
          donatedTrips++;
        } catch (error) {
          Navigator.pop(context); // Close the modal
          setState(() {
            isLoading = false; // Set isLoading to false
          });
          finishedAction('Bei der Spende des $donatedTrips. Weges ist ein Fehler aufgetreten', true);
          return;
        }
      } else {
        trip.donationState = DonationState.notDonated;
        widget.trekko.saveTrip(trip);
      }
    }
    Navigator.pop(context);
    setState(() {
      isLoading = false;
    });
    finishedAction('Sie haben $donatedTrips Wege übermittelt', false);
    selectedTrips.clear();
  }

  void finishedAction(String message, bool error) {
    selectedTrips.clear();
    setState(() {
      isLoading = false;
    });
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(error ? 'Fehler' : 'Spende Erfolgreich'),
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
