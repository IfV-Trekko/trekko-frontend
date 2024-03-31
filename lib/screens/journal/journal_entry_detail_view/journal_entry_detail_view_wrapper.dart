import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/donation_state.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_size.dart';
import 'package:trekko_frontend/components/constants/button_style.dart';
import 'package:trekko_frontend/components/maps/trip_map.dart';
import 'package:trekko_frontend/screens/journal/journal_entry_detail_view/components/description.dart';
import 'package:trekko_frontend/screens/journal/journal_entry_detail_view/components/details.dart';
import 'package:trekko_frontend/screens/journal/journal_entry_detail_view/components/edit_context.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class JournalEntryDetailViewWrapper extends StatefulWidget {
  final Trip trip;

  const JournalEntryDetailViewWrapper({required this.trip, Key? key})
      : super(key: key);

  @override
  TestWrapperState createState() => TestWrapperState();
}

class TestWrapperState extends State<JournalEntryDetailViewWrapper> {
  bool isLoading = false;

  void save(Trekko trekko) {
    trekko.saveTrip(widget.trip);
  }

  void _askForReset(Trekko trekko) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Weg zurücksetzen?'),
            content: const Text(
                'Möchtest du wirklich den Weg zurücksetzen? Der Weg wird auf die ursprünglichen Daten zurückgesetzt, wobei alle Änderungen verloren gehen.'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Zurücksetzen'),
                onPressed: () {
                  widget.trip.reset();
                  save(trekko);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final trekko = TrekkoProvider.of(context);

    return CupertinoPageScaffold(
        backgroundColor: AppThemeColors.contrast150,
        navigationBar: CupertinoNavigationBar(
            leading: Transform.translate(
              offset: const Offset(-16, 0),
              child: CupertinoNavigationBarBackButton(
                  previousPageTitle: 'Tagebuch',
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            middle: const Text('Wege'),
            trailing: Button(
              stretch: false,
              title: 'Zurücksetzen',
              onPressed: () async {
                _askForReset(trekko);
              },
              size: ButtonSize.small,
              style: ButtonStyle.secondary,
            )),
        child: SafeArea(
            child: Stack(
          children: [
            ListView(children: [
              SizedBox(
                  height: 234,
                  child: Center(
                    child: TripMap(
                      trip: widget.trip,
                    ),
                  )),
              Description(
                  trip: widget.trip,
                  startDate: widget.trip.getStartTime(),
                  endDate: widget.trip.getEndTime()),
              Container(
                height: 1,
                width: double.infinity,
                color: AppThemeColors.contrast700,
              ),
              Details(
                detailVehicle: widget.trip.getTransportTypes(),
                onSavedVehicle: (value) {
                  widget.trip.setTransportTypes(value);
                  save(trekko);
                },
                detailPurpose: widget.trip.purpose ?? '',
                onSavedPurpose: (value) {
                  widget.trip.purpose = value;
                  save(trekko);
                },
                detailComment: widget.trip.comment ?? '',
                onSavedComment: (value) {
                  widget.trip.comment = value;
                  save(trekko);
                },
              ),
              const SizedBox(height: 128),
            ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: EditContext(
                  isDonating: isLoading,
                  donated: widget.trip.donationState == DonationState.donated,
                  onDonate: () async {
                    save(trekko);
                    setState(() {
                      isLoading = true;
                    });
                    await trekko.donate(trekko
                        .getTripQuery()
                        .idEqualTo(widget.trip.id)
                        .build());
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onDelete: () {
                    Navigator.of(context).pop();
                    trekko.deleteTrip(trekko
                        .getTripQuery()
                        .idEqualTo(widget.trip.id)
                        .build());
                  },
                  onRevoke: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await trekko.revoke(trekko
                        .getTripQuery()
                        .idEqualTo(widget.trip.id)
                        .build());
                    trekko.saveTrip(widget.trip);
                    setState(() {
                      isLoading = false;
                    });
                  }),
            ),
          ],
        )));
  }
}
