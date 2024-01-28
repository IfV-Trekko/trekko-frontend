import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view_description.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view_details.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view_edit_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class JournalEntryDetailView extends StatelessWidget {
  final Stream<Trip> trip;

  const JournalEntryDetailView(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast150,
      navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
              previousPageTitle: 'Tagebuch',
              onPressed: () {
                Navigator.of(context).pop();
              }),
          middle: Text('Wege'),
          trailing: Button(
            stretch: false,
            title: 'Spenden',
            onPressed: () {},
            size: ButtonSize.small,
            style: ButtonStyle.primary,
          )),
      child: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 261, //TODO nicht clean
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  //
                  //
                  //
                  //TODO Placeholder for Map
                  Container(
                    height: 234,
                    color: AppThemeColors.blue,
                    child: Center(
                      child: Text(
                          'Kinder: kleine Energiebündel 🏃💫, Meister der Kreativität 🎨✨ und Experten im Herzen-Erwärmen 💖🌟'),
                    ),
                    //
                    //
                    //
                  ),
                  JournalEntryDetailViewDescription(
                      startingPoint: 'Europaplatz', //TODO: Daten aus Trip holen
                      endpoint: 'Ettlingen',
                      startDate: 'Fr., 09 Nov 2023',
                      endDate: 'Fr., 09 Nov 2023'),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppThemeColors.contrast700, //TODO: Farbe anpassen
                  ),
                  JournalEntryDetailViewDetails(),
                  // Expanded(child: JournalEntryDetailViewDetails())
                ])),
          ),
          JournalEntryDetailViewEditContext(),
        ],
      )),
    );
  }
}
