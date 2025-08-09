import '../../export.dart';

TextDirection languageDirection(BuildContext context) {
  String languageCode = context.locale.languageCode;
  bool isRtl = Bidi.isRtlLanguage(languageCode);
  return isRtl ? TextDirection.rtl : TextDirection.ltr;
}
