import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';

enum ButtonStyle {
  primary(AppThemeColors.blue, AppThemeColors.contrast0),
  secondary(AppThemeColors.contrast150, AppThemeColors.blue),
  destructive(AppThemeColors.contrast150, AppThemeColors.red),
  transparent(AppThemeColors.contrast0, AppThemeColors.blue);

  const ButtonStyle(this.backgroundColor, this.textColor);
  final Color backgroundColor;
  final Color textColor;
}
