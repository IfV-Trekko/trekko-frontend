import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:flutter/cupertino.dart';

import 'journal_entry.dart';
import 'journal_subtitle.dart';

class TripsListView extends StatefulWidget {
  final List<Trip> trips;
  final bool selectionMode;
  final Function(Trip, bool) onSelectionChanged;
  final Trekko trekko;
  List<int> selectedTrips = [];

  TripsListView({
    required this.trips,
    required this.selectionMode,
    required this.onSelectionChanged,
    required this.trekko,
    required this.selectedTrips,
  });

  @override
  _TripsListViewState createState() => _TripsListViewState();
}

class _TripsListViewState extends State<TripsListView> {
  @override
  Widget build(BuildContext context) {
    // Your existing buildTripsListView code goes here, with some modifications:
    // Replace all instances of `trips` with `widget.trips`
    // Replace all instances of `selectionMode` with `widget.selectionMode`
    // Replace all instances of `onSelectionChanged` with `widget.onSelectionChanged`
    // Replace all instances of `trekko` with `widget.trekko`

    widget.trips.sort((a, b) => a.calculateStartTime().compareTo(b.calculateStartTime()));
    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: widget.selectionMode ? 64.0 : 16.0,
      ),
      itemCount: widget.trips.length,
      itemBuilder: (context, index) {
        final trip = widget.trips[index];

        // Check if this is the first trip or a new day has started
        if (index == 0 || !_isSameDay(widget.trips[index - 1].calculateStartTime(), trip.calculateStartTime())) {
          return Column(
            children: [
              JournalSubtitle(trip.calculateStartTime()), // Add the JournalSubtitle widget
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: JournalEntry(
                  key: ValueKey(widget.trips[index].id),
                  trip,
                  widget.selectionMode,
                  widget.trekko,
                  isSelected: widget.selectedTrips.contains(trip.id),
                  onSelectionChanged: (Trip trip, bool isSelected) {
                    setState(() {
                      if (isSelected) {
                        widget.selectedTrips.add(trip.id);
                      } else {
                        widget.selectedTrips.remove(trip.id);
                      }
                    });
                  },
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: JournalEntry(
              key: ValueKey(widget.trips[index].id),
              trip,
              widget.selectionMode,
              widget.trekko,
              isSelected: widget.selectedTrips.contains(trip.id),
              onSelectionChanged: (Trip trip, bool isSelected) {
                setState(() {
                  if (isSelected) {
                    widget.selectedTrips.add(trip.id);
                  } else {
                    widget.selectedTrips.remove(trip.id);
                  }
                });
              },
            ),
          );
        }
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}