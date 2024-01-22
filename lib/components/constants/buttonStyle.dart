import 'package:flutter/cupertino.dart';

enum ButtonStyle {
  primary(CupertinoColors.activeBlue, CupertinoColors.white),
  secondary(CupertinoColors.white, CupertinoColors.activeBlue);

  const ButtonStyle(this.backgroundColor, this.textColor);
  final Color backgroundColor;
  final Color textColor;

  get BackroundColor => backgroundColor;
  get TextColor => textColor;
}
