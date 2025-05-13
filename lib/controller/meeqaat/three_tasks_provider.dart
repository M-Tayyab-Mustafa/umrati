import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/services/local_storage.dart';
import '../../utils/services/toast.dart';
import '../../view/nav/page.dart';

final meeqaatThreeTasksProvider = ChangeNotifierProvider<MeeqaatThreeTasksNotifier>((ref) => MeeqaatThreeTasksNotifier());

class MeeqaatThreeTasksNotifier extends ChangeNotifier {
  bool isTwoNafiPrayersChecked = false;
  bool isIntentionChecked = false;
  bool isTalbiyahChecked = false;

  updateTwoNafiPrayersChecked() {
    isTwoNafiPrayersChecked = !isTwoNafiPrayersChecked;
    notifyListeners();
  }

  updateIntentionChecked() {
    isIntentionChecked = !isIntentionChecked;
    notifyListeners();
  }

  updateTalbiyahChecked() {
    isTalbiyahChecked = !isTalbiyahChecked;
    notifyListeners();
  }

  void skip(BuildContext context) {
    LocalStorageManager.showMeeqaatThreeTasksPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }

  void tasksDone(BuildContext context) {
    if (!(isTwoNafiPrayersChecked && isIntentionChecked && isTalbiyahChecked)) {
      errorToast('Please check Two Nafi Prayers, Intention and, Talbiyah boxes');
      return;
    }
    LocalStorageManager.showMeeqaatThreeTasksPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }
}
