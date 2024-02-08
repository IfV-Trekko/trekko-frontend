import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class EditContext extends StatelessWidget {
  final bool donated;
  final bool isDonating;
  final Function() onDonate;
  final Function() onDelete;
  final Function() onRevoke;

  const EditContext(
      {required this.donated,
      required this.isDonating,
      required this.onDonate,
      required this.onDelete,
      required this.onRevoke,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppThemeColors.contrast0,
        border: Border(
          top: BorderSide(
            color: AppThemeColors.contrast400,
            width: 1,
          ),
          bottom: BorderSide(
            color: AppThemeColors.contrast400,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: Button(
            loading: isDonating,
            style: donated ? ButtonStyle.secondary : ButtonStyle.primary,
            title: donated ? 'Spende zurückziehen' : 'Spenden',
            onPressed: donated ? onRevoke : onDonate,
          )),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            child: Button(
                style: ButtonStyle.destructive,
                title: '',
                icon: HeroIcons.trash,
                // HeroIcons.ellipsisHorizontal,
                onPressed: () {
                  _askForPermission(context);
                }),
          ),
        ],
      ),
    );
  }

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
}
