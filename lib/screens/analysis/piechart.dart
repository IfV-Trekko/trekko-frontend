import 'package:app_frontend/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State {
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
        AspectRatio(
          aspectRatio: 1.6,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              PieChart(
                PieChartData(
                  sectionsSpace: 5,
                  centerSpaceRadius: 50,
                  sections: showingSections(),
                  startDegreeOffset: 20,
                ),
              ),
              Text(
                '1234km',
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
          child:
          Wrap(
            spacing: 12, // Horizontaler Abstand zwischen den Legenden-Indikatoren
            runSpacing: 12, // Vertikaler Abstand zwischen den Zeilen
            children: [
              LegendIndicator(color: AppThemeColors.purple, text: 'Fahrrad'),
              LegendIndicator(color: AppThemeColors.orange, text: 'Auto'),
              LegendIndicator(color: AppThemeColors.blue, text: 'zu Fuß'),
              LegendIndicator(color: AppThemeColors.turquoise, text: 'ÖPNV'),
            ],
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final radius = 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppThemeColors.purple,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: AppThemeTextStyles.normal.copyWith(
                color: AppThemeColors.contrast0,
                fontWeight: FontWeight.bold,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppThemeColors.orange,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: AppThemeTextStyles.normal.copyWith(
                color: AppThemeColors.contrast0,
              fontWeight: FontWeight.bold,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppThemeColors.blue,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: AppThemeTextStyles.normal.copyWith(
                color: AppThemeColors.contrast0,
              fontWeight: FontWeight.bold,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: AppThemeColors.turquoise,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: AppThemeTextStyles.normal.copyWith(
                color: AppThemeColors.contrast0,
              fontWeight: FontWeight.bold,
            ),
          );
        default:
          throw Error();
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
        Text(text, style: AppThemeTextStyles.normal.copyWith(
          color: color,
        )),
      ],
    );
  }
}
