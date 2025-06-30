import '../../export.dart';
import '../../view/nav/home/page.dart';

final bottomNavProvider = ChangeNotifierProvider<BottomNavNotifier>((ref) => BottomNavNotifier());

class BottomNavNotifier extends ChangeNotifier {
  BottomNavTabs selectedTab = BottomNavTabs.home;
  Widget child = const HomePage();

  var logoAlign = Alignment.center;

  void onBottomNavTap(BottomNavTabs selectedOption) {
    logoAlign = Alignment.center;
    selectedTab = selectedOption;
    switch (selectedOption) {
      case BottomNavTabs.profile:
        child = const SizedBox.shrink();
        break;
      case BottomNavTabs.supplications:
        child = const SizedBox.shrink();
        break;
      case BottomNavTabs.home:
        child = HomePage();
        break;
      case BottomNavTabs.prayer:
        child = const SizedBox.shrink();
        break;
      default:
        child = const SizedBox.shrink();
    }
    notifyListeners();
  }

  void updateChild(Widget child) {
    this.child = child;
    notifyListeners();
  }

  void updateLogoAlign(Alignment align) {
    logoAlign = align;
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
