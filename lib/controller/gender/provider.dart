import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/helper/constants.dart';
import '../../view/meeqaat/two_tasks.dart';

final genderProvider = ChangeNotifierProvider<OTPNotifier>((ref) => OTPNotifier());

class OTPNotifier extends ChangeNotifier {
  Gender selectedGender = Gender.male;
  bool isUpdatingGender = false;
  void updateGender(Gender gender) {
    if (selectedGender == gender) return;
    selectedGender = gender;
    notifyListeners();
  }

  void skip(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
  }

  void continueTap(BuildContext context) {
    isUpdatingGender = true;
    notifyListeners();
    //TODO: Update gender
    isUpdatingGender = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
  }
}
