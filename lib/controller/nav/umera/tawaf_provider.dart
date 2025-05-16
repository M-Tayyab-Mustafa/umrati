import 'dart:developer' show log;
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../utils/helper/constants.dart';
import '../../../utils/services/toast.dart';
part '../../../utils/helper/tawaf.dart';

final tawafProvider = ChangeNotifierProvider<TawafNotifier>((ref) => TawafNotifier());

class TawafNotifier extends ChangeNotifier {
  // Class-level variables
  bool isLoading = false;
  bool isInTawaf = false;

  //*
  double totalAngleCovered = 0;
  double? previousBearing;

  //* Tawaf Rounds
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = false;
  int circleCount = -1;

  //*
  bool isTawafCompleted = false;
  bool isSafaMarwaCompleted = false;
  bool isUmeraCompleted = false;

  startTawaf() async {
    if (isInTawaf) {
      isInTawaf = false;
      isTawafCompleted = false;
      isSafaMarwaCompleted = false;
      positionStreamSubscription?.cancel();
      _resetTawaf();
      return;
    }
    isInTawaf = true;
    notifyListeners();
    _getPermission();
  }

  Future<void> _getPermission() async {
    totalAngleCovered = 0;
    previousBearing = null;
    tawafCircleCompletionPercent = 0;
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      var alKabaLatLongDoc = await settingsCollection.doc(CommonDoc.alKaba.name).get();
      var kabaLatLng = LatLng(alKabaLatLongDoc.data()!['lat'], alKabaLatLongDoc.data()!['lng']);
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      ).listen((position) => _updateLocation(position, currentPosition, kabaLatLng));
    } else {
      errorToast('Please allow location permission');
      isInTawaf = false;
    }
    notifyListeners();
  }

  Future<void> _updateLocation(Position currentPosition, Position startingPosition, LatLng kabaLatLng) async {
    final currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    final startingLatLng = LatLng(startingPosition.latitude, startingPosition.longitude);
    previousBearing ??= calculateBearing(kabaLatLng, startingLatLng);
    double currentBearing = calculateBearing(kabaLatLng, currentLatLng);
    double delta = angleDifference(previousBearing!, currentBearing);

    if (delta > 10) {
      totalAngleCovered += delta;
      isRoundCompleted = (totalAngleCovered / 360).toInt() == 0;
      tawafCircleCompletionPercent = ((totalAngleCovered % 360) / 100).clamp(0, 1);
      notifyListeners();
    } else if (delta < -10) {
      totalAngleCovered -= delta;
      tawafCircleCompletionPercent = ((totalAngleCovered % 360) / 100).clamp(0, 1);
      notifyListeners();
    }
    previousBearing = currentBearing;
    log('Current bearing: ${currentBearing.toStringAsFixed(2)}°');
    log('Angle delta: ${delta.toStringAsFixed(2)}°');
    log('Total angle covered: ${totalAngleCovered.toStringAsFixed(2)}°');
    log('Current lap progress: ${(totalAngleCovered % 360).toStringAsFixed(2)}°');
  }

  startNextRound() {
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
  }

  _resetTawaf() {
    circleCount = -1;
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
    notifyListeners();
  }

  moveToSafaMarwa({required BuildContext context, required WidgetRef ref}) {
    isTawafCompleted = true;
    _resetTawaf();
  }

  void safaMarwaCompleted() {
    isSafaMarwaCompleted = true;
    notifyListeners();
  }

  void umeraCompleted() {
    isUmeraCompleted = true;
    notifyListeners();
  }

  void goToHome() {
    isInTawaf = false;
    isTawafCompleted = false;
    isSafaMarwaCompleted = false;
    isUmeraCompleted = false;
    _resetTawaf();
    notifyListeners();
  }
}
