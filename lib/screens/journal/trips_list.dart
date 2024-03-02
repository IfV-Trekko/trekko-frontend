import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/journal/journal_entry.dart';
import 'package:app_frontend/screens/journal/journal_subtitle.dart';
import 'package:app_frontend/trekko_provider.dart';
import 'package:flutter/cupertino.dart';

class TripsList extends StatelessWidget {
  final List<Trip> trips;
  final bool selectionMode;
  final Function(Trip, bool) onSelectionChanged;

  final List<int> selectedTrips;

  const TripsList(
      {super.key,
      required this.trips,
      required this.selectionMode,
      required this.onSelectionChanged,
      required this.selectedTrips});

  @override
  Widget build(BuildContext context) {
    final Trekko trekko = TrekkoProvider.of(context);

    trips.sort((a, b) => b.getStartTime().compareTo(a.getStartTime()));

    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final trip = trips[index];

              if (index == 0 ||
                  !_isSameDay(
                      trips[index - 1].getStartTime(), trip.getStartTime())) {
                return Column(
                  children: [
                    JournalSubtitle(trip.getStartTime()),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: JournalEntry(
                          key: ValueKey(trips[index].id),
                          trip,
                          selectionMode,
                          trekko,
                          isSelected: selectedTrips.contains(trip.id),
                          onSelectionChanged: onSelectionChanged),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: JournalEntry(
                    key: ValueKey(trips[index].id),
                    trip,
                    selectionMode,
                    trekko,
                    isSelected: selectedTrips.contains(trip.id),
                    onSelectionChanged: onSelectionChanged,
                  ),
                );
              }
            },
            childCount: trips.length,
          ),
        ));
  }
}

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
