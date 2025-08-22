import 'package:shared_preferences/shared_preferences.dart';

import '../../export.dart';

class LocalStorageManager {
  static SharedPreferences? _sharedPreferences;

  LocalStorageManager._();

  factory LocalStorageManager() => LocalStorageManager._();

  //* Local Keys
  static final String _languagePage = 'language_page';
  static final String _loginPage = 'login_page';
  static final String _genderPage = 'gender_page';
  static final String _twoTasksBeforeMeeqaatPage = 'two_tasks_before_meeqaat_page';
  static final String _meeqaatPage = 'location_fetch_page';
  static final String _meeqaatThreeTasksPage = 'meeqaat_three_tasks_page';
  static final String _user = 'user';

  static Future<void> initialization() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> showSelectLanguagePage(bool show) {
    return _sharedPreferences!.setBool(_languagePage, show);
  }

  static Future<bool> getSelectLanguagePage() async {
    return (_sharedPreferences!.getBool(_languagePage)) ?? true;
  }

  static Future<bool?> showLoginPage(bool show) {
    return _sharedPreferences!.setBool(_loginPage, show);
  }

  static Future<bool> getLoginPage() async {
    return (_sharedPreferences!.getBool(_loginPage)) ?? true;
  }

  static Future<void> saveUser(
    UserModel user, {
    bool toFirebase = true,
    FieldValue? created_at,
    FieldValue? subscription_created_at,
    FieldValue? subscription_expire_at,
    FieldValue? subscription_updated_at,
  }) async {
    try {
      if (toFirebase) {
        await userCollection
            .doc(user.uid)
            .set(
              user.toMap(
                updated_at: FieldValue.serverTimestamp(),
                created_at: created_at,
                subscription_created_at: subscription_created_at,
                subscription_expire_at: subscription_expire_at,
                subscription_updated_at: subscription_updated_at,
              ),
              SetOptions(merge: true),
            );
        user = (await getUser(fromFirebase: true))!;
      }
      await _sharedPreferences!.setString(_user, user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel?> getUser({bool fromFirebase = false}) async {
    try {
      var json = _sharedPreferences!.getString(_user);
      if (json == null) return null;
      var user = UserModel.fromJson(json);
      if (fromFirebase) {
        var doc = await userCollection.doc(user.uid).get();
        if (doc.exists) {
          var updatedUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          await saveUser(updatedUser, toFirebase: false);
          return updatedUser;
        } else {
          clearStorage();
          return null;
        }
      } else {
        return user;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool?> showGenderPage(bool show) {
    return _sharedPreferences!.setBool(_genderPage, show);
  }

  static Future<bool> getGenderPage() async {
    return (_sharedPreferences!.getBool(_genderPage)) ?? true;
  }

  static Future<bool?> showTwoTasksBeforeMeeqaatPage(bool show) {
    return _sharedPreferences!.setBool(_twoTasksBeforeMeeqaatPage, show);
  }

  static Future<bool> getTwoTasksBeforeMeeqaatPage() async {
    return (_sharedPreferences!.getBool(_twoTasksBeforeMeeqaatPage)) ?? true;
  }

  static Future<bool?> showMeeqaatPage(bool show) {
    return _sharedPreferences!.setBool(_meeqaatPage, show);
  }

  static Future<bool> getMeeqaatPage() async {
    return (_sharedPreferences!.getBool(_meeqaatPage)) ?? true;
  }

  static Future<bool?> showMeeqaatThreeTasksPage(bool show) {
    return _sharedPreferences!.setBool(_meeqaatThreeTasksPage, show);
  }

  static Future<bool> getMeeqaatThreeTasksPage() async {
    return (_sharedPreferences!.getBool(_meeqaatThreeTasksPage)) ?? true;
  }

  static Future<bool> clearStorage() async {
    return await _sharedPreferences!.clear();
  }
}
