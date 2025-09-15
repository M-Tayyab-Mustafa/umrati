import '../../export.dart';
import '../../view/auth/email_or_phone_linking.dart';
import '../../view/auth/gender.dart';
import '../../view/auth/login.dart';
import '../../view/language/select_language.dart';
import '../../view/location_permission/page.dart';
import '../../view/bottom_nav/page.dart';
import '../../view/subscription/page.dart';

final splashProvider = ChangeNotifierProvider.autoDispose<SplashNotifier>((ref) => SplashNotifier());

class SplashNotifier extends ChangeNotifier {
  void initialization(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    screenSize = MediaQuery.sizeOf(context);
    await redirections(context);
  }

  Future<void> redirections(BuildContext context, [showPermissionPage = true]) async {
    final user = await LocalStorageManager.getUser(fromFirebase: true);
    await Helper.getCurrencySymbol();
    bool isExpired = true;
    if (user != null && user.subscription_id != null && user.subscription_id!.isNotEmpty) {
      Helper.userSubscription = SubscriptionModel.fromMap((await FirebaseFirestore.instance.collection(CollectionNames.subscriptions.name).doc(user.subscription_id).get()).data()!);
      isExpired = DateTime.now().isAfter(Helper.userSubscription!.expire_at!.toDate());
      if (isExpired && Helper.userSubscription?.plan.type != PlanType.free.name) errorToast(LocaleKeys.subscription_expire_msg.tr());
    }
    final permissionStatus = await Geolocator.checkPermission();
    if (await LocalStorageManager.getSelectLanguagePage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectLanguagePage()));
    } else if (user == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else if (user.phone.isEmpty || user.email.isEmpty || user.country_code.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EmailOrPhoneLinkingPage()));
    } else if ((permissionStatus == LocationPermission.deniedForever || permissionStatus == LocationPermission.denied) && showPermissionPage) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LocationPermissionPage()));
    } else if (user.gender.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectGenderPage()));
    } else if (isExpired == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SubscriptionPlansPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationPage()));
    }
  }
}
