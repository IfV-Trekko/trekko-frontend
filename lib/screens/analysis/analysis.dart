import 'package:app_backend/controller/analysis/calculation_reductor.dart';
import 'package:app_backend/controller/analysis/reductions.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/page_control.dart';
import 'package:app_frontend/screens/analysis/barchart.dart';
import 'package:app_frontend/screens/analysis/piechart.dart';
import 'package:app_frontend/screens/analysis/vehicle_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:fling_units/fling_units.dart';
import 'package:isar/isar.dart';

class Analysis extends StatefulWidget {
  final Trekko trekko;

  const Analysis(this.trekko, {Key? key}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

// enum TransportTypeTheme {
//   by_foot(TransportType.by_foot, AppThemeColors.turquoise),
//   car(TransportType.car, AppThemeColors.orange),
//   bicycle(TransportType.by_foot, AppThemeColors.purple),
//   publicTransport(TransportType.by_foot, AppThemeColors.blue);
//
//   final TransportType type;
//   final Color color;
//
//   const TransportTypeTheme(this.type, this.color);
//
//   static TransportTypeTheme? fromTransportType(TransportType type) {
//     for (TransportTypeTheme theme in TransportTypeTheme.values) {
//       if (theme.type == type) {
//         return theme;
//       }
//     }
//     return null;
//   }
// }

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
                child: PieChartWidget(),
                //BarChartWidget(),
              ),
            )
          ],
        )
    );
  }
}