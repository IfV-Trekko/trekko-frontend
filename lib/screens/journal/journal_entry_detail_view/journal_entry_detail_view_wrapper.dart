import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/components/map.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/description.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/details.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/edit_context.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view_provider.dart';
import 'package:app_frontend/trekko_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

class JournalEntryDetailViewWrapper extends StatefulWidget {
  final Trip trip;

  JournalEntryDetailViewWrapper({required this.trip, Key? key})
      : super(key: key);

  @override
  _TestWrapperState createState() => _TestWrapperState();
}

class _TestWrapperState extends State<JournalEntryDetailViewWrapper> {
  bool hasUnsafedChanges = false;

  void setUnsafedChanges(bool hasUnsafedChanges) {
    setState(() {
      this.hasUnsafedChanges = hasUnsafedChanges;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trekko = TrekkoProvider.of(context);

    return JournalEntryDetailViewProvider(
      hasUnsafedChanges: hasUnsafedChanges,
      onSetUnsafedChanges: setUnsafedChanges,
      child: CupertinoPageScaffold(
        backgroundColor: AppThemeColors.contrast150,
        navigationBar: CupertinoNavigationBar(
            leading: CupertinoNavigationBarBackButton(
                previousPageTitle: 'Tagebuch', //TODO off center
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            middle: const Text('Wege'),
            trailing: widget.trip.donationState == DonationState.donated
                ? Button(
                    stretch: false,
                    title: 'Zurückziehen',
                    onPressed: () {
                      trekko.revoke(trekko
                          .getTripQuery()
                          .idEqualTo(widget.trip.id)
                          .build());
                    },
                    size: ButtonSize.small,
                    style: ButtonStyle.secondary,
                  )
                : Button(
                    stretch: false,
                    title: 'Spenden',
                    onPressed: () {
                      trekko.donate(trekko
                          .getTripQuery()
                          .idEqualTo(widget.trip.id)
                          .build());
                    },
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
                  trip: widget.trip,
                  startDate: widget.trip.calculateStartTime(),
                  endDate: widget.trip.calculateEndTime()),
              Container(
                height: 1,
                width: double.infinity,
                color: AppThemeColors.contrast700,
              ),
              const JournalEntryDetailViewDetails(),
            ])),
            Align(
              alignment: Alignment.bottomCenter,
              child: JournalEntryDetailViewEditContext(
                  donated: widget.trip.donationState == DonationState.donated,
                  onReset: () {
                    widget.trip.reset();
                  },
                  onUpdate: () {
                    trekko.saveTrip(widget.trip);
                  },
                  onDonate: () async {
                    await trekko.saveTrip(widget.trip);
                    await trekko.donate(trekko
                        .getTripQuery()
                        .idEqualTo(widget.trip.id)
                        .build());
                  },
                  onDelete: () {
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(
                        seconds: 1)); //TODO warum schmiert trotzdem ab?
                    trekko.deleteTrip(trekko
                        .getTripQuery()
                        .idEqualTo(widget.trip.id)
                        .build());
                  },
                  onRevoke: () {
                    trekko.revoke(trekko
                        .getTripQuery()
                        .idEqualTo(widget.trip.id)
                        .build());
                  }),
            ),
          ],
        )),
      ),
    );
  }
}