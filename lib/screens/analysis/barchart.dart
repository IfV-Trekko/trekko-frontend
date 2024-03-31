import 'package:trekko_backend/controller/analysis/average.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/analyze_util.dart';
import 'package:trekko_backend/controller/utils/query_util.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';
import 'package:async/async.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple(this.item1, this.item2);
}

class BarChartWidget extends StatefulWidget {
  final Trekko trekko;

  const BarChartWidget({super.key, required this.trekko});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  Stream<double?> getData(TransportType vehicle) {
    return widget.trekko.analyze(
        QueryUtil(widget.trekko).buildTransportType(vehicle),
        TripUtil(vehicle)
            .build((leg) => leg.getDuration().inMinutes.toDouble()),
        AverageCalculation());
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
    var type = TransportType.values[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6,
      child: HeroIcon(TransportDesign.getIcon(type),
          size: 17, color: TransportDesign.getColor(type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<Tuple<TransportType, double>>> buildData() {
      List<Stream<Tuple<TransportType, double>>> data =
          List.empty(growable: true);
      for (TransportType type in TransportType.values) {
        data.add(getData(type).map((double? value) {
          if (value == null) {
            return Tuple(type, 0);
          } else {
            return Tuple(type, value);
          }
        }));
      }
      return StreamZip(data);
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
                    const EdgeInsets.only(bottom: 14.0, left: 12.0, top: 7.0),
                child: Text('Ø Wegzeit', style: AppThemeTextStyles.title),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
              margin:
                  const EdgeInsets.only(right: 12.0, bottom: 12.0, top: 12.0),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: StreamBuilder<List<Tuple<TransportType, double>>>(
                  stream: buildData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CupertinoActivityIndicator();
                    } else if (snapshot.hasError) {
                      throw snapshot.error!;
                    } else if (snapshot.hasData) {
                      double maxDuration = 0;
                      double durationSum = 0;
                      List<BarChartGroupData> barGroups =
                          List.empty(growable: true);
                      for (Tuple<TransportType, double> data
                          in snapshot.data!) {
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
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: AppThemeColors.contrast150,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${rod.toY}',
                                  const TextStyle(
                                      color: AppThemeColors.contrast900),
                                );
                              },
                            ),
                          ),
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: durationSum / TransportType.values.length,
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
                    } else {
                      return const CupertinoActivityIndicator();
                    }
                  },
                ),
              ))
        ],
      ),
    );
  }
}
