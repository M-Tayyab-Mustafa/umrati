import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/colors.dart';

late Size screenSize;

final primaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.outer)];
final innerPrimaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.inner)];

enum Gender { male, female }

enum BackgroundType { empty, logo, logoWithSkip }

FutureOr<bool> requestLocationPermission() async {
  var status = await Permission.locationAlways.status;
  var locationStatus = await Permission.location.status;
  var locationWhenInUseStatus = await Permission.locationWhenInUse.status;
  if (!(status.isGranted && locationStatus.isGranted && locationWhenInUseStatus.isGranted)) {
    status = await Permission.locationAlways.request();
    locationStatus = await Permission.location.request();
    locationWhenInUseStatus = await Permission.locationWhenInUse.request();
  }
  return status.isGranted && locationStatus.isGranted && locationWhenInUseStatus.isGranted;
}

class DefaultImages {
  static const String logoWithName = 'assets/svg/logo_with_text.svg';
  static const String longArrowForward = 'assets/svg/forward_arrow.svg';
}
