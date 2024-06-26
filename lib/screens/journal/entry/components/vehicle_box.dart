import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';

class VehicleBox extends StatelessWidget {
  final String _title;
  final Color _color;
  final HeroIcons _icon;
  final bool showText;

  VehicleBox(TransportType transportType, {super.key, this.showText = false})
      : _title = TransportDesign.getName(transportType),
        _color = TransportDesign.getColor(transportType),
        _icon = TransportDesign.getIcon(transportType);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(_icon, size: 18, color: _color.withOpacity(0.8)),
          LayoutBuilder(
            builder: ((context, constraints) {
              return Row(
                children: [
                  if (showText) const SizedBox(width: 6),
                  if (showText)
                    Text(
                      _title,
                      style: AppThemeTextStyles.small
                          .copyWith(color: _color.withOpacity(0.8)),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
