import 'package:app_backend/controller/request/bodies/response/project_metadata_response.dart';
import 'package:app_backend/controller/utils/onboarding_utils.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptTermsWidget extends StatefulWidget {
  final Function(bool) onAccepted; // Callback hinzufügen

  const AcceptTermsWidget({Key? key, required this.onAccepted})
      : super(key: key);

  @override
  _AcceptTermsWidgetState createState() => _AcceptTermsWidgetState();
}

class _AcceptTermsWidgetState extends State<AcceptTermsWidget> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CupertinoCheckbox(
              shape: const CircleBorder(),
              value: _isAccepted,
              onChanged: (bool? newValue) {
                setState(() {
                  _isAccepted = newValue!;
                });
                widget.onAccepted(_isAccepted);
              },
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isAccepted = !_isAccepted;
                  });
                  widget.onAccepted(_isAccepted);
                },
                child: Text(
                  'Ich akzeptiere die Allgemeinen Geschäftsbedingungen.',
                  style: AppThemeTextStyles.normal.copyWith(
                    color: _isAccepted
                        ? AppThemeColors.blue
                        : AppThemeColors.contrast500,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () async {
                  final String projectUrl =
                      ModalRoute.of(context)!.settings.arguments as String;
                  final ProjectMetadataResponse metaData =
                      await OnboardingUtils.loadProjectMetadata(projectUrl);
                  final Uri url = Uri.parse(metaData.terms);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  "Hier klicken, um die Datenschutzbestimmungen zu lesen.",
                  style: AppThemeTextStyles.tiny.copyWith(
                    color: AppThemeColors.blue,
                  ),
                ),
              ))
        ])
      ],
    );
  }
}
