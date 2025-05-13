import 'dart:async' show Timer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/utils/services/local_storage.dart';

import '../../../utils/helper/constants.dart';

final tawafProvider = ChangeNotifierProvider<TawafNotifier>((ref) => TawafNotifier());

class TawafNotifier extends ChangeNotifier {
  //* Is Loading Data
  bool isLoading = false;
  var tawafCollection = FirebaseFirestore.instance.collection(CollectionNames.users.name);
  DocumentReference? userDoc;

  //
  bool isInTawaf = false;
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = false;
  int circleCount = -1;
  Timer? timer;
  bool isTawafCompleted = false;
  bool isSafaMarwaCompleted = false;
  bool isUmeraCompleted = false;

  initialization() async {
    isLoading = true;
    notifyListeners();
    userDoc = tawafCollection.doc((await LocalStorageManager.getUser())!.uid);
    var data = (await userDoc!.get()).data() as Map<String, dynamic>;
    data.containsKey(CommonField.isInTawaf.name) && data[CommonField.isInTawaf.name] == true ? isInTawaf = true : isInTawaf = false;
    isLoading = false;
    notifyListeners();
  }

  startTawaf() {
    if (isInTawaf) {
      isInTawaf = false;
      isTawafCompleted = false;
      isSafaMarwaCompleted = false;
      _resetTawaf();
      userDoc!.set({CommonField.isInTawaf.name: isInTawaf}, SetOptions(merge: true));
      return;
    }
    isInTawaf = true;
    userDoc!.set({CommonField.isInTawaf.name: isInTawaf}, SetOptions(merge: true));
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
