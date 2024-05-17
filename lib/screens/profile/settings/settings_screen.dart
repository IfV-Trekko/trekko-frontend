import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/profile/battery_usage_setting.dart';
import 'package:trekko_backend/model/profile/profile.dart';
import 'package:trekko_backend/model/tracking_state.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/picker/setting_picker.dart';
import 'package:trekko_frontend/components/pop_up_utils.dart';
import 'package:trekko_frontend/components/tile_utils.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _updateDialog(Trekko trekko, BuildContext context, Profile profile,
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
                  await _saveBatterySetting(trekko, profile, newSetting);
                  await trekko.setTrackingState(TrackingState.paused);
                  await trekko.setTrackingState(TrackingState.running);
                }
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _saveBatterySetting(
      Trekko trekko, Profile profile, BatteryUsageSetting setting) async {
    profile.preferences.batteryUsageSetting = setting;
    await trekko.savePreferences(profile.preferences);
  }

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

  @override
  Widget build(BuildContext context) {
    Trekko trekko = TrekkoProvider.of(context);
    return CupertinoPageScaffold(
        backgroundColor: AppThemeColors.contrast100,
        child: CustomScrollView(slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Einstellungen'),
          ),
          SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
            margin: EdgeInsets.zero,
            children: <Widget>[
              CupertinoListSection.insetGrouped(
                margin: TileUtils.listSectionMargin,
                additionalDividerMargin: TileUtils.defaultDividerMargin,
                children: [
                  CupertinoListTile.notched(
                    padding: TileUtils.listTilePadding,
                    title: Text('Alle Wegedaten exportieren',
                        style: AppThemeTextStyles.normal),
                    onTap: () async {
                      await trekko.export(trekko.getTripQuery());
                      PopUpUtils.showPopUp(context, 'Export erfolgreich',
                          'Ihre Daten wurden erfolgreich exportiert.');
                    },
                  ),
                  CupertinoListTile.notched(
                    padding: TileUtils.listTilePadding,
                    title: Text('Wegedaten importieren',
                        style: AppThemeTextStyles.normal),
                    onTap: () async {
                      trekko.import();
                      PopUpUtils.showPopUp(context, 'Import erfolgreich',
                          'Ihre Daten wurden erfolgreich importiert.');
                    },
                  )
                ],
              ),
              StreamBuilder(
                  stream: trekko.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Profile profile = snapshot.data!;
                      return CupertinoListSection.insetGrouped(
                        margin: TileUtils.listSectionMargin,
                        children: [
                          CupertinoListTile.notched(
                            padding: TileUtils.listTilePadding,
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
                              if (newSetting == null ||
                                  newSetting == previousSetting) return;
                              if (await trekko.getTrackingState().first ==
                                  TrackingState.paused) {
                                _saveBatterySetting(
                                    trekko, profile, newSetting);
                              } else if (context.mounted) {
                                _updateDialog(trekko, context, profile,
                                    previousSetting, newSetting);
                              }
                            },
                          ),
                        ],
                      );
                    }
                    return const CupertinoActivityIndicator();
                  })
            ],
          )),
        ]));
  }
}
