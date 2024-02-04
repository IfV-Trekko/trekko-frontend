import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/login/item_divider.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class ChooseLoginProcessScreen extends StatelessWidget {
  final LoginApp app;

  const ChooseLoginProcessScreen(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        app: app,
        title: "Neu hier?",
        buttonTitle: null,
        onButtonPress: null,
        child: Column(
          children: [
            const Text("TODO: Bild"),
            const SizedBox(height: 300,),
            Button(
                title: "Registrieren",
                onPressed: () {
                  Navigator.pushNamed(context, "/login/signUp/");
                }),
            const ItemDivider(),
            Button(
                title: "Anmelden",
                style: ButtonStyle.secondary,
                onPressed: () {
                  Navigator.pushNamed(context, "/login/signIn/");
                }),
          ],
        ));
  }
}
