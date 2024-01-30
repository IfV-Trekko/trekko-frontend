import 'package:app_backend/controller/analysis/reductions.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/leg.dart';
import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/screens/analysis/attribute_row.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:fling_units/fling_units.dart';

import '../../app_theme.dart';

class BasicChart extends StatelessWidget{

  Trekko trekko;
  //TransportType vehicle;

  BasicChart({required this.trekko});

/*  Stream<SpeedReduction?> getData(TransportType vehicle) {
    return trekko.analyze(
        trekko
            .getTripQuery()
            .filter()
            .legsElement((l) => l.transportTypeEqualTo(vehicle))
            .build(),
            (t) => t.getSpeed(),
        SpeedReduction.AVERAGE
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only( top: 3, left: 4),
        child:
        Column(
          children: [
            Row(
              children:[
                Text('Geschwindigkeit',
                  style: AppThemeTextStyles.title,
                ),
              ]
            ),
            SizedBox(height: 16),
            // AttributeRow(title: TransportDesign.getName(vehicle),
            //     value: getDataFormatted((t) => t.getDistance(),
            //         DistanceReduction.AVERAGE, (d) => d.as(kilo.meters).roundToDouble().toString() + " km"))
          ],
        )
    );
  }
}

