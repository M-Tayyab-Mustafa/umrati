import '../../export.dart';
part 'enums.dart';

late Size screenSize;
int distanceFilter = 10;

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

get mapsApiKey async => (await settingsCollection.doc(CommonDoc.constants.name).get()).get(CommonField.googleMapKey.name);
