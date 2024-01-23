import 'package:flutter/cupertino.dart';
import '../../app_theme.dart';

class TextInputPage extends StatelessWidget {
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
            placeholder: 'Batterieverbrauch',
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
