import 'dart:async' show Timer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/controller/nav/umera/tawaf_provider.dart';

import '../../../utils/helper/constants.dart';
import '../../../widgets/tawaf_completed_dialog.dart';

final safaMarwaProvider = ChangeNotifierProvider<SafaMarwaNotifier>((ref) => SafaMarwaNotifier());

class SafaMarwaNotifier extends ChangeNotifier {
  BuildContext? context;
  WidgetRef? ref;
  ScrollController? scrollController;
  double oneSideRunCompletionPercent = 0.0;
  bool isOnSideRunComplete = false;
  int circleCount = -1;
  Timer? timer;

  void updateLocation() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      if (isOnSideRunComplete) {
        if (oneSideRunCompletionPercent <= 0.0000) {
          _updateCircleCount();
        } else {
          oneSideRunCompletionPercent = roundToOneDecimal(oneSideRunCompletionPercent - 0.1);
        }
      } else {
        if (oneSideRunCompletionPercent >= 1.0000) {
          isOnSideRunComplete = true;
        } else {
          oneSideRunCompletionPercent = roundToOneDecimal(oneSideRunCompletionPercent + 0.1);
        }
      }
      notifyListeners();
      if (scrollController!.hasClients) {
        var position = scrollController!.position.maxScrollExtent * (1 - oneSideRunCompletionPercent);
        scrollController!.animateTo(position, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      }
    });
  }

  _updateCircleCount() {
    timer?.cancel();
    circleCount == -1 ? circleCount = 1 : circleCount++;
    if (circleCount == 7) {
      tawafCompletionDialog();
    }
    isOnSideRunComplete = false;
  }

  _resetSafaMarwa() {
    circleCount = -1;
    oneSideRunCompletionPercent = 0.0;
    isOnSideRunComplete = false;
    notifyListeners();
  }

  tawafCompletionDialog() async {
    await showGeneralDialog(context: context!, pageBuilder: (context, animation, secondaryAnimation) => TawafCompletionDialog());
    _resetSafaMarwa();
    ref?.watch(tawafProvider).safaMarwaCompleted();
  }
}
