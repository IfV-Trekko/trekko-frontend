import 'package:async/async.dart';
import 'package:app_backend/controller/analysis/reductions.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';
import '../../components/constants/transportDesign.dart';
import 'legend_indicator.dart';

class PieChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartWidgetState();

  Trekko trekko;

  PieChartWidget({required this.trekko});
}

class PieChartWidgetState extends State<PieChartWidget> {
  Stream<Distance?> getData(TransportType vehicle) {
    return widget.trekko.analyze(
        widget.trekko
            .getTripQuery()
            .filter()
            .legsElement((l) => l.transportTypeEqualTo(vehicle))
            .build(),
        (t) => t.getDistance(),
        DistanceReduction.SUM);
  }

  Widget buildPieChart(Distance sum) {
    List<Stream<PieChartSectionData>> pieCharts = List.empty(growable: true);
    for (TransportType type in TransportType.values) {
      pieCharts.add(getData(type).map((Distance? value) {
        return PieChartSectionData(
          color: TransportDesign.getColor(type),
          value: value == null ? 0 : value.as(meters),
          title: value == null || sum == const Distance.zero()
              ? '0%'
              : '${(value.as(meters) / sum.as(meters) * 100).round()}%',
          radius: 55,
          titleStyle: AppThemeTextStyles.normal.copyWith(
            color: AppThemeColors.contrast0,
            fontWeight: FontWeight.bold,
          ),
        );
      }));
    }

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.contrast0,
        border: Border.all(color: AppThemeColors.contrast400),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(top: 9, bottom: 16, left: 12, right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin:
                    const EdgeInsets.only(bottom: 14.0, left: 4.0, top: 7.0),
                child: Text('Gesamtstrecke', style: AppThemeTextStyles.title),
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: 1.6,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                StreamBuilder<List<PieChartSectionData>>(
                  stream: StreamZip(pieCharts),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return PieChart(
                        PieChartData(
                          sectionsSpace: 5,
                          centerSpaceRadius: 50,
                          sections: snapshot.data!,
                          startDegreeOffset: 20,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      throw snapshot.error!;
                    } else {
                      return CupertinoActivityIndicator();
                    }
                  },
                ),
                Text(
                  "${sum.as(kilo.meters).roundToDouble()} km",
                  style: AppThemeTextStyles.normal
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppThemeColors.contrast100,
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                const EdgeInsets.only(top: 9, bottom: 9, left: 12, right: 12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (TransportType type in TransportType.values)
                  LegendIndicator(
                      color: TransportDesign.getColor(type),
                      text: TransportDesign.getName(type)),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var stream = widget.trekko.analyze(widget.trekko.getTripQuery().build(),
        (p0) => p0.getDistance(), DistanceReduction.SUM);
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildPieChart(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return buildPieChart(0.meters);
          }
        });
  }
}
