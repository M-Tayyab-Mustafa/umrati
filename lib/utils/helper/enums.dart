part of 'constants.dart';

enum Gender { male, female, unknown }

enum BackgroundType { empty, logo, logoWithBackButton, logoWithSkip }

enum BottomNavTabs { profile, umra, home, ziarat, settings }

enum ZiaratCities { mecca, medina, taif, other }

enum ZiaratDestinationsCreationOptions { auto, manual }

enum CollectionNames { users, settings }

enum MapMarkerId { userLocation, destination }

enum CommonDoc {
  alKaba('al_kaba'),
  constants('constants'),
  safaMarwa('safa_marwa'),
  safaMarwaRunningPoints('safa_marwa_running_points'),
  ziarat('ziarat');

  final String name;

  const CommonDoc(this.name);
}

enum CommonField {
  isInTawaf('isInTawaf'),
  points('points'),
  googleMapKey('google_map_key'),
  startingPoint('startingPoint'),
  selectedZiarat('selected_ziarat');

  final String name;

  const CommonField(this.name);
}

enum Dua {
  round1('رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ'),
  round2('اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَعَافِنِي وَارْزُقْنِي'),
  round3('اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ'),
  round4('اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ'),
  round5('اللَّهُمَّ حَبِّبْ إِلَيَّ الإِيمَانَ وَزَيِّنْهُ فِي قَلْبِي وَكَرِّهْ إِلَيَّ الْكُفْرَ وَالْفُسُوقَ وَالْعِصْيَانَ'),
  round6('اللَّهُمَّ اجْعَلْ هَذَا الْبَلَدَ آمِنًا مُطْمَئِنًّا وَارْزُقْ أَهْلَهُ مِنَ الثَّمَرَاتِ'),
  round7('اللَّهُمَّ اخْتِمْ لَنَا بِالسَّعَادَةِ وَاجْعَلْ عَاقِبَتَنَا إِلَى خَيْرٍ'),
  goingToMarwa(
    'اللَّهُمَّ اسْتَعْمِلْنِي بِسُنَّةِ نَبِيِّكَ مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ، وَتَوَفَّنِي عَلَىٰ مِلَّتِهِ، وَأَعِذْنِي مِنْ مُضِلَّاتِ الْفِتَنِ بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِينَ۔',
  ),
  goingToSafa('بِسْمِ اللَّهِ، أَبْدَأُ بِمَا بَدَأَ اللَّهُ بِهِ، إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ۔');

  final String dua;

  const Dua(this.dua);
}
