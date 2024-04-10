import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:trekko_backend/controller/builder/build_exception.dart';
import 'package:trekko_backend/controller/builder/login_builder.dart';
import 'package:trekko_backend/controller/builder/login_result.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_frontend/components/text_input.dart';
import 'package:trekko_frontend/screens/onboarding/item_divider.dart';
import 'package:trekko_frontend/screens/onboarding/simple_onboarding_screen.dart';

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
            } else {
              Logger().e(e);
            }
            if (context.mounted) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                        title: Text(reason),
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
