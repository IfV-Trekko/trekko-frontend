import 'package:app_frontend/components/text_input.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/login/simple_onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class JoinProjectScreen extends StatefulWidget {
  final LoginApp app;

  const JoinProjectScreen(this.app, {super.key});

  @override
  State<JoinProjectScreen> createState() => _JoinProjectScreenState();
}

class _JoinProjectScreenState extends State<JoinProjectScreen> {
  TextEditingController projectUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        app: widget.app,
        title: "Projekt beitreten",
        buttonTitle: "Weiter",
        onButtonPress: () async {
          widget.app.projectUrl = projectUrl.value.text;
          Navigator.pushNamed(context, "/login/how/");
        },
        child: TextInput(
          title: "Project-URL",
          hiddenTitle: "Project-URL",
          controller: projectUrl,
        ));
  }
}
