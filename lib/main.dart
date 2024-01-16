import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/analysis/analysis.dart';
import 'package:app_frontend/screens/journal/journal.dart';
import 'package:app_frontend/screens/profile/profile.dart';
import 'package:app_frontend/screens/tracking/tracking.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

void main() {
  runApp(TrekkoApp());
}

class Screen {
  final String title;
  final HeroIcons icon;
  final Widget screen;

  Screen(this.title, this.icon, this.screen);
}

class TrekkoApp extends StatefulWidget {
  final List<Screen> screens = [
    Screen('Erhebung', HeroIcons.play, Tracking()),
    Screen('Tagebuch', HeroIcons.queueList, Journal()),
    Screen('Statistik', HeroIcons.chartPie, Analysis()),
    Screen('Profil', HeroIcons.userCircle, Profile()),
  ];

  @override
  _TrekkoAppState createState() => _TrekkoAppState();
}

class _TrekkoAppState extends State<TrekkoApp> {
  final CupertinoTabController controller = CupertinoTabController();

  Screen get currentScreen => super.widget.screens[controller.index];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Trekko',
      theme: AppTheme.lightTheme,
      home: CupertinoTabScaffold(
        controller: controller,
        tabBar: CupertinoTabBar(
          onTap: (index) {
            setState(() {});
          },
          items: super
              .widget
              .screens
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
          return currentScreen.screen;
        },
    ));
  }
}

