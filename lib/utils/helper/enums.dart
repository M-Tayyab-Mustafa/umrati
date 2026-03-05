part of 'constants.dart';

enum Gender { male, female }

enum BackgroundType { empty, logo, logoWithSkip, titleWithBackButton }

enum TitleType { empty, backArrow }

enum BottomNavTabs { home, profile, askMufti, settings }

enum ZiaraatCities { mecca, medina, taif, other }

enum ZiaraatDestinationsCreationOptions { auto, manual }

enum CollectionNames {
  users('users'),
  settings('settings'),
  plans('plans'),
  subscriptions('subscriptions'),
  histories('histories'),
  messages('messages'),
  otp('email_otps');

  final String name;
  const CollectionNames(this.name);
}

enum StorageFolderNames {
  profileImages('profile_images');

  final String name;

  const StorageFolderNames(this.name);
}

enum MapMarkerId { userLocation, destination }

enum UserActivityType { tawaf, umrah, ziaraat }

enum CommonDoc {
  alKaba('al_kaba'),
  meeqaat('meeqaat'),
  paymentSettings('payment_settings'),
  ultimatePlan('ultimate_plan'),
  constants('constants'),
  safaMarwa('safa_marwa'),
  safaMarwaRunningPoints('safa_marwa_running_points'),
  ziaraat('ziaraat');

  final String name;

  const CommonDoc(this.name);
}

enum PlanType { individual, group }

enum CommonField {
  isInTawaf('isInTawaf'),
  points('points'),
  threeMonths('3_months'),
  alHajarAlAswad('al_hajar_al_aswad'),
  matafGreenLight('mataf_green_light'),
  alHajarToMatafThreshold('al_hajar_to_mataf_threshold'),
  oneYear('1_year'),
  regions('regions'),
  symbols('symbols'),
  inAppProducts('in_app_products'),
  bypassEmails('bypass_emails'),
  messages('messages'),
  currencyCode('currency_code'),
  googleMapKey('google_map_key'),
  startingPoint('startingPoint'),
  stripePublishableKey('stripe_publishable_key'),
  stripeSecretKey('stripe_secret_key'),
  selectedZiaraat('selected_ziaraat'),
  emailServiceId('email_service_id'),
  emailTemplateId('email_template_id'),
  emailPrivateKey('email_private_key'),
  emailPublicKey('email_public_key');

  final String name;

  const CommonField(this.name);
}

enum Dua {
  round1('رَبِّ اغْفِرْلِیْ وَتُبْ عَلَیَّ اِنَّکَ اَنْتَ التَّوَّابُ الرَّحِيْمُ'),
  round2('رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً، وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ'),
  round3('رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً'),
  round4('اَللّٰھُمَّ اکْفِنِیْ بِحَلَالِکَ عَنْ حَرَامِکَ وَاَغْنِنِیْ بِفَضْلِکَ عَمَّنْ سِوَاکَ'),
  round5('اَللّٰھُمَّ اِنِّیْ اَسْأَلُکَ الْھُدٰی وَالتُّقٰی وَالْعَفَافَ وَالغِنٰی'),
  round6('اَللّٰھُمَّ اِنِّیْ اَسْأَلُکَ رِزْقًا طَیِّبًا وَعِلْمًا نَافِعًا وَعَمَلًا مُتَقَـبَّلًا'),
  saiRound1('اَللّٰھُمَّ لَکَ الْحَمْدُ کَالَّذِیْ تَـقُوْلُ وَخَیْرًا مِّمَّا نَقُولُ'),
  saiRound2('اَللّٰھُمَّ لَقِّنِی حُجَّۃَ الْاِیْمَانِ عِنْدَ الْمَمَاتِ'),
  saiRound3('یَاحَیُّ یَاقَـیُّومُ بِرَحْمَتِکَ اَسْتَغِیْثُ اَصْلِحْ لِی شَأْنِی کُلَّہٗ وَلَا تَکِلْنِی اِلٰی نَفْسِیْ طَرْفَۃَ عَیْنٍ'),
  saiRound4('اَللّٰھُمَّ اجْعَلْ اَوْسَعَ رِزْقِکَ عَلَیَّ عِنْدَ کِـبَرِ سِنِّی وَانْقِطَاعِ عُمْرِیْ'),
  saiRound5('اَللّٰھُمَّ اھْدِنِیْ وَسَدِّدْنِی'),
  saiRound6('اَللّٰھُمَّ اَعِنَّا عَلٰی ذِکْرِکَ وَشُکْرِکَ وَحُسْنِ عِبَادَتِکَ');

  final String dua;

  const Dua(this.dua);
}

enum IstilaamDua {
  round1('بِسْمِ اللّٰهِ وَاللّٰهُ أكْبَرُ اَللّٰهُمَّ إيْمَانًا بِكَ وَتَصْدِيْقًا بِكِتابِكَ وَوَفَاءً بِعَهْدِكَ وَاتِّباعًا لِّسُنَّةِ نَبِيِّكَ صَلَّى اللّٰهُ عَلَيْهِ وسَلَّمَ'),
  otherRounds('بِسْمِ اللّٰهِ وَاللّٰهُ أكْبَرُ');

  final String dua;

  const IstilaamDua(this.dua);
}

enum HistoryType { umrah, tawaf, ziaraat }
