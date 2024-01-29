import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/tracked_point.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/components/map.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/journal_entry_detail_view_description.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/journal_entry_detail_view_details.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/journal_entry_detail_view_edit_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class JournalEntryDetailView extends StatelessWidget {
  final Stream<Trip> trip;

  const JournalEntryDetailView(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: trip,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            TrackedPoint first = snapshot.data!.legs.first.trackedPoints.first;
            TrackedPoint last = snapshot.data!.legs.last.trackedPoints.last;
            Trip trip = snapshot.data!;
            return CupertinoPageScaffold(
              backgroundColor: AppThemeColors.contrast150,
              navigationBar: CupertinoNavigationBar(
                  leading: CupertinoNavigationBarBackButton(
                      previousPageTitle: 'Tagebuch',
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  middle: Text('Wege'),
                  trailing: trip.donationState == DonationState.donated
                      ? Button(
                          stretch: false,
                          title: 'Zurückziehen',
                          onPressed: () {},
                          size: ButtonSize.small,
                          style: ButtonStyle.secondary,
                        )
                      : Button(
                          stretch: false,
                          title: 'Spenden',
                          onPressed: () {},
                          size: ButtonSize.small,
                          style: ButtonStyle.primary,
                        )),
              child: SafeArea(
                  child: Column(
                children: [
                  Expanded(
                      child: ListView(children: [
                    SizedBox(
                        height: 234,
                        child: Center(
                          child: MainMap(),
                        )),
                    JournalEntryDetailViewDescription(
                        trip: trip,
                        startDate: trip.calculateStartTime(),
                        endDate: trip.calculateStartTime()),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: AppThemeColors.contrast700, //TODO: Farbe anpassen
                    ),
                    JournalEntryDetailViewDetails(),
                  ])),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: JournalEntryDetailViewEditContext(
                        donated: trip.donationState == DonationState.donated),
                  )
                ],
              )),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Fehler beim Laden der Daten"));
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        });
  }
}
