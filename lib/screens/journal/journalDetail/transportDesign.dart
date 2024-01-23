import 'package:app_backend/model/trip/transport_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

import '../../../app_theme.dart';
//TODO: change from Pink and Cake to correct colors and icons
class TransportDesign {
  static final Map<TransportType, Color> _colors = {
    TransportType.by_foot: AppThemeColors.pink,
    TransportType.bicycle: AppThemeColors.pink,
    TransportType.car: AppThemeColors.pink,
    TransportType.publicTransport: AppThemeColors.pink,
    TransportType.ship: AppThemeColors.pink,
    TransportType.plane: AppThemeColors.pink,
    TransportType.other: AppThemeColors.pink,
  };

  static final Map<TransportType, HeroIcons> _icons = {
    TransportType.by_foot: HeroIcons.cake,
    TransportType.bicycle: HeroIcons.arrowSmallDown,
    TransportType.car: HeroIcons.arrowSmallLeft,
    TransportType.publicTransport: HeroIcons.arrowSmallUp,
    TransportType.ship: HeroIcons.eyeDropper,
    TransportType.plane: HeroIcons.wallet,
    TransportType.other: HeroIcons.xCircle,
  };

  static Color getColor(TransportType type) {
    return _colors[type] ?? AppThemeColors.contrast0;
  }

  static HeroIcons getIcon(TransportType type) {
    return _icons[type] ?? HeroIcons.cake; //TODO fix return to sensible default when no icon available
  }
}