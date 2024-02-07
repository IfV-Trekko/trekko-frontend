import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/text_response_keyboard_type.dart';
import 'package:flutter/cupertino.dart';

class TextResponse extends StatefulWidget {
  final int maxLength;
  final int maxLines;
  final String title;
  final String initialValue;
  late String placeholder;
  final Function(String) onSaved;
  final TextResponseKeyboardType keyboardType;
  late TextEditingController _controller;

  TextResponse(
      {super.key,
      required this.maxLength,
      required this.maxLines,
      required this.onSaved,
      required this.title,
      required this.placeholder,
      required this.keyboardType,
      required this.initialValue}) {
    _controller = TextEditingController(text: initialValue);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }
  @override
  State<TextResponse> createState() => _TextResponseState();
}

class _TextResponseState extends State<TextResponse> {
  late String _newResponse = '';

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < widget.maxLines - 1; i++) {
      widget.placeholder += '\n';
    }
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast0,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppThemeColors.contrast0,
        border: const Border(bottom: BorderSide.none),
        leading: Transform.translate(
          offset: const Offset(-16, 0),
          child: CupertinoNavigationBarBackButton(
            previousPageTitle: 'Zurück',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        middle: Text(widget.title),
        trailing: Button(
          title: 'Speichern',
          size: ButtonSize.small,
          stretch: false,
          onPressed: () {
            if (widget.keyboardType == TextResponseKeyboardType.dezimal) {
              final parsedValue =
                  double.tryParse(_newResponse.replaceAll(',', '.'));
              final updatedValue = parsedValue != null && parsedValue > 0
                  ? parsedValue
                  : widget.initialValue;
              widget.onSaved(updatedValue.toString());
            } else {
              widget.onSaved(_newResponse);
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 20 + ((widget.maxLines - 1) * 22) + 24,
                child: CupertinoTextField(
                  textAlign: TextAlign.start,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  keyboardType: widget.keyboardType.inputType,
                  controller: widget._controller,
                  scrollPadding: const EdgeInsets.all(2),
                  maxLength: widget.maxLength, //TODO reset on save empty
                  maxLines: widget.maxLines,
                  placeholder: widget.placeholder, //TODO warum mittig????
                  autofocus: true,
                  decoration: BoxDecoration(
                    color: AppThemeColors.contrast100,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _newResponse = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ändere den Wert und speichere ihn, um die Änderung zu übernehmen.',
              style: AppThemeTextStyles.small
                  .copyWith(color: AppThemeColors.contrast500),
            )
          ],
        ),
      ),
    );
  }
}
