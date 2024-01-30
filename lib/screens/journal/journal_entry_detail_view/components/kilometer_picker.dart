import 'dart:ui';

import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class JournalEntryDetailKilometerPicker extends StatefulWidget {
  final double initialValue;
  final Function(double) onChange;
  const JournalEntryDetailKilometerPicker(
      {super.key, required this.initialValue, required this.onChange});

  @override
  _JournalEntryDetailKilometerPickerState createState() =>
      _JournalEntryDetailKilometerPickerState();
}

class _JournalEntryDetailKilometerPickerState
    extends State<JournalEntryDetailKilometerPicker> {
  late double _kilometers;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _kilometers = widget.initialValue;
    _controller = TextEditingController(text: _kilometers.toStringAsFixed(1));
  }

  void _onEditingComplete() {
    final parsedValue = double.tryParse(_controller.text.replaceAll(',', '.'));
    final updatedValue = parsedValue != null && parsedValue > 0
        ? parsedValue
        : widget.initialValue;
    setState(() {
      _kilometers = updatedValue;
      _controller.text = _kilometers.toStringAsFixed(1);
      widget.onChange(_kilometers);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _controller.text,
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
            width: textWidth + 24, // Dynamic width based on text width
            child: CupertinoTextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              controller: _controller,
              padding: EdgeInsets.all(0),
              onEditingComplete: _onEditingComplete,
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