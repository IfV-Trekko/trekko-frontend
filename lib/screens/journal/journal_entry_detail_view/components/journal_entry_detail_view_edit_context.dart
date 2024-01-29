import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class JournalEntryDetailViewEditContext extends StatelessWidget {
  final bool donated;
  const JournalEntryDetailViewEditContext({required this.donated, super.key});
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
                  title: donated ? 'Aktualisieren' : 'Spenden',
                  onPressed: () {})),
          SizedBox(width: 8),
          EditContext(donated: donated) // TODO abhängigkeit einfügen
        ],
      ),
    );
  }
}

class EditContext extends StatelessWidget {
  final bool donated;

  const EditContext({required this.donated, super.key});

  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showEditContextDonated(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {},
            child: const Text('Zurücksetzen'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {},
            child: const Text('Spende zurückziehen'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {},
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

  void _showEditContextNotDonated(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {},
            child: const Text('Zurücksetzen'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {},
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
