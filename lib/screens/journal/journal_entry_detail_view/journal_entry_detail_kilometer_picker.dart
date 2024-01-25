import 'dart:ui';

import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class JournalEntryDetailKilometerPicker extends StatefulWidget {
  const JournalEntryDetailKilometerPicker({super.key});

  @override
  _JournalEntryDetailKilometerPickerState createState() =>
      _JournalEntryDetailKilometerPickerState();
}

class _JournalEntryDetailKilometerPickerState
    extends State<JournalEntryDetailKilometerPicker> {
  double? _kilometers;
  String _inputText = '';
  String placeholder = '8,8'; //TODO initialize with backend

  void _onChanged(String value) {
    setState(() {
      _kilometers = double.tryParse(value.replaceAll(',', '.'));
      _inputText = "${value}km";
    });
    // TODO: Pass _kilometers to the backend
  }

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _inputText,
        style: AppThemeTextStyles.small,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textWidth = textPainter.size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11),
      height: 34,
      decoration: BoxDecoration(
        color: AppThemeColors.contrast0,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppThemeColors.contrast200, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: _inputText == ''
                ? placeholder.length * 17
                : textWidth + 4, // Dynamic width based on text width
            child: CupertinoTextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              placeholder: placeholder,
              padding: EdgeInsets.all(0),
              onChanged: _onChanged, // TODO Backend einbinden
              style: AppThemeTextStyles.small,
              decoration: BoxDecoration(
                border: Border.all(color: AppThemeColors.contrast0),
              ),
              suffix: Text('km',
                  style: AppThemeTextStyles.small
                      .copyWith(color: AppThemeColors.contrast500)),
            ),
          ),
        ],
      ),
    );
  }
}
