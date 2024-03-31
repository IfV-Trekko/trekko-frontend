import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/onboarding/join_project_screen.dart';
import 'package:trekko_frontend/screens/onboarding/simple_onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String route = "/login/welcome/";

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
      title: 'Willkommen\nbei\n TREKKO',
      buttonTitle: 'Beginnen',
      onButtonPress: () async {
        Navigator.pushNamed(context, JoinProjectScreen.route);
      },
      child: Column(
        children: [
          Text(
            "Eine App des Institut für\nVerkehrswesen am KIT",
            textAlign: TextAlign.center,
            style: AppThemeTextStyles.normal,
          ),
          const SizedBox(height: 100),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/IfV.png", width: 82, height: 87),
              const SizedBox(width: 50),
              Image.asset("assets/images/KIT.png", width: 141, height: 66),
            ],
          )
        ],
      ),
    );
  }
}
