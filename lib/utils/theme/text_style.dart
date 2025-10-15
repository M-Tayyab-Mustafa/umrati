import '../../export.dart';

class CTextStyle {
  CTextStyle._();
  static BuildContext? _context;
  static init(BuildContext context) => _context = context;
  static double increaseSizeForUrdu() => SizeConfig.sp(isLTR(_context) ? 0 : 6);

  static TextStyle w100({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: SizeConfig.sp(fontSize ?? 12) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w200({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: SizeConfig.sp(fontSize ?? 12) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w300({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: SizeConfig.sp(fontSize ?? 14) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w400({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: SizeConfig.sp(fontSize ?? 16) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w500({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: SizeConfig.sp(fontSize ?? 16) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w600({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SizeConfig.sp(fontSize ?? 18) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w700({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: SizeConfig.sp(fontSize ?? 20) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w800({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: SizeConfig.sp(fontSize ?? 24) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
  static TextStyle w900({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily, double? letterSpacing}) => TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: SizeConfig.sp(fontSize ?? 26) + increaseSizeForUrdu(),
    fontFamily: fontFamily ?? (isLTR(_context) ? Helper.englishTextFontFamily : Helper.urduTextFontFamily),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
