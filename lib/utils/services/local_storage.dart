import 'package:shared_preferences/shared_preferences.dart';

import '../../export.dart';

class LocalStorageManager {
  static SharedPreferences? _sharedPreferences;

  LocalStorageManager._();

  factory LocalStorageManager() => LocalStorageManager._();

  //* Local Keys
  static final String _languagePage = 'language_page';
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

  static Future<void> saveUser(UserModel user, {bool toFirebase = true, FieldValue? created_at}) async {
    try {
      if (toFirebase) {
        await userCollection.doc(user.uid).set(user.toMap(updated_at: FieldValue.serverTimestamp(), created_at: created_at), SetOptions(merge: true));
        user = UserModel.fromMap((await userCollection.doc(user.uid).get()).data()!);
      }
      await _sharedPreferences!.setString(_user, user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  static FutureOr<UserModel?> getUser({bool fromFirebase = false}) async {
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

  static FutureOr<bool> clearStorage() async {
    return await _sharedPreferences!.clear();
  }
}
