import 'package:trekko_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class LegendIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const LegendIndicator({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(text,
            style: AppThemeTextStyles.normal.copyWith(
              color: color,
            )),
      ],
    );
  }
}
