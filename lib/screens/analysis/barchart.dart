import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 14.0, left: 12.0, top: 12.0),
              child: Text('Gesamtstrecke',
                  style: AppThemeTextStyles.title),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        AspectRatio(
            aspectRatio: 1.6,
          child: BarChart(
            BarChartData(
              //alignment: BarChartAlignment.spaceAround,
              maxY: 15,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              gridData: FlGridData(
                show: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(color: Colors.black, fontSize: 13),
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Mon';
                      case 1:
                        return 'Tue';
                      case 2:
                        return 'Wed';
                      case 3:
                        return 'Thu';
                      case 4:
                        return 'Fri';
                      case 5:
                        return 'Sat';
                      case 6:
                        return 'Sun';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                ),
                rightTitles: SideTitles(
                  showTitles: false,
                ),
                topTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 8, colors: [Colors.lightBlueAccent])]),
                BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 10, colors: [Colors.lightBlueAccent])]),
                BarChartGroupData(x: 5, barRods: [BarChartRodData(y: 14, colors: [Colors.lightBlueAccent])]),
                // Fügen Sie weitere BarChartGroupData für andere Balken hinzu
              ],
            ),
          ),
        )
      ],
    );
  }
  }