import 'package:app_backend/controller/builder/build_exception.dart';
import 'package:app_backend/controller/builder/registration_builder.dart';
import 'package:app_backend/controller/builder/registration_result.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/screens/onboarding/accept_terms_widget.dart';
import 'package:app_frontend/screens/onboarding/enter_code_screen.dart';
import 'package:app_frontend/screens/onboarding/item_divider.dart';
import 'package:app_frontend/screens/onboarding/simple_onboarding_screen.dart';
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

  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        title: "Registrierung",
        buttonTitle: _agreedToTerms ? "Registrieren" : null,
        onButtonPress: _agreedToTerms
            ? () async {
                try {
                  Trekko trekko = await RegistrationBuilder.withData(
                          projectUrl: ModalRoute.of(context)!.settings.arguments
                              as String,
                          email: email.value.text,
                          password: password.value.text,
                          passwordConfirmation: passwordRepeat.value.text,
                          code: "12345")
                      .build();
                  Navigator.pushNamed(context, EnterCodeScreen.route,
                      arguments: trekko);
                } catch (e) {
                  String reason =
                      "Unbekannter Fehler";
                  if (e is BuildException) {
                    if (e.reason ==
                        RegistrationResult.failedInvalidCredentials) {
                      reason =
                          'Ungültige Eingaben. Bitte überprüfen Sie Ihre Eingaben.';
                    } else if (e.reason ==
                        RegistrationResult.failedEmailAlreadyUsed) {
                      reason =
                          'E-Mail Adresse bereits registriert, bitte loggen Sie sich ein.';
                    } else if (e.reason ==
                        RegistrationResult.failedNoConnection) {
                      reason =
                          'Keine Verbindung zum Server. Bitte überprüfen Sie Ihre Internetverbindung.';
                    } else if (e.reason ==
                        RegistrationResult.failedPasswordRepeat) {
                      reason = 'Passwörter stimmen nicht überein.';
                    }
                  }
                  showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                            title: Text(reason),
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
              }
            : null,
        child: SingleChildScrollView(
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
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 22),
                  child: Text(
                    "Passwortanfoderungen: \n- mind. 8 Zeichen lang \n- mind einen Großbuchstaben"
                    " \n- mind.einen Kleinbuchstaben \n- mind. eine Zahl enthalten "
                    "\n- mind. ein Sonderzeichen enthalten",
                    style: AppThemeTextStyles.tiny,
                  ),
                )
              ],
            ),
            const ItemDivider(),
            TextInput(
              title: "Passwort wiederholen",
              hiddenTitle: "Passwort wiederholen",
              controller: passwordRepeat,
              obscured: true,
            ),
            const ItemDivider(),
            Container(
              padding: const EdgeInsets.only(left: 8),
              child: AcceptTermsWidget(
                onAccepted: (bool value) {
                  setState(() {
                    _agreedToTerms = value;
                  });
                },
              ),
            ),
          ]),
        ));
  }
}
