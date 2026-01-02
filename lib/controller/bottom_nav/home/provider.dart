import 'package:umrati/view/subscription/page.dart';

import '../../../export.dart';
import '../../../view/bottom_nav/home/umrah/page.dart';
import '../../../view/bottom_nav/home/ziaraat/page.dart';

final homeProvider = ChangeNotifierProvider.autoDispose<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void onUmrahTap(BuildContext context) async {
    var user = await LocalStorageManager.getUser();
    if (user!.is_premium) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => const UmrahPage()));
    } else {
      errorToast('Only Premium Users Can Access Umrah Feature');
      await Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionPlansPage(isRenewingPlan: true)));
    }
  }

  void onTawafTap(BuildContext context) async => Navigator.push(context, MaterialPageRoute(builder: (context) => const UmrahPage(userActivityType: UserActivityType.tawaf)));

  void onZiaraatTap(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ZiaraatPage()));
  }
}
