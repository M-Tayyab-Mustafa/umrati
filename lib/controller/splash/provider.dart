import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/local_storage.dart';
import '../../view/auth/gender.dart';
import '../../view/auth/login.dart';
import '../../view/language/select_language.dart';
import '../../view/meeqaat/two_tasks.dart';

final splashProvider = ChangeNotifierProvider.autoDispose<SplashNotifier>((ref) => SplashNotifier());

class SplashNotifier extends ChangeNotifier {
  void initialization(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    screenSize = MediaQuery.sizeOf(context);

    if (await LocalStorageManager.getSelectLanguagePage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectLanguagePage()));
    } else if (await LocalStorageManager.getLoginPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else if (await LocalStorageManager.getGenderPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectGenderPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeeqaatTwoTasksPage()));
    }
  }
}
