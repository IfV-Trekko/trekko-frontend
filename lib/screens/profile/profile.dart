import 'package:app_backend/controller/trekko.dart';
import 'package:flutter/cupertino.dart';
import '../../app_theme.dart';
import 'package:app_backend/model/profile/profile.dart';

import 'input_text_screen.dart'; //TODO Warum muss das importiert werden??

class ProfileScreen extends StatefulWidget {
  final Trekko trekko;

  const ProfileScreen(this.trekko, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final double defaultDividerMargin = 2;
  final EdgeInsetsGeometry listTilePadding =
      const EdgeInsets.only(left: 16, right: 16);
  final EdgeInsetsGeometry firstListSectionMargin =
      const EdgeInsets.fromLTRB(16, 16, 16, 16);
  final EdgeInsetsGeometry listSectionMargin =
      const EdgeInsets.fromLTRB(16, 0, 16, 16);

  String batteryUsage = '0%'; //TODO richtig implementieren

  TextInputPage textInputPage = new TextInputPage();

  Future<void> _navigateAndEditText() async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute<String>(
        builder: (BuildContext context) => textInputPage,
      ),
    );

    if (result != null) {
      setState(() {
        batteryUsage = result; // Aktualisieren Sie den Text mit dem Ergebnis
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast100,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text('Profil'),
          ),
          SliverFillRemaining(
              child: StreamBuilder<Profile>(
            stream: widget.trekko.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Profile profile = snapshot.data!;
                List<CupertinoListTile> questionTiles = [];
                for (var question in profile.preferences.onboardingQuestions) {
                  if (question.value != null && question.value!.isNotEmpty) {
                    // Only add a ListTile for answered questions
                    questionTiles.add(CupertinoListTile.notched(
                      padding: listTilePadding,
                      title: Text(question.title,
                          style: AppThemeTextStyles.normal),
                      additionalInfo: Text(question.value!),
                    ));
                  }
                }
                if (questionTiles == null || questionTiles.isEmpty) {
                  questionTiles.add(CupertinoListTile.notched(
                    padding: listTilePadding,
                    title: Text('Keine Fragen beantwortet',
                        style: AppThemeTextStyles.normal),
                  ));
                }

                return Column(
                  children: [
                    CupertinoListSection.insetGrouped(
                      margin: firstListSectionMargin,
                      additionalDividerMargin: defaultDividerMargin,
                      children: [
                        CupertinoListTile.notched(
                          padding: listTilePadding,
                          title:
                              Text('E-Mail', style: AppThemeTextStyles.normal),
                          additionalInfo: Text(profile.email),
                        ),
                        CupertinoListTile.notched(
                          padding: listTilePadding,
                          title: Text('Projekt-URL',
                              style: AppThemeTextStyles.normal),
                          additionalInfo: Text(profile.projectUrl),
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      margin: listSectionMargin,
                      additionalDividerMargin: defaultDividerMargin,
                      children: questionTiles,
                    ),
                    CupertinoListSection.insetGrouped(
                      margin: listSectionMargin,
                      additionalDividerMargin: defaultDividerMargin,
                      children: [
                        CupertinoListTile.notched(
                          padding: listTilePadding,
                          title: Text('Batterieverbrauch',
                              style: AppThemeTextStyles
                                  .normal), //TODO richtig implementieren
                          additionalInfo: Text(batteryUsage),
                          trailing: const CupertinoListTileChevron(),
                          onTap: _navigateAndEditText, // Ändern Sie die onTap-Funktion
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const CupertinoActivityIndicator();
            },
          )),
        ],
      ),
    );
  }
}

