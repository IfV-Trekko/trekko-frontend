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
              Container(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CupertinoDatePicker(
                                onDateTimeChanged: (value) {},
                                initialDateTime: null,
                              ), //TODO auslagern und implementieren
                            ],
                          ),
                          //TODO implement PathShowcase
                          // JournalEntryDetailViewDescription(
                          //     //TODO implement
                        ],
                      ),
                    ),
                    Container(
                        child: Column(
                      children: [
                        CupertinoListSection.insetGrouped(children: [
                          CupertinoListTile.notched(
                            title: Text('Anlass / Zweck',
                                style: AppThemeTextStyles.normal),
                            trailing: const CupertinoListTileChevron(),
                            additionalInfo: CupertinoPicker(
                              itemExtent: 32,
                              children: [
                                Text('Arbeit'),
                                Text('Einkaufen'),
                                Text('Freizeit'),
                                Text('Sonstiges')
                              ],
                              onSelectedItemChanged: (value) {},
                            ),
                          ),
                          CupertinoListTile.notched(
                            title: Text('Verkehrsmittel',
                                style: AppThemeTextStyles.normal),
                            trailing:
                                const CupertinoListTileChevron(), //TODO change icons and implement heroicons
                            additionalInfo: CupertinoPicker(
                              itemExtent: 32,
                              children: [
                                Text('Zu Fuß'),
                                Text('Fahrrad'),
                                Text('ÖPNV'),
                                Text('Auto'),
                                Text('Sonstiges')
                              ], //TODO add icons
                              onSelectedItemChanged: (value) {},
                            ),
                          ),
                        ]),
                        CupertinoListSection.insetGrouped(children: [
                          CupertinoListTile.notched(
                            title: Text('Kommentar',
                                style: AppThemeTextStyles.normal),
                            additionalInfo: CupertinoTextField(
                              placeholder: 'Kommentar',
                              maxLines: 10,
                            ),
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
                        child: CupertinoContextMenu(
                          actions: <Widget>[
                            CupertinoContextMenuAction(
                              onPressed: () {
                                Navigator.pop(context); //TODO implement Backend
                              },
                              isDefaultAction: true,
                              trailingIcon: CupertinoIcons
                                  .doc_on_clipboard_fill, //TODO change icons
                              child: const Text('Spende zurückziehen'),
                            ),
                            CupertinoContextMenuAction(
                              onPressed: () {
                                Navigator.pop(context); //TODO implement Backend
                              },
                              isDestructiveAction: true,
                              trailingIcon: CupertinoIcons
                                  .delete, //TODO change icons and implement heroicons
                              child: const Text('Unwideruflich löschen'),
                            ),
                          ],
                          child: Button(
                              style: ButtonStyle.secondary,
                              title: '',
                              icon: HeroIcons.squares2x2, //TODO change icons
                              onPressed: () {}),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
