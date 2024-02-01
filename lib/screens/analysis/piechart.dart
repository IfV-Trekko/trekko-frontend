import 'package:async/async.dart';

import 'package:app_backend/controller/analysis/reductions.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';

import '../journal/journalDetail/transportDesign.dart';

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
          title: value == null
              ? '0%'
              : (value.as(meters) / sum.as(meters) * 100).round().toString() +
                  '%',
          radius: 55,
          titleStyle: AppThemeTextStyles.normal.copyWith(
            color: AppThemeColors.contrast0,
            fontWeight: FontWeight.bold,
          ),
        );
      }));
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 14.0, left: 4.0, top: 7.0),
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
                    return Text("${snapshot.error}");
                  } else {
                    return CupertinoActivityIndicator();
                  }
                },
              ),
              Text(
                sum.as(kilo.meters).roundToDouble().toString() + " km",
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
          padding: EdgeInsets.only(top: 9, bottom: 9, left: 12, right: 12),
          child: Wrap(
            spacing:
                12, // Horizontaler Abstand zwischen den Legenden-Indikatoren
            runSpacing: 12, // Vertikaler Abstand zwischen den Zeilen
            children: [
              for (TransportType type in TransportType.values)
                LegendIndicator(
                    color: TransportDesign.getColor(type),
                    text: TransportDesign.getName(type)),
            ],
          ),
        )
      ],
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
            return CupertinoActivityIndicator();
          }
        });
  }
}

class LegendIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const LegendIndicator({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 8),
        Text(text,
            style: AppThemeTextStyles.normal.copyWith(
              color: color,
            )),
      ],
    );
  }
}
