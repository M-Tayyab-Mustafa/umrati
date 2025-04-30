import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/meeqaat/permission.dart';

final meeqaatThreeTasksProvider = ChangeNotifierProvider<MeeqaatThreeTasksNotifier>((ref) => MeeqaatThreeTasksNotifier());

class MeeqaatThreeTasksNotifier extends ChangeNotifier {
  bool isConfirmingMeeqaat = false;

  void skip(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatPermissionPage()));
  }

  void tasksDone(BuildContext context) {
    isConfirmingMeeqaat = true;
    notifyListeners();
    isConfirmingMeeqaat = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatPermissionPage()));
  }
}
