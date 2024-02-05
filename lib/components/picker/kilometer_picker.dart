import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class KilometerPicker extends StatefulWidget {
  final double initialValue;
  final Function(double) onChange;

  const KilometerPicker({
    Key? key,
    required this.initialValue,
    required this.onChange,
  }) : super(key: key);

  @override
  _KilometerPickerState createState() => _KilometerPickerState();
}

class _KilometerPickerState extends State<KilometerPicker> {
  late double _kilometers;
  late TextEditingController _controller;
  late OverlayEntry _overlayEntry;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _kilometers = widget.initialValue;
    _controller = TextEditingController(text: _kilometers.toStringAsFixed(1));
    _focusNode.addListener(_handleFocusChange);
  }

  void _onEditingComplete() {
    final parsedValue = double.tryParse(_controller.text.replaceAll(',', '.'));
    final updatedValue = parsedValue != null && parsedValue > 0
        ? parsedValue
        : widget.initialValue;
    setState(() {
      _kilometers = updatedValue;
      _controller.text = _kilometers.toStringAsFixed(1);
      widget.onChange(_kilometers);
    });
    _focusNode.unfocus();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry);
    } else {
      _overlayEntry.remove();
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          color: AppThemeColors.contrast100,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            CupertinoButton(
              child: Text(
                'Speichern',
                style: AppThemeTextStyles.normal.copyWith(
                    color: AppThemeColors.blue,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0),
              ),
              onPressed: () {
                _focusNode.unfocus();
              },
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _controller.text,
        style: AppThemeTextStyles.small,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textWidth = textPainter.size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      height: 34,
      decoration: BoxDecoration(
        color: AppThemeColors.contrast0,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppThemeColors.contrast200, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: textWidth + 24, // Dynamic width based on text width
            child: CupertinoTextField(
              focusNode: _focusNode,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              controller: _controller,
              padding: const EdgeInsets.all(0),
              onEditingComplete: _onEditingComplete,
              style: AppThemeTextStyles.small,
              decoration: BoxDecoration(
                border: Border.all(color: AppThemeColors.contrast0),
              ),
              suffix: Text('km',
                  style: AppThemeTextStyles.small
                      .copyWith(color: AppThemeColors.contrast500)),
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }
}
