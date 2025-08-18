import '../../export.dart';

TextDirection languageDirection(BuildContext context) {
  String languageCode = context.locale.languageCode;
  bool isRtl = Bidi.isRtlLanguage(languageCode);
  return isRtl ? TextDirection.rtl : TextDirection.ltr;
}

TextDirection getDirection(String text) {
  // Regex for different scripts
  final latinRegex = RegExp(r'[A-Za-z]');
  final arabicRegex = RegExp(r'[\u0600-\u06FF]'); // Arabic, Persian, Urdu
  final hebrewRegex = RegExp(r'[\u0590-\u05FF]');
  final devanagariRegex = RegExp(r'[\u0900-\u097F]'); // Hindi, Marathi, Nepali
  final cyrillicRegex = RegExp(r'[\u0400-\u04FF]'); // Russian, Bulgarian, etc.
  final hanRegex = RegExp(r'[\u4E00-\u9FFF]'); // Chinese characters
  final hangulRegex = RegExp(r'[\uAC00-\uD7AF]'); // Korean
  final kanaRegex = RegExp(r'[\u3040-\u30FF]'); // Japanese Hiragana+Katakana

  // Count matches
  int latinCount = latinRegex.allMatches(text).length;
  int arabicCount = arabicRegex.allMatches(text).length;
  int hebrewCount = hebrewRegex.allMatches(text).length;
  int devanagariCount = devanagariRegex.allMatches(text).length;
  int cyrillicCount = cyrillicRegex.allMatches(text).length;
  int hanCount = hanRegex.allMatches(text).length;
  int hangulCount = hangulRegex.allMatches(text).length;
  int kanaCount = kanaRegex.allMatches(text).length;

  // Totals
  final rtlCount = arabicCount + hebrewCount;
  final ltrCount = latinCount + devanagariCount + cyrillicCount + hanCount + hangulCount + kanaCount;

  // Decide direction
  if (rtlCount > ltrCount) {
    return TextDirection.rtl;
  } else {
    return TextDirection.ltr;
  }
}
