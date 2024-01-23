import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class JournalEntryDetailView extends StatelessWidget {
  final Stream<Trip> trip;

  const JournalEntryDetailView(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppThemeColors.contrast100,
        navigationBar: CupertinoNavigationBar(
            leading: CupertinoNavigationBarBackButton(
              previousPageTitle: 'Tagebuch',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                        height: 234,
                        color: AppThemeColors.blue,
                        child: Center(
                          child: Text(
                              'Kinder: kleine Energiebündel 🏃💫, Meister der Kreativität 🎨✨ und Experten im Herzen-Erwärmen 💖🌟'),
                        )),
                    Container(
                      padding: EdgeInsets.all(16),
                      color: AppThemeColors.orange,
                    ),
                    Container(
                        child: Column(
                      children: [
                        CupertinoListSection.insetGrouped(children: [
                          CupertinoListTile.notched(
                            title: Text('Anlass / Zweck',
                                style: AppThemeTextStyles.normal),
                            additionalInfo: Text('Arbeit'),
                          ),
                          CupertinoListTile.notched(
                            title: Text('Verkehrsmittel',
                                style: AppThemeTextStyles.normal),
                            additionalInfo: Text('Auto'),
                          ),
                        ]),
                        CupertinoListSection.insetGrouped(children: [
                          CupertinoListTile.notched(
                            title: Text('Kommentar',
                                style: AppThemeTextStyles.normal),
                            additionalInfo: Text('AHHHHHHHHH'),
                          ),
                        ])
                      ],
                    ))
                  ],
                )),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppThemeColors.contrast0,
                  border: Border(
                    top: BorderSide(
                      color: AppThemeColors.contrast150,
                      width: 1,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: Button(title: 'Spenden', onPressed: () {})),
                    SizedBox(width: 8),
                    Container(
                      width: 48,
                      child: Button(
                          style: ButtonStyle.secondary,
                          title: '',
                          icon: HeroIcons.squares2x2, //TODO change icons
                          onPressed: () {}),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
