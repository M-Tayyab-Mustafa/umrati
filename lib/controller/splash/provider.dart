import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/local_storage.dart';
import '../../view/auth/login.dart';
import '../../view/language/select_language.dart';

final splashProvider = ChangeNotifierProvider<SplashNotifier>((ref) => SplashNotifier());

class SplashNotifier extends ChangeNotifier {
  void initialization(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    screenSize = MediaQuery.sizeOf(context);
    bool isFirstTime = await LocalStorageManager.getFirstTime();
    if (isFirstTime) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectLanguagePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}
