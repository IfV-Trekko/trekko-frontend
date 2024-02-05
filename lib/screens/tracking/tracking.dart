import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/main_map.dart';
import 'package:app_frontend/screens/tracking/map_option_sheet.dart';
import 'package:flutter/cupertino.dart';

class TrackingScreen extends StatefulWidget {
  final Trekko trekko;

  const TrackingScreen({super.key, required this.trekko});

  @override
  State<StatefulWidget> createState() {
    return _TrackingScreenState();
  }
}

class _TrackingScreenState extends State<TrackingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          MainMap(),
          SafeArea(
            //TODO nur eine Idee
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Align(
                alignment: Alignment.topRight,
                child: Idea(),
              ),
            ),
          ),
          MapOptionSheet(
            trekko: widget.trekko,
          )
        ],
      ),
    );
  }
}

class Idea extends StatefulWidget {
  const Idea({super.key});

  @override
  State<Idea> createState() => _IdeaState();
}

class _IdeaState extends State<Idea> {
  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      groupValue: 0,
      onValueChanged: (value) {
        print(value);
      },
      children: Map.from({
        0: const Text('Selten'),
        1: const Text('Oft'),
        2: const Text('Sehr oft'),
      }),
    );
  }
}
