import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class WelcomeScreen extends StatelessWidget {
  final LoginApp app;

  const WelcomeScreen(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
      app: app,
      title: 'Willkommen\nbei\n TREKKO',
      buttonTitle: 'Beginnen',
      onButtonPress: () async {
        Navigator.pushNamed(context, "/login/project/");
      },
      child: const Column(
        children: [
          Text("Eine App des Institut für\nVerkehrswesen am KIT",
              textAlign: TextAlign.center),
          Text("TODO: LOGO"),
        ],
      ),
    );
  }
}
