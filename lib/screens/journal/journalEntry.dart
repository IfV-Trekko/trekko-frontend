import 'package:flutter/cupertino.dart';

class journalEntry extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: CupertinoColors.systemGrey,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(), //TODO Children einfügen (Labels)
          ),
        ),
      ),
    );
  }


  void onPressed(){

  }
}
