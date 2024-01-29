import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:app_frontend/components/constants/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class Button extends StatelessWidget {
  final String title;
  final HeroIcons? icon;
  final bool loading;
  final bool stretch;
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
      this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
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
                  children: [
                    if (loading) ...[
                      SizedBox(width: 10),
                      CupertinoActivityIndicator(
                        color: style == ButtonStyle.primary
                            ? AppThemeColors.contrast0
                            : AppThemeColors.blue,
                      ),
                      SizedBox(width: 10),
                    ] else ...[
                      const SizedBox(width: 10),
                      if (icon != null) ...[
                        HeroIcon(
                          icon!,
                          size: size.iconSize,
                          color: style.textColor,
                        ),
                        SizedBox(width: size.sizedBoxWidth),
                      ],
                      Text(
                        title,
                        style: GoogleFonts.inter(
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
