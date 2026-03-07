import '../../export.dart';

class CTextStyle {
  CTextStyle._();
  static BuildContext? context;
  static double increaseSizeForFontFamily(String? fontFamily) =>
      fontFamily == Helper.englishTextFontFamily
          ? 1.sp
          : fontFamily == Helper.urduTextFontFamily
          ? 3.sp
          : 8.sp;

  static String get getFontFamily => isLTR(context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily;

  static TextStyle w100({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: (fontSize ?? 12).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w200({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: (fontSize ?? 12).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w300({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: (fontSize ?? 14).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w400({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: (fontSize ?? 16).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w500({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: (fontSize ?? 16).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w600({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: (fontSize ?? 18).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w700({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: (fontSize ?? 20).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w800({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: (fontSize ?? 24).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w900({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: (fontSize ?? 26).sp + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
