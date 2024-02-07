import 'package:app_backend/controller/builder/build_exception.dart';
import 'package:app_backend/controller/builder/login_builder.dart';
import 'package:app_backend/controller/builder/login_result.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/login/item_divider.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class SignInScreen extends StatefulWidget {
  static const String route = "/login/signIn/";

  final Function(Trekko) callback;

  const SignInScreen(this.callback, {super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        title: "Anmeldung",
        buttonTitle: "Anmelden",
        onButtonPress: () async {
          try {
            Trekko trekko = await LoginBuilder.withData(
                    projectUrl:
                        ModalRoute.of(context)!.settings.arguments as String,
                    email: email.value.text,
                    password: password.value.text)
                .build();
            widget.callback.call(trekko);
          } catch (e) {
            String reason = "Fehler Unbekannt";
            if (e is BuildException) {
              if (e.reason == LoginResult.failedInvalidCredentials) {
                reason = 'E-Mail oder Passwort falsch';
              } else if (e.reason == LoginResult.failedNoConnection) {
                reason =
                    'Keine Verbindung zum Server, bitte überprüfen Sie Ihre Internetverbindung';
              } else if (e.reason == LoginResult.failedNoSuchUser) {
                reason =
                    'Der Benutzer existiert nicht, bitte registrieren Sie sich';
              } else if (e.reason == LoginResult.failedSessionExpired) {
                reason = 'Sitzung abgelaufen, bitte loggen Sie sich erneut ein';
              }
            }
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title: Text(reason),
                      // TODO: Better information text
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Ok'),
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
