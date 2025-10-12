import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/view/bottom_nav/page.dart';

import '../../utils/services/local_storage.dart';
import '../../utils/services/translations/locale_keys.g.dart';

final languageProvider = ChangeNotifierProvider.autoDispose<LanguageNotifier>((ref) => LanguageNotifier());

class LanguageNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  String selectedLanguage = LocaleKeys.english;
  List<String> languages = [LocaleKeys.english, LocaleKeys.urdu];
  bool isUpdatingLanguage = false;

  Future<void> initialization() async {
    selectedLanguage = context.locale.languageCode == 'en' ? LocaleKeys.english : LocaleKeys.urdu;
    notifyListeners();
  }

  void updateLanguage(String language) {
    selectedLanguage = language;
    notifyListeners();
  }

  void continueTap() {
    if (isUpdatingLanguage) {
      if (selectedLanguage == LocaleKeys.english) {
        context.setLocale(Locale('en', 'US'));
      } else {
        context.setLocale(Locale('ur', 'PK'));
      }
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationPage()));
    } else {
      if (selectedLanguage == LocaleKeys.english) {
        context.setLocale(Locale('en', 'US'));
      } else {
        context.setLocale(Locale('ur', 'PK'));
      }
      LocalStorageManager.showSelectLanguagePage(false);
      Navigator.pop(context, selectedLanguage);
    }
  }

  void resetLanguage(BuildContext context) {
    selectedLanguage = context.locale.languageCode == 'en' ? LocaleKeys.english : LocaleKeys.urdu;
    notifyListeners();
  }
}
