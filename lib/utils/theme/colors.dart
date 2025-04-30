import 'package:flutter/material.dart';

class CColors {
  CColors._();
  static const Color primary = Color(0xFF0B7C18);
  static const Color duaBackground = Color(0xFFC5FFAA);
  static const Color secondary = Color(0xFF28B67E);
  static final Color background = Color.fromARGB(255, 168, 255, 178).withValues(alpha: 0.4);
  static final Color lightGrey = Color(0x73737300).withValues(alpha: 0.1);
  static const Color grey = Color(0xFF4B4B4B);
  static const Color greyShade1 = Color.fromARGB(255, 117, 117, 117);
  static const Color deepTeal = Color(0xFF1D4C4F);

  //* Button
  static final LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF28B67E), Color(0xFF0B7C18).withValues(alpha: 0.95), Color(0xFF0B7C18)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static final LinearGradient trackingGradient = LinearGradient(colors: [Color(0xFFDBE8D9), Color(0xFFF1FFF3)], begin: Alignment.bottomLeft, end: Alignment.topRight);
  static final LinearGradient secondaryGradient = LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFDFE3DF)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  static final LinearGradient solidButtonGradient = LinearGradient(colors: [Color(0xFF28B67E), Color(0xFF0B7C18), Color(0xFF0B7C18)], begin: Alignment.centerLeft, end: Alignment.centerRight);
  static final Color shadow = Color(0xFF09C61F).withValues(alpha: 0.3);
  static final Color buttonShadow = Colors.black.withValues(alpha: 0.6);
}
