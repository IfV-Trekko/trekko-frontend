import 'package:trekko_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class TextInput extends StatelessWidget {
  final String title;
  final String hiddenTitle;
  final TextEditingController controller;
  final bool obscured;

  const TextInput(
      {super.key,
      required this.title,
      required this.hiddenTitle,
      required this.controller,
      this.obscured = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppThemeTextStyles.normal),
        const SizedBox(height: 11),
        SizedBox(
            height: 48,
            width: 361,
            child: CupertinoTextField(
              controller: controller,
              placeholder: hiddenTitle,
              obscureText: obscured,
              style: AppThemeTextStyles.normal,
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: AppThemeColors.contrast100,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
            )),
      ],
    );
  }
}
