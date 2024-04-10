import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class TileUtils {
  static const double defaultDividerMargin = 2;
  static const EdgeInsetsGeometry listTilePadding =
      EdgeInsets.only(left: 16, right: 16);
  static const EdgeInsetsGeometry listSectionMargin =
      EdgeInsets.fromLTRB(16, 16, 16, 16);

  static Widget buildTitleRow(String title, HeroIcons icon) {
    return Row(
      children: [
        HeroIcon(icon),
        const SizedBox(width: 8),
        Flexible(
          child: Text(title, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
