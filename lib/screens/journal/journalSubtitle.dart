import 'package:flutter/cupertino.dart';

class journalSubtitle extends StatelessWidget {
  String _title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey, //TODO: Farbe zu Trekko grau ändern
            width: 1.0,
          ),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        _title,
        style: const TextStyle(
          color: CupertinoColors.systemGrey, //TODO farbe zu Trekko grau ändern
          fontFamily: 'SF Pro',
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  journalSubtitle(this._title);
}
