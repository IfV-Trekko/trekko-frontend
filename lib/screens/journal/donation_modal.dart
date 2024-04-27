import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/donation_state.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_size.dart';
import 'package:trekko_frontend/components/constants/button_style.dart';
import 'package:trekko_frontend/screens/journal/entry/selectable_position_collection_entry.dart';

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
    super.build(context);

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
          .andDonationState(DonationState.undefined)
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
          if (trips.isEmpty) {
            return Center(
                child: Text(
              'Keine Wege zum Spenden gefunden',
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
                  trekko: widget.trekko,
                  data: trip,
                  selected: selectedTrips.contains(trip.id),
                  selectionMode: true,
                  onTap: () {
                    setState(() {
                      if (!selectedTrips.contains(trip.id)) {
                        selectedTrips.add(trip.id);
                      } else {
                        selectedTrips.remove(trip.id);
                      }
                    });
                  },
                );
              },
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
    if (selectedTrips.isEmpty) {
      finishedAction('Es muss mindestens ein Weg ausgewählt sein', true);
      return;
    }
    int donatedTrips = 0;
    var allTrips = await widget.trekko
        .getTripQuery()
        .andDonationState(DonationState.undefined)
        .collect();
    for (var trip in allTrips) {
      if (!selectedTrips.contains(trip.id)) {
        trip.donationState = DonationState.notDonated;
        widget.trekko.saveTrip(trip);
      }
    }

    try {
      await widget.trekko
          .donate(widget.trekko.getTripQuery().andAnyId(selectedTrips));
      if (mounted) Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
      finishedAction('Sie haben $donatedTrips Wege übermittelt', false);
      selectedTrips.clear();
    } catch (error) {
      if (mounted) Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
      finishedAction(
          'Bei der Spende des $donatedTrips. Weges ist ein Fehler aufgetreten',
          true);
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
              title: Text(error ? 'Fehler' : 'Spende Erfolgreich'),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Schließen'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
