import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/page_control.dart';
import 'package:trekko_frontend/screens/analysis/barchart.dart';
import 'package:trekko_frontend/screens/analysis/basic_chart.dart';
import 'package:trekko_frontend/screens/analysis/piechart.dart';
import 'package:trekko_frontend/screens/analysis/vehicle_data.dart';
import 'package:flutter/cupertino.dart';

class Analysis extends StatefulWidget {
  final Trekko trekko;

  const Analysis(this.trekko, {Key? key}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
        backgroundColor: AppThemeColors.contrast100,
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Statistik'),
            ),
            SliverToBoxAdapter(
              child: CustomPageControl(
                pages: TransportType.values
                    .map((e) => VehicleData(vehicle: e, trekko: widget.trekko))
                    .toList(),
                pageHeights: 288,
              ),
            ),
            SliverToBoxAdapter(
              child: CustomPageControl(
                pages: [
                  PieChartWidget(trekko: widget.trekko),
                  BarChartWidget(trekko: widget.trekko),
                  BasicChart(trekko: widget.trekko),
                ],
                pageHeights: 440,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, right: 16.0, left: 16.0, bottom: 64.0),
                child: Text(
                  "Die Statistiken verarbeiten nur Daten unbearbeiteter, automatisch getrackter Wege.",
                  style: AppThemeTextStyles.tiny,
                ),
              ),
            )
          ],
        ));
  }
}
