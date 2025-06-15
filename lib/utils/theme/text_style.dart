import '../../export.dart';

class CTextStyle {
  CTextStyle._();
  static BuildContext? _context;
  static set context(BuildContext context) => _context = context;
  static TextStyle w100({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: fontSize ?? 12,
    fontFamily: fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
  static TextStyle w200({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: fontSize ?? 12,
    fontFamily: fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
  static TextStyle w300({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: fontSize ?? 14,
    fontFamily: fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
  static TextStyle w400({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: fontSize ?? 16,
    fontFamily: fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
  static TextStyle w500({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: fontSize ?? 16,
    fontFamily: fontFamily ?? fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
  static TextStyle w600({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: fontSize ?? 18,
    fontFamily: fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
  static TextStyle w700({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: fontSize ?? 20,
    fontFamily: fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
  static TextStyle w800({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: fontSize ?? 24,
    fontFamily: fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
  static TextStyle w900({double? fontSize, Color? color, TextDecoration? decoration, double? height, String? fontFamily}) => TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: fontSize ?? 26,
    fontFamily: fontFamily ?? (isLTR(_context) ? 'Jameel Noori Nastaleeq Kasheeda' : 'Roboto'),
    color: color,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
}
