import 'package:flutter/cupertino.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TrackingState();
  }
}

class _TrackingState extends State<Tracking> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text('Tracking'),
      ),
    );
  }
}