import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:flutter/cupertino.dart';

class TextResponse extends StatefulWidget {
  final int maxLength;
  final String title;
  final String initialValue;
  final String placeholder;
  final Function(String) onSaved;
  late TextEditingController _controller;

  TextResponse(
      {super.key,
      required this.maxLength,
      required this.onSaved,
      required this.title,
      required this.placeholder,
      required this.initialValue}) {
    _controller = TextEditingController(text: initialValue);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }
  @override
  State<TextResponse> createState() => _TextResponseState();
}

class _TextResponseState extends State<TextResponse> {
  late String _newResponse;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Zurück',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: Text(widget.title),
        trailing: Button(
          title: 'Speichern',
          size: ButtonSize.small,
          stretch: false,
          onPressed: () {
            widget.onSaved(_newResponse);
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: CupertinoTextField(
            controller: widget._controller,
            scrollPadding: const EdgeInsets.all(2),
            maxLength: widget.maxLength,
            maxLines: null,
            placeholder: widget.placeholder,
            autofocus: true,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onChanged: (String value) {
              setState(() {
                _newResponse = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
