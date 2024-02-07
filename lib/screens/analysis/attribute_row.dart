import 'package:flutter/material.dart';
import '../../app_theme.dart';

class AttributeRow extends StatelessWidget {
  final String title;
  final Widget value;

  const AttributeRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.contrast0,
        border: Border.all(color: AppThemeColors.contrast150),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(top: 9, bottom: 9, left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppThemeTextStyles.normal,
          ),
          value
        ],
      ),
    );
  }
}
