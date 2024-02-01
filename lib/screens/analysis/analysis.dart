import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/page_control.dart';
import 'package:app_frontend/screens/analysis/vehicle_data.dart';
import 'package:flutter/cupertino.dart';
import 'basic_chart.dart';

class Analysis extends StatefulWidget {
  final Trekko trekko;

  const Analysis(this.trekko, {Key? key}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<VehicleDataBox> vehicleData = [];
    for(TransportType type in TransportType.values) {
        vehicleData.add(VehicleDataBox(vehicle: type, trekko: widget.trekko));
    }

    return CupertinoPageScaffold(
        backgroundColor: AppThemeColors.contrast100,
        child: CustomScrollView (
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text('Statistik'),
            ),
            SliverToBoxAdapter(
            child: CustomPageControl(
              pages: vehicleData,
            ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 14.0, left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                  color: AppThemeColors.contrast0,
                  border: Border.all(color: AppThemeColors.contrast400),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.only(top: 9, bottom: 9, left: 12, right: 12),
                child: //PieChartWidget(trekko: widget.trekko),
                //BarChartWidget(trekko: widget.trekko),
                BasicChart(trekko: widget.trekko),
              ),
            )
          ],
        )
    );
  }
}