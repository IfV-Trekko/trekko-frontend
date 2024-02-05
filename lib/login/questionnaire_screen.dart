import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class QuestionnaireScreen extends StatefulWidget {
  static const String route = "/login/questionnaire/";

  final Function(Trekko) callback;

  const QuestionnaireScreen(this.callback, {super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  @override
  Widget build(BuildContext context) {
    Trekko trekko = ModalRoute.of(context)!.settings.arguments as Trekko;
    return SimpleOnboardingScreen(
      title: "Fragebogen",
      buttonTitle: "Registrierung abschließen",
      onButtonPress: () async {
        widget.callback.call(trekko);
      },
      child: Column(
        children: [
          Text(
              "Alle Angaben sind freiwillig und\ndienen rein zu Forschungszwecken",
              textAlign: TextAlign.center,
              style: AppThemeTextStyles.normal),
          const SizedBox(height: 20),
          FutureBuilder(
              future:
                  trekko.getProfile().map((event) => event.preferences).first,
              builder: (context, snapshot) {
                return const Text("Viel Spaß David, dein Part");
              })
        ],
      ),
    );
  }
}
