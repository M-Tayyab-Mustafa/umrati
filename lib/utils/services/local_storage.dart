import 'dart:async' show FutureOr;

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  static SharedPreferences? _sharedPreferences;

  LocalStorageManager._();

  factory LocalStorageManager() => LocalStorageManager._();

  //* Local Keys
  static final String _firstTime = 'first_time';

  static FutureOr<void> initialization() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static FutureOr<bool?> saveFirstTime(bool firstTime) {
    return _sharedPreferences!.setBool(_firstTime, firstTime);
  }

  static FutureOr<bool> getFirstTime() async {
    return (_sharedPreferences!.getBool(_firstTime)) ?? true;
  }
}
