import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/position_utils.dart';
import 'package:trekko_backend/controller/wrapper/manual/manual_trip_wrapper.dart';
import 'package:trekko_backend/model/cache/wrapper_type.dart';
import 'package:trekko_backend/model/position.dart';
import 'package:trekko_backend/model/position_accuracy.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class ManualTrackingSheet extends StatefulWidget {
  const ManualTrackingSheet({super.key});

  @override
  State<ManualTrackingSheet> createState() => _ManualTrackingSheetState();
}

class _ManualTrackingSheetState extends State<ManualTrackingSheet> {
  Widget buildTransportTypeIcon(TransportType type, bool selected) {
    return Container(
        decoration: BoxDecoration(
            color: selected
                ? TransportDesign.getColor(type).withOpacity(0.3)
                : null,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: TransportDesign.getColor(type))),
        child: HeroIcon(TransportDesign.getIcon(type),
            color: TransportDesign.getColor(type), size: 60));
  }

  @override
  Widget build(BuildContext context) {
    Trekko trekko = TrekkoProvider.of(context);
    return StreamBuilder(
        stream: trekko.getWrapper(WrapperType.MANUAL),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ManualTripWrapper manual = snapshot.data!;
            return Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  for (TransportType type in TransportType.values)
                    GestureDetector(
                        onLongPress: () async {
                          Position pos = await PositionUtils.getPosition(
                              PositionAccuracy.best);
                          if (manual.getTransportType() == type) {
                            manual.triggerEndOnLegEnd();
                          } else {
                            setState(() {
                              manual.updateTransportType(type);
                            });
                          }
                          await trekko.sendPosition(pos, [WrapperType.MANUAL]);
                        },
                        child: buildTransportTypeIcon(
                            type, manual.getTransportType() == type))
                ]);
          } else {
            return const CupertinoActivityIndicator();
          }
        });
  }
}
