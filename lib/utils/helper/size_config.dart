part of 'constants.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double _scale;
  static const double _baseWidth = 390;
  static const double _baseHeight = 844;

  static void init(BuildContext context, {double baseWidth = _baseWidth, double baseHeight = _baseHeight}) {
    final mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;

    // Use the smaller scaling factor to avoid distortion
    double scaleWidth = screenWidth / baseWidth;
    double scaleHeight = screenHeight / baseHeight;
    _scale = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;
  }

  static double w(double width) => width * _scale;
  static double h(double height) => height * _scale;

  static double sp(double fontSize, BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(fontSize * _scale);
  }
}
