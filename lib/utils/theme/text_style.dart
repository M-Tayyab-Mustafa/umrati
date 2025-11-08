import '../../export.dart';

class CTextStyle {
  CTextStyle._();
  static BuildContext? _context;
  static init(BuildContext context) => _context = context;
  static double increaseSizeForFontFamily(String? fontFamily) =>
      fontFamily == Helper.englishTextFontFamily
          ? SizeConfig.sp(1)
          : fontFamily == Helper.urduTextFontFamily
          ? SizeConfig.sp(6)
          : SizeConfig.sp(8);

  static get getFontFamily => isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily;

  static TextStyle w100({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: SizeConfig.sp(fontSize ?? 12) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w200({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: SizeConfig.sp(fontSize ?? 12) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w300({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: SizeConfig.sp(fontSize ?? 14) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w400({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: SizeConfig.sp(fontSize ?? 16) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w500({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: SizeConfig.sp(fontSize ?? 16) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w600({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SizeConfig.sp(fontSize ?? 18) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w700({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: SizeConfig.sp(fontSize ?? 20) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w800({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: SizeConfig.sp(fontSize ?? 24) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w900({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: SizeConfig.sp(fontSize ?? 26) + increaseSizeForFontFamily(fontFamily ?? getFontFamily),
    fontFamily: fontFamily ?? getFontFamily,
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
