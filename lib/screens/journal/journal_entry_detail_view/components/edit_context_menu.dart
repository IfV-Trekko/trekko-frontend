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
      required this.onReset, //TODO funktioniert nicht
      required this.onRevoke,
      super.key});

  // void _showEditContextDonated(BuildContext context) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoActionSheet(
  //       actions: <CupertinoActionSheetAction>[
  //         CupertinoActionSheetAction(
  //           onPressed: () {
  //             onReset();
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Zurücksetzen'),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () {
  //             onRevoke();
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Spende zurückziehen'),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () {
  //             onDelete();
  //             Navigator.pop(context);
  //           },
  //           isDestructiveAction: true,
  //           child: const Text('Unwideruflich löschen'),
  //         ),
  //       ],
  //       cancelButton: CupertinoActionSheetAction(
  //         isDefaultAction: true,
  //         onPressed: () {
  //           Navigator.pop(context, 'Cancel');
  //         },
  //         child: const Text('Cancel'),
  //       ),
  //     ),
  //   );
  // }

  // void _showEditContextNotDonated(BuildContext context) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoActionSheet(
  //       actions: <CupertinoActionSheetAction>[
  //         CupertinoActionSheetAction(
  //           onPressed: () {
  //             onReset();
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Zurücksetzen'),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () {
  //             onDelete();
  //             Navigator.pop(context);
  //           },
  //           isDestructiveAction: true,
  //           child: const Text('Unwideruflich Löschen'),
  //         ),
  //       ],
  //       cancelButton: CupertinoActionSheetAction(
  //         isDefaultAction: true,
  //         onPressed: () {
  //           Navigator.pop(context, 'Cancel');
  //         },
  //         child: const Text('Cancel'),
  //       ),
  //     ),
  //   );
  // }

  void _askForPermission(BuildContext context) {
    //TODO was sagt iht dazu?
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
                    Navigator.pop(context); //TODO implement
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
          // HeroIcons.ellipsisHorizontal,
          onPressed: () {
            _askForPermission(context);
          }),
      //  donated
      //     ? () => _showEditContextDonated(context)
      //     : () => _showEditContextNotDonated(context)),
    );
  }
}
