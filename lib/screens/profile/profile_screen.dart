import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:heroicons/heroicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/profile/profile.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/main.dart';
import 'package:trekko_frontend/screens/debug/debug_screen.dart';
import 'package:trekko_frontend/screens/profile/question_tiles_section.dart';
import 'package:trekko_frontend/screens/profile/settings/settings_screen.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
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

  void _askForPermission(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
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
                    await TrekkoProvider.of(context).signOut(delete: true);
                    runLoginApp();

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Trekko trekko = TrekkoProvider.of(context);
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast100,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: CupertinoSliverNavigationBar(
                largeTitle: const Text('Profil'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (kDebugMode)
                      CupertinoButton(
                        child: const HeroIcon(HeroIcons.bugAnt),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const DebugScreen(),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Builder(builder: (BuildContext context) {
          return StreamBuilder<Profile>(
            stream: trekko.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Profile profile = snapshot.data!;

                return CustomScrollView(
                  slivers: [
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverToBoxAdapter(
                        child: CupertinoListSection.insetGrouped(
                          margin: firstListSectionMargin
                              .subtract(const EdgeInsets.only(bottom: 16)),
                          additionalDividerMargin: defaultDividerMargin,
                          children: [
                            CupertinoListTile.notched(
                              padding: listTilePadding,
                              title:
                              Text('E-Mail', style: AppThemeTextStyles.normal),
                              additionalInfo: Text(
                                  profile.isOnline()
                                      ? profile.email
                                      : "Keine E-Mail",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end),
                            ),
                            CupertinoListTile.notched(
                              padding: listTilePadding,
                              title: Text('Projekt-URL',
                                  style: AppThemeTextStyles.normal),
                              additionalInfo: Text(
                                  profile.isOnline()
                                      ? profile.projectUrl
                                      : "Keine Projekt-URL",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end),
                            ),
                          ],
                        )),
                    SliverToBoxAdapter(
                        child: QuestionTilesSection(trekko: trekko)),
                    SliverToBoxAdapter(
                        child: CupertinoListSection.insetGrouped(
                          margin: listSectionMargin,
                          additionalDividerMargin: defaultDividerMargin,
                          children: [
                            CupertinoListTile.notched(
                              padding: listTilePadding,
                              title: Text('Einstellungen',
                                  style: AppThemeTextStyles.normal),
                              // Icon that indicates that the user can navigate to the settings
                              additionalInfo: const HeroIcon(
                                  HeroIcons.chevronRight,
                              color: AppThemeColors.contrast400),
                              onTap: () async {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      builder: (
                                          context) => const SettingsScreen()),
                                );
                              },
                            ),
                          ],
                        )),
                    SliverToBoxAdapter(
                        child: CupertinoListSection.insetGrouped(
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
                                    await trekko.signOut();
                                    runLoginApp();
                                  }),
                            ])),
                    SliverToBoxAdapter(
                        child: CupertinoListSection.insetGrouped(
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
                        )),
                    SliverToBoxAdapter(
                      child: FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                                padding: listTilePadding,
                                child: Text(
                                    'Version ${snapshot.data!
                                        .version}+${snapshot.data!
                                        .buildNumber}',
                                    textAlign: TextAlign.center,
                                    style: AppThemeTextStyles.normal.copyWith(
                                      color: AppThemeColors.contrast700,
                                      fontSize: 12,
                                    )));
                          }
                          return const CupertinoActivityIndicator();
                        },
                      ),
                    )
                  ],
                );
              }
              return const CupertinoActivityIndicator();
            },
          );
        }),
      ),
    );
  }
}
