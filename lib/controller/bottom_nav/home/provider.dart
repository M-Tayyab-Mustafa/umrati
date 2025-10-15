import '../../../export.dart';
import '../../../view/bottom_nav/home/umrah/page.dart';
import '../../../view/bottom_nav/home/ziaraat/page.dart';

final homeProvider = ChangeNotifierProvider.autoDispose<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void onUmrahTap() async => Navigator.push(context, MaterialPageRoute(builder: (context) => const UmrahPage()));

  void onTawafTap() async => Navigator.push(context, MaterialPageRoute(builder: (context) => const UmrahPage(userActivityType: UserActivityType.tawaf)));

  void onZiaraatTap() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ZiaraatPage()));
  }
}
