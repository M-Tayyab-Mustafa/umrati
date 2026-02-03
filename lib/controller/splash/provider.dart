import '../../export.dart';
import '../../view/auth/gender.dart';
import '../../view/auth/login.dart';
import '../../view/language/select_language.dart';
import '../../view/location_permission/page.dart';
import '../../view/bottom_nav/page.dart';
import '../../view/subscription/page.dart';

final splashProvider = ChangeNotifierProvider.autoDispose<SplashNotifier>((ref) => SplashNotifier());

class SplashNotifier extends ChangeNotifier {
  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void initialization(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    screenSize = MediaQuery.sizeOf(context);
    await redirections(context);
  }

  Future<void> redirections(BuildContext context, {showPermissionPage = true}) async {
    final user = await LocalStorageManager.getUser(fromFirebase: true);
    await Helper.getCurrencySymbol();
    final byPassEmails = await Helper.getByPassEmails();
    bool isExpired = true;
    if (user != null) {
      if (byPassEmails.contains(user.email.toLowerCase().trim())) {
        if (user.subscription_id != null && user.subscription_id!.isNotEmpty) {
          final docSnapshot = subscriptionCollection.doc(user.subscription_id);
          Helper.userSubscription = SubscriptionModel.fromMap((await docSnapshot.get()).data()!);
          var newExpireAt = DateTime.now().add(const Duration(days: 2));
          await docSnapshot.update({'expire_at': Timestamp.fromMillisecondsSinceEpoch(newExpireAt.millisecondsSinceEpoch)});
          isExpired = false;
        } else {
          final plan = await Helper.getUltimatePlan();
          DocumentReference<Map<String, dynamic>> doc = subscriptionCollection.doc();
          await doc.set(SubscriptionModel(uid: doc.id, user_ids: [user.uid], plan: plan).toMap(created_at: FieldValue.serverTimestamp(), updated_at: FieldValue.serverTimestamp(), expire_at: FieldValue.serverTimestamp()));
          final expireAt = (await doc.get()).get('expire_at') as Timestamp;
          await doc.update({'expire_at': Timestamp.fromMillisecondsSinceEpoch(expireAt.toDate().add(Duration(days: plan.duration)).millisecondsSinceEpoch)});
          Helper.userSubscription = SubscriptionModel.fromMap((await doc.get()).data()!);
          await LocalStorageManager.saveUser(user.copyWith(subscription_id: doc.id, is_premium: true));
          isExpired = false;
        }
      } else {
        if (user.subscription_id != null && user.subscription_id!.isNotEmpty) {
          Helper.userSubscription = SubscriptionModel.fromMap((await subscriptionCollection.doc(user.subscription_id).get()).data()!);
          isExpired = DateTime.now().isAfter(Helper.userSubscription!.expire_at!.toDate());
          if (isExpired) errorToast(LocaleKeys.subscription_expire_msg.tr());
        } else {
          isExpired = false;
        }
      }
    }
    final permissionStatus = await Geolocator.checkPermission();
    Navigator.popUntil(context, (route) => route.isFirst);
    if (await LocalStorageManager.getSelectLanguagePage()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectLanguagePage()));
    } else if (user == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
