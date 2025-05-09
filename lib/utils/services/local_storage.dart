import 'dart:async' show FutureOr;

import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';

class LocalStorageManager {
  static SharedPreferences? _sharedPreferences;

  LocalStorageManager._();

  factory LocalStorageManager() => LocalStorageManager._();

  //* Local Keys
  static final String _languagePage = 'language_page';
  static final String _loginPage = 'login_page';
  static final String _genderPage = 'gender_page';
  static final String _user = 'user';

  static FutureOr<void> initialization() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static FutureOr<bool?> showSelectLanguagePage(bool show) {
    return _sharedPreferences!.setBool(_languagePage, show);
  }

  static FutureOr<bool> getSelectLanguagePage() async {
    return (_sharedPreferences!.getBool(_languagePage)) ?? true;
  }

  static FutureOr<bool?> showLoginPage(bool show) {
    return _sharedPreferences!.setBool(_loginPage, show);
  }

  static FutureOr<bool> getLoginPage() async {
    return (_sharedPreferences!.getBool(_loginPage)) ?? true;
  }

  static FutureOr<bool?> saveUser(UserModel user) {
    return _sharedPreferences!.setString(_user, user.toJson());
  }

  static FutureOr<UserModel?> getUser() async {
    var json = (_sharedPreferences!.getString(_user));
    if (json != null) {
      return UserModel.fromJson(json);
    }
    return null;
  }

  static FutureOr<bool?> showGenderPage(bool show) {
    return _sharedPreferences!.setBool(_genderPage, show);
  }

  static FutureOr<bool> getGenderPage() async {
    return (_sharedPreferences!.getBool(_genderPage)) ?? true;
  }
}
