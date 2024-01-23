import 'package:flutter/cupertino.dart';
import '../../app_theme.dart';

class TextInputPage extends StatelessWidget {
  final String title;
  final String currentText;

  TextInputPage({required this.title, required this.currentText});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast100,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profil'),
      ),
      child: Center(
        child: Padding( // TODO: use input component as soon as ready
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CupertinoTextField(
            placeholder: title,
            autofocus: true,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onSubmitted: (String value) {
              Navigator.of(context).pop(value);
            },
          ),
        ),
      ),
    );
  }
}
