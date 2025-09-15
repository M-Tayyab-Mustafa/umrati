import '../../../export.dart';
import '../../../view/bottom_nav/home/umra/page.dart';
import '../../../view/bottom_nav/home/ziarat/page.dart';

final homeProvider = ChangeNotifierProvider.autoDispose<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void onUmraTap() async {
    ref.read(umraProvider.notifier).isFromTawaf = false;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const UmraPage()));
  }

  void onTawafTap() async {
    ref.read(umraProvider.notifier).isFromTawaf = true;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const UmraPage()));
  }

  void onZiaratTap() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ZiaratPage()));
  }
}
