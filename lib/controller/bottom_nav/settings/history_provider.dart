import '../../../export.dart';
import '../../../view/bottom_nav/settings/history/tawaf.dart';
import '../../../view/bottom_nav/settings/history/umrah.dart';

final historyProvider = ChangeNotifierProvider.autoDispose<HistoryNotifier>((ref) => HistoryNotifier());

class HistoryNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;
  UserModel? user;

  List<HistoryModel> umrahHistories = [];
  List<HistoryModel> tawafHistories = [];

  Future<void> initialization() async {
    user = await LocalStorageManager.getUser(fromFirebase: true);
    umrahHistories =
        (await historyCollection.where(Filter.or(Filter('user_id', isEqualTo: user!.uid), Filter('type', isEqualTo: UmraType.umra.name))).get()).docs
            .map((history) => HistoryModel.fromMap(history.data()))
            .toList();
    tawafHistories =
        (await historyCollection.where(Filter.or(Filter('user_id', isEqualTo: user!.uid), Filter('type', isEqualTo: UmraType.tawaf.name))).get()).docs
            .map((history) => HistoryModel.fromMap(history.data()))
            .toList();
  }

  void onUmraTap() => Navigator.push(context, MaterialPageRoute(builder: (context) => const UmrahHistoryPage()));

  void onTawafTap() => Navigator.push(context, MaterialPageRoute(builder: (context) => const TawafHistoryPage()));

  void onZiaratTap() {}
}
