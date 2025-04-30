import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/meeqaat/three_tasks.dart';

final meeqaatTwoTasksProvider = ChangeNotifierProvider<MeeqaatTwoTasksNotifier>((ref) => MeeqaatTwoTasksNotifier());

class MeeqaatTwoTasksNotifier extends ChangeNotifier {
  bool isConfirmingMeeqaat = false;

  void skip(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatThreeTasksPage()));
  }

  void moveToThreeOtherTasks(BuildContext context) {
    isConfirmingMeeqaat = true;
    notifyListeners();
    isConfirmingMeeqaat = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatThreeTasksPage()));
  }

  void showIhramTutorial(BuildContext context) {}
}
