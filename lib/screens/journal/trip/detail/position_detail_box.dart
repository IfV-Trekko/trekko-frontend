import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_frontend/components/tile_utils.dart';

class PositionDetailBox extends StatelessWidget {

  final PositionCollection data;

  const PositionDetailBox({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      margin: TileUtils.listSectionMargin,
      additionalDividerMargin: TileUtils.defaultDividerMargin,
      children: [
        CupertinoListTile.notched(
          title: TileUtils.buildTitleRow("Distanz", HeroIcons.map),
          padding: TileUtils.listTilePadding,
          trailing: Text(
              '${data.calculateDistance().as(meters).toStringAsFixed(0)}m'),
        ),
        CupertinoListTile.notched(
          title: TileUtils.buildTitleRow("Dauer", HeroIcons.clock),
          padding: TileUtils.listTilePadding,
          trailing: Text('${data.calculateDuration().inMinutes}min'),
        ),
        CupertinoListTile.notched(
          title: TileUtils.buildTitleRow("Startzeit", HeroIcons.chevronRight),
          padding: TileUtils.listTilePadding,
          trailing: Text(
              DateFormat('HH:mm').format(data.calculateStartTime())),
        ),
        CupertinoListTile.notched(
          title: TileUtils.buildTitleRow("Endzeit", HeroIcons.chevronLeft),
          padding: TileUtils.listTilePadding,
          trailing: Text(
              DateFormat('HH:mm').format(data.calculateEndTime())),
        ),
        CupertinoListTile.notched(
          title: TileUtils.buildTitleRow("Geschwindigkeit", HeroIcons.arrowTrendingUp),
          padding: TileUtils.listTilePadding,
          trailing: Text(
              '${data.calculateSpeed().as(kilo.meters, hours).toStringAsFixed(2)}km/h'),
        ),
      ],
    );
  }
}
