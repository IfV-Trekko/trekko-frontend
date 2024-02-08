import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/page_control.dart';
import 'package:app_frontend/screens/analysis/barchart.dart';
import 'package:app_frontend/screens/analysis/basic_chart.dart';
import 'package:app_frontend/screens/analysis/piechart.dart';
import 'package:app_frontend/screens/analysis/vehicle_data.dart';
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
    List<VehicleData> vehicleData = [];
    for (TransportType type in TransportType.values) {
      vehicleData.add(VehicleData(vehicle: type, trekko: widget.trekko));
    }

    return CupertinoPageScaffold(
        backgroundColor: AppThemeColors.contrast100,
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Statistik'),
            ),
            SliverToBoxAdapter(
              child: CustomPageControl(
                pages: vehicleData,
                pageHeights: 288,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: CustomPageControl(
                  pages: [
                    PieChartWidget(trekko: widget.trekko),
                    BarChartWidget(trekko: widget.trekko),
                    BasicChart(trekko: widget.trekko),
                  ],
                  pageHeights: 440,
                ),
              ),
            ),
          ],
        ));
  }
}
