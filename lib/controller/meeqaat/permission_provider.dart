import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/meeqaat/location_fetched.dart';

final meeqaatPermissionProvider = ChangeNotifierProvider<MeeqaatPermissionNotifier>((ref) => MeeqaatPermissionNotifier());

class MeeqaatPermissionNotifier extends ChangeNotifier {
  bool isConfirmingMeeqaat = false;

  void skip(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatLocationFetchedPage()));
  }

  void continueTab(BuildContext context) {
    isConfirmingMeeqaat = true;
    notifyListeners();
    isConfirmingMeeqaat = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatLocationFetchedPage()));
  }
}
