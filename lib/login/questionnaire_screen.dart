import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/profile/profile.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

import '../screens/profile/form.dart';

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
      child: StreamBuilder(
        stream: trekko.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Profile profile = snapshot.data!;
            List<CupertinoListTile> questionTiles = QuestionTilesBuilder.buildQuestionTiles(
              context: context,
              profile: profile,
              trekko:  trekko,
              padding: const EdgeInsets.only(left: 16, right: 16),
            );
            return CupertinoListSection.insetGrouped(
              additionalDividerMargin: 2,
              children: questionTiles,
            );
          }
          return Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}
