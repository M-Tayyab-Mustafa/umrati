part of 'constants.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double _scale;
  static const double _baseWidth = 390;
  static const double _baseHeight = 844;
  static BuildContext? _context;

  static void init(BuildContext context, {double baseWidth = _baseWidth, double baseHeight = _baseHeight}) {
    _context = context;
    final mediaQueryData = MediaQuery.of(_context!);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    double scaleWidth = screenWidth / baseWidth;
    double scaleHeight = screenHeight / baseHeight;
    _scale = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;
  }

  static double w(double width) => width * _scale;
  static double h(double height) => height * _scale;
  static double r(double value) => value * _scale;
  static double sp(double fontSize) => MediaQuery.textScalerOf(_context!).scale(fontSize * _scale);

  static EdgeInsets get zero => EdgeInsets.zero;
  static EdgeInsets all(double value) => EdgeInsets.all(value * _scale);
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) => EdgeInsets.symmetric(horizontal: horizontal * _scale, vertical: vertical * _scale);
  static EdgeInsets only({double left = 0, double top = 0, double right = 0, double bottom = 0}) =>
      EdgeInsets.only(left: left * _scale, top: top * _scale, right: right * _scale, bottom: bottom * _scale);
}
