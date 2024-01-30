import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class JournalEntryDetailViewTimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final Function(DateTime) onChange;
  DateTime? minimumDateTime;
  DateTime? maximumDateTime;

  JournalEntryDetailViewTimePicker({
    Key? key,
    required this.initialDateTime,
    required this.onChange,
    this.minimumDateTime,
    this.maximumDateTime,
  }) : super(key: key) {
    minimumDateTime ??= initialDateTime.subtract(const Duration(days: 7));
    maximumDateTime ??= initialDateTime.add(const Duration(days: 7));
  }

  @override
  _JournalEntryDetailViewTimePickerState createState() =>
      _JournalEntryDetailViewTimePickerState();
}

class _JournalEntryDetailViewTimePickerState
    extends State<JournalEntryDetailViewTimePicker> {
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
    return Container(
      height: 34,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 11),
        color: AppThemeColors.contrast150,
        onPressed: () => _showCupertinoDateTimePicker(
          context,
        ),
        child: Text(
          "${setDateTime.hour.toString().padLeft(2, '0')}:${setDateTime.minute.toString().padLeft(2, '0')}",
          style: AppThemeTextStyles.small.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
