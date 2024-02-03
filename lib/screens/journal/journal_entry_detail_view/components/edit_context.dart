import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class JournalEntryDetailViewEditContext extends StatelessWidget {
  final bool donated;
  final Function() onDonate;
  final Function() onUpdate;
  final Function() onDelete;
  final Function() onReset;
  final Function() onRevoke;

  const JournalEntryDetailViewEditContext(
      {required this.donated,
      required this.onDonate,
      required this.onUpdate,
      required this.onDelete,
      required this.onReset,
      required this.onRevoke,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: Button(
            style: donated ? ButtonStyle.secondary : ButtonStyle.primary,
            title: donated ? 'Spende zurückziehen' : 'Spenden',
            onPressed: donated ? onRevoke : onDonate,
          )),
          SizedBox(width: 8),
          EditContextMenu(
              onDelete: onDelete,
              donated: donated,
              onReset: onReset,
              onRevoke: onRevoke)
        ],
      ),
    );
  }
}

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

  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showEditContextDonated(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              onReset();
              Navigator.pop(context);
            },
            child: const Text('Zurücksetzen'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              onRevoke();
              Navigator.pop(context);
            },
            child: const Text('Spende zurückziehen'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text('Unwideruflich löschen'),
            isDestructiveAction: true,
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  void _showEditContextNotDonated(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              onReset();
              Navigator.pop(context);
            },
            child: const Text('Zurücksetzen'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text('Unwideruflich Löschen'),
            isDestructiveAction: true,
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      child: Button(
          style: ButtonStyle.secondary,
          title: '',
          icon: HeroIcons.ellipsisHorizontal,
          onPressed: donated
              ? () => _showEditContextDonated(context)
              : () =>
                  _showEditContextNotDonated(context)), //TODO abhängig machen
    );
  }
}
