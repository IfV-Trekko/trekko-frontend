import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/components/trip_map.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/description.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/details.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/edit_context.dart';
import 'package:app_frontend/trekko_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

class JournalEntryDetailViewWrapper extends StatefulWidget {
  final Trip trip;

  const JournalEntryDetailViewWrapper({required this.trip, Key? key})
      : super(key: key);

  @override
  _TestWrapperState createState() => _TestWrapperState();
}

class _TestWrapperState extends State<JournalEntryDetailViewWrapper> {
  bool isLoading = false;

  void _askForReset() {
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
              offset: const Offset(-16, 0), //TODO überprüfen
              child: CupertinoNavigationBarBackButton(
                  previousPageTitle: 'Tagebuch',
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            middle: const Text('Wege'),
            trailing:
                // widget.trip.donationState == DonationState.donated
                //     ?
                Button(
              stretch: false,
              title: 'Zurücksetzen',
              onPressed: () async {
                _askForReset(); //TODO funktioniert nicht & vorher fragen
                await trekko.saveTrip(widget.trip);
              },
              size: ButtonSize.small,
              style: ButtonStyle.secondary,
            )),
        child: SafeArea(
            child: Stack(
          children: [
            Expanded(
                child: ListView(children: [
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
                  trekko.saveTrip(widget.trip);
                },
                detailPurpose: widget.trip.purpose ?? '',
                onSavedPurpose: (value) {
                  widget.trip.purpose = value;
                  trekko.saveTrip(widget.trip);
                },
                detailComment: widget.trip.comment ?? '',
                onSavedComment: (value) {
                  widget.trip.comment = value;
                  trekko.saveTrip(widget.trip);
                },
              ),
              const SizedBox(height: 128),
            ])),
            Align(
              alignment: Alignment.bottomCenter,
              child: EditContext(
                  //TODO schießt mit hoch
                  isDonatig: isLoading,
                  donated: widget.trip.donationState == DonationState.donated,
                  onReset: () {
                    widget.trip.reset(); //TODO funktioniert nicht
                  },
                  onUpdate: () {
                    trekko.saveTrip(widget.trip);
                  },
                  onDonate: () async {
                    await trekko.saveTrip(widget.trip);
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
