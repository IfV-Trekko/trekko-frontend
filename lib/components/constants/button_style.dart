import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

enum ButtonStyle {
  primary(AppThemeColors.blue, AppThemeColors.contrast0),
  secondary(AppThemeColors.contrast150, AppThemeColors.blue),
  destructive(AppThemeColors.red, AppThemeColors.contrast0),
  transparent(AppThemeColors.contrast0, AppThemeColors.blue);


  const ButtonStyle(this.backgroundColor, this.textColor);
  final Color backgroundColor;
  final Color textColor;
}
