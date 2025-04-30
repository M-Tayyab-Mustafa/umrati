import 'package:flutter/material.dart';

import '../theme/colors.dart';

late Size screenSize;

final primaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.outer)];

enum Gender { male, female }

enum BackgroundType { empty, logo, logoWithSkip }

class DefaultImages {
  static const String logoWithName = 'assets/svg/logo_with_text.svg';
  static const String longArrowForward = 'assets/svg/forward_arrow.svg';
}
