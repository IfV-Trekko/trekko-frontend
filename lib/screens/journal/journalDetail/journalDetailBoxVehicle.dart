import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_frontend/screens/journal/journalDetail/transportDesign.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:heroicons/src/icons.g.dart';

import '../../../app_theme.dart';

class JournalDetailBoxVehicle extends StatelessWidget {
  final String _title;
  final Color _color;
  final HeroIcons _icon;

  JournalDetailBoxVehicle(TransportType transportType)
      : _title = TransportDesign.getName(transportType),
        _color = TransportDesign.getColor(transportType),
        _icon = TransportDesign.getIcon(transportType);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 24,
        decoration: BoxDecoration(
          color: _color.withOpacity(0.16), // Background color with opacity 0.16
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            _icon,
            size: 18,
            color: _color.withOpacity(0.8), // Icon color with opacity 0.8
          ),
          SizedBox(width: 6),
          Text(
            _title,
            style: AppThemeTextStyles.small.copyWith(color: _color),
          ),
        ],
      ),
    );
  }
}