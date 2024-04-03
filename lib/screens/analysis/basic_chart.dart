import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/analysis/average.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/analyze_util.dart';
import 'package:trekko_backend/controller/utils/query_util.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/analysis/basicchart_row.dart';

class BasicChart extends StatelessWidget {
  final Trekko trekko;

  const BasicChart({super.key, required this.trekko});

  Stream<double?> getData(TransportType vehicle) {
    return trekko.analyze(
        QueryUtil(trekko).buildTransportType(vehicle),
        TripUtil(vehicle).build((leg) => leg.getSpeed().as(kilo.meters, hours)),
        AverageCalculation());
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
                return StreamBuilder<double?>(
                  stream: getData(type),
                  builder: (context, snapshot) {
                    Widget dataWidget;
                    if (snapshot.hasData) {
                      var speed = snapshot.data?.toStringAsFixed(1);
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
