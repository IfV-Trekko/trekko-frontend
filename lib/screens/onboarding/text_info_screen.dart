import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/onboarding_text_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/onboarding/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class TextInfoScreen extends StatelessWidget {
  static const String routeAbout = "/login/about/";
  static const String routeGoal = "/login/goal/";

  final String title;
  final OnboardingTextType text;
  final String nextPage;

  const TextInfoScreen(
      {super.key,
      required this.title,
      required this.text,
      required this.nextPage});

  @override
  Widget build(BuildContext context) {
    Trekko trekko = ModalRoute.of(context)!.settings.arguments as Trekko;
    return SimpleOnboardingScreen(
        title: title,
        buttonTitle: "Weiter",
        onButtonPress: () async {
          Navigator.pushNamed(context, nextPage,
              arguments: ModalRoute.of(context)!.settings.arguments as Trekko);
        },
        child: FutureBuilder(
            future: trekko.loadText(text),
            builder: (context, data) {
              if (data.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    data.data!,
                    style: AppThemeTextStyles.normal.copyWith(fontSize: 18),
                  ),
                );
              } else if (data.hasError) {
                return const Text("Fehler beim Laden");
              }
              return const CupertinoActivityIndicator();
            }));
  }
}
