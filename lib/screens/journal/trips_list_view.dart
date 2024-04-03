import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/screens/journal/journal_entry.dart';
import 'package:trekko_frontend/screens/journal/journal_subtitle.dart';

//is used to render the list of journal entries in the donation modal
class TripsListView extends StatefulWidget {
  final List<Trip> trips;
  final bool selectionMode;
  final Function(Trip, bool) onSelectionChanged;
  final Trekko trekko;
  final List<int> selectedTrips;

  const TripsListView({
    super.key,
    required this.trips,
    required this.selectionMode,
    required this.onSelectionChanged,
    required this.trekko,
    required this.selectedTrips,
  });

  @override
  TripsListViewState createState() => TripsListViewState();
}

class TripsListViewState extends State<TripsListView> {
  @override
  Widget build(BuildContext context) {
    widget.trips.sort((a, b) => a.getStartTime().compareTo(b.getStartTime()));
    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: widget.selectionMode ? 64.0 : 16.0,
      ),
      itemCount: widget.trips.length,
      itemBuilder: (context, index) {
        final trip = widget.trips[index];
        if (index == 0 ||
            !_isSameDay(
                widget.trips[index - 1].getStartTime(), trip.getStartTime())) {
          return Column(
            children: [
              JournalSubtitle(trip.getStartTime()),
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
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
