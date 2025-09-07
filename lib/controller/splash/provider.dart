import '../../export.dart';
import '../../view/auth/gender.dart';
import '../../view/auth/login.dart';
import '../../view/auth/phone_no.dart';
import '../../view/language/select_language.dart';
import '../../view/location_permission/page.dart';
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
    final user = await LocalStorageManager.getUser(fromFirebase: true);
    await Helper.getCurrencySymbol();
    bool isExpired = true;
    if (user != null && user.subscription_id != null && user.subscription_id!.isNotEmpty) {
      var doc = (await FirebaseFirestore.instance.collection(CollectionNames.subscriptions.name).doc(user.subscription_id).get());
      Helper.userSubscription = SubscriptionModel.fromMap(doc.data()!);
      final expireAt = doc.get('expire_at');
      if (expireAt.runtimeType == Timestamp) {
        isExpired = DateTime.now().isAfter(expireAt.toDate());
      } else {
        isExpired = Timestamp.fromMillisecondsSinceEpoch(expireAt).toDate().isAfter(expireAt.toDate());
      }
      if (isExpired && Helper.userSubscription?.plan.type != PlanType.free.name) errorToast(LocaleKeys.subscription_expire_msg.tr());
    }
    final permissionStatus = await Geolocator.checkPermission();
    if (await LocalStorageManager.getSelectLanguagePage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectLanguagePage()));
    } else if (user == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else if ((permissionStatus == LocationPermission.deniedForever || permissionStatus == LocationPermission.denied) && showPermissionPage) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LocationPermissionPage()));
    } else if (user.gender.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectGenderPage()));
    } else if (user.country_code.isEmpty || user.phone.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PhoneNoPage()));
    } else if (isExpired == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SubscriptionPlansPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationPage()));
    }
  }
}
