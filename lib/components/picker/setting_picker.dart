import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';

class SettingsPicker extends StatelessWidget {
  final List<Widget> children;
  final Function(int) onSettingSelected;

  const SettingsPicker(
      {Key? key, required this.children, required this.onSettingSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0; // Initialer Index oder aus Profile laden
    return CupertinoActionSheet(
      actions: <Widget>[
        SizedBox(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 32,
            magnification: 1.22,
            squeeze: 1.2,
            backgroundColor: AppThemeColors.contrast0,
            onSelectedItemChanged: (int index) {
              selectedIndex = index;
            },
            children: children,
          ),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Fertig'),
        onPressed: () {
          onSettingSelected(selectedIndex);
          Navigator.pop(context);
        },
      ),
    );
  }
}
