import 'package:app_backend/controller/builder/authentification_utils.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/profile/battery_usage_setting.dart';
import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:app_backend/model/profile/question_type.dart';
import 'package:app_frontend/screens/profile/setting_picker.dart';
import 'package:flutter/cupertino.dart';
import '../../app_theme.dart';
import 'package:app_backend/model/profile/profile.dart';
import '../../main.dart';
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

  Future<void> _navigateAndEditText(Profile profile,
      OnboardingQuestion question, Function(String) onChange) async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute<String>(
        builder: (BuildContext context) => TextInputPage(question: question,
            trekko: widget.trekko, profile: profile),
      ),
    );
    if (result != null) {
      onChange.call(result);
      widget.trekko.savePreferences(profile.preferences);
    }
  }

  Future <void> _showBatteryUsageSettingPicker(BuildContext context, Profile profile) async {
    List<Widget> batterySettingOptions = BatteryUsageSetting.values.map((setting) {
      return Center(child: Text(setting.name));
    }).toList();

    void onSettingSelected(int selectedIndex) {
      BatteryUsageSetting selectedSetting = BatteryUsageSetting.values[selectedIndex];
      profile.preferences.batteryUsageSetting = selectedSetting;
      widget.trekko.savePreferences(profile.preferences);
    }

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return SettingsPicker(
          onSettingSelected: onSettingSelected,
          children: batterySettingOptions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast100,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Profil'),
          ),
          SliverFillRemaining(
              child: StreamBuilder<Profile>(
            stream: widget.trekko.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Profile profile = snapshot.data!;
                List<CupertinoListTile> questionTiles = [];

                for (OnboardingQuestion question
                    in profile.preferences.onboardingQuestions) {
                  dynamic answer =
                      profile.preferences.getQuestionAnswer(question.key);

                  CupertinoListTile questionTile;
                  if (question.type == QuestionType.boolean) {
                    questionTile = CupertinoListTile.notched(
                      padding: listTilePadding,
                      title: Text(question.title,
                          style: AppThemeTextStyles.normal),
                      trailing: CupertinoSwitch(
                        value: answer == null ? false : answer as bool,
                        // TODO: Fallback falls Wert nicht existiert
                        activeColor: AppThemeColors.green,
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            profile.preferences.setQuestionAnswer(question.key,
                                newValue);
                            widget.trekko.savePreferences(profile.preferences);
                          }
                        },
                      ),
                    );
                  } else if (question.type == QuestionType.select) {
                    // CupertinoListTile mit onTap-Navigation für select-Fragen
                    questionTile = CupertinoListTile.notched(
                      padding: listTilePadding,
                      title: Text(question.title,
                          style: AppThemeTextStyles.normal),
                      additionalInfo: Text(answer ?? "Nicht beantwortet"),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _navigateAndEditText(
                        profile,
                        question,
                        (String value) {
                          profile.preferences
                              .setQuestionAnswer(question.key, value);
                          widget.trekko.savePreferences(profile.preferences);
                        },
                      ),
                    );
                  } else {
                    // Standard-CupertinoListTile mit Chevron und onTap-Navigation
                    questionTile = CupertinoListTile.notched(
                      padding: listTilePadding,
                      title: Text(question.title,
                          style: AppThemeTextStyles.normal),
                      additionalInfo: Text(answer == null
                          ? "Nicht beantwortet"
                          : question.type == QuestionType.number ? answer.toInt().toString() : answer.toString()),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _navigateAndEditText(
                        profile,
                        question,
                        (String value) {
                          profile.preferences
                              .setQuestionAnswer(question.key, value);
                          widget.trekko.savePreferences(profile.preferences);
                        },
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
                          additionalInfo: Text(
                              profile.preferences.batteryUsageSetting.name),
                          onTap: () async {
                            await _showBatteryUsageSettingPicker(context, profile);
                          },
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                        margin: listSectionMargin,
                        additionalDividerMargin: defaultDividerMargin,
                        children:[
                          CupertinoListTile.notched(
                              padding: listTilePadding,
                              title: Text('Abmelden',
                                  style: AppThemeTextStyles.normal.copyWith(
                                    color: AppThemeColors.blue,
                                  )),
                              onTap: () async {
                                await widget.trekko.terminate();
                                runLoginApp();
                              }),
                        ]
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
                            onTap: () async {
                              await widget.trekko.terminate();
                              await AuthentificationUtils.deleteProfile(profile.projectUrl, profile.email);
                              runLoginApp();
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
