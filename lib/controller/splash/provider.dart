import '../../export.dart';
import '../../view/auth/gender.dart';
import '../../view/auth/login.dart';
import '../../view/language/select_language.dart';
import '../../view/meeqaat/page.dart';
import '../../view/meeqaat/three_tasks.dart';
import '../../view/meeqaat/permission.dart';
import '../../view/meeqaat/two_tasks.dart';
import '../../view/nav/page.dart';
import '../../view/subscription/page.dart';

final splashProvider = ChangeNotifierProvider.autoDispose<SplashNotifier>((ref) => SplashNotifier());

class SplashNotifier extends ChangeNotifier {
  void initialization(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    screenSize = MediaQuery.sizeOf(context);
    await redirections(context);
  }

  Future<void> redirections(BuildContext context, [showPermissionPage = true]) async {
    final user = await LocalStorageManager.getUser();
    final isExpired = user?.subscription?.expire_at?.toDate().isBefore(DateTime.now());
    final permissionStatus = await Geolocator.checkPermission();
    if (await LocalStorageManager.getSelectLanguagePage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectLanguagePage()));
    } else if (await LocalStorageManager.getLoginPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else if ((permissionStatus == LocationPermission.deniedForever || permissionStatus == LocationPermission.denied) && showPermissionPage) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LocationPermissionPage()));
    } else if (isExpired == null || isExpired == true) {
      if (user!.subscription?.isFreeSubscribed == false) errorToast(LocaleKeys.subscription_expire_msg.tr());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SubscriptionPlansPage()));
    } else if (await LocalStorageManager.getGenderPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectGenderPage()));
    } else if (await LocalStorageManager.getTwoTasksBeforeMeeqaatPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeeqaatTwoTasksPage()));
    } else if (await LocalStorageManager.getMeeqaatPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeeqaatPage()));
    } else if (await LocalStorageManager.getMeeqaatThreeTasksPage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeeqaatThreeTasksPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationPage()));
    }
  }
}
