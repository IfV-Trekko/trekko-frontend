import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/login/choose_login_process_screen.dart';
import 'package:app_frontend/login/join_project_screen.dart';
import 'package:app_frontend/login/sign_in_screen.dart';
import 'package:app_frontend/login/sign_up_screen.dart';
import 'package:app_frontend/login/welcome_screen.dart';
import 'package:flutter/cupertino.dart';

class LoginApp extends StatelessWidget {
  final Function(Trekko) trekkoCallBack;
  String? projectUrl;
  String? email;

  LoginApp(this.trekkoCallBack, {super.key});

  void use(Trekko trekko) {
    trekkoCallBack.call(trekko);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget Function(BuildContext)> routes = {
      "/login/welcome/": (b) => WelcomeScreen(this),
      "/login/project/": (b) => JoinProjectScreen(this),
      "/login/how/": (b) => ChooseLoginProcessScreen(this),
      "/login/signIn/": (b) => SignInScreen(this),
      "/login/signUp/": (b) => SignUpScreen(this),
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
