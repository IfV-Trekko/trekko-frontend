import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/picker/date_picker.dart';

class LegEditBar extends StatelessWidget {
  final EdgeInsetsGeometry listSectionMargin =
      const EdgeInsets.fromLTRB(16, 0, 16, 16);

  final DateTime time;
  final Function(DateTime) onDateChanged;
  final Function(DateTime) onTimeChanged;
  final Function onAddPoint;

  const LegEditBar(
      {super.key,
      required this.time,
      required this.onDateChanged,
      required this.onTimeChanged,
      required this.onAddPoint});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      margin: listSectionMargin,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Date picker
            DatePicker(
                time: time,
                mode: CupertinoDatePickerMode.date,
                onDateChanged: onDateChanged),
            // Plus button to add a new point
            CupertinoButton(
              // Icon with filled background behind the icon
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppThemeColors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  color: CupertinoColors.white,
                ),
              ),
              onPressed: () => onAddPoint(),
            ),
            DatePicker(
                time: time,
                mode: CupertinoDatePickerMode.time,
                onDateChanged: onTimeChanged),
          ],
        ),
      ],
    );
  }
}
