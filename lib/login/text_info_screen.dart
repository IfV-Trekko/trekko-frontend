import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class TextInfoScreen extends StatelessWidget {
  final LoginApp app;
  final String title;
  final Future<String> text;
  final String nextPage;

  const TextInfoScreen(this.app,
      {super.key, required this.title, required this.text, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(app: app,
        title: title,
        buttonTitle: "Weiter",
        onButtonPress: () async {
          Navigator.pushNamed(context, nextPage);
        },
        child: FutureBuilder(future: text, builder: (context, data) {
          if (data.hasData) {
            return Text(
              data.data!,
              style: AppThemeTextStyles.normal,
            );
          } else if (data.hasError) {
            return Text("Fehler beim Laden");
          }
          return CupertinoActivityIndicator();
        }));
  }
}
