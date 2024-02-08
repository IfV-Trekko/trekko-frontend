import 'package:flutter/cupertino.dart';

enum TextResponseKeyboardType {
  text(inputType: TextInputType.text),
  number(inputType: TextInputType.number),
  dezimal(inputType: TextInputType.numberWithOptions(decimal: true)),
  ;

  const TextResponseKeyboardType({required this.inputType});
  final TextInputType inputType;
}
