import '../../export.dart';
part 'enums.dart';
part 'size_config.dart';

late Size screenSize;
int distanceFilter = 10;
String currencySymbol = '\$';

final primaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.outer)];
final greyShadows = [BoxShadow(color: CColors.grey, blurRadius: 10, blurStyle: BlurStyle.outer)];
final innerPrimaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.inner)];

class DefaultImages {
  static const String logoWithName = 'assets/svg/logo_with_text.svg';
  static const String longArrowForward = 'assets/svg/forward_arrow.svg';
}

var userCollection = FirebaseFirestore.instance.collection(CollectionNames.users.name);
var settingsCollection = FirebaseFirestore.instance.collection(CollectionNames.settings.name);
var historyCollection = FirebaseFirestore.instance.collection(CollectionNames.histories.name);
var messagesCollection = FirebaseFirestore.instance.collection(CollectionNames.messages.name);
var subscriptionCollection = FirebaseFirestore.instance.collection(CollectionNames.subscriptions.name);
var plansCollection = FirebaseFirestore.instance.collection(CollectionNames.plans.name);

bool isLTR(context) => languageDirection(context) == TextDirection.ltr;

TextDirection languageDirection(BuildContext context) {
  String languageCode = context.locale.languageCode;
  bool isRtl = Bidi.isRtlLanguage(languageCode);
  return isRtl ? TextDirection.rtl : TextDirection.ltr;
}

TextDirection getTextDirection(String text) {
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
