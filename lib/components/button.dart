import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/button_size.dart';
import 'package:trekko_frontend/components/constants/button_style.dart';

class Button extends StatelessWidget {
  final String title;
  final HeroIcons? icon;
  final bool loading;
  final bool stretch;
  final bool fillIcon;
  final ButtonStyle style;
  final ButtonSize size;
  final Function onPressed;

  const Button(
      {required this.title,
      required this.onPressed,
      this.style = ButtonStyle.primary,
      this.size = ButtonSize.large,
      this.loading = false,
      this.stretch = true,
      this.fillIcon = false,
      this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          onPressed();
        },
        child: Opacity(
            opacity: loading ? 0.7 : 1.0,
            child: Container(
                height: size.height,
                decoration: BoxDecoration(
                  color: style.backgroundColor,
                  borderRadius: BorderRadius.circular(size.borderRadius),
                ),
                child: Row(
                  mainAxisSize: stretch ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (loading) ...[
                      const SizedBox(width: 10),
                      CupertinoActivityIndicator(
                        color: style == ButtonStyle.primary
                            ? AppThemeColors.contrast0
                            : AppThemeColors.blue,
                      ),
                      const SizedBox(width: 10),
                    ] else ...[
                      const SizedBox(width: 10),
                      if (icon != null) ...[
                        HeroIcon(
                          icon!,
                          size: size.iconSize,
                          color: style.textColor,
                          style: fillIcon
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                        ),
                        if (title.isNotEmpty) ...[
                          SizedBox(width: size.sizedBoxWidth),
                        ]
                      ],
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          height: size.lineHeight,
                          color: style.textColor,
                          fontSize: size.fontSize,
                          fontWeight: size.fontWeight,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ],
                ))));
  }
}
