import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trekko_frontend/components/picker/picker_util.dart';

class DatePicker extends StatelessWidget {
  final DateTime time;
  final CupertinoDatePickerMode mode;
  final Function(DateTime) onDateChanged;

  const DatePicker(
      {super.key, required this.time, required this.mode, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    DateFormat format = mode == CupertinoDatePickerMode.date
        ? DateFormat('dd.MM.yyyy')
        : DateFormat('HH:mm');
    return CupertinoButton(
      child: SizedBox(width: 100, child: Center(child: Text(format.format(time)))),
      onPressed: () => PickerUtil.showDialog(
        context,
        CupertinoDatePicker(
          initialDateTime: time,
          mode: mode,
          use24hFormat: true,
          showDayOfWeek: true,
          onDateTimeChanged: (DateTime newDate) {
            onDateChanged(newDate);
          },
        ),
      ),
    );
  }
}
