import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/ckeck_box_response.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/text_response.dart';
import 'package:flutter/cupertino.dart';

class Details extends StatefulWidget {
  final String detailPurpose;
  final String detailComment;
  final List<TransportType> detailVehicle;
  final Function(String) onSavedPurpose;
  final Function(String) onSavedComment;
  final Function(List<TransportType>) onSavedVehicle;
  final double additionalDividerMargin = 2;

  const Details(
      {required this.detailPurpose,
      required this.onSavedPurpose,
      required this.detailComment,
      required this.onSavedComment,
      required this.onSavedVehicle,
      required this.detailVehicle,
      super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CupertinoListSection.insetGrouped(
        backgroundColor: AppThemeColors.contrast150,
        additionalDividerMargin: widget.additionalDividerMargin,
        children: [
          CupertinoListTile(
            //TODO auch auslagern?
            title: Text('Anlass / Zweck', style: AppThemeTextStyles.normal),
            trailing: const CupertinoListTileChevron(),
            additionalInfo: widget.detailPurpose.isEmpty
                ? const Text('Arbeit, Freizeit, etc.') //TODO maximal lang?
                : SizedBox(
                    width: 150,
                    child: Text(
                      widget.detailPurpose,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => TextResponse(
                      maxLength: 350,
                      onSaved: widget.onSavedPurpose,
                      title: 'Anlass / Zweck',
                      placeholder: 'Arbeit, Freizeit, etc.',
                      initialValue: widget.detailPurpose)));
            },
          ),
          CupertinoListTile(
            title: Text('Verkehrsmittel', style: AppThemeTextStyles.normal),
            trailing: const CupertinoListTileChevron(),
            additionalInfo: const Text('zu Fuß'), //TODO implementieren
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => CheckBoxResponse<TransportType>(
                        getName: TransportDesign.getName,
                        title: 'Verkehrsmittel',
                        responses: TransportType.values,
                        onSaved: (List<TransportType> value) =>
                            widget.onSavedVehicle(value),
                        initialResponses: widget.detailVehicle,
                      )));
            },
          ),
        ],
      ),
      CupertinoListSection.insetGrouped(
        //TODO Bei Zeilenumbruch richtig angezeigt?
        //TODO auslagern
        backgroundColor: AppThemeColors.contrast150,
        additionalDividerMargin: widget.additionalDividerMargin,
        children: [
          CupertinoListTile(
            title: Text('Kommentar', style: AppThemeTextStyles.normal),
            trailing: const CupertinoListTileChevron(),
            additionalInfo: widget.detailComment.isEmpty
                ? const Text('Anmerkung, Fehler, etc.')
                : SizedBox(
                    width: 150,
                    child: Text(
                      widget.detailComment,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => TextResponse(
                      maxLength: 700,
                      onSaved: widget.onSavedComment,
                      title: 'Kommentar',
                      placeholder: 'Anmerkung, Fehler, etc.',
                      initialValue: widget.detailComment)));
            },
          ),
        ],
      ),
    ]);
  }
}
