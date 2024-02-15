import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/screens/onboarding/simple_onboarding_screen.dart';
import 'package:app_frontend/screens/onboarding/text_info_screen.dart';
import 'package:flutter/cupertino.dart';

class EnterCodeScreen extends StatefulWidget {
  static const String route = "/login/enterCode/";

  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  TextEditingController code = TextEditingController();

  Future<bool> _onWillPop(Trekko trekko, BuildContext context) async {
    trekko.terminate();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Trekko trekko = ModalRoute.of(context)!.settings.arguments as Trekko;
    return PopScope(
        onPopInvoked: (d) => _onWillPop(trekko, context),
        child: SimpleOnboardingScreen(
        title: "Fast\ngeschafft...",
        buttonTitle: "Verifizieren",
        onButtonPress: () async {
          Navigator.pushNamed(context, TextInfoScreen.routeAbout,
              arguments: ModalRoute.of(context)!.settings.arguments);
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
        )));
  }
}
