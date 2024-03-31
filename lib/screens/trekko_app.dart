import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/analysis/analysis.dart';
import 'package:trekko_frontend/screens/journal/journal.dart';
import 'package:trekko_frontend/screens/profile/profile_screen.dart';
import 'package:trekko_frontend/screens/tracking/tracking.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class Screen {
  final String title;
  final HeroIcons icon;
  final Widget screen;

  Screen(this.title, this.icon, this.screen);
}

class TrekkoApp extends StatefulWidget {
  final Trekko trekko;

  const TrekkoApp({super.key, required this.trekko});

  @override
  TrekkoAppState createState() => TrekkoAppState();
}

class TrekkoAppState extends State<TrekkoApp> {
  final CupertinoTabController controller = CupertinoTabController();

  late List<Screen> screens;

  Screen get currentScreen => screens[controller.index];

  @override
  void initState() {
    super.initState();
    screens = [
      Screen('Erhebung', HeroIcons.play,
          TrackingScreen(trekko: super.widget.trekko)),
      Screen('Tagebuch', HeroIcons.queueList, const JournalScreen()),
      Screen('Statistik', HeroIcons.chartPie, Analysis(super.widget.trekko)),
      Screen(
          'Profil', HeroIcons.userCircle, ProfileScreen(super.widget.trekko)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Trekko',
      theme: AppTheme.lightTheme,
      home: TrekkoProvider(
          trekko: widget.trekko,
          child: CupertinoTabScaffold(
            controller: controller,
            tabBar: CupertinoTabBar(
              backgroundColor: AppThemeColors.contrast0,
              onTap: (index) {
                // This is to make the widget refresh to update the icon state
                setState(() {});
              },
              items: screens
                  .map((e) => BottomNavigationBarItem(
                        icon: HeroIcon(
                          e.icon,
                          size: 24,
                          style: currentScreen == e
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                        ),
                        label: e.title,
                      ))
                  .toList(),
            ),
            tabBuilder: (context, index) {
              return IndexedStack(
                index: index,
                children: screens
                    .map((e) => CupertinoTabView(
                          builder: (context) {
                            return e.screen;
                          },
                        ))
                    .toList(),
              );
            },
          )),
    );
  }
}
