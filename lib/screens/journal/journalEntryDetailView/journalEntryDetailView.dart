import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/buttonSize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class journalEntryDetailView extends StatelessWidget {
  final Stream<Trip> trip;

  const journalEntryDetailView(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            previousPageTitle: "Tagebuch",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          middle: Text('Wege'),
          trailing: Button(
            stretch: false,
            title: 'SPENDEN',
            onPressed: () {
              Navigator.pop(context);
            },
            size: ButtonSize.small,
          )),
      child: Center(
        child: Text('Journal Entry Detail View'),
      ),
    );
  }
}
