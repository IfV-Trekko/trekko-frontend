import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/edit_context_menu.dart';
import 'package:flutter/cupertino.dart';

class EditContext extends StatelessWidget {
  final bool donated;
  final bool isDonatig;
  final Function() onDonate;
  final Function() onUpdate;
  final Function() onDelete;
  final Function() onReset;
  final Function() onRevoke;

  const EditContext(
      {required this.donated,
      required this.isDonatig,
      required this.onDonate,
      required this.onUpdate,
      required this.onDelete,
      required this.onReset,
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
            loading: isDonatig,
            style: donated ? ButtonStyle.secondary : ButtonStyle.primary,
            title: donated ? 'Spende zurückziehen' : 'Spenden',
            onPressed: donated ? onRevoke : onDonate,
          )),
          const SizedBox(width: 8),
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
