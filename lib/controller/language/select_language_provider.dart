// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async' show FutureOr;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/services/local_storage.dart';
import '../../view/auth/login.dart';
import '../../view/language/language.dart';
import 'language_provider.dart';

final selectLanguageProvider = ChangeNotifierProvider<SelectLanguageNotifier>((ref) => SelectLanguageNotifier());

class SelectLanguageNotifier extends ChangeNotifier {
  FutureOr<void> changeLanguageTap(BuildContext context, WidgetRef ref) async {
    ref.read(languageProvider).resetLanguage(context);
    await Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
  }

  FutureOr<void> continueTap(BuildContext context) async {
    LocalStorageManager.saveFirstTime(false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
