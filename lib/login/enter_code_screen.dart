import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class EnterCodeScreen extends StatefulWidget {
  final LoginApp app;

  const EnterCodeScreen(this.app, {super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {

  TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        app: widget.app,
        title: "Fast\ngeschafft...",
        buttonTitle: "Verifizieren",
        onButtonPress: () async {
          // TODO: Register here instead of the screen before
          Navigator.pushNamed(context, "/login/about/");
        },
        child: Column(
          children: [
            Text(
                "Bitte gib den Registrierungscode\nein, den wir dir an deine E-Mail Adresse\ngesendet haben.",
                textAlign: TextAlign.center,
                style: AppThemeTextStyles.normal),
            const SizedBox(height: 50),
            TextInput(title: "Code", hiddenTitle: "Code", controller: code),
          ],
        ));
  }
}
