import 'package:app_backend/controller/builder/build_exception.dart';
import 'package:app_backend/controller/builder/registration_builder.dart';
import 'package:app_backend/controller/builder/registration_result.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/login/enter_code_screen.dart';
import 'package:app_frontend/login/item_divider.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class SignUpScreen extends StatefulWidget {
  static const String route = "/login/signUp/";

  const SignUpScreen({super.key});

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
        title: "Registrierung",
        buttonTitle: "Registrieren",
        onButtonPress: () async {
          try {
            Trekko trekko = await RegistrationBuilder.withData(
                    projectUrl:
                        ModalRoute.of(context)!.settings.arguments as String,
                    email: email.value.text,
                    password: password.value.text,
                    passwordConfirmation: passwordRepeat.value.text,
                    code: "12345")
                .build();
            Navigator.pushNamed(context, EnterCodeScreen.route,
                arguments: trekko);
          } catch (e) {
            String reason = "Unbekannter Fehler";
            if (e is BuildException) {
              reason = e.reason.toString();
              if (e.reason == RegistrationResult.failedOther) {
                print(e);
              }
            } else {
              print(e);
            }
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title: Text("Fehler: " + reason),
                      // TODO: Better information text
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
