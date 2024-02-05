import 'package:app_backend/controller/builder/build_exception.dart';
import 'package:app_backend/controller/builder/registration_builder.dart';
import 'package:app_backend/controller/builder/registration_result.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/login/item_divider.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class SignUpScreen extends StatefulWidget {
  final LoginApp app;

  const SignUpScreen(this.app, {super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordRepeat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        app: widget.app,
        title: "Registrierung",
        buttonTitle: "Registrieren",
        onButtonPress: () async {
          try {
            widget.app.trekko = await RegistrationBuilder(
                widget.app.projectUrl!,
                email.value.text,
                password.value.text,
                passwordRepeat.value.text,
                "12345")
                .build();
            Navigator.pushNamed(context, "/login/enterCode/");
          } catch(e) {
            String reason = "Unbekannter Fehler";
            if (e is BuildException) {
              reason = e.reason.toString();
              if (e.reason == RegistrationResult.failedOther) {
                print(e);
              }
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
          const ItemDivider(),
          TextInput(
            title: "Passwort wiederholen",
            hiddenTitle: "Passwort wiederholen",
            controller: passwordRepeat,
            obscured: true,
          ),
        ]));
  }
}
