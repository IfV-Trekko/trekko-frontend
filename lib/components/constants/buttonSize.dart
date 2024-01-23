import 'package:flutter/cupertino.dart';

enum ButtonSize {
  small(
      height: 28,
      borderRadius: 40,
      fontSize: 15,
      iconSize: 20,
      sizedBoxWidth: 4,
      fontWeight: FontWeight.w400), //TODO attribute benennen
  large(
      height: 48,
      borderRadius: 10,
      fontSize: 17,
      iconSize: 24,
      sizedBoxWidth: 4,
      fontWeight: FontWeight.w600);

  const ButtonSize(
      {required this.height,
      required this.borderRadius,
      required this.fontSize,
      required this.iconSize,
      required this.sizedBoxWidth,
      required this.fontWeight});
  final double height;
  final double borderRadius;
  final double fontSize;
  final double iconSize;
  final double sizedBoxWidth;
  final FontWeight fontWeight;
}
