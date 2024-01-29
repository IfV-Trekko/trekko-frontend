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
    minimumDateTime ??= initialDateTime.add(Duration(days: -1));
    maximumDateTime ??= initialDateTime.add(Duration(days: 1));
  }

  @override
  _JournalEntryDetailViewTimePickerState createState() =>
      _JournalEntryDetailViewTimePickerState();
}

class _JournalEntryDetailViewTimePickerState
    extends State<JournalEntryDetailViewTimePicker> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  void _showCupertinoDateTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 270,
        color: AppThemeColors.contrast0,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Container(
                height: 34,
                padding: EdgeInsets.symmetric(horizontal: 11),
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
              child: Text('OK'),
              onPressed: () {
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
          "${widget.initialDateTime.hour.toString().padLeft(2, '0')}:${widget.initialDateTime.minute.toString().padLeft(2, '0')}",
          style: AppThemeTextStyles.small.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
