import 'package:flutter/material.dart';

class CTextStyle {
  CTextStyle._();
  static TextStyle w100({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w100, fontSize: fontSize ?? 12, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
  static TextStyle w200({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w200, fontSize: fontSize ?? 12, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
  static TextStyle w300({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w300, fontSize: fontSize ?? 14, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
  static TextStyle w400({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: fontSize ?? 16, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
  static TextStyle w500({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize ?? 16, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
  static TextStyle w600({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize ?? 18, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
  static TextStyle w700({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize ?? 20, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
  static TextStyle w800({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w800, fontSize: fontSize ?? 24, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
  static TextStyle w900({double? fontSize, Color? color, TextDecoration? decoration, double? height}) =>
      TextStyle(fontWeight: FontWeight.w900, fontSize: fontSize ?? 26, fontFamily: 'Roboto', color: color, decoration: decoration, decorationColor: color, height: height);
}
