import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class JoinProjectScreen extends StatelessWidget {
  final LoginApp app;

  const JoinProjectScreen(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        app: app,
        child: Column(
          children: [
            Text("Projekt-URL",
                style: AppThemeTextStyles.normal),
            CupertinoTextField(
              placeholder: "Projekt-URL",
              onSubmitted: (url) {
                // TODO: Ping url

              },
            )
          ],
        ),
        title: "Projekt beitreten",
        buttonTitle: "Registrieren",
        onButtonPress: () async {
          Navigator.pushNamed(context, "/login/signIn");
        });
  }
}
