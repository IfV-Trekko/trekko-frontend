import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_frontend/components/constants/text_response_keyboard_type.dart';
import 'package:trekko_frontend/components/tile_utils.dart';
import 'package:trekko_frontend/components/responses/text_response.dart';

class EditableTripDetails extends StatelessWidget {
  final String? purpose;
  final String? comment;
  final Function(String?) onSavedPurpose;
  final Function(String?) onSavedComment;
  final double additionalDividerMargin = 2;

  const EditableTripDetails(
      {required this.purpose,
      required this.onSavedPurpose,
      required this.comment,
      required this.onSavedComment,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CupertinoListSection.insetGrouped(
        margin: TileUtils.listSectionMargin,
        additionalDividerMargin: TileUtils.defaultDividerMargin,
        children: [
          CupertinoListTile(
            title:
                TileUtils.buildTitleRow('Anlass / Zweck', HeroIcons.lightBulb),
            trailing: const CupertinoListTileChevron(),
            padding: TileUtils.listTilePadding,
            additionalInfo: purpose == null || purpose!.isEmpty
                ? const Text('Arbeit, Freizeit, etc.')
                : Text(
                    purpose!,
                    textAlign: TextAlign.end,
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
            title: TileUtils.buildTitleRow('Kommentar', HeroIcons.bookOpen),
            trailing: const CupertinoListTileChevron(),
            padding: TileUtils.listTilePadding,
            additionalInfo: comment == null || comment!.isEmpty
                ? const Text('Anmerkung, etc.')
                : Text(
                    comment!,
                    textAlign: TextAlign.end,
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
