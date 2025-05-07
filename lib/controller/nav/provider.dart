import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/nav/umera/tawaf.dart';
import '../../utils/helper/constants.dart';

final bottomNavProvider = ChangeNotifierProvider<BottomNavNotifier>((ref) => BottomNavNotifier());

class BottomNavNotifier extends ChangeNotifier {
  BottomNavTabs selectedTab = BottomNavTabs.umera;
  Widget child = const StartTawafPage();

  void onBottomNavTap(BottomNavTabs selectedOption) {
    selectedTab = selectedOption;
    switch (selectedOption) {
      case BottomNavTabs.profile:
      case BottomNavTabs.umera:
        child = const StartTawafPage();
        break;
      case BottomNavTabs.more:
      case BottomNavTabs.ziarat:
      default:
        child = Scaffold();
    }
    notifyListeners();
  }

  void updateChild(Widget child) {
    this.child = child;
    notifyListeners();
  }
}
