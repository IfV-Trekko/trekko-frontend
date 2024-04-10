import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trekko_frontend/components/picker/picker_util.dart';

class DatePicker extends StatelessWidget {
  final DateTime time;
  final CupertinoDatePickerMode mode;
  final Function(DateTime) onDateChanged;

  const DatePicker(
      {super.key,
      required this.time,
      required this.mode,
      required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    DateFormat format = mode == CupertinoDatePickerMode.date
        ? DateFormat('dd.MM.yyyy')
        : DateFormat('HH:mm');
    return CupertinoButton(
      child: Center(child: Text(format.format(time))),
      onPressed: () => PickerUtil.showDialog(
        context,
        height: 210,
        Column(
          children: [
            SizedBox(
              height: 200,
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: CupertinoDatePicker(
                  initialDateTime: time,
                  mode: mode,
                  use24hFormat: true,
                  showDayOfWeek: true,
                  onDateTimeChanged: (DateTime newDate) {
                    onDateChanged(newDate);
                  },
                ),
              ),
            ),
            // CupertinoButton(
            //   child: const Text('Zurücksetzen'),
            //   onPressed: () {
            //     onDateChanged(DateTime.now());
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
