import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/helper/constants.dart';
import '../../utils/services/local_storage.dart';
import '../../view/meeqaat/two_tasks.dart';

final genderProvider = ChangeNotifierProvider.autoDispose<GenderNotifier>((ref) => GenderNotifier());

class GenderNotifier extends ChangeNotifier {
  Gender selectedGender = Gender.male;
  bool isUpdatingGender = false;
  void updateGender(Gender gender) {
    if (selectedGender == gender) return;
    selectedGender = gender;
    notifyListeners();
  }

  void skip(BuildContext context) {
    LocalStorageManager.showGenderPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
  }

  void continueTap(BuildContext context) async {
    isUpdatingGender = true;
    notifyListeners();
    var user = (await LocalStorageManager.getUser())!;
    user = user.copyWith(gender: selectedGender.name.toLowerCase());
    await FirebaseFirestore.instance.collection(CollectionNames.users.name).doc(user.uid).set(user.toMap(), SetOptions(merge: true));
    LocalStorageManager.showGenderPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
    isUpdatingGender = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
  }
}
