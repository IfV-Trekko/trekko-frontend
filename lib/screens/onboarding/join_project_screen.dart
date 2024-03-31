import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:trekko_backend/controller/builder/authentification_utils.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_style.dart';
import 'package:trekko_frontend/components/text_input.dart';
import 'package:trekko_frontend/screens/onboarding/choose_login_process_screen.dart';
import 'package:trekko_frontend/screens/onboarding/simple_onboarding_screen.dart';

class JoinProjectScreen extends StatefulWidget {
  static const String route = "/login/project/";

  const JoinProjectScreen({super.key});

  @override
  State<JoinProjectScreen> createState() => _JoinProjectScreenState();
}

class _JoinProjectScreenState extends State<JoinProjectScreen> {
  TextEditingController projectUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleOnboardingScreen(
        title: "Projekt\nbeitreten",
        buttonTitle: "Weiter",
        onButtonPress: () async {
          if (projectUrl.value.text.toLowerCase() ==
              "flammkuchen isst man hier auch gar nicht so oft") {
            // https://www.youtube.com/watch?v=UCL-eKVpfWk
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title:
                          const Text("Naaahhh unterschätz das mal nicht hier"),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Werd ich nicht'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ));
            return;
          }

          if (!await AuthentificationUtils.isServerValid(projectUrl.text)) {
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title: const Text(
                          "Das angegebene Projekt konnte nicht gefunden werden"),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Erneut versuchen'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ));
            return;
          }

          Navigator.pushNamed(context, ChooseLoginProcessScreen.route,
              arguments: projectUrl.value.text);
        },
        child: Column(children: [
          TextInput(
            title: "Project-URL",
            hiddenTitle: "Project-URL",
            controller: projectUrl,
          ),
          const SizedBox(
            height: 200,
          ),
          // If kDebugMode, add a button to set the local server
          if (kDebugMode)
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
