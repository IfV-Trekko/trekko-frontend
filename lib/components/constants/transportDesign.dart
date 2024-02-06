import 'package:app_backend/model/trip/transport_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import '../../app_theme.dart';

//TODO: change from red and Hashtag to correct colors and icons
class TransportDesign {
  static final Map<TransportType, Color> _colors = {
    TransportType.by_foot: AppThemeColors.blue,
    TransportType.bicycle: AppThemeColors.purple,
    TransportType.car: AppThemeColors.orange,
    TransportType.publicTransport: AppThemeColors.pink,
    TransportType.ship: AppThemeColors.red,
    TransportType.plane: AppThemeColors.turquoise,
    TransportType.other: AppThemeColors.red,
  };

  //TODO change to correct icons from CupertinoIcons package
  static final Map<TransportType, HeroIcons> _icons = {
    TransportType.by_foot: HeroIcons.footstepsOutline,
    TransportType.bicycle: HeroIcons.bicycleOutline,
    TransportType.car: HeroIcons.carSportOutline,
    TransportType.publicTransport: HeroIcons.trainOutline,
    TransportType.ship: HeroIcons.boatOutline,
    TransportType.plane: HeroIcons.airplaneOutline,
    TransportType.other: HeroIcons.hashtag,
  };

  static final Map<TransportType, String> _name = {
    TransportType.by_foot: "Zu Fuß",
    TransportType.bicycle: "Fahrrad",
    TransportType.car: "Auto",
    TransportType.publicTransport: "ÖPNV",
    TransportType.ship: "Schiff",
    TransportType.plane: "Flugzeug",
    TransportType.other: "Sonstige",
  };

  static String getName(TransportType type) {
    return _name[type] ?? "Fehler";
  }

  static Color getColor(TransportType type) {
    return _colors[type] ?? AppThemeColors.contrast0;
  }

  static HeroIcons getIcon(TransportType type) {
    return _icons[type] ?? HeroIcons.hashtag;
  }
}
