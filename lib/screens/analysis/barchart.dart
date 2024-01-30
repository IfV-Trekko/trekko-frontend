import 'package:app_backend/controller/analysis/reductions.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';

class BarChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartWidgetState();

  Trekko trekko;

  BarChartWidget({required this.trekko});
}

class BarChartWidgetState extends State<BarChartWidget> {
  Stream<Duration?> getData(TransportType vehicle) {
    return widget.trekko.analyze(
        widget.trekko
            .getTripQuery()
            .filter()
            .legsElement((l) => l.transportTypeEqualTo(vehicle))
            .build(),
        (t) => t.getDuration(),
        DurationReduction.AVERAGE);
  }

  @override
  Widget build(BuildContext context) {
    double maxDuration = 0;
    for (TransportType type in TransportType.values) {
      getData(type).map((Duration? value) {
        if (value!.inMinutes > maxDuration) {
          maxDuration = value.inMinutes.toDouble();
        }
      });
    }

    List<BarChartGroupData> barGroups = List.empty(growable: true);
    for (TransportType type in TransportType.values) {
      barGroups.add(BarChartGroupData(
        x: TransportType.values.indexOf(type),
        barRods: [
          BarChartRodData(
            toY: 5, //TODO: Wert anpassen
            color: TransportDesign.getColor(type),
            width: 14,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ));
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 14.0, left: 12.0, top: 12.0),
              child: Text('Durch. Wegzeit', style: AppThemeTextStyles.title),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Container(
            margin: EdgeInsets.only(right: 12.0, bottom: 12.0, top: 12.0),
            child: AspectRatio(
              aspectRatio: 1.6,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.values[4],
                  maxY: maxDuration, //TODO: Maximalwert anpassen
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 11, //TODO: Wert anpassen, kann den Durchschnittswert darstellen
                        color: AppThemeColors.purple, //TODO: Farbe anpassen
                        strokeWidth: 2,
                      ),
                    ],
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppThemeColors.contrast200,
                        strokeWidth: 1.5,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  titlesData: const FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      drawBelowEverything: false,
                    ),
                    topTitles: AxisTitles(
                      drawBelowEverything: false,
                    ),
                  ),
                  barGroups: barGroups,
                ),
              ),
            ))
      ],
    );
  }
}
