import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/onboarding_text_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/onboarding/choose_login_process_screen.dart';
import 'package:trekko_frontend/screens/onboarding/enter_code_screen.dart';
import 'package:trekko_frontend/screens/onboarding/join_project_screen.dart';
import 'package:trekko_frontend/screens/onboarding/questionnaire_screen.dart';
import 'package:trekko_frontend/screens/onboarding/sign_in_screen.dart';
import 'package:trekko_frontend/screens/onboarding/sign_up_screen.dart';
import 'package:trekko_frontend/screens/onboarding/text_info_screen.dart';
import 'package:trekko_frontend/screens/onboarding/welcome_screen.dart';

class LoginApp extends StatelessWidget {
  final Function(Trekko) trekkoCallBack;

  const LoginApp(this.trekkoCallBack, {super.key});

  void launchApp(Trekko trekko) {
    trekkoCallBack.call(trekko);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget Function(BuildContext)> routes = {
      WelcomeScreen.route: (b) => const WelcomeScreen(),
      JoinProjectScreen.route: (b) => const JoinProjectScreen(),
      ChooseLoginProcessScreen.route: (b) => const ChooseLoginProcessScreen(),
      SignInScreen.route: (b) => SignInScreen(trekkoCallBack),
      SignUpScreen.route: (b) => const SignUpScreen(),
      EnterCodeScreen.route: (b) => const EnterCodeScreen(),
      TextInfoScreen.routeAbout: (b) => const TextInfoScreen(
          text: OnboardingTextType.whoText,
          title: "Wer sind wir?",
          nextPage: TextInfoScreen.routeGoal),
      TextInfoScreen.routeGoal: (b) => const TextInfoScreen(
          text: OnboardingTextType.whatText,
          title: "Was wollen\nwir?",
          nextPage: QuestionnaireScreen.route),
      QuestionnaireScreen.route: (b) => QuestionnaireScreen(
            trekkoCallBack,
          ),
    };

    return CupertinoApp(
      home: const WelcomeScreen(),
      theme: AppTheme.lightTheme,
      routes: routes,
    );
  }
}
