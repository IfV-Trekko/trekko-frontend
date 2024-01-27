import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class JournalEntryDetailViewTimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  late DateTime minimumDateTime;
  late DateTime maximumDateTime; //TODO so ok?

  JournalEntryDetailViewTimePicker({
    Key? key,
    required this.initialDateTime,
  }) : super(key: key) {
    minimumDateTime = initialDateTime.add(Duration(days: -1));
    maximumDateTime = initialDateTime.add(Duration(days: 1));
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
                      //TODO set to backend
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
              onPressed: () {}, //TODO schick ans Backend
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
        onPressed: () => _showCupertinoDateTimePicker(context),
        child: Text(
          "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}",
          style: AppThemeTextStyles.small.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
