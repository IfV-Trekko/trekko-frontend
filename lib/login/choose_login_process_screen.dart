import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/login/item_divider.dart';
import 'package:app_frontend/login/sign_in_screen.dart';
import 'package:app_frontend/login/sign_up_screen.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class ChooseLoginProcessScreen extends StatelessWidget {
  static const String route = "/login/how/";

  const ChooseLoginProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        title: "Neu hier?",
        buttonTitle: null,
        onButtonPress: null,
        child: Column(
          children: [
            const HeroIcon(
              HeroIcons.user,
              // kp wie das original logo heißt dieses goofy ass logo muss aber erstmal reichen
              size: 250,
            ),
            const SizedBox(
              height: 100,
            ),
            Button(
                title: "Registrieren",
                onPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.route,
                      arguments:
                          ModalRoute.of(context)!.settings.arguments as String);
                }),
            const ItemDivider(),
            Button(
                title: "Anmelden",
                style: ButtonStyle.secondary,
                onPressed: () {
                  Navigator.pushNamed(context, SignInScreen.route,
                      arguments:
                          ModalRoute.of(context)!.settings.arguments as String);
                }),
          ],
        ));
  }
}
