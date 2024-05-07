import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';

class InformationRow extends StatelessWidget {
  final PositionCollection data;

  const InformationRow({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    Duration duration = data.calculateDuration();
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            DateFormat('HH:mm').format(data.calculateStartTime()),
            style: AppThemeTextStyles.largeTitle.copyWith(letterSpacing: -1),
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(hours > 0 ? "$hours h $minutes min" : "$minutes min",
                    style: TextStyle(
                        color: TransportDesign.getColor(
                            data.calculateMostUsedType()))),
                const SizedBox(width: 4.0),
                Text(
                  "- ${data.calculateDistance().as(kilo.meters).toStringAsFixed(1)} km",
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Text(
            DateFormat('HH:mm').format(data.calculateEndTime()),
            style: AppThemeTextStyles.largeTitle.copyWith(letterSpacing: -1),
          ),
        ),
      ],
    );
  }
}
