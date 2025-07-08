import '../../export.dart';
import '../../view/meeqaat/location_fetched.dart';
import '../../view/nav/page.dart';
import '../../widgets/dialog/confirmation.dart';

final meeqaatPermissionProvider = ChangeNotifierProvider<MeeqaatPermissionNotifier>((ref) => MeeqaatPermissionNotifier());

class MeeqaatPermissionNotifier extends ChangeNotifier {
  bool isConfirmingMeeqaat = false;

  void skip(BuildContext context) async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
    if (result == false) {
      return;
    }
    LocalStorageManager.showGetLocationPermissionPage(false);
    LocalStorageManager.showLocationFetchPage(false);
    LocalStorageManager.showMeeqaatThreeTasksPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }

  void continueTab(BuildContext context) async {
    await Geolocator.requestPermission();
    LocalStorageManager.showGetLocationPermissionPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatLocationFetchedPage()));
  }
}
