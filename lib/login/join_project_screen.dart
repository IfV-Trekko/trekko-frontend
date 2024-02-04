import 'dart:io';

import 'package:app_backend/controller/builder/authentification_utils.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
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
        title: "Projekt\nbeitreten",
        buttonTitle: "Weiter",
        onButtonPress: () async {
          if (!await AuthentificationUtils.isServerValid(projectUrl.text)) {
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title: Text(
                          "Das angegebene Projekt konnte nicht gefunden werden"),
                      actions: [
                        CupertinoDialogAction(
                          child: Text('Verstanden'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ));
            return;
          }

          if (projectUrl.value.text.toLowerCase() ==
              "flammkuchen isst man hier auch gar nicht so oft") {
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title: Text("Naaahhh unterschätz das mal nicht hier"),
                      actions: [
                        CupertinoDialogAction(
                          child: Text('Werd ich nicht'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ));
            return;
          }

          widget.app.projectUrl = projectUrl.value.text;
          Navigator.pushNamed(context, "/login/how/");
        },
        child: Column(children: [
          TextInput(
            title: "Project-URL",
            hiddenTitle: "Project-URL",
            controller: projectUrl,
          ),
          const SizedBox(
            height: 300,
          ),
          Button(
              title: "(Debug) Local",
              style: ButtonStyle.secondary,
              onPressed: () {
                String local = Platform.isAndroid ? "10.0.2.2" : "localhost";
                projectUrl.text = "http://$local:8080";
              }),
        ]));
  }
}
