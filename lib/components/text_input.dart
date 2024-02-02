import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class TextInput extends StatelessWidget {

  final String title;
  final String hiddenTitle;
  final Function(String) onComplete;

  const TextInput({super.key, required this.title, required this.hiddenTitle, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppThemeTextStyles.normal),
        SizedBox(height: 2),
        CupertinoTextField(
          placeholder: hiddenTitle,
          onSubmitted: onComplete,
        )
      ],
    );
  }
}
