import 'package:app_backend/controller/builder/login_builder.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  final LoginApp app;

  const LoginScreen(this.app, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        app: widget.app,
        child: Column(children: [
          TextInput(
            title: "E-Mail",
            hiddenTitle: "E-Mail Adresse",
            onComplete: (s) => email = s,
          ),
          TextInput(
            title: "Passwort",
            hiddenTitle: "Passwort",
            onComplete: (s) => password = s,
          ),
        ]),
        title: "Anmelden",
        buttonTitle: "Anmelden",
        onButtonPress: () async {
          widget.app.trekkoCallBack.call(
              await LoginBuilder(widget.app.projectUrl!, email!, password!)
                  .build());
        });
  }
}
