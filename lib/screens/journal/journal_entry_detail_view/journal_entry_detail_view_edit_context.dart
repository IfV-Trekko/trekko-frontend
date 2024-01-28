import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class JournalEntryDetailViewEditContext extends StatelessWidget {
  const JournalEntryDetailViewEditContext({super.key});
  //TODO eigentlich falscher stil vom ContextMenu
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
          Expanded(child: Button(title: 'Spenden', onPressed: () {})),
          SizedBox(width: 8),
          EditContext()
        ],
      ),
    );
  }
}

class EditContext extends StatelessWidget {
  const EditContext({super.key});

  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showEditContext(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      child: Button(
          style: ButtonStyle.secondary,
          title: '',
          icon: HeroIcons.squares2x2, //TODO change icons
          onPressed: () => _showEditContext(context)),
    );
  }
}
