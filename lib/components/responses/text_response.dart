import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_size.dart';
import 'package:trekko_frontend/components/constants/text_response_keyboard_type.dart';

class TextResponse extends StatefulWidget {
  final int maxLength;
  final int maxLines;
  final String title;
  final String suffix;
  final String initialValue;
  final Function(String?) onSaved;
  final TextResponseKeyboardType keyboardType;
  final String placeholder;

  const TextResponse(
      {super.key,
      required this.maxLength,
      required this.maxLines,
      required this.onSaved,
      required this.title,
      required this.suffix,
      required this.placeholder,
      required this.keyboardType,
      required this.initialValue});

  @override
  State<TextResponse> createState() => _TextResponseState();
}

class _TextResponseState extends State<TextResponse> {
  late String _newResponse;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _newResponse = widget.initialValue;
    _controller = TextEditingController(text: widget.initialValue);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }

  void saveValue() {
    if (_newResponse.isEmpty) {
      widget.onSaved(null);
    } else if (widget.keyboardType == TextResponseKeyboardType.dezimal) {
      final parsedValue = double.tryParse(_newResponse.replaceAll(',', '.'));
      final updatedValue = parsedValue != null && parsedValue > 0
          ? parsedValue
          : double.parse(widget.initialValue);
      widget.onSaved(updatedValue.toString());
    } else {
      widget.onSaved(_newResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    var combinedPlaceholder = widget.placeholder;
    for (var i = 0; i < widget.maxLines - 1; i++) {
      combinedPlaceholder += '\n';
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
            saveValue();
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
                  onEditingComplete: () {
                    saveValue();
                  },
                  suffix: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Text(
                      widget.suffix,
                      style: AppThemeTextStyles.normal.copyWith(
                        color: AppThemeColors.contrast500,
                      ),
                    ),
                  ),
                  textAlign: TextAlign.start,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  keyboardType: widget.keyboardType.inputType,
                  controller: _controller,
                  scrollPadding: const EdgeInsets.all(2),
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  placeholder: combinedPlaceholder,
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
