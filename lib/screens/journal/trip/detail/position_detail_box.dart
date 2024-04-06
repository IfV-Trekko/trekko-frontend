import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_frontend/components/constants/tile_dimensions.dart';

class PositionDetailBox extends StatelessWidget {

  final PositionCollection data;

  const PositionDetailBox({required this.data, super.key});

  Widget _buildTitleRow(String title, HeroIcons icon) {
    return Row(
      children: [
        HeroIcon(icon),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      margin: TileDimensions.listSectionMargin,
      additionalDividerMargin: TileDimensions.defaultDividerMargin,
      children: [
        CupertinoListTile.notched(
          title: _buildTitleRow("Distanz", HeroIcons.map),
          padding: TileDimensions.listTilePadding,
          trailing: Text(
              '${data.calculateDistance().as(meters).toStringAsFixed(0)}m'),
        ),
        CupertinoListTile.notched(
          title: _buildTitleRow("Dauer", HeroIcons.clock),
          padding: TileDimensions.listTilePadding,
          trailing: Text('${data.calculateDuration().inMinutes}min'),
        ),
        CupertinoListTile.notched(
          title: _buildTitleRow("Startzeit", HeroIcons.chevronRight),
          padding: TileDimensions.listTilePadding,
          trailing: Text(
              DateFormat('dd.MM.yyyy HH:mm').format(data.calculateStartTime())),
        ),
        CupertinoListTile.notched(
          title: _buildTitleRow("Endzeit", HeroIcons.chevronLeft),
          padding: TileDimensions.listTilePadding,
          trailing: Text(
              DateFormat('dd.MM.yyyy HH:mm').format(data.calculateEndTime())),
        ),
        CupertinoListTile.notched(
          title: _buildTitleRow("Geschwindigkeit", HeroIcons.arrowTrendingUp),
          padding: TileDimensions.listTilePadding,
          trailing: Text(
              '${data.calculateSpeed().as(kilo.meters, hours).toStringAsFixed(2)}km/h'),
        ),
      ],
    );
  }
}
