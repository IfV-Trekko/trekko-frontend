import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_frontend/screens/onboarding/simple_onboarding_screen.dart';
import 'package:trekko_frontend/screens/profile/question_tiles_section.dart';

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
        padding: EdgeInsets.zero,
        child: QuestionTilesSection(trekko: trekko));
  }
}
