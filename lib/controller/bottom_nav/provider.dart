import 'package:umrati/view/subscription/page.dart';

import '../../export.dart';
import '../../view/bottom_nav/home/page.dart';
import '../../view/bottom_nav/profile/page.dart';
import '../../view/bottom_nav/settings/page.dart';
import '../../view/bottom_nav/ask_mufti/page.dart';

final bottomNavProvider = ChangeNotifierProvider.autoDispose<BottomNavNotifier>((ref) => BottomNavNotifier());

class BottomNavNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;
  BottomNavTabs selectedTab = BottomNavTabs.home;
  Widget child = const HomePage();
  bool canPop = false;
  Timer? bounceTimer;

  void onBottomNavTap(BottomNavTabs selectedOption) async {
    var user = await LocalStorageManager.getUser();
    var previousTab = selectedTab;
    selectedTab = selectedOption;
    switch (selectedOption) {
      case BottomNavTabs.home:
        child = const HomePage();
        break;
      case BottomNavTabs.profile:
        child = const ProfilePage();
        break;
      case BottomNavTabs.askMufti:
        child = const SizedBox.shrink();
        if (user!.is_premium) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AskMuftiPage()));
        } else {
          errorToast('Only Premium Users Can Access Ask Mufti Feature');
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionPlansPage(isRenewingPlan: true)));
        }
        onBottomNavTap(previousTab);
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

  void onPopInvokedWithResult(bool didPop, result) {
    if (canPop) {
      exit(0);
    } else {
      canPop = true;
      infoToast('Press again to exit');
      bounceTimer?.cancel();
      bounceTimer = Timer(const Duration(seconds: 2), () {
        canPop = false;
      });
    }
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
