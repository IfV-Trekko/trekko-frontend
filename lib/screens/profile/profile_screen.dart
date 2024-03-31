import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/profile/battery_usage_setting.dart';
import 'package:trekko_backend/model/tracking_state.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/picker/setting_picker.dart';
import 'package:trekko_frontend/main.dart';
import 'package:trekko_frontend/screens/profile/question_tiles_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/profile/profile.dart';

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

  Future<BatteryUsageSetting?> showBatteryUsageSettingPicker(
      BuildContext context, Profile profile) async {
    BatteryUsageSetting? temporarySelection;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return SettingsPicker(
          onSettingSelected: (int selectedIndex) {
            temporarySelection = BatteryUsageSetting.values[selectedIndex];
          },
          children: BatteryUsageSetting.values
              .map((setting) => Center(child: Text(setting.name)))
              .toList(),
        );
      },
    );

    return temporarySelection;
  }

  void _askForPermission(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Unwiderruflich Löschen?'),
              content: const Text(
                  'Möchten Sie ihr Profil mit deinen Daten wirklich unwiderruflich löschen? Dieser Schritt kann nicht rückgängig gemacht werden. Sind Sie sicher, dass Sie fortfahren möchten?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Abbrechen'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Löschen'),
                  onPressed: () async {
                    await widget.trekko.signOut(delete: true);
                    runLoginApp();

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ));
  }

  void _updateDialog(BuildContext context, Profile profile,
      BatteryUsageSetting previousSetting, BatteryUsageSetting? newSetting) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Akkunutzungseinstellung geändert'),
          content: const Text(
              'Damit Ihre Änderung wirksam wird, muss die Erhebung neu gestartet werden.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () async {
                if (newSetting != null) {
                  profile.preferences.batteryUsageSetting = newSetting;
                  widget.trekko.savePreferences(profile.preferences);
                  await widget.trekko.setTrackingState(TrackingState.paused);
                  await widget.trekko.setTrackingState(TrackingState.running);
                }
                if (!mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
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
                          additionalInfo: SizedBox(
                            width: 250,
                            child: Text(profile.email,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end),
                          ),
                        ),
                        CupertinoListTile.notched(
                          padding: listTilePadding,
                          title: Text('Projekt-URL',
                              style: AppThemeTextStyles.normal),
                          additionalInfo: SizedBox(
                            width: 250,
                            child: Text(profile.projectUrl,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end),
                          ),
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
                            BatteryUsageSetting previousSetting =
                                profile.preferences.batteryUsageSetting;
                            BatteryUsageSetting? newSetting =
                                await showBatteryUsageSettingPicker(
                                    context, profile);
                            if (newSetting != null &&
                                newSetting != previousSetting) {
                              _updateDialog(context, profile, previousSetting,
                                  newSetting);
                            }
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
                                await widget.trekko.signOut();
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
                              _askForPermission(context);
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
