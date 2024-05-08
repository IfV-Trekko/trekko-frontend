import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/page_control.dart';
import 'package:trekko_frontend/screens/analysis/barchart.dart';
import 'package:trekko_frontend/screens/analysis/basic_chart.dart';
import 'package:trekko_frontend/screens/analysis/piechart.dart';
import 'package:trekko_frontend/screens/analysis/vehicle_data.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class Analysis extends StatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  AnalysisState createState() => AnalysisState();
}

class AnalysisState extends State<Analysis> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Trekko trekko = TrekkoProvider.of(context);
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
                    .map((e) => VehicleData(vehicle: e, trekko: trekko))
                    .toList(),
                pageHeights: 288,
              ),
            ),
            SliverToBoxAdapter(
              child: CustomPageControl(
                pages: [
                  PieChartWidget(trekko: trekko),
                  BarChartWidget(trekko: trekko),
                  BasicChart(trekko: trekko),
                ],
                pageHeights: 440,
              ),
            ),
          ],
        ));
  }
}
