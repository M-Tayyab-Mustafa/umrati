import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/services/local_storage.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../view/auth/login.dart';

final languageProvider = NotifierProvider<LanguageNotifier, String>(() => LanguageNotifier());

class LanguageNotifier extends Notifier<String> {
  List<String> languages = [LocaleKeys.english.tr(), LocaleKeys.urdu.tr()];

  @override
  String build() {
    return LocaleKeys.english.tr();
  }

  void updateLanguage(String language) {
    state = language;
  }

  void continueTap(BuildContext context) {
    LocalStorageManager.saveFirstTime(false);
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
