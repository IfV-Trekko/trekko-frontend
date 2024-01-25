import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/profile/battery_usage_setting.dart';
import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:app_backend/model/profile/question_type.dart';
import 'package:flutter/cupertino.dart';
import '../../app_theme.dart';
import 'package:app_backend/model/profile/profile.dart';
import 'input_text_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Trekko trekko;

  const ProfileScreen(this.trekko, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final double defaultDividerMargin = 2;
  final EdgeInsetsGeometry listTilePadding =
      const EdgeInsets.only(left: 16, right: 16);
  final EdgeInsetsGeometry firstListSectionMargin =
      const EdgeInsets.fromLTRB(16, 16, 16, 16);
  final EdgeInsetsGeometry listSectionMargin =
      const EdgeInsets.fromLTRB(16, 0, 16, 16);

  Future<void> _navigateAndEditText(Profile profile, OnboardingQuestion question, Function(String) onChange) async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute<String>(
        builder: (BuildContext context) =>
            TextInputPage(question: question),
      ),
    );
    if (result != null) {
      onChange.call(result);
      widget.trekko.savePreferences(profile.preferences);
    }
  }

  Future<void> _showBatteryUsageSettingPicker(BuildContext context, Profile profile) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        int selectedIndex = BatteryUsageSetting.values.indexOf(profile.preferences.batteryUsageSetting);
        return CupertinoActionSheet(
          actions: <Widget>[
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32,
                onSelectedItemChanged: (int index) {
                  selectedIndex = index;
                },
                children: List<Widget>.generate(
                  BatteryUsageSetting.values.length,
                      (int index) {
                    return Center(
                      child: Text(BatteryUsageSetting.values[index].name),
                    );
                  },
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Fertig'),
            onPressed: () {
              Navigator.pop(context);
              _updateBatteryUsageSetting(profile, BatteryUsageSetting.values[selectedIndex]);
            },
          ),
        );
      },
    );
  }

  void _updateBatteryUsageSetting(Profile profile, BatteryUsageSetting setting) {
    // Aktualisieren Sie hier die Einstellung und speichern Sie die Änderungen
    profile.preferences.batteryUsageSetting = setting;
    // Optional: Aktualisieren Sie den State, um die Änderung im UI anzuzeigen
    setState(() {});
    widget.trekko.savePreferences(profile.preferences); //TODO: saving of settings
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

                for (OnboardingQuestion question in profile.onboardingQuestions) {
                  String? answer = profile.preferences.getQuestionAnswer(question.key);
                  answer ??= 'Nicht beantwortet';

                  CupertinoListTile questionTile;

                  if (question.type == QuestionType.boolean) {
                    // CupertinoSwitch für boolean Fragen
                    bool switchValue = answer.toLowerCase() == 'true';
                    questionTile = CupertinoListTile.notched(
                      padding: listTilePadding,
                      title: Text(question.title,
                          style: AppThemeTextStyles.normal),
                      trailing: CupertinoSwitch(
                        value: switchValue,
                        activeColor: AppThemeColors.green,
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            setState(() {
                              switchValue = newValue; // Aktualisiere den lokalen Zustand des Schalters
                            });
                            profile.preferences.setQuestionAnswer(
                                question.key, newValue.toString()); //TODO: implement change of answer
                          }
                        },
                      ),
                    );
                  } else {
                    // Standard-CupertinoListTile mit Chevron und onTap-Navigation
                    questionTile = CupertinoListTile.notched(
                      padding: listTilePadding,
                      title: Text(question.title,
                          style: AppThemeTextStyles.normal),
                      additionalInfo: Text(question.type.toString()),//Text(answer),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _navigateAndEditText(profile, question,
                        (String value) => profile.preferences
                            .setQuestionAnswer(question.key, value),
                      ),
                    );
                  }
                  questionTiles.add(questionTile);
                }
                if (questionTiles.isEmpty) {
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
                          title: Text('Akkunutzung',
                              style: AppThemeTextStyles.normal),
                          additionalInfo: Text(profile.preferences.batteryUsageSetting.name), //TODO: implement change of usage setting
                          onTap: () async {
                            await _showBatteryUsageSettingPicker(context, profile);
                          },
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      margin: listSectionMargin,
                      additionalDividerMargin: defaultDividerMargin,
                      children: [
                        CupertinoListTile.notched(
                            padding: listTilePadding,
                            title: Text('Profil & Daten löschen',
                                style: AppThemeTextStyles.normal.copyWith(
                                  color: AppThemeColors.red,
                                )),
                            onTap: () {
                              //TODO: implement delete profile
                            }),
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
