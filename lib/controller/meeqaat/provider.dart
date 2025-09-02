import '../../export.dart';
import '../../view/meeqaat/three_tasks.dart';

final locationFetchProvider = ChangeNotifierProvider.autoDispose<MeeqaatLocationFetchProviderNotifier>((ref) => MeeqaatLocationFetchProviderNotifier());

class MeeqaatLocationFetchProviderNotifier extends ChangeNotifier {
  String location = '';
  String? distance;
  String? time;

  getLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
      location = '${placemarks.street}, ${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
      notifyListeners();
      var meeqaatDoc = await FirebaseFirestore.instance.collection(CollectionNames.settings.name).doc(CommonDoc.meeqaat.name).get();
      final leg = await Helper.getRouteLeg(startPoint: LatLng(position.latitude, position.longitude), endPoint: LatLng(meeqaatDoc.get('lat'), meeqaatDoc.get('lng')));
      if (leg != null) {
        distance = leg['distance']['text'];
        time = leg['duration']['text'];
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  void continueTab(BuildContext context) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatThreeTasksPage()));
  }
}
