import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/model/position.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/picker/date_picker.dart';

class AddStopScreen extends StatefulWidget {
  final Position? initialPosition;

  const AddStopScreen({super.key, this.initialPosition});

  @override
  State<AddStopScreen> createState() => _AddStopScreenState();
}

class _AddStopScreenState extends State<AddStopScreen> {
  late MapController controller;
  late DateTime time;
  GeoPoint? initPosition;

  @override
  void initState() {
    if (widget.initialPosition == null) {
      controller = MapController.withUserPosition();
      time = DateTime.now();
    } else {
      Position pos = widget.initialPosition!;
      initPosition = GeoPoint(latitude: pos.latitude, longitude: pos.longitude);
      time = pos.timestamp;
      controller = MapController.withPosition(initPosition: initPosition!);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      OSMFlutter(
          onMapIsReady: (b) {
            if (initPosition != null) {
              controller.zoomToBoundingBox(
                  BoundingBox.fromGeoPoints([initPosition!]),
                  paddinInPixel: 100000);
            }
          },
          controller: controller,
          osmOption: const OSMOption(enableRotationByGesture: false)),
      Positioned(
        top: MediaQuery.of(context).size.height / 2 - 46,
        left: MediaQuery.of(context).size.width / 2 - 20,
        // The indicator is an icon
        child: const Center(
          child: HeroIcon(
            HeroIcons.mapPin,
            style: HeroIconStyle.solid,
            size: 30,
            color: AppThemeColors.blue,
          ),
        ),
      ),
      Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 20,
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppThemeColors.contrast0.withOpacity(0.6),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    margin:
                        const EdgeInsets.only(left: 60, right: 60, bottom: 10),
                    child: DatePicker(
                      mode: CupertinoDatePickerMode.dateAndTime,
                      onDateChanged: (date) {
                        time = date;
                      },
                      time: time,
                    ),
                  ),
                  Button(
                      title: "Fertig",
                      stretch: true,
                      onPressed: () async {
                        GeoPoint p = await controller.centerMap;
                        Navigator.of(context).pop(Position.min(
                            latitude: p.latitude,
                            longitude: p.longitude,
                            timestamp: time));
                      }),
                ],
              )))
    ]);
  }
}
