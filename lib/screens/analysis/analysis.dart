import 'package:flutter/cupertino.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AnalysisState();
  }
}

class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text('Analysis'),
      ),
    );
  }
}