import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static CupertinoThemeData get lightTheme {
    return CupertinoThemeData(
      textTheme: CupertinoTextThemeData(

      ),
      primaryColor: AppThemeColors.blue,
    );
  }
}

class AppThemeColors {
  static const Color purple = Color(0xFF8330D5);
  static const Color pink = Color(0xFFDF34BA);
  static const Color blue = Color(0xFF0C79FE);
  static const Color turquoise = Color(0xFF1F7CA4);
  static const Color green = Color(0xFF27AE60);
  static const Color red = Color(0xFFFF3B30);
  static const Color orange = Color(0xFFFC6816);

  static const Color contrast900 = Color(0xFF000000);
  static const Color contrast800 = Color(0xFF454545);
  static const Color contrast700 = Color(0xFF868782);
  static const Color contrast500 = Color(0xFF868782);
  static const Color contrast400 = Color(0xFFBDBDBD);
  static const Color contrast200 = Color(0xFFE0E0E0);
  static const Color contrast150 = Color(0xFFE7E7E7);
  static const Color contrast100 = Color(0xFFF2F2F2);
  static const Color contrast0 = Color(0xFFEDEDED);
}

class AppThemeTextStyles {
  static TextStyle get headline => GoogleFonts.inter(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    height: 40,
    color: AppThemeColors.contrast900,
  );

  static TextStyle get largeTitle => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 40,
    color: AppThemeColors.contrast900,
  );

  static TextStyle get title => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 29,
    color: AppThemeColors.contrast900,
  );

  static TextStyle get normal => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 22,
    color: AppThemeColors.contrast900,
  );

  static TextStyle get small => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 18,
    color: AppThemeColors.contrast900,
  );

  static TextStyle get tiny => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 13,
    color: AppThemeColors.contrast700,
  );
}
