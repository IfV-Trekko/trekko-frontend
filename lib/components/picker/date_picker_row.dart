import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_frontend/components/picker/date_picker.dart';

class DatePickerRow extends StatelessWidget {
  final DateTime time;
  final void Function(DateTime) onDateChanged;

  const DatePickerRow(
      {super.key,
      required this.time,
      required this.onDateChanged});

  _addTime(Duration diff) {
    onDateChanged(time.add(diff));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            child: const HeroIcon(HeroIcons.arrowLeft),
            onPressed: () {
              _addTime(const Duration(days: -1));
            },
          ),
          DatePicker(
              time: time,
              onDateChanged: (DateTime newDate) {
                onDateChanged(newDate);
              }),
          CupertinoButton(
            child: const HeroIcon(HeroIcons.arrowRight),
            onPressed: () {
              _addTime(const Duration(days: 1));
            },
          ),
        ],
      ),
    ]);
  }
}
