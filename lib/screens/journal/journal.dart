import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

import '../../app_theme.dart';
import 'journalEntry.dart';

class Journal extends StatefulWidget {
  final Trekko trekko;

  const Journal({super.key, required this.trekko});

  @override
  State<StatefulWidget> createState() {
    return _JournalState();
  }
}

class _JournalState extends State<Journal> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
      stream: widget.trekko.getTripQuery().build().watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
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
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return JournalEntry(trip);
              },
            );
          }
        }
      },
    );
  }
}
