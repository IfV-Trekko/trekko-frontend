import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/text_response_keyboard_type.dart';
import 'package:trekko_frontend/components/responses/text_response.dart';

class EditablePositionDetails extends StatelessWidget {
  final String? purpose;
  final String? comment;
  final Function(String?) onSavedPurpose;
  final Function(String?) onSavedComment;
  final double additionalDividerMargin = 2;

  const EditablePositionDetails(
      {required this.purpose,
      required this.onSavedPurpose,
      required this.comment,
      required this.onSavedComment,
      super.key});

  Widget _buildTitleRow(String title, HeroIcons icon) {
    return Row(
      children: [
        HeroIcon(icon),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CupertinoListSection.insetGrouped(
        additionalDividerMargin: additionalDividerMargin,
        children: [
          CupertinoListTile(
            title: _buildTitleRow('Anlass / Zweck', HeroIcons.lightBulb),
            trailing: const CupertinoListTileChevron(),
            additionalInfo: purpose == null || purpose!.isEmpty
                ? const Text('Arbeit, Freizeit, etc.')
                : SizedBox(
                    width: 100,
                    child: Text(
                      purpose!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => TextResponse(
                      suffix: '',
                      maxLines: 1,
                      keyboardType: TextResponseKeyboardType.text,
                      maxLength: 350,
                      onSaved: onSavedPurpose,
                      title: 'Anlass / Zweck',
                      placeholder: 'Arbeit, Freizeit, etc.',
                      initialValue: purpose ?? '')));
            },
          ),
          CupertinoListTile(
            title: _buildTitleRow('Kommentar', HeroIcons.bookOpen),
            trailing: const CupertinoListTileChevron(),
            additionalInfo: comment == null || comment!.isEmpty
                ? const Text('Anmerkung, etc.')
                : SizedBox(
                    width: 100,
                    child: Text(
                      comment!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => TextResponse(
                      suffix: '',
                      maxLines: 6,
                      keyboardType: TextResponseKeyboardType.text,
                      maxLength: 700,
                      onSaved: onSavedComment,
                      title: 'Kommentar',
                      placeholder: 'Anmerkung, Fehler, etc.',
                      initialValue: comment ?? '')));
            },
          ),
        ],
      ),
    ]);
  }
}
