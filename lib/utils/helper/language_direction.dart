import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

TextDirection languageDirection(BuildContext context) {
  String languageCode = context.locale.languageCode;
  bool isRtl = Bidi.isRtlLanguage(languageCode);
  return isRtl ? TextDirection.rtl : TextDirection.ltr;
}
