import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tawafProvider = ChangeNotifierProvider<TawafNotifier>((ref) => TawafNotifier());

class TawafNotifier extends ChangeNotifier {
  bool isInTawaf = false;
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = false;
  int circleCount = -1;
  Timer? timer;
  bool isTawafCompleted = false;
  bool isSafaMarwaCompleted = false;
  bool isUmeraCompleted = false;
  startTawaf() {
    if (isInTawaf) {
      isInTawaf = false;
      isTawafCompleted = false;
      isSafaMarwaCompleted = false;
      _resetTawaf();
      return;
    }
    isInTawaf = true;
    notifyListeners();
    updateLocation();
  }

  updateLocation() {
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (tawafCircleCompletionPercent >= 0.9) {
        _updateCircleCount();
      } else {
        tawafCircleCompletionPercent = tawafCircleCompletionPercent + 0.1;
        notifyListeners();
      }
    });
  }

  startNextRound() {
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
    updateLocation();
  }

  _resetTawaf() {
    circleCount = -1;
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
    timer?.cancel();
    notifyListeners();
  }

  _updateCircleCount() {
    circleCount == -1 ? circleCount = 1 : circleCount++;
    isRoundCompleted = true;
    timer?.cancel();
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
