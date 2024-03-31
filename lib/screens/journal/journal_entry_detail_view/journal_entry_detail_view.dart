import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view_wrapper.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class JournalEntryDetailView extends StatefulWidget {
  final Trip trip;

  const JournalEntryDetailView(this.trip, {super.key});

  @override
  State<JournalEntryDetailView> createState() => _JournalEntryDetailViewState();
}

class _JournalEntryDetailViewState extends State<JournalEntryDetailView> {
  @override
  Widget build(BuildContext context) {
    final Trekko trekko = TrekkoProvider.of(context);

    return StreamBuilder(
        stream: trekko
            .getTripQuery()
            .idEqualTo(widget.trip.id)
            .watch(fireImmediately: true)
            .map((event) => event.first),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Trip trip = snapshot.data!;
            return JournalEntryDetailViewWrapper(trip: trip);
          } else if (snapshot.hasError) {
            return const Center(child: Text("Fehler beim Laden der Daten"));
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        });
  }
}
