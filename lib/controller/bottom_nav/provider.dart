import '../../export.dart';
import '../../view/bottom_nav/home/page.dart';
import '../../view/bottom_nav/profile/page.dart';
import '../../view/bottom_nav/settings/page.dart';
import 'ask_mufti/page.dart';

final bottomNavProvider = ChangeNotifierProvider.autoDispose<BottomNavNotifier>((ref) => BottomNavNotifier());

class BottomNavNotifier extends ChangeNotifier {
  BottomNavTabs selectedTab = BottomNavTabs.home;
  Widget child = const HomePage();

  void onBottomNavTap(BottomNavTabs selectedOption) {
    selectedTab = selectedOption;
    switch (selectedOption) {
      case BottomNavTabs.home:
        child = const HomePage();
        break;
      case BottomNavTabs.profile:
        child = const ProfilePage();
        break;
      case BottomNavTabs.askMufti:
        child = AskMuftiPage();
        break;
      default:
        child = const SettingsPage();
    }
    notifyListeners();
  }

  void updateChild(Widget child) {
    this.child = child;
    notifyListeners();
  }
}

LatLng offsetLatLng(LatLng origin, double distanceInMeters, double bearingInDegrees) {
  const double earthRadius = 6371000;
  final double bearing = bearingInDegrees * pi / 180;

  final double lat1 = origin.latitude * pi / 180;
  final double lon1 = origin.longitude * pi / 180;

  final double lat2 = asin(sin(lat1) * cos(distanceInMeters / earthRadius) + cos(lat1) * sin(distanceInMeters / earthRadius) * cos(bearing));

  final double lon2 = lon1 + atan2(sin(bearing) * sin(distanceInMeters / earthRadius) * cos(lat1), cos(distanceInMeters / earthRadius) - sin(lat1) * sin(lat2));

  return LatLng(lat2 * 180 / pi, lon2 * 180 / pi);
}
