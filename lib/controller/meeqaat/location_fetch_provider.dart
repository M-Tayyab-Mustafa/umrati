import '../../export.dart';
import '../../view/meeqaat/three_tasks.dart';
import '../../view/nav/page.dart';
import '../../widgets/dialog/confirmation.dart';

final locationFetchProvider = ChangeNotifierProvider.autoDispose<MeeqaatLocationFetchProviderNotifier>((ref) => MeeqaatLocationFetchProviderNotifier());

class MeeqaatLocationFetchProviderNotifier extends ChangeNotifier {
  String location = '';
  getLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
      location = '${placemarks.street}, ${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
    } catch (e) {
      errorToast(e.toString());
    }
  }

  void skip(BuildContext context) async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
    if (result == false) {
      return;
    }
    LocalStorageManager.showLocationFetchPage(false);
    LocalStorageManager.showMeeqaatThreeTasksPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }

  void continueTab(BuildContext context) async {
    LocalStorageManager.showLocationFetchPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatThreeTasksPage()));
  }
}
