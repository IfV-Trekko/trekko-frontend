import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class JournalEntryDetailViewDetails extends StatelessWidget {
  const JournalEntryDetailViewDetails();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      CupertinoListSection.insetGrouped(
        backgroundColor: AppThemeColors.contrast150,
        children: [
          CupertinoListTile(
            title: Text('Anlass / Zweck', style: AppThemeTextStyles.normal),
            trailing: Container(child: CupertinoListTileChevron()),
            additionalInfo:
                Container(child: Text('Arbeit')), //TODO implementieren
          ),
          CupertinoListTile(
            title: Text('Verkehrsmittel', style: AppThemeTextStyles.normal),
            trailing: Container(child: CupertinoListTileChevron()),
            additionalInfo:
                Container(child: Text('zu Fuß')), //TODO implementieren
          ),
        ],
      ),
      CupertinoListSection.insetGrouped(
        backgroundColor: AppThemeColors.contrast150,
        children: [
          CupertinoListTile(
            title: Text('Kommentar', style: AppThemeTextStyles.normal),
            additionalInfo: Container(child: Text('Anmerkung, Fehler, etc.')),
          ),
        ],
      ),
    ]));
  }
}
