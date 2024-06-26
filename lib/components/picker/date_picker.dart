import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trekko_frontend/components/picker/picker_util.dart';

class DatePicker extends StatefulWidget {
  static final DateFormat DAY_AND_HOUR = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat DAY = DateFormat('dd.MM.yyyy');
  static final DateFormat HOUR = DateFormat('HH:mm');

  final DateTime time;
  final CupertinoDatePickerMode mode;
  final Function(DateTime) onDateChanged;

  const DatePicker(
      {super.key,
      required this.time,
      required this.mode,
      required this.onDateChanged});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  late DateTime _currentTime;

  void _changeDate(DateTime newDate) {
    setState(() {
      _currentTime = newDate;
    });
    widget.onDateChanged(newDate);
  }

  @override
  void initState() {
    _currentTime = widget.time;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = widget.mode == CupertinoDatePickerMode.date
        ? DatePicker.DAY
        : widget.mode == CupertinoDatePickerMode.dateAndTime
            ? DatePicker.DAY_AND_HOUR
            : DatePicker.HOUR;
    return CupertinoButton(
      child: Center(child: Text(format.format(_currentTime))),
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
                  initialDateTime: widget.time,
                  mode: widget.mode,
                  use24hFormat: true,
                  showDayOfWeek: true,
                  onDateTimeChanged: (DateTime newDate) {
                    _changeDate(newDate);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
