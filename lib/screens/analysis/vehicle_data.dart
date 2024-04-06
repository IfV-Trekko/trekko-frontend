import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/controller/analysis/average.dart';
import 'package:trekko_backend/controller/analysis/calculation.dart';
import 'package:trekko_backend/controller/analysis/reductions.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/analyze_util.dart';
import 'package:trekko_backend/controller/utils/trip_query.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';
import 'package:trekko_frontend/screens/analysis/attribute_row.dart';

class VehicleData extends StatelessWidget {
  final Trekko trekko;
  final TransportType vehicle;

  const VehicleData({super.key, required this.trekko, required this.vehicle});

  Stream<T?> getData<T>(Iterable<T> Function(Trip) apply, Calculation<T> calc) {
    return trekko.analyze(
        TripQuery(trekko).andTransportType(vehicle).build(), apply, calc);
  }

  Widget getDataFormatted<T>(Iterable<T> Function(Trip) apply,
      Calculation<T> reduction, String Function(T) format) {
    return StreamBuilder<T?>(
      stream: getData(apply, reduction),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            format(snapshot.data as T),
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
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.contrast0,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: AppThemeColors.contrast0,
          border: Border.all(
            color: TransportDesign.getColor(vehicle).withOpacity(0.27),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TransportDesign.getColor(vehicle).withOpacity(0.08),
              TransportDesign.getColor(vehicle).withOpacity(0.00),
              TransportDesign.getColor(vehicle).withOpacity(0.00),
            ],
            stops: const [0.0, 0.1875, 1],
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                HeroIcon(
                  TransportDesign.getIcon(vehicle),
                  size: 24,
                  color: TransportDesign.getColor(vehicle),
                ),
                const SizedBox(width: 8),
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
                value: getDataFormatted(
                    TripUtil(vehicle).build(
                        (leg) => leg.calculateDistance().as(kilo.meters)),
                    DoubleReduction.SUM,
                    (d) => "${d.toStringAsFixed(1)} km")),
            const SizedBox(height: 8),
            AttributeRow(
                title: 'Ø Strecke pro Weg',
                value: getDataFormatted(
                    TripUtil(vehicle).build(
                        (leg) => leg.calculateDistance().as(kilo.meters)),
                    AverageCalculation(),
                    (d) => "${d.toStringAsFixed(1)} km")),
            const SizedBox(height: 8),
            AttributeRow(
                title: 'Ø Geschwindigkeit',
                value: getDataFormatted(
                    TripUtil(vehicle).build(
                        (leg) => leg.calculateSpeed().as(kilo.meters, hours)),
                    AverageCalculation(),
                    (d) => "${d.toStringAsFixed(1)} km/h")),
            const SizedBox(height: 8),
            AttributeRow(
                title: 'Ø Wegzeit',
                value: getDataFormatted(
                    TripUtil(vehicle).build(
                        (leg) => leg.calculateDuration().inMinutes.toDouble()),
                    AverageCalculation(),
                    (d) => "${d.toStringAsFixed(1)} min")),
          ],
        ),
      ),
    );
  }
}
