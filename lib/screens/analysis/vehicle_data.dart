import 'package:app_backend/controller/analysis/reductions.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:flutter/cupertino.dart';
import '../../app_theme.dart';
import 'attribute_row.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';

class VehicleDataBox extends StatelessWidget {
  Trekko trekko;
  TransportType vehicle;

  VehicleDataBox({required this.trekko, required this.vehicle});

  Stream<T?> getData<T>(T Function(Trip) apply, Reduction<T> reduction) {
    return trekko.analyze(
        trekko
            .getTripQuery()
            .filter()
            .legsElement((l) => l.transportTypeEqualTo(vehicle))
            .build(),
        apply,
        reduction);
  }

  Widget getDataFormatted<T>(T Function(Trip) apply, Reduction<T> reduction,
      String Function(T) format) {
    return StreamBuilder<T?>(
      stream: getData(apply, reduction),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            format(snapshot.data!), // Verwendung des Parameters value
            style:
                AppThemeTextStyles.normal.copyWith(fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            'Keine Daten',
            style:
                AppThemeTextStyles.normal.copyWith(fontWeight: FontWeight.w600),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var sizedBox = const SizedBox(height: 8);
    return Container(
        decoration: BoxDecoration(
          color: AppThemeColors.contrast0,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: AppThemeColors.contrast0,
          border: Border.all(
            color: TransportDesign.getColor(vehicle).withOpacity(0.27),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TransportDesign.getColor(vehicle)
                  .withOpacity(0.08),
              TransportDesign.getColor(vehicle)
                  .withOpacity(0.00),
              TransportDesign.getColor(vehicle)
                  .withOpacity(0.00),
            ],
            stops: [0.0, 0.1875, 1],
          ),

          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [  //TODO: Icon einfügen
                /*Icon(
                  TransportDesign.getIcon(vehicle),
                  color: TransportDesign.getColor(vehicle),
                  size: 32,
                ),*/
                Text(
                  TransportDesign.getName(vehicle),
                  style: AppThemeTextStyles.title.copyWith(
                    color: TransportDesign.getColor(vehicle),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AttributeRow(
                title: 'Gesamtstrecke',
                value: getDataFormatted((t) => t.getDistance(),
                    DistanceReduction.SUM, (d) => d.as(kilo.meters).roundToDouble().toString() + " km")),

            sizedBox,
            AttributeRow(
                title: 'Ø Strecke pro Weg',
                value: getDataFormatted((t) => t.getDistance(),
                    DistanceReduction.AVERAGE, (d) => d.as(kilo.meters).roundToDouble().toString() + " km")),

            sizedBox,
            AttributeRow(
                title: 'Ø Geschwindigkeit',
                value: getDataFormatted((t) => t.getSpeed(),
                    SpeedReduction.AVERAGE, (d) => d.as(kilo.meters, hours).roundToDouble().toString() + " km/h")),

            sizedBox,
            AttributeRow(
                title: 'Ø Wegzeit',
                value: getDataFormatted((t) => t.getDuration(),
                    DurationReduction.AVERAGE, (d) => d.inMinutes.roundToDouble().toString() + " min")),
          ],
        ),
      ),
    );
  }
}
