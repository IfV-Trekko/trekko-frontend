import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/constants/text_response_keyboard_type.dart';
import 'package:app_frontend/components/responses/text_response.dart';
import 'package:flutter/cupertino.dart';

class KilometerPicker extends StatefulWidget {
  final double value;
  final Function(String) onChange;

  const KilometerPicker({
    Key? key,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  _KilometerPickerState createState() => _KilometerPickerState();
}

class _KilometerPickerState extends State<KilometerPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppThemeColors.contrast150, width: 1),
        ),
        padding: EdgeInsets.zero,
        height: 34,
        child: Align(
          alignment: Alignment.center,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            color: AppThemeColors.contrast0,
            child: Row(children: [
              Text(
                widget.value.toStringAsFixed(2),
                style: AppThemeTextStyles.small,
              ),
              const SizedBox(width: 6),
              Text(
                'km',
                style: AppThemeTextStyles.small
                    .copyWith(color: AppThemeColors.contrast500),
              ),
            ]),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => TextResponse(
                  suffix: 'km',
                  acceptEmptyResponse: false,
                  maxLines: 1,
                  keyboardType: TextResponseKeyboardType.dezimal,
                  maxLength: 10,
                  onSaved: widget.onChange,
                  title: 'Distanz ändern',
                  placeholder: '8,4 km',
                  initialValue: widget.value.toStringAsFixed(2),
                ),
              ));
            },
          ),
        ));
  }
}
