import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/local_storage.dart';
import '../../view/auth/gender.dart';
import '../../view/auth/login.dart';
import '../../view/language/select_language.dart';
import '../../view/meeqaat/location_fetched.dart';
import '../../view/meeqaat/three_tasks.dart';
import '../../view/permission.dart';
import '../../view/meeqaat/two_tasks.dart';
import '../../view/nav/page.dart';

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
    } else if (await LocalStorageManager.getTwoTasksBeforeMeeqaatPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeeqaatTwoTasksPage()));
    } else if (await LocalStorageManager.getGetLocationPermissionPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LocationPermissionPage()));
    } else if (await LocalStorageManager.getLocationFetchPage() && await Permission.locationAlways.status == PermissionStatus.granted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeeqaatLocationFetchedPage()));
    } else if (await LocalStorageManager.getMeeqaatThreeTasksPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeeqaatThreeTasksPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationPage()));
    }
  }
}
