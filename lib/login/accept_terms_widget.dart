import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptTermsWidget extends StatefulWidget {

  final Function(bool) onAccepted; // Callback hinzufügen

  AcceptTermsWidget({Key? key, required this.onAccepted}) : super(key: key);

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
                    color: _isAccepted ? AppThemeColors.blue : AppThemeColors.contrast500,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () async {
                  Uri url = Uri(
                      scheme: 'https',
                      host: 'www.trekko.de',
                      path: '/datenschutz');
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
              )
            )
          ]
        )
      ],
    );
  }
}