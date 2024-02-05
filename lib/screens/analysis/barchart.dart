import 'package:app_backend/controller/analysis/reductions.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:async/async.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:isar/isar.dart';

class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;
  Tuple(this.item1, this.item2);
}

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
    Stream<List<Tuple<TransportType, double>>> buildData() {
      List<Stream<Tuple<TransportType, double>>> data = List.empty(growable: true);
      for (TransportType type in TransportType.values) {
        data.add(getData(type).map((Duration? value) {
          if (value == null) {
            return Tuple(type, 0);
          } else {
            return Tuple(type, value.inMinutes.toDouble());
          }
        }));
      }
      return StreamZip(data);
    }

    BarChartGroupData chartFromDouble(TransportType type, double data) {
      return BarChartGroupData(
        x: TransportType.values.indexOf(type),
        barRods: [
          BarChartRodData(
            toY: data,
            color: TransportDesign.getColor(type),
            width: 14,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    }

    Widget getTitles(double value, TitleMeta meta) {
      String text;
      TextStyle? style;
      switch (value.toInt()) {
        case 0:
          text = 'zF';
          style =
              TextStyle(color: TransportDesign.getColor(TransportType.by_foot));
          break;
        case 1:
          text = 'Fr';
          style =
              TextStyle(color: TransportDesign.getColor(TransportType.bicycle));
          break;
        case 2:
          text = 'A';
          style = TextStyle(color: TransportDesign.getColor(TransportType.car));
          break;
        case 3:
          text = 'ÖPNV';
          style = TextStyle(
              color: TransportDesign.getColor(TransportType.publicTransport));
          break;
        case 4:
          text = 'S';
          style =
              TextStyle(color: TransportDesign.getColor(TransportType.ship));
          break;
        case 5:
          text = 'Fl';
          style =
              TextStyle(color: TransportDesign.getColor(TransportType.plane));
          break;
        case 6:
          text = 'Sonst.';
          style =
              TextStyle(color: TransportDesign.getColor(TransportType.other));
          break;
        default:
          text = '';
          break;
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 6,
        child: Text(text, style: style),
      );
    }

    FlTitlesData titlesData = FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(
        drawBelowEverything: false,
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          //interval: 2,
          reservedSize: 34,
        ),
      ),
      topTitles: const AxisTitles(
        drawBelowEverything: false,
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: getTitles,
        ),
      ),
    );

    return Container( //TODO: schöner Code?? bzw Codeduplikation
    decoration: BoxDecoration(
    color: AppThemeColors.contrast0,
    border: Border.all(color: AppThemeColors.contrast400),
    borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.only(top: 9, bottom: 16, left: 12, right: 12),
    child:
    Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin:
              const EdgeInsets.only(bottom: 14.0, left: 12.0, top: 7.0),
              child: Text('Ø Wegzeit', style: AppThemeTextStyles.title),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Container(
            margin: const EdgeInsets.only(right: 12.0, bottom: 12.0, top: 12.0),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: StreamBuilder<List<Tuple<TransportType, double>>>(
                stream: buildData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double maxDuration = 0;
                    double durationSum = 0;
                    List<BarChartGroupData> barGroups = List.empty(growable: true);
                    for (Tuple<TransportType, double> data in snapshot.data!) {
                      if (data.item2 > maxDuration) {
                        maxDuration = data.item2;
                      }
                      barGroups.add(chartFromDouble(data.item1, data.item2));
                      durationSum += data.item2;
                    }
                    return BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.values[4],
                        maxY: maxDuration,
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: durationSum / TransportType.values.length, //TODO: schöner Code??
                              color: AppThemeColors.contrast400,
                              strokeWidth: 2,
                            ),
                          ],
                        ),
                        gridData: FlGridData(
                          show: false,
                          drawHorizontalLine: true,
                          drawVerticalLine: false,
                          horizontalInterval: 5,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                              color: AppThemeColors.contrast200,
                              strokeWidth: 1.5,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        titlesData: titlesData,
                        barGroups: barGroups,
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
            ))
      ],
    ),
    );
  }
}
