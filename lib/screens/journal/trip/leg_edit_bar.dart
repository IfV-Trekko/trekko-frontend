import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/tile_utils.dart';
import 'package:trekko_frontend/components/picker/date_picker.dart';

class LegEditBar extends StatelessWidget {

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
    double width = MediaQuery.of(context).size.width;
    return CupertinoListSection.insetGrouped(
      margin: TileUtils.listSectionMargin,
      additionalDividerMargin: TileUtils.defaultDividerMargin,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Date picker
            SizedBox(
              width: width * 0.32,
              child: DatePicker(
                  time: time,
                  mode: CupertinoDatePickerMode.date,
                  onDateChanged: onDateChanged),
            ),
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
            SizedBox(
              width: width * 0.3,
              child: DatePicker(
                  time: time,
                  mode: CupertinoDatePickerMode.time,
                  onDateChanged: onTimeChanged),
            ),
          ],
        ),
      ],
    );
  }
}
