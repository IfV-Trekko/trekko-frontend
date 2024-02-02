import 'package:app_frontend/app_theme.dart';
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
  String? projectUrl;

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        app: widget.app,
        title: "Projekt beitreten",
        buttonTitle: "Weiter",
        onButtonPress: () async {
          Navigator.pushNamed(context, "/login/signIn");
        },
        child: TextInput(title: "Project-URL", hiddenTitle: "Project-URL", onComplete: (s) => projectUrl = s));
  }
}
