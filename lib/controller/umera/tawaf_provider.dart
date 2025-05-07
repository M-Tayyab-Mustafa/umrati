import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/umera/safa_marwa_home.dart';

final tawafProvider = ChangeNotifierProvider<TawafNotifier>((ref) => TawafNotifier());

class TawafNotifier extends ChangeNotifier {
  bool isInTawaf = false;
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = false;
  int circleCount = -1;
  Timer? timer;
  startTawaf() {
    if (isInTawaf) {
      resetTawaf();
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

  resetTawaf() {
    isInTawaf = false;
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

  moveToSafaMarwa({required BuildContext context}) {
    resetTawaf();
    Navigator.push(context, MaterialPageRoute(builder: (context) => SafaMarwaHomePage()));
  }
}
