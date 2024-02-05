import 'package:app_backend/controller/builder/build_exception.dart';
import 'package:app_backend/controller/builder/login_builder.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/login/item_divider.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class SignInScreen extends StatefulWidget {

  static const String route = "/login/signIn/";

  final LoginApp app;

  const SignInScreen(this.app, {super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        app: widget.app,
        title: "Anmeldung",
        buttonTitle: "Anmelden",
        onButtonPress: () async {
          try {
            widget.app.trekko = await LoginBuilder(
                widget.app.projectUrl!, email.value.text, password.value.text)
                .build();
            widget.app.launchApp();
          } catch(e) {
            String reason = "Unbekannt";
            if (e is BuildException) {
              reason = e.reason.toString();
            }
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: Text("Fehler: " + reason), // TODO: Better information text
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
          }
        },
        child: Column(children: [
          TextInput(
            title: "E-Mail",
            hiddenTitle: "E-Mail Adresse",
            controller: email,
          ),
          const ItemDivider(),
          TextInput(
            title: "Passwort",
            hiddenTitle: "Passwort",
            controller: password,
            obscured: true,
          ),
        ]));
  }
}
