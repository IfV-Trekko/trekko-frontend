import 'package:app_backend/controller/analysis/reductions.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/analysis/basicchart_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';

class BasicChart extends StatelessWidget {
  final Trekko trekko;

  const BasicChart({super.key, required this.trekko});

  Stream<DerivedMeasurement<Measurement<Distance>, Measurement<Time>>?> getData(
      TransportType vehicle) {
    return trekko.analyze(
        trekko
            .getTripQuery()
            .filter()
            .legsElement((l) => l.transportTypeEqualTo(vehicle))
            .build(),
        (t) => t.calculateSpeed(),
        SpeedReduction.AVERAGE);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.contrast0,
        border: Border.all(color: AppThemeColors.contrast400),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(top: 9, bottom: 9, left: 12, right: 12),
      child: Container(
          margin: const EdgeInsets.only(top: 7, left: 4, right: 4),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(
                  'Ø Geschwindigkeit',
                  style: AppThemeTextStyles.title,
                ),
              ]),
              const SizedBox(height: 16),
              ...TransportType.values.map((type) {
                return StreamBuilder<
                    DerivedMeasurement<Measurement<Distance>,
                        Measurement<Time>>?>(
                  stream: getData(type),
                  builder: (context, snapshot) {
                    Widget dataWidget;
                    if (snapshot.hasData) {
                      var speed = snapshot.data
                          ?.as(kilo.meters, hours)
                          .toStringAsFixed(1);
                      dataWidget = Text('${speed.toString()} km/h');
                    } else {
                      dataWidget = const Text('Keine Daten');
                    }
                    return BasicChartRow(type: type, value: dataWidget);
                  },
                );
              }).toList(),
            ],
          )),
    );
  }
}
