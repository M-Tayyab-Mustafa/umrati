import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/colors.dart';
part 'enums.dart';

late Size screenSize;

final primaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.outer)];
final innerPrimaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.inner)];
double roundToOneDecimal(double value) => (value * 1000).round() / 1000;

FutureOr<bool> requestLocationPermission() async {
  var status = await Permission.locationAlways.status;
  if (!(status.isGranted)) {
    status = await Permission.locationAlways.request();
  }
  return status.isGranted;
}

FutureOr<bool> requestLocationWhenInUse() async {
  var locationWhenInUseStatus = await Permission.locationWhenInUse.status;
  if (!(locationWhenInUseStatus.isGranted)) {
    locationWhenInUseStatus = await Permission.locationWhenInUse.request();
  }
  return locationWhenInUseStatus.isGranted;
}

class DefaultImages {
  static const String logoWithName = 'assets/svg/logo_with_text.svg';
  static const String longArrowForward = 'assets/svg/forward_arrow.svg';
}
