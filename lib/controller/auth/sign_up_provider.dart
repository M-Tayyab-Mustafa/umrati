import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/services/local_storage.dart';
import '../../view/auth/gender.dart';

final signUpProvider = ChangeNotifierProvider<SignUpNotifier>((ref) => SignUpNotifier());

class SignUpNotifier extends ChangeNotifier {
  bool registeringWithEmail = false;

  Future<void> skip(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectGenderPage()));
  }

  Future<void> continueTap(BuildContext context) async {
    LocalStorageManager.saveFirstTime(true);
    registeringWithEmail = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    registeringWithEmail = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectGenderPage()));
  }
}
