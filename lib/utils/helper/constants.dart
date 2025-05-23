import 'package:geolocator/geolocator.dart' show Position;
import '../../export.dart';
part 'enums.dart';

late Size screenSize;

final primaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.outer)];
final innerPrimaryShadows = [BoxShadow(color: CColors.shadow, blurRadius: 10, blurStyle: BlurStyle.inner)];

FutureOr<bool> requestLocationAlways() async {
  var status = await Permission.locationAlways.status;
  if (!(status.isGranted)) {
    status = await Permission.locationAlways.request();
  }
  return status.isGranted;
}

class DefaultImages {
  static const String logoWithName = 'assets/svg/logo_with_text.svg';
  static const String longArrowForward = 'assets/svg/forward_arrow.svg';
}

StreamSubscription<Position>? positionStreamSubscription;

var userCollection = FirebaseFirestore.instance.collection(CollectionNames.users.name);
var settingsCollection = FirebaseFirestore.instance.collection(CollectionNames.settings.name);

isLTR(context) => languageDirection(context) == TextDirection.ltr;
