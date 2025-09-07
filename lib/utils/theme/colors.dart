import 'package:flutter/material.dart';

class CColors {
  CColors._();
  static const Color primary = Color(0xFF0B7C18);
  static const Color duaBackground = Color(0xFFC5FFAA);
  static const Color charcoalBlack = Color(0xFF212029);
  static const Color secondaryBackground = Color(0xFFE6FBE2);
  static const Color secondary = Color(0xFF28B67E);
  static const Color tileBackground = Color(0xFFE5F7E6);
  static final Color background = Color.fromARGB(255, 168, 255, 178).withValues(alpha: 0.4);
  static const Color darkIndigo = Color(0xFF181C2E);
  static const Color grey = Color(0xFF4B4B4B);
  static final Color lightGrey = Color(0x73737300).withValues(alpha: 0.1);
  static const Color greyShade1 = Color.fromARGB(255, 117, 117, 117);
  static const Color greyShade2 = Color(0xFF4F4F4F);
  static const Color greyShade3 = Color(0xFFD9D9D9);
  static const Color greyShade4 = Color(0xFF565454);
  static const Color deepTeal = Color(0xFF1D4C4F);
  static const Color tackingRadiusColor = Color(0xFFBDCDBB);
  static final Color tackingSecondaryRadiusColor = Color(0xFFBBBABC).withValues(alpha: 0.25);

  static final LinearGradient planCardBackgroundGradient = LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFE5F7E6)], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static final LinearGradient planTextGradient = LinearGradient(colors: [secondary, primary], begin: Alignment.topLeft, end: Alignment.bottomRight);

  //* Button
  static final LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF28B67E), Color(0xFF0B7C18).withValues(alpha: 0.95), Color(0xFF0B7C18)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static final LinearGradient trackingGradient = LinearGradient(colors: [Color(0xFFDBE8D9), Color(0xFFF1FFF3)], begin: Alignment(-0.1, 1), end: Alignment(4, -1.5));
  static final LinearGradient trackingSecondaryGradient = LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFDFE3DF)], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static final LinearGradient solidButtonGradient = LinearGradient(colors: [Color(0xFF28B67E), Color(0xFF0B7C18), Color(0xFF0B7C18)], begin: Alignment.centerLeft, end: Alignment.centerRight);
  static final Color shadow = Color(0xFF09C61F).withValues(alpha: 0.3);
  static final Color buttonShadow = Colors.black.withValues(alpha: 0.6);
}
