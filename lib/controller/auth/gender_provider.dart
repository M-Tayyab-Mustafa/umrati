import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/helper/constants.dart';
import '../../utils/services/local_storage.dart';
import '../../view/meeqaat/two_tasks.dart';
import '../../widgets/dialog/confirmation.dart';

final genderProvider = ChangeNotifierProvider.autoDispose<GenderNotifier>((ref) => GenderNotifier());

class GenderNotifier extends ChangeNotifier {
  Gender selectedGender = Gender.unknown;
  bool isUpdatingGender = false;
  void updateGender(Gender gender) {
    if (selectedGender == gender) return;
    selectedGender = gender;
    notifyListeners();
  }

  void skip(BuildContext context) async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
    if (result == false) {
      return;
    }
    isUpdatingGender = true;
    notifyListeners();
    await LocalStorageManager.showGenderPage(false);
    var user = (await LocalStorageManager.getUser())!;
    user = user.copyWith(gender: Gender.unknown.name.toLowerCase());
    await FirebaseFirestore.instance.collection(CollectionNames.users.name).doc(user.uid).set(user.toMap(), SetOptions(merge: true));
    isUpdatingGender = false;
    notifyListeners();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
  }

  void continueTap(BuildContext context) async {
    isUpdatingGender = true;
    notifyListeners();
    var user = (await LocalStorageManager.getUser())!;
    user = user.copyWith(gender: selectedGender.name.toLowerCase());
    await FirebaseFirestore.instance.collection(CollectionNames.users.name).doc(user.uid).set(user.toMap(), SetOptions(merge: true));
    await LocalStorageManager.showGenderPage(false);
    isUpdatingGender = false;
    notifyListeners();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
  }
}
