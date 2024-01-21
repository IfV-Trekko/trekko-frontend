import 'package:app_backend/controller/builder/build_exception.dart';
import 'package:app_backend/controller/builder/login_builder.dart';
import 'package:app_backend/controller/builder/login_result.dart';
import 'package:app_backend/controller/builder/registration_builder.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/analysis/analysis.dart';
import 'package:app_frontend/screens/journal/journal.dart';
import 'package:app_frontend/screens/profile/profile.dart';
import 'package:app_frontend/screens/tracking/tracking.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

void main() async {
  try {
    Trekko trekko = await LoginBuilder("http://10.0.2.2:8080", "realAccount1@web.de", "1aA!hklj32r4hkjl324ra").build();
    runApp(TrekkoApp(trekko: trekko));
  } catch (e) {
    if (e is BuildException) {
      if (e.reason == LoginResult.failedNoSuchUser) {
        try {
          runApp(TrekkoApp(trekko: await RegistrationBuilder("http://10.0.2.2:8080", "realAccount1@web.de", "1aA!hklj32r4hkjl324ra", "1aA!hklj32r4hkjl324ra", "12345").build()));
        } catch (e) {
          print((e as BuildException).reason);
        }
      }
    }
    rethrow;
  }
}

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
  _TrekkoAppState createState() => _TrekkoAppState();
}

class _TrekkoAppState extends State<TrekkoApp> {
  final CupertinoTabController controller = CupertinoTabController();

  late List<Screen> screens;

  Screen get currentScreen => screens[controller.index];

  @override
  Widget build(BuildContext context) {
    screens = [
      Screen('Erhebung', HeroIcons.play, Tracking()),
      Screen('Tagebuch', HeroIcons.queueList, Journal()),
      Screen('Statistik', HeroIcons.chartPie, Analysis()),
      Screen('Profil', HeroIcons.userCircle, ProfileScreen(super.widget.trekko)),
    ];
    return CupertinoApp(
      title: 'Trekko',
      theme: AppTheme.lightTheme,
      home: CupertinoTabScaffold(
        controller: controller,
        tabBar: CupertinoTabBar(
          onTap: (index) {
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
          return currentScreen.screen;
        },
    ));
  }
}

