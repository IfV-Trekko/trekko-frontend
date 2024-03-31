import 'package:trekko_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class TimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final Function(DateTime) onChange;
  final DateTime? minimumDateTime;
  final DateTime? maximumDateTime;

  TimePicker({
    Key? key,
    required this.initialDateTime,
    required this.onChange,
    DateTime? minimumDateTime,
    DateTime? maximumDateTime,
  })  : minimumDateTime = minimumDateTime ??
            initialDateTime.subtract(const Duration(days: 7)),
        maximumDateTime =
            maximumDateTime ?? initialDateTime.add(const Duration(days: 7)),
        super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late DateTime selectedDateTime;
  late DateTime setDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
    setDateTime = widget.initialDateTime;
  }

  void _showCupertinoDateTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 270,
        color: AppThemeColors.contrast0,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: CupertinoDatePicker(
                  use24hFormat: true,
                  initialDateTime: selectedDateTime,
                  onDateTimeChanged: (val) {
                    setState(() {
                      selectedDateTime = val;
                    });
                  },
                  minimumDate: widget.minimumDateTime,
                  maximumDate: widget.maximumDateTime,
                  mode: CupertinoDatePickerMode.dateAndTime,
                ),
              ),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  setDateTime = selectedDateTime;
                });
                widget.onChange(selectedDateTime);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        color: AppThemeColors.contrast150,
        onPressed: () => _showCupertinoDateTimePicker(
          context,
        ),
        child: Text(
          "${widget.initialDateTime.hour.toString().padLeft(2, '0')}:${widget.initialDateTime.minute.toString().padLeft(2, '0')}",
          style: AppThemeTextStyles.small.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
