import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/position_utils.dart';
import 'package:trekko_backend/controller/wrapper/manual/manual_trip_wrapper.dart';
import 'package:trekko_backend/model/cache/wrapper_type.dart';
import 'package:trekko_backend/model/position.dart';
import 'package:trekko_backend/model/position_accuracy.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';
import 'package:trekko_frontend/components/pop_up_utils.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class ManualTrackingSheet extends StatefulWidget {
  const ManualTrackingSheet({super.key});

  @override
  State<ManualTrackingSheet> createState() => _ManualTrackingSheetState();
}

class _ManualTrackingSheetState extends State<ManualTrackingSheet> {
  bool loading = false;

  Widget buildTransportTypeIcon(TransportType type, bool selected) {
    Color color =
        loading ? AppThemeColors.contrast400 : TransportDesign.getColor(type);
    return Container(
        decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.2) : null,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color)),
        child: HeroIcon(TransportDesign.getIcon(type), color: color, size: 60));
  }

  Widget buildHint() {
    return Text(
        "Gedrückt halten zum Wechseln des Transportmittels oder Beenden des manuellen Weges",
        style: AppThemeTextStyles.tabBarLabel);
  }

  Widget buildIconWrap(ManualTripWrapper manual, Trekko trekko) {
    return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          for (TransportType type in TransportType.values)
            GestureDetector(
                onLongPress: () async {
                  if (loading) return;

                  setState(() {
                    loading = true;
                  });
                  Position? pos = await PositionUtils.getPosition(
                      PositionAccuracy.best,
                      checkPermissions: true);
                  if (pos == null) {
                    PopUpUtils.showPopUp(context, "Fehler",
                        "Konnte Position nicht bestimmen. Stellen Sie bitte sicher, dass alle nötigen Berechtigungen erteilt wurden.");
                    setState(() {
                      loading = false;
                    });
                    return;
                  }

                  if (manual.getTransportType() == type) {
                    manual.triggerEnd();
                  } else {
                    setState(() {
                      manual.triggerStartLeg(type);
                    });
                  }
                  await trekko.sendPosition(pos, [WrapperType.MANUAL]);
                  setState(() {
                    loading = false;
                  });
                },
                child: buildTransportTypeIcon(
                    type, manual.getTransportType() == type))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    Trekko trekko = TrekkoProvider.of(context);
    return StreamBuilder(
        stream: trekko.getWrapper(WrapperType.MANUAL),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ManualTripWrapper manual = snapshot.data!;
            return Column(
              children: [
                buildIconWrap(manual, trekko),
                const SizedBox(height: 4),
                buildHint(),
                const SizedBox(height: 4),
                if (loading)
                  const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CupertinoActivityIndicator())
              ],
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        });
  }
}
