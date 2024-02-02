import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class TextInput extends StatelessWidget {

  final String title;
  final String hiddenTitle;
  final TextEditingController controller;

  const TextInput({super.key, required this.title, required this.hiddenTitle, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppThemeTextStyles.normal),
        SizedBox(height: 2),
        CupertinoTextField(
          controller: controller,
          placeholder: hiddenTitle,
        )
      ],
    );
  }
}
