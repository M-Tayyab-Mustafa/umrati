import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/services/local_storage.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../view/auth/login.dart';

final languageProvider = ChangeNotifierProvider<LanguageNotifier>((ref) => LanguageNotifier());

class LanguageNotifier extends ChangeNotifier {
  String selectedLanguage = LocaleKeys.english.tr();
  List<String> languages = [LocaleKeys.english, LocaleKeys.urdu];

  void updateLanguage(BuildContext context, String language) {
    selectedLanguage = language;
    notifyListeners();
  }

  void continueTap(BuildContext context) {
    if (selectedLanguage == LocaleKeys.english) {
      context.setLocale(Locale('en', 'US'));
    } else {
      context.setLocale(Locale('ur', 'PK'));
    }
    LocalStorageManager.saveFirstTime(false);
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void resetLanguage(BuildContext context) {
    selectedLanguage = context.locale.languageCode == 'en' ? LocaleKeys.english : LocaleKeys.urdu;
    notifyListeners();
  }
}
