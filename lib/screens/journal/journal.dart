import 'package:flutter/cupertino.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<StatefulWidget> createState() {
    return _JournalState();
  }
}

class _JournalState extends State<Journal> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text('Journal'),

      ),
    );
  }
}