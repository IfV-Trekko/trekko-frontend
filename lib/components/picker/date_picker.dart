import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  final DateTime time;
  final Function(DateTime) onDateChanged;

  const DatePicker(
      {super.key, required this.time, required this.onDateChanged});

  void _showDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Text(DateFormat("dd.MM.yyyy").format(time)),
      onPressed: () => _showDialog(
        context,
        CupertinoDatePicker(
          initialDateTime: time,
          mode: CupertinoDatePickerMode.date,
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
