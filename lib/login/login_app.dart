import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/onboarding_text_type.dart';
import 'package:app_frontend/login/choose_login_process_screen.dart';
import 'package:app_frontend/login/enter_code_screen.dart';
import 'package:app_frontend/login/join_project_screen.dart';
import 'package:app_frontend/login/questionnaire_screen.dart';
import 'package:app_frontend/login/sign_in_screen.dart';
import 'package:app_frontend/login/sign_up_screen.dart';
import 'package:app_frontend/login/text_info_screen.dart';
import 'package:app_frontend/login/welcome_screen.dart';
import 'package:flutter/cupertino.dart';

class LoginApp extends StatelessWidget {
  final Function(Trekko) trekkoCallBack;
  String? projectUrl;
  Trekko? trekko;

  LoginApp(this.trekkoCallBack, {super.key});

  void launchApp() {
    trekkoCallBack.call(trekko!);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Clean this up
    Map<String, Widget Function(BuildContext)> routes = {
      "/login/welcome/": (b) => WelcomeScreen(this),
      "/login/project/": (b) => JoinProjectScreen(this),
      "/login/how/": (b) => ChooseLoginProcessScreen(this),
      "/login/signIn/": (b) => SignInScreen(this),
      "/login/signUp/": (b) => SignUpScreen(this),
      "/login/enterCode/": (b) => EnterCodeScreen(this),
      "/login/about/": (b) => TextInfoScreen(this,
          text: trekko!.loadText(OnboardingTextType.whoText),
          title: "Wer sind wir?",
          nextPage: "/login/goal/"),
      "/login/goal/": (b) => TextInfoScreen(this,
          text: trekko!.loadText(OnboardingTextType.whatText),
          title: "Was wollen\nwir?",
          nextPage: "/login/questionnaire/"),
      "/login/questionnaire/": (b) => QuestionnaireScreen(this,
          questions: trekko!
              .getProfile()
              .first
              .then((value) => value.preferences.onboardingQuestions)),
    };

    return CupertinoApp(
      home: WelcomeScreen(this),
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
            builder: (b) => routes[settings.name]!.call(b));
      },
      // routes: routes,
    );
  }
}
