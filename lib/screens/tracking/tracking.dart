import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/buttonSize.dart';
import 'package:app_frontend/components/constants/buttonStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

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
        child: Button(
          title: 'Tracking',
          onPressed: () {},
        ),
      ),
    );
  }
}
