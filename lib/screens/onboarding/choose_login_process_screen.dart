import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_style.dart';
import 'package:trekko_frontend/screens/onboarding/item_divider.dart';
import 'package:trekko_frontend/screens/onboarding/sign_in_screen.dart';
import 'package:trekko_frontend/screens/onboarding/sign_up_screen.dart';
import 'package:trekko_frontend/screens/onboarding/simple_onboarding_screen.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeroIcon(
              HeroIcons.user,
              size: 250,
              color: AppThemeColors.contrast900,
            ),
            const SizedBox(
              height: 100,
            ), //TODO: Add a better spacing
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
