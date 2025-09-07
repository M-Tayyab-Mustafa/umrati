import '../../export.dart';
part 'enums.dart';

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

get mapsApiKey async => (await settingsCollection.doc(CommonDoc.constants.name).get()).get(CommonField.googleMapKey.name);

const Map<String, String> countryDialCodes = {
  "+93": "AF", // Afghanistan
  "+355": "AL", // Albania
  "+213": "DZ", // Algeria
  "+1684": "AS", // American Samoa
  "+376": "AD", // Andorra
  "+244": "AO", // Angola
  "+1264": "AI", // Anguilla
  "+54": "AR", // Argentina
  "+374": "AM", // Armenia
  "+297": "AW", // Aruba
  "+61": "AU", // Australia
  "+43": "AT", // Austria
  "+994": "AZ", // Azerbaijan
  "+1242": "BS", // Bahamas
  "+973": "BH", // Bahrain
  "+880": "BD", // Bangladesh
  "+1246": "BB", // Barbados
  "+375": "BY", // Belarus
  "+32": "BE", // Belgium
  "+501": "BZ", // Belize
  "+229": "BJ", // Benin
  "+975": "BT", // Bhutan
  "+591": "BO", // Bolivia
  "+387": "BA", // Bosnia and Herzegovina
  "+267": "BW", // Botswana
  "+55": "BR", // Brazil
  "+673": "BN", // Brunei
  "+359": "BG", // Bulgaria
  "+226": "BF", // Burkina Faso
  "+257": "BI", // Burundi
  "+855": "KH", // Cambodia
  "+237": "CM", // Cameroon
  "+1": "US", // United States
  "+238": "CV", // Cape Verde
  "+1345": "KY", // Cayman Islands
  "+236": "CF", // Central African Republic
  "+235": "TD", // Chad
  "+56": "CL", // Chile
  "+86": "CN", // China
  "+57": "CO", // Colombia
  "+269": "KM", // Comoros
  "+242": "CG", // Congo
  "+243": "CD", // Congo (DRC)
  "+506": "CR", // Costa Rica
  "+385": "HR", // Croatia
  "+53": "CU", // Cuba
  "+357": "CY", // Cyprus
  "+420": "CZ", // Czech Republic
  "+45": "DK", // Denmark
  "+253": "DJ", // Djibouti
  "+1767": "DM", // Dominica
  "+1809": "DO", // Dominican Republic (shared with +1829, +1849)
  "+593": "EC", // Ecuador
  "+20": "EG", // Egypt
  "+503": "SV", // El Salvador
  "+240": "GQ", // Equatorial Guinea
  "+291": "ER", // Eritrea
  "+372": "EE", // Estonia
  "+251": "ET", // Ethiopia
  "+679": "FJ", // Fiji
  "+358": "FI", // Finland
  "+33": "FR", // France
  "+49": "DE", // Germany
  "+233": "GH", // Ghana
  "+30": "GR", // Greece
  "+1473": "GD", // Grenada
  "+502": "GT", // Guatemala
  "+224": "GN", // Guinea
  "+245": "GW", // Guinea-Bissau
  "+592": "GY", // Guyana
  "+509": "HT", // Haiti
  "+504": "HN", // Honduras
  "+36": "HU", // Hungary
  "+354": "IS", // Iceland
  "+91": "IN", // India
  "+62": "ID", // Indonesia
  "+98": "IR", // Iran
  "+964": "IQ", // Iraq
  "+353": "IE", // Ireland
  "+972": "IL", // Israel
  "+39": "IT", // Italy
  "+1876": "JM", // Jamaica
  "+81": "JP", // Japan
  "+962": "JO", // Jordan
  "+7": "RU", // Russia / Kazakhstan (shared)
  "+254": "KE", // Kenya
  "+82": "KR", // South Korea
  "+965": "KW", // Kuwait
  "+996": "KG", // Kyrgyzstan
  "+856": "LA", // Laos
  "+371": "LV", // Latvia
  "+961": "LB", // Lebanon
  "+231": "LR", // Liberia
  "+218": "LY", // Libya
  "+370": "LT", // Lithuania
  "+352": "LU", // Luxembourg
  "+853": "MO", // Macao
  "+389": "MK", // North Macedonia
  "+261": "MG", // Madagascar
  "+60": "MY", // Malaysia
  "+960": "MV", // Maldives
  "+223": "ML", // Mali
  "+356": "MT", // Malta
  "+230": "MU", // Mauritius
  "+52": "MX", // Mexico
  "+373": "MD", // Moldova
  "+377": "MC", // Monaco
  "+976": "MN", // Mongolia
  "+382": "ME", // Montenegro
  "+212": "MA", // Morocco
  "+258": "MZ", // Mozambique
  "+95": "MM", // Myanmar
  "+264": "NA", // Namibia
  "+977": "NP", // Nepal
  "+31": "NL", // Netherlands
  "+64": "NZ", // New Zealand
  "+505": "NI", // Nicaragua
  "+227": "NE", // Niger
  "+234": "NG", // Nigeria
  "+47": "NO", // Norway
  "+968": "OM", // Oman
  "+92": "PK", // Pakistan
  "+507": "PA", // Panama
  "+595": "PY", // Paraguay
  "+51": "PE", // Peru
  "+63": "PH", // Philippines
  "+48": "PL", // Poland
  "+351": "PT", // Portugal
  "+974": "QA", // Qatar
  "+40": "RO", // Romania
  "+250": "RW", // Rwanda
  "+966": "SA", // Saudi Arabia
  "+221": "SN", // Senegal
  "+381": "RS", // Serbia
  "+65": "SG", // Singapore
  "+421": "SK", // Slovakia
  "+386": "SI", // Slovenia
  "+27": "ZA", // South Africa
  "+211": "SS", // South Sudan
  "+34": "ES", // Spain
  "+94": "LK", // Sri Lanka
  "+249": "SD", // Sudan
  "+597": "SR", // Suriname
  "+268": "SZ", // Swaziland / Eswatini
  "+46": "SE", // Sweden
  "+41": "CH", // Switzerland
  "+963": "SY", // Syria
  "+886": "TW", // Taiwan
  "+992": "TJ", // Tajikistan
  "+255": "TZ", // Tanzania
  "+66": "TH", // Thailand
  "+228": "TG", // Togo
  "+676": "TO", // Tonga
  "+1868": "TT", // Trinidad and Tobago
  "+216": "TN", // Tunisia
  "+90": "TR", // Turkey
  "+993": "TM", // Turkmenistan
  "+256": "UG", // Uganda
  "+380": "UA", // Ukraine
  "+971": "AE", // United Arab Emirates
  "+44": "GB", // United Kingdom
  "+598": "UY", // Uruguay
  "+998": "UZ", // Uzbekistan
  "+678": "VU", // Vanuatu
  "+58": "VE", // Venezuela
  "+84": "VN", // Vietnam
  "+967": "YE", // Yemen
  "+260": "ZM", // Zambia
  "+263": "ZW", // Zimbabwe
};
