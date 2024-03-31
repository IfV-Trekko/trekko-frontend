import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';

class BasicChartRow extends StatelessWidget {
  final TransportType type;
  final Widget value;

  const BasicChartRow({super.key, required this.type, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppThemeColors.contrast0,
        border: Border.all(color: AppThemeColors.contrast150),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(top: 9, bottom: 9, left: 12, right: 12),
      child: Row(
        children: [
          HeroIcon(
            TransportDesign.getIcon(type),
            size: 17,
            color: TransportDesign.getColor(type),
          ),
          const SizedBox(width: 8),
          Text(
            TransportDesign.getName(type),
            style: AppThemeTextStyles.normal
                .copyWith(color: TransportDesign.getColor(type)),
          ),
          const Spacer(),
          value
        ],
      ),
    );
  }
}
