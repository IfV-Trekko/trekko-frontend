import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class QuestionnaireScreen extends StatefulWidget {
  final LoginApp app;
  final Future<List<OnboardingQuestion>> questions;

  const QuestionnaireScreen(this.app, {super.key, required this.questions});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
      title: "Fragebogen",
      app: widget.app,
      buttonTitle: "Registrierung abschließen",
      onButtonPress: () async {
        widget.app.launchApp();
      },
      child: Column(
        children: [
          Text(
              "Alle Angaben sind freiwillig und\ndienen rein zu Forschungszwecken",
              textAlign: TextAlign.center,
              style: AppThemeTextStyles.normal),
          const SizedBox(height: 20),
          FutureBuilder(
              future: widget.questions,
              builder: (context, snapshot) {
                return const Text("Viel Spaß David, dein Part");
              })
        ],
      ),
    );
  }
}
