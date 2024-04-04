import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/components/picker/date_picker.dart';

class LegEditBar extends StatelessWidget {
  final DateTime time;
  final Function(DateTime) onDateChanged;
  final Function onAddPoint;

  const LegEditBar({super.key, required this.time, required this.onDateChanged, required this.onAddPoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // decoration: const BoxDecoration(
      //   color: CupertinoColors.systemBackground,
      //   boxShadow: [
      //     BoxShadow(
      //       color: CupertinoColors.systemBackground,
      //       spreadRadius: 7,
      //       blurRadius: 7,
      //       offset: Offset(0, 0),
      //     ),
      //   ],
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Date picker
          DatePicker(time: time, onDateChanged: onDateChanged),
          // Plus button to add a new point
          CupertinoButton(
            child: const Icon(CupertinoIcons.add),
            onPressed: () => onAddPoint(),
          ),
          // Time picker
          CupertinoButton(
            child: const Icon(CupertinoIcons.clock),
            onPressed: () => showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: time,
                  onDateTimeChanged: onDateChanged,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
