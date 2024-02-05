import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../app_theme.dart';

class BasicChartRow extends StatelessWidget {
  final TransportType type;
  final Widget value;

  BasicChartRow({required this.type, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppThemeColors.contrast0,
        border: Border.all(color: AppThemeColors.contrast150),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.only(top: 9, bottom: 9, left: 12, right: 12),
      child: Row(
        children: [
          HeroIcon(
            TransportDesign.getIcon(type),
            size: 17,
            color: TransportDesign.getColor(type),
          ),
          SizedBox(width: 8),
          Text(
            TransportDesign.getName(type),
            style: AppThemeTextStyles.normal.copyWith(
              color: TransportDesign.getColor(type),
            ),
          ),
          Spacer(),
          value
        ],
      ),
    );
  }
}