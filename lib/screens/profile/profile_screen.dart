import 'package:app_backend/controller/builder/authentification_utils.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/profile/battery_usage_setting.dart';
import 'package:app_backend/model/tracking_state.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/picker/setting_picker.dart';
import 'package:app_frontend/main.dart';
import 'package:app_frontend/screens/profile/question_tiles_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_backend/model/profile/profile.dart';

class ProfileScreen extends StatefulWidget {
  final Trekko trekko;

  const ProfileScreen(this.trekko, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  Profile? toDelete;

  @override
  bool get wantKeepAlive => true;

  final double defaultDividerMargin = 2;
  final EdgeInsetsGeometry listTilePadding =
      const EdgeInsets.only(left: 16, right: 16);
  final EdgeInsetsGeometry firstListSectionMargin =
      const EdgeInsets.fromLTRB(16, 16, 16, 16);
  final EdgeInsetsGeometry listSectionMargin =
      const EdgeInsets.fromLTRB(16, 0, 16, 16);

  Future<void> showBatteryUsageSettingPicker(
      BuildContext context, Profile profile) async {
    List<Widget> batterySettingOptions =
        BatteryUsageSetting.values.map((setting) {
      return Center(child: Text(setting.name));
    }).toList();

    void onSettingSelected(int selectedIndex) {
      BatteryUsageSetting selectedSetting =
          BatteryUsageSetting.values[selectedIndex];
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
  void dispose() {
    if (toDelete != null) {
      // Currently doing nothing
      AuthentificationUtils.deleteProfile(
          toDelete!.projectUrl, toDelete!.email);
    }
    super.dispose();
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
                List<CupertinoListTile> questionTiles =
                    QuestionTilesBuilder.buildQuestionTiles(
                  context: context,
                  profile: profile,
                  trekko: widget.trekko,
                  padding: listTilePadding,
                );
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
                          onTap: () {
                            BatteryUsageSetting previousSetting =
                                profile.preferences.batteryUsageSetting;
                            showBatteryUsageSettingPicker(context, profile)
                                .then((value) => updateDialog(
                                    context, profile, previousSetting));
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
                              title: Text('Abmelden',
                                  style: AppThemeTextStyles.normal.copyWith(
                                    color: AppThemeColors.blue,
                                  )),
                              onTap: () async {
                                runLoginApp();
                              }),
                        ]),
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
                              _askForPermission(context, profile);
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

  void _askForPermission(BuildContext context, Profile profile) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Unwiderruflich Löschen?'),
              content: const Text(
                  'Möchten Sie ihr Profil mit deinen Daten wirklich unwiderruflich löschen? Dieser Schritt kann nicht rückgängig gemacht werden. Sind Sie sicher, dass Sie fortfahren möchten?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Abbrechen'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Löschen'),
                  onPressed: () {
                    toDelete = profile;
                    runLoginApp();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  void updateDialog(BuildContext context, Profile profile,
      BatteryUsageSetting previousSetting) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Akkunutzungseinstellung geändert'),
          content: const Text(
              'Damit ihre Änderung wirksam wird muss die Erhbung neu gestartet werden.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: Text('Abbrechen'),
              onPressed: () {
                profile.preferences.batteryUsageSetting = previousSetting;
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                widget.trekko.setTrackingState(TrackingState.paused);
                widget.trekko.setTrackingState(TrackingState.running);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
