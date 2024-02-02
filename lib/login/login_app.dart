import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/login/join_project_screen.dart';
import 'package:app_frontend/login/welcome_screen.dart';
import 'package:flutter/cupertino.dart';

class LoginApp extends StatelessWidget {
  final Function(Trekko) trekkoCallBack;
  String? projectUrl;
  String? email;

  LoginApp(this.trekkoCallBack, {super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, Widget Function(BuildContext)> routes = {
      "/login/welcome/": (b) => WelcomeScreen(this),
      "/login/project/": (b) => JoinProjectScreen(this),
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
