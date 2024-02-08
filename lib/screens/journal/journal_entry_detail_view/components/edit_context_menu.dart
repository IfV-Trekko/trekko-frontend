import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class EditContextMenu extends StatelessWidget {
  final bool donated;
  final Function() onDelete;
  final Function() onReset;
  final Function() onRevoke;

  const EditContextMenu(
      {required this.onDelete,
      required this.donated,
      required this.onReset,
      required this.onRevoke,
      super.key});

  void _askForPermission(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Unwideruflich Löschen?'),
              content: const Text(
                  'Möchtest du die Spende wirklich unwiderruflich löschen?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Abbrechen'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Löschen'),
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      child: Button(
          style: ButtonStyle.destructive,
          title: '',
          icon: HeroIcons.trash,
          onPressed: () {
            _askForPermission(context);
          }),
    );
  }
}
